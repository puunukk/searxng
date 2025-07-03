FROM python:3.11
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt

# The documentation shows SearXNG looks for environment variables
# We'll use those to override the default settings
EXPOSE 8080

CMD ["python", "-m", "searx/webapp.py"]
