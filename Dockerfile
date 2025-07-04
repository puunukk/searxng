FROM python:3.11-alpine

# Set environment variables
ENV SEARXNG_SETTINGS_PATH="/etc/searxng/settings.yml"
ENV INSTANCE_NAME="OtsXNG"
ENV BIND_ADDRESS="0.0.0.0:8080"

# Create searxng user and directories
RUN adduser -D -h /usr/local/searxng -s /bin/sh searxng \
    && mkdir -p /etc/searxng /usr/local/searxng/run \
    && chown -R searxng:searxng /etc/searxng /usr/local/searxng

RUN pip install "setuptools<71.0.0" wheel
# Install SearXNG itself as a package (this is the key step we were missing)
#RUN pip install --use-pep517 --no-build-isolation -e .
RUN pip install --no-use-pep517 -e .


WORKDIR /app

COPY . /app
# Install dependencies first
RUN pip install -r requirements.txt

# The documentation shows SearXNG looks for environment variables
# We'll use those to override the default settings
EXPOSE 8080

# Now we can use the official command because searx is properly installed
CMD ["python", "searx/webapp.py"]
# CMD ["python", "-m", "searx/webapp.py"]
