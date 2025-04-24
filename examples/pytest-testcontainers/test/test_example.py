# flake8: noqa: UP035
from collections.abc import Iterator
from http import HTTPStatus
from typing import Any
from urllib.parse import urljoin

import pytest
import requests
from testcontainers.core.container import DockerContainer
from testcontainers.core.waiting_utils import wait_container_is_ready
from typing_extensions import Self


class MockbookContainer(DockerContainer):
    def __init__(
        self,
        image: str = "lasuillard/mockbook:0.5",
        port: int = 80,
        **kwargs: Any,
    ) -> None:
        super().__init__(image, **kwargs)
        self.port = port
        self.with_exposed_ports(self.port)

    @wait_container_is_ready(requests.ConnectionError, requests.HTTPError)
    def _connect(self) -> None:
        response = requests.get(urljoin(self.get_url(), "/"), timeout=5)
        response.raise_for_status()

    def get_url(self) -> str:
        host, port = self.get_container_host_ip(), self.get_exposed_port(self.port)
        return f"http://{host}:{port}"

    def start(self) -> Self:
        super().start()
        self._connect()
        return self


@pytest.fixture(scope="session")
def mockbook_url(request: pytest.FixtureRequest) -> Iterator[str]:
    with (
        MockbookContainer()
        .maybe_emulate_amd64()
        .with_volume_mapping(
            host=str(request.config.rootpath / "notebooks"),
            container="/app/mockbook/notebooks",
            mode="ro",
        )
        .start()
    ) as container:
        yield container.get_url()


def test_mock_api(mockbook_url: str) -> None:
    response = requests.get(urljoin(mockbook_url, "/mock-api"), timeout=5)

    assert response.status_code == HTTPStatus.OK
    assert response.json() == {"message": "Hello from Mockbook!"}
