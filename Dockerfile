FROM python:3.11

COPY . /app
WORKDIR /app

# Install dependencies first
RUN pip install -r requirements.txt

# Install SearXNG itself as a package (this is the key step we were missing)
RUN pip install --use-pep517 --no-build-isolation -e .

# The documentation shows SearXNG looks for environment variables
# We'll use those to override the default settings
EXPOSE 8080

# Now we can use the official command because searx is properly installed
CMD ["python", "searx/webapp.py"]
# CMD ["python", "-m", "searx/webapp.py"]
