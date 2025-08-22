# Safe default target
.PHONY: help install test run
.DEFAULT_GOAL := help

help:
	@echo "make install   -> create venv and install requirements"
	@echo "make test      -> run pytest in venv"
	@echo "make run       -> run the demo CLI (edit args in Makefile or pass manually)"

install:
	python3 -m venv .venv
	. .venv/bin/activate && pip install -U pip
	. .venv/bin/activate && pip install -r requirements.txt

test:
	. .venv/bin/activate && pytest -q

# Example CLI usage (edit as you like or run python main.py directly)
run:
	. .venv/bin/activate && python main.py --help
