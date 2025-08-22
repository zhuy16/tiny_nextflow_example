#!/usr/bin/env bash
# Robust Nextflow installer for macOS / Linux
# Installs Nextflow into $HOME/bin (no sudo), ensures PATH in ~/.zshrc,
# and verifies Java and download tool availability.

set -euo pipefail

NF_DEST="$HOME/bin"
NF_BIN="$NF_DEST/nextflow"
ZSHRC="$HOME/.zshrc"

echo "Installing Nextflow to: $NF_DEST"

# Check Java: ensure 'java -version' runs and major version is >=11
if command -v java >/dev/null 2>&1; then
	if java -version >/dev/null 2>&1; then
		JAVA_VER_FULL=$(java -version 2>&1 | head -n 1)
		echo "Found Java: $JAVA_VER_FULL"
		# extract major version (works for formats like 'openjdk version "17.0.1"' or 'java version "1.8.0_361"')
		JAVA_MAJOR=$(java -version 2>&1 | awk -F[\"._] '/version/ {v=$2; if(v=="1") v=$3; print v; exit}')
		if [[ -z "$JAVA_MAJOR" ]] || ! [[ "$JAVA_MAJOR" =~ ^[0-9]+$ ]]; then
			echo "Warning: couldn't parse Java major version, proceeding but Nextflow may fail. Detected: $JAVA_VER_FULL"
		elif (( JAVA_MAJOR < 11 )); then
			echo "Error: Java major version $JAVA_MAJOR found; Nextflow requires Java 11+."
			echo "Please install OpenJDK 11+ (e.g. 'brew install openjdk@17') and rerun this script."
			exit 1
		fi
	else
		echo "Error: 'java' command is present but failed to run. On macOS this can happen when the Java runtime is not installed."
		echo "Please install a JDK (e.g. 'brew install openjdk@17') and ensure 'java -version' prints a version, then rerun."
		exit 1
	fi
else
	echo "Error: Java (JRE/JDK) not found. Nextflow requires Java 11+."
	echo "Please install OpenJDK 11+ (e.g. 'brew install openjdk@17') and rerun this script."
	exit 1
fi

# Choose downloader
DOWNLOADER=""
if command -v curl >/dev/null 2>&1; then
	DOWNLOADER="curl -fsSLo"
elif command -v wget >/dev/null 2>&1; then
	DOWNLOADER="wget -qO"
else
	echo "Error: neither curl nor wget is available. Please install one and rerun."
	exit 1
fi

# Ensure destination dir exists
mkdir -p "$NF_DEST"

# Download Nextflow to a temp file then move into place
TMPFILE=$(mktemp -t nextflow.XXXXXX)
echo "Downloading Nextflow..."
if [[ "$DOWNLOADER" == curl* ]]; then
	curl -fsSLo "$TMPFILE" https://get.nextflow.io
else
	wget -qO "$TMPFILE" https://get.nextflow.io
fi

chmod +x "$TMPFILE"
mv -f "$TMPFILE" "$NF_BIN"
echo "Nextflow binary installed to $NF_BIN"

# Ensure PATH contains $HOME/bin in ~/.zshrc (idempotent)
if ! grep -q "export PATH=\"\$HOME/bin:\$PATH\"" "$ZSHRC" 2>/dev/null; then
	if [ ! -e "$ZSHRC" ] || [ -w "$ZSHRC" ]; then
		echo 'export PATH="$HOME/bin:$PATH"' >> "$ZSHRC"
		echo "Appended PATH update to $ZSHRC"
	else
		echo "Warning: $ZSHRC exists but is not writable. Please add the following line to your $ZSHRC manually:"
		echo 'export PATH="$HOME/bin:$PATH"'
	fi
fi

# Source zshrc for this run if possible
if [ -n "${ZSH_VERSION-}" ]; then
	# already in zsh
	source "$ZSHRC" || true
else
	# try to source for the current shell
	if [ -f "$ZSHRC" ]; then
		# shellcheck disable=SC1090
		source "$ZSHRC" || true
	fi
fi

# Verify installation
if command -v nextflow >/dev/null 2>&1; then
	echo "Nextflow is on PATH:" $(command -v nextflow)
	nextflow -version || true
else
	echo "Nextflow not found on PATH, trying direct exec: $NF_BIN"
	"$NF_BIN" -version || { echo "Nextflow failed to run."; exit 1; }
fi

echo "Nextflow installation finished."