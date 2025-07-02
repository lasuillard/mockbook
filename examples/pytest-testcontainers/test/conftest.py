# flake8: noqa: UP035, E501
import atexit
import pickle
from collections.abc import Callable
from pathlib import Path
from typing import Any, cast
from urllib.parse import urljoin

import pytest
import requests
from filelock import FileLock
from testcontainers.core.container import DockerContainer
from testcontainers.core.waiting_utils import wait_container_is_ready
from typing_extensions import Self


class MockbookContainer(DockerContainer):
    """Testcontainers container for Mockbook."""

    def __init__(
        self,
        image: str = "lasuillard/mockbook:main",
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
def mockbook_url(
    request: pytest.FixtureRequest,
    tmp_path_factory: pytest.TempPathFactory,
    worker_id: str,
) -> str:
    """Fixture to start a Mockbook container and return its URL."""

    def create_container() -> str:
        container = (
            MockbookContainer()
            .maybe_emulate_amd64()
            .with_volume_mapping(
                host=str(request.config.rootpath / "notebooks"),
                container="/app/mockbook/notebooks",
                mode="ro",
            )
            .start()
        )

        # ? Uses `atexit` to teardown fixture instead
        # ? `request.addfinalizer` or session-scoped fixtures may suffer concurrency issue,
        # ? where one worker stops the container while another is still using it.
        atexit.register(container.stop)

        return container.get_url()

    # pytest-xdist disabled; let the session-scoped fixture cache the result
    if worker_id == "master":
        return create_container()

    # Use file-based caching to ensure the container is only created once and shared across workers
    root_tmp_dir = tmp_path_factory.getbasetemp().parent
    filename = root_tmp_dir / "mockbook-container.pickle"
    return once(
        create_container,
        datafile=filename,
        lockfile=filename.with_suffix(filename.suffix + ".lock"),
    )


def once[T](factory: Callable[..., T], *, datafile: Path, lockfile: Path) -> T:
    """Ensure that a factory function is only called once, and the result is cached.

    Reference: https://pytest-xdist.readthedocs.io/en/stable/how-to.html#making-session-scoped-fixtures-execute-only-once
    """
    with FileLock(lockfile):
        if datafile.is_file():
            with datafile.open("rb") as f_r:
                data = pickle.load(f_r)  # noqa: S301
        else:
            data = factory()
            with datafile.open("wb") as f_w:
                pickle.dump(data, f_w)

    return cast("T", data)
