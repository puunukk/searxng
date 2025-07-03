FROM python:3.11-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    build-base \
    libffi-dev \
    libxslt-dev \
    libxml2-dev \
    openssl-dev \
    su-exec

# Create searxng user and directory
RUN adduser -D -h /usr/local/searxng -s /bin/sh searxng
WORKDIR /usr/local/searxng

# Copy source code
COPY --chown=searxng:searxng . .

# Switch to searxng user and install
USER searxng
RUN pip install --user --no-cache-dir -e .

# Generate secret key if not provided
RUN if ! grep -q "secret_key.*[a-f0-9]\{32\}" searx/settings.yml; then \
        SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))") && \
        sed -i "s/ultrasecretkey/$SECRET_KEY/g" searx/settings.yml; \
    fi

# Set default instance name
RUN sed -i 's/instance_name: "SearXNG"/instance_name: "Puunukk Search"/g' searx/settings.yml

EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/healthz || exit 1

# Start SearXNG
CMD ["python", "searx/webapp.py"]
