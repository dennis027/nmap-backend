
# syntax=docker/dockerfile:1.4

FROM python:3.8.16-alpine3.16
EXPOSE 8000
WORKDIR /app_backend 
COPY ./nmap-backend/requirements.txt /app_backend/requirements.txt
RUN pip3 install Cmake

RUN apk update && apk add curl


# Install ODBC Driver 17 for SQL Server
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.10.2.1-1_amd64.apk
RUN curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.10.1.1-1_amd64.apk

RUN apk add --allow-untrusted msodbcsql17_17.10.2.1-1_amd64.apk
RUN apk add --allow-untrusted mssql-tools_17.10.1.1-1_amd64.apk

RUN apk add gcc libc-dev g++ libffi-dev libxml2 unixodbc unixodbc-dev

RUN python3 -m venv venv
RUN . venv/bin/activate
RUN pip3 install -r /app_backend/requirements.txt --no-cache-dir
COPY . /app_backend/ 
ENTRYPOINT [ "python3" ]
CMD ["./nmap-backend/manage.py", "runserver", "0.0.0.0:8000"]
