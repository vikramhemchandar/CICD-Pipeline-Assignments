# Stage 1: Build and Test
FROM python:3.12-slim AS builder
WORKDIR /app
COPY Requirements.txt .
RUN pip install --no-cache-dir -r Requirements.txt
COPY . .
RUN pytest

# Stage 2: Production
FROM python:3.12-slim
WORKDIR /app
COPY Requirements.txt .
RUN pip install --no-cache-dir Flask
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]