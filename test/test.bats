setup_file() {
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
@test "Mock service is up" {
	run curl --fail --silent http://localhost:8000
	assert_output '"OK"'
}

@test "Jupyter Lab is up" {
	run curl --fail http://localhost:8888
	assert_success
}
