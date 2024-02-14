# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory in the container to /app
WORKDIR /app

# Add the current directory contents into the container at /app
ADD . /app

RUN mkdir -p /app/cache && chmod -R 775 /app/cache

RUN chmod -R 775 /app/.chroma

# Install any needed packages specified in requirements.txt
# Also install build-essential for C++ compiler
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential && \
    pip install -r requirements.txt

ENV TRANSFORMERS_CACHE=/app/cache

ENV HF_HOME=/app/cache

RUN pip install sentence_transformers

RUN pip3 install torch torchvision torchaudio

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the command to start your app using gunicorn
CMD ["gunicorn", "-b", ":8000", "webui_app:app"]