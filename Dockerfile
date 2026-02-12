FROM python:3.12-slim
WORKDIR /app
COPY . .
RUN pip install flask
RUN pip install pytest
EXPOSE 5000
CMD ["python", "app.py"]
