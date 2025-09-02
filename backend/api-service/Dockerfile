# Use the official Python image as a parent image
FROM python:3.11-slim as builder

# Set the working directory
WORKDIR /app

# Prevent python from writing pyc files
ENV PYTHONDONTWRITEBYTECODE 1
# Ensure python output is sent straight to the terminal
ENV PYTHONUNBUFFERED 1

# Create a virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# --- Final Stage ---
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Copy the virtual environment from the builder stage
COPY --from=builder /opt/venv /opt/venv

# Copy the application code
COPY . .

# Make port 8080 available to the world outside this container
# Note: Cloud Run uses the PORT env var, but this is good practice
EXPOSE 8080

# Set the new path
ENV PATH="/opt/venv/bin:$PATH"

# Run the app. Gunicorn is a production-ready web server.
# We use the PORT environment variable provided by Cloud Run.
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "1", "--threads", "8", "--timeout", "0", "main:app"]
