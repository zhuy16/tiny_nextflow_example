# tiny_nextflow_example

Reproducible demo: toy ATAC/RNA steps (mock), Nextflow + Docker, pytest tests, schema checks.

## Run
nextflow run main.nf -profile docker

## What it shows
- Idempotent steps (temp -> atomic move)
- Deterministic seeds
- Input schema validation
- CI-friendly tests (pytest -q)
