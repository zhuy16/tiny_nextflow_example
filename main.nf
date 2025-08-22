nextflow.enable.dsl=2

process QC {
  tag "$sample"
  cpus 1; memory '1 GB'; time '10m'
  container 'python:3.10-slim'
  input:
    tuple val(sample), path(reads)
  output:
    path "${sample}.qc.txt"
  script:
  """
  set -euo pipefail
  tmp=${sample}.qc.txt.tmp
  python - <<'PY' > $tmp
import random, sys; random.seed(42)
print(f"SAMPLE={r'$sample'}; READS={r'$reads'}; OK=1")
PY
  mv $tmp ${sample}.qc.txt
  """
}

workflow {
  Channel.of(
    tuple('S1', file('S1_R1.fastq.gz')),
    tuple('S2', file('S2_R1.fastq.gz'))
  ) | QC
}
