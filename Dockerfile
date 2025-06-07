FROM python:3.9-slim-buster

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV TF_DISABLE_MKL=1
ENV TF_DISABLE_SEGMENT_REDUCTION_OP_DETERMINISM_EXCEPTIONS=true
ENV TF_CPP_MIN_LOG_LEVEL=2
ENV TF_ENABLE_ONEDNN_OPTS=0
ENV NUMBA_DISABLE_INTEL_SVML=1
ENV NUMBA_NUM_THREADS=1
ENV OMP_NUM_THREADS=1
ENV PORT=8000

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libsndfile1 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements first to leverage Docker cache
COPY Requirements.txt .

# Install Python dependencies with retry mechanism
RUN pip install --no-cache-dir --retries 3 --timeout 100 -r Requirements.txt

# Copy the rest of the application
COPY . .

# Make start script executable
RUN chmod +x start.sh

# Expose port
EXPOSE ${PORT}

# Command to run the application
CMD ["./start.sh"] 