FROM python:3.11
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt

# Generate secret key if not provided via environment variable
RUN if [ -z "$SEARXNG_SECRET_KEY" ]; then \
        export SEARXNG_SECRET_KEY=$(python -c "import secrets; print(secrets.token_hex(32))"); \
    fi && \
    sed -i "s/ultrasecretkey/${SEARXNG_SECRET_KEY}/g" searx/settings.yml

CMD ["python", "-m", "searx/webapp.py"]
