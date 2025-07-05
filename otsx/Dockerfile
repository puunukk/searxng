FROM python:3.11-alpine

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    libxml2-dev \
    libxslt-dev \
    zlib-dev \
    libffi-dev \
    openssl-dev \
    git

# Create searxng user and directories
RUN adduser -D -h /usr/local/searxng -s /bin/ash searxng \
    && mkdir -p /etc/searxng /var/cache/searxng \
    && chown -R searxng:searxng /etc/searxng /var/cache/searxng

# Set working directory
WORKDIR /usr/local/searxng

# Copy the entire forked repo
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -U pip setuptools wheel \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir "uwsgi~=2.0"

# Install SearXNG from source
RUN pip install --no-cache-dir -e .

# Set ownership
RUN chown -R searxng:searxng /usr/local/searxng

# Switch to searxng user
USER searxng

# Environment variables
ENV SEARXNG_SETTINGS_PATH="/etc/searxng/settings.yml"
ENV UWSGI_SETTINGS_PATH="/etc/searxng/uwsgi.ini"
ENV BIND_ADDRESS="[::]:8080"
ENV INSTANCE_NAME="OtsX"

# Create volumes for config and cache
VOLUME ["/etc/searxng", "/var/cache/searxng"]

# Expose port
EXPOSE 8080

# Start SearXNG with proper uwsgi config
CMD ["uwsgi", "/etc/searxng/uwsgi.ini"]

# Start with simple gunicorn (NO uwsgi complexity)
#CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "--timeout", "120", "searx.webapp:application"] 