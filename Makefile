.PHONY: ci black flake8 pylint isort pytest autoformat install

VENV=venv
PYTHON=python3

ci: black flake8 pylint isort pytest

$(VENV): $(VENV)/bin/activate

$(VENV)/bin/activate:
ifeq (, $(shell which virtualenv))
	$(error "`virtualenv` is not installed, consider running `pip3 install virtualenv`")
endif
	test -d $(VENV) || virtualenv -p python3 $(VENV)
	touch $(VENV)/bin/activate

install-requirements-dev: requirements-dev.txt
	$(PYTHON) -m pip install -r $<
	$(PYTHON) -m pip install -e .

requirements-dev.txt: requirements-dev.in
	pip-compile $<

black: install-requirements-dev
	$(PYTHON) -m black . --check --diff --exclude $(VENV)

flake8: install-requirements-dev
	$(PYTHON) -m flake8 . --count --show-source --statistics --exclude $(VENV)

pylint: install-requirements-dev
	$(PYTHON) -m pylint --rcfile=setup.cfg opendrop

isort: install-requirements-dev
	$(PYTHON) -m isort -c opendrop/**.py

pytest: install-requirements-dev
	$(PYTHON) -m pytest

autoformat: install-requirements-dev
	$(PYTHON) -m isort opendrop/**.py
	$(PYTHON) -m black . --exclude $(VENV)

install:
	$(PYTHON) -m pip install -e .