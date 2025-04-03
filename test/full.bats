setup_file() {
	docker compose --env-file /dev/null up --detach --build --wait --wait-timeout 30
}

setup() {
	load 'test_helper/bats-support/load'
	load 'test_helper/bats-assert/load'
}

teardown_file() {
	docker compose down
}

# Test services are up
# ============================================================================
@test "Mockbook service is up" {
	run curl --fail http://localhost:8000/docs
	assert_success
}

@test "JupyterLab service is up" {
	run curl --fail --silent http://localhost:8888/jupyter/api
	assert_output --regexp '^\{"version": ".*"\}$'
}

@test "NGINX service is up" {
	# Has route to JupyterLab
	run curl --fail --silent http://localhost:80/jupyter/api
	assert_output --regexp '^\{"version": ".*"\}$'

	# Has route to Mockbook
	run curl --fail --silent http://localhost:80/
	assert_output --regexp '^"OK"$'
}
