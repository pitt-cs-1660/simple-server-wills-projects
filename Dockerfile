# Build stage

# Use Python 3.12 as base image
FROM python:3.12 AS builder

# Install uv package manager
RUN pip install uv

# Set working directory
WORKDIR /app

# Copy pyproject.toml
COPY pyproject.toml ./

# Install Python dependencies
RUN uv sync --no-install-project --no-editable







# Final Stage

# Using Python 3.12-slim as base image
FROM python:3.12-slim AS final

# Set environment variables 
ENV VIRTUAL_ENV=/app/.venv 
ENV PATH="/app/.venv/bin:${PATH}" 
ENV PYTHONDONTWRITEBYTECODE=1 
ENV PYTHONUNBUFFERED=1 
ENV PYTHONPATH=/app

# Set working directory
WORKDIR /app

# Copy venv from builder
COPY --from=builder /app/.venv /app/.venv

# Copy application source code
COPY . .

# Create a non-root user
RUN useradd -m appuser

# Expose port 8000
EXPOSE 8000

# Run FastAPI 
CMD ["uvicorn", "cc_simple_server.server:app", "--host", "0.0.0.0", "--port", "8000"]