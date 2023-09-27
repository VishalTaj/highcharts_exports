# Use the Python 3.13.5 Alpine image as the base image
FROM python:3.13.5-alpine AS base

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    FLASK_APP=app.py

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file into the container at /app
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN apk add --no-cache --virtual .build-deps \
        gcc musl-dev libffi-dev \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del .build-deps

# Copy the current directory contents into the container at /app
COPY . /app/

# Expose port 5000 for the Flask application
EXPOSE 5000

FROM base AS development
# Define the command to run your Flask app
CMD ["flask", "run", "--host", "0.0.0.0"]

FROM base AS production
RUN pip install --no-cache-dir gunicorn
RUN which gunicorn && gunicorn --version
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]