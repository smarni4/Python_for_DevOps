FROM python:3.11-alpine

WORKDIR /app

COPY requirements.txt ./app
COPY devops /app

RUN pip install --upgrade pip
RUN pip install django tzdata
RUN cd devops

ENTRYPOINT ["python3"]

CMD ["manage.py", "runserver", "0.0.0.0:8000"]
