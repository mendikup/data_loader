FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

ENV MYSQL_USER="memdykuperman"
ENV MYSQL_PASSWORD="1234"
ENV MYSQL_DATABASE=mydb
ENV MYSQL_ROOT_PASSWORD=mysql://mysql:3306/

CMD ["uvicorn", "app.app:app", "--host", "0.0.0.0", "--port", "8000"]
