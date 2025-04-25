export COMPOSE_FILE="test/docker-compose.yaml"

setup_file() {
	export JUPYTERLAB_DISABLED=1
	export MOCKBOOK_AUTORELOAD_DISABLED=1
	export NGINX_DISABLED=1

	docker compose --env-file /dev/null up --detach --build --wait --wait-timeout 30
}

setup() {
	load 'test_helper/bats-support/load'
	load 'test_helper/bats-assert/load'
}

teardown_file() {
	docker compose down
}

@test "Mockbook service is up" {
	run curl --fail http://localhost:8000/docs
	assert_success
}

@test "JupyterLab service is down" {
	run curl --fail http://localhost:8888/jupyter/api
	assert_failure 56 # curl: (56) Recv failure: Connection reset by peer
}

@test "NGINX service is down" {
	run curl --fail http://localhost:80/
	assert_failure 56
}
