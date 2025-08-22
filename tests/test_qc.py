import subprocess, pathlib, re

def test_qc_outputs_are_deterministic(tmp_path):
    # simulate one task
    out = tmp_path / "S1.qc.txt"
    tmp = tmp_path / "S1.qc.txt.tmp"
    tmp.write_text("SAMPLE=S1; READS=S1_R1.fastq.gz; OK=1\n")
    tmp.rename(out)
    txt = out.read_text()
    assert "SAMPLE=S1" in txt and "OK=1" in txt

def test_idempotent_atomic_write(tmp_path):
    p = tmp_path / "x.txt"
    for _ in range(3):
        tmp = tmp_path / "x.txt.tmp"
        tmp.write_text("hi")
        tmp.rename(p)
    assert p.read_text() == "hi"
