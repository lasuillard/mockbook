import importlib
import sys
from pathlib import Path

from mockbook.app import app  # noqa: F401
from mockbook.loader import NotebookFinder

sys.meta_path.append(NotebookFinder())

notebook_dir = Path(__file__).parent / "notebooks"

# Import all .ipynb files in the notebooks directory
for file in notebook_dir.glob("*.ipynb"):
    importlib.import_module(f"mockbook.notebooks.{file.stem}")
