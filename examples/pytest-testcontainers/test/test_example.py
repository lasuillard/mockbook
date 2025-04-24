# flake8: noqa: UP035
from http import HTTPStatus
from urllib.parse import urljoin

import pytest
import requests


@pytest.mark.parametrize(
    argnames="repeat",
    argvalues=list(range(4)),
)
def test_mock_api(mockbook_url: str, repeat: int) -> None:  # noqa: ARG001
    response = requests.get(urljoin(mockbook_url, "/mock-api"), timeout=5)

    assert response.status_code == HTTPStatus.OK
    assert response.json() == {"message": "Hello from Mockbook!"}
