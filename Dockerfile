# Dockerfile
FROM python:3.10-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Create staticfiles directory
RUN mkdir -p staticfiles

# Run Django setup commands with error handling
RUN python manage.py collectstatic --noinput --settings=myproject.settings || echo "Static files collection failed, continuing..."

# Create a non-root user
RUN useradd -m -u 1000 django && chown -R django:django /app
USER django

EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health/ || exit 1

# Use gunicorn with more verbose logging and error handling
CMD ["sh", "-c", "python manage.py migrate --noinput || echo 'Migration failed'; gunicorn --bind 0.0.0.0:8000 --workers 1 --timeout 120 --log-level info --access-logfile - --error-logfile - myproject.wsgi:application"]