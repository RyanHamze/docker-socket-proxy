"""SHAI-specific default-deny checks.

Modified for SHAI. Original proxy work by Tecnativa and contributors.
"""

import os
import time
import urllib.error
import urllib.request

import pytest
from plumbum import ProcessExecutionError
from plumbum.cmd import docker


def test_default_monitoring_is_read_only(proxy_factory):
    with proxy_factory() as container_id:
        docker("container", "ls")
        docker("container", "inspect", container_id)
        docker("container", "stats", "--no-stream", container_id)
        endpoint = os.environ["DOCKER_HOST"].replace("tcp://", "http://")
        with urllib.request.urlopen(
            endpoint + f"/events?since={int(time.time()) - 1}&until={int(time.time())}",
            timeout=3,
        ) as response:
            assert response.status == 200

        for command in (
            ("container", "restart", container_id),
            ("container", "stop", container_id),
            ("container", "exec", container_id, "true"),
            ("network", "create", "must-not-exist"),
        ):
            with pytest.raises(ProcessExecutionError):
                docker(*command)


def test_unknown_path_is_denied(proxy_factory):
    with proxy_factory():
        endpoint = os.environ["DOCKER_HOST"].replace("tcp://", "http://")
        with pytest.raises(urllib.error.HTTPError) as error:
            urllib.request.urlopen(endpoint + "/shai-unknown", timeout=3)
        assert error.value.code == 403
