from setuptools import setup


# List of dependencies installed via `pip install -e ".[dev]"`
# by virtue of the Setuptools `extras_require` value in the Python
# dictionary below.
dev_requires = [
    "pyramid_debugtoolbar",
    "pytest",
    "apache-log-parser",
]


setup(
    name="dummy_app",
    extras_require={
        "dev": dev_requires,
    },
    entry_points={
        "paste.app_factory": ["main = dummy_app:main"],
    },
)
