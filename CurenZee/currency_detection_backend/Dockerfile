
# Use the official Python image from the Docker Hub
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

#COPY Dockerfile Dockerfile
#COPY docker-compose.yml docker-compose.yml
# Upgrade pip
RUN python -m pip install --upgrade pip

# Install necessary system dependencies for OpenCV
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0

# Install TensorFlow with Intel optimization and GPU support
#RUN pip install tensorflow-intel
#RUN pip install tensorflow[and-cuda]==2.14

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

 RUN pip install opencv-python-headless

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Run gunicorn when the container launches
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--timeout", "600", "app:app"]
