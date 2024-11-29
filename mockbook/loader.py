"""Import Jupyter notebooks as modules.

Source from https://jupyter-notebook.readthedocs.io/en/stable/examples/Notebook/Importing%20Notebooks.html
"""

from __future__ import annotations

import io
import os
import sys
import types
from importlib.abc import Loader, MetaPathFinder
from importlib.util import spec_from_loader
from typing import TYPE_CHECKING, Any

from IPython import get_ipython
from IPython.core.interactiveshell import InteractiveShell
from nbformat import read

if TYPE_CHECKING:
    from collections.abc import Sequence


def find_notebook(fullname: str, path: Sequence[str] | None = None) -> str | None:
    """find a notebook, given its fully qualified name and an optional path

    This turns "foo.bar" into "foo/bar.ipynb"
    and tries turning "Foo_Bar" into "Foo Bar" if Foo_Bar
    does not exist.
    """
    name = fullname.rsplit(".", 1)[-1]
    if not path:
        path = [""]

    for d in path:
        nb_path = os.path.join(d, name + ".ipynb")  # noqa: PTH118
        if os.path.isfile(nb_path):  # noqa: PTH113
            return nb_path

        # let import Notebook_Name find "Notebook Name.ipynb"
        nb_path = nb_path.replace("_", " ")
        if os.path.isfile(nb_path):  # noqa: PTH113
            return nb_path

    return None


class NotebookLoader(Loader):
    """Module Loader for Jupyter Notebooks"""

    def __init__(self, path: Sequence[str] | None = None) -> None:
        self.shell = InteractiveShell.instance()
        self.path = path

    def load_module(self, fullname: str) -> types.ModuleType:
        """import a notebook as a module"""
        path = find_notebook(fullname, self.path)
        if not path:
            msg = f"Notebook not found: {fullname}"
            raise ImportError(msg)

        print(f"importing Jupyter notebook from {path}")  # noqa: T201

        # load the notebook object
        with io.open(path, "r", encoding="utf-8") as f:  # noqa: UP020
            nb = read(f, 4)

        # create the module and add it to sys.modules
        # if name in sys.modules:
        #    return sys.modules[name]  # noqa: ERA001
        mod = types.ModuleType(fullname)
        mod.__file__ = path
        mod.__loader__ = self
        mod.__dict__["get_ipython"] = get_ipython
        sys.modules[fullname] = mod

        # extra work to ensure that magics that would affect the user_ns
        # actually affect the notebook module's ns
        save_user_ns = self.shell.user_ns
        self.shell.user_ns = mod.__dict__

        try:
            for cell in nb.cells:
                if cell.cell_type == "code":
                    # transform the input to executable Python
                    code = self.shell.input_transformer_manager.transform_cell(
                        cell.source,
                    )
                    # run the code in themodule
                    exec(code, mod.__dict__)  # noqa: S102
        finally:
            self.shell.user_ns = save_user_ns
        return mod


class NotebookFinder(MetaPathFinder):
    """Module finder that locates Jupyter Notebooks"""

    def __init__(self) -> None:
        self.loaders: dict = {}

    def find_module(self, fullname: str, path: Sequence[str] | None = None) -> Any:
        nb_path = find_notebook(fullname, path)
        if not nb_path:
            return None

        key = path
        if path:
            # lists aren't hashable
            key = os.path.sep.join(path)

        if key not in self.loaders:
            self.loaders[key] = NotebookLoader(path)
        return self.loaders[key]

    def find_spec(
        self,
        fullname: str,
        path: Sequence[str] | None,
        target: Any | None = None,  # noqa: ARG002
    ) -> Any:
        loader = self.find_module(fullname, path)
        if loader is None:
            return None

        return spec_from_loader(fullname, loader)
