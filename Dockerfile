FROM python:3.10-slim

# Install Nextflow dependencies
RUN apt-get update && \
    apt-get install -y default-jre-headless curl && \
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
