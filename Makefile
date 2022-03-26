SHELL=/bin/bash -euo pipefail

setup-python-packages-and-run-challenge-2:
	python -m venv venv && . venv/bin/activate && pip install urllib
	python metadata.py

run-challenge-3-test:
	python -m challenge-3.value_finder_test