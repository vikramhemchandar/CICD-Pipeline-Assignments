# Stage 1: Build and Test
FROM python:3.12-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN python -m pytest --version

# Stage 2: Production
# FROM python:3.12-slim
# WORKDIR /app
# COPY requirements.txt .
# RUN pip install --no-cache-dir Flask
# COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]