# Example - pytest using Testcontainers

Example using Mockbook as your mock server in pytest with Testcontainers.

> [!NOTE]
> Consider other mock libraries such as [requests-mock](https://pypi.org/project/requests-mock/) if possible, instead of using Mockbook as your mock server.

To run example tests, run the following commands:

```bash
$ uv run pytest --numprocesses=4 .
```

Also, this example includes [pytest-xdist](https://github.com/pytest-dev/pytest-xdist) to run tests in parallel, running containers only once per whole test session.

It takes a while to run the first time, as it needs to download the image from remote. Subsequent runs will be faster, as the image is stored locally.
