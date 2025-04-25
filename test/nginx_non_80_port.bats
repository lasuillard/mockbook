# Related issues: #31
export COMPOSE_FILE="test/docker-compose.yaml"

setup_file() {
	export NGINX_PORT=10080

	docker compose --env-file /dev/null up --detach --build --wait --wait-timeout 30
}

setup() {
	load 'test_helper/bats-support/load'
	load 'test_helper/bats-assert/load'
}

teardown_file() {
	docker compose down
}

@test "Trailing slash in URL returns redirect to URL without slash" {
	run curl --fail --location http://localhost:10080/lorem-ipsum/
	assert_success
}
