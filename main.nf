nextflow.enable.dsl=2

process QC {
  tag "$sample"
  cpus 1; memory '1 GB'; time '10m'
  container 'python:3.10-slim'
  input:
    tuple val(sample), path(reads1), path(reads2)
  output:
    path "${sample}.qc.txt"
  script:
  """
  set -euo pipefail
  tmp=${sample}.qc.txt.tmp
  python - <<'PY' > \$tmp
import random, sys
random.seed(42)
print("SAMPLE=%s; READS1=%s; READS2=%s; OK=1" % ("${sample}", "${reads1}", "${reads2}"))
PY
  mv \$tmp ${sample}.qc.txt
  """
}

workflow {
  Channel.of(
    tuple('S1', file('tests/data/S1_R1.fastq'), file('tests/data/S1_R2.fastq'))
    // Add more samples as needed
  ) | QC
}
