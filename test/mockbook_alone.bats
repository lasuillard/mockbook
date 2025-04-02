setup_file() {
	export DISABLE_JUPYTERLAB=1
	export DISABLE_MOCKBOOK_AUTORELOAD=1
	docker compose up --detach --build --wait --wait-timeout 30
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

@test "JupyterLab service is down" {
	run curl --fail http://localhost:8888/jupyter
	assert_failure
}
