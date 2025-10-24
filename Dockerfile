FROM python:3.11-slim

WORKDIR /app

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        fortune-mod \
        fortunes \
        cowsay \
        netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

# Copy app
COPY . /app
RUN chmod +x ./wisecow.sh

EXPOSE 4499

CMD ["/bin/bash", "./wisecow.sh"]

