FROM python:3.10-slim

# non-interactive apt and smaller image
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
        apt-get install -y --no-install-recommends \
            default-jre-headless \
            curl \
            graphviz \
            ca-certificates && \
        rm -rf /var/lib/apt/lists/*

# Install Nextflow
RUN curl -s https://get.nextflow.io | bash && \
        mv nextflow /usr/local/bin/ && \
        chmod +x /usr/local/bin/nextflow

# Set up Python environment
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project
COPY . .

# Default command (can be overridden)
CMD ["nextflow", "run", "main.nf", "-profile", "docker"]
