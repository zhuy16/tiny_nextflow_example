# tiny_nextflow_example

A minimal, reproducible Nextflow pipeline demo for research engineering interviews.

## Overview
This project demonstrates:
- A toy workflow (QC step) using Nextflow DSL2
- Containerized execution (Docker)
- Deterministic, idempotent steps
- Input schema validation (mocked)
- Automated testing with pytest

## File/Folder Structure
- `main.nf` — Main Nextflow workflow (QC example)
- `nextflow` — Nextflow launcher script (keep at repo root)
- `requirements.txt` — Python dependencies for tests/scripts
- `tests/` — Pytest-based tests for workflow logic
- `preparation/` — (Optional) Setup scripts/logs
- `.gitignore` — Excludes cache, logs, and temp files

## Quickstart
1. **Install Nextflow** (if not present):
	```sh
	curl -s https://get.nextflow.io | bash
	```
	Or use the provided `nextflow` launcher.
2. **Install Python dependencies:**
	```sh
	python3 -m venv .venv && source .venv/bin/activate
	pip install -r requirements.txt
	```
3. **Run the workflow:**
	```sh
	./nextflow run main.nf -profile docker
	```
4. **Run tests:**
	```sh
	pytest -q tests/
	```

## Example Output
QC output files like `S1.qc.txt` will be generated for each sample.

## Notes
- The workflow is intentionally simple for demonstration.
- All steps are deterministic and idempotent.
- The repo is CI-friendly and easy to extend.

---

For interviewers: This repo is designed to showcase best practices in reproducible workflow development, containerization, and test-driven research engineering.
