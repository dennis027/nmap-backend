
# syntax=docker/dockerfile:1.4

FROM python:3.8.16-alpine3.16
EXPOSE 8000
WORKDIR /app_backend 
COPY requirements.txt /app_backend 
RUN pip3 install Cmake

RUN apk update && apk add curl


RUN python3 -m venv venv
RUN . venv/bin/activate
RUN pip3 install -r requirements.txt --no-cache-dir
COPY . /app_backend/ 
ENTRYPOINT [ "python3" ]
CMD ["manage.py", "runserver", "0.0.0.0:8000"]
