FROM ubuntu:22.04

# Install python and dependencies
RUN apt-get update && apt-get install -y python3-pip python3-venv && rm -rf /var/lib/apt/lists/*

# Create and use a virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app

# Copy requirements first to leverage Docker caching layers
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code
COPY . .

# Create a dedicated volume directory entirely outside your code files
RUN mkdir -p /data && chmod 777 /data
VOLUME /data

CMD [ "python3", "-m", "flask", "run", "--host=0.0.0.0", "--port=8001" ]
