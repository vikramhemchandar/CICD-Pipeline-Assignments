FROM python:3.12-slim
WORKDIR /app
COPY . .
RUN pip install -r Requirements.txt
EXPOSE 5000
CMD ["python", "app.py"]