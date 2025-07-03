FROM python:3.11
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt

# Generate secret key if not provided via environment variable
# RUN if [ -z "$SEARXNG_SECRET_KEY" ]; then \
#         export SEARXNG_SECRET_KEY=$(python -c "import secrets; print(secrets.token_hex(32))"); \
#     fi && \
#     sed -i "s/ultrasecretkey/${SEARXNG_SECRET_KEY}/g" searx/settings.yml

# Create startup script that configures both secret key and network binding
RUN echo '#!/bin/bash\n\
# Replace secret key if environment variable is provided\n\
if [ ! -z "$SEARXNG_SECRET_KEY" ]; then\n\
    sed -i "s/ultrasecretkey/$SEARXNG_SECRET_KEY/g" /app/searx/settings.yml\n\
fi\n\
# Start SearXNG with proper host binding\n\
export FLASK_APP=searx.webapp\n\
exec python -m flask run --host=0.0.0.0 --port=8080' > /app/start.sh && chmod +x /app/start.sh

CMD ["/app/start.sh"]
# CMD ["python", "-m", "searx/webapp.py"]
