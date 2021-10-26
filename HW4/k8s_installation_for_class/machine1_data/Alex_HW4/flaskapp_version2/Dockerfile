FROM python:3
ENV PYTHONUNBUFFERED 1
ADD . /flaskapp_2
WORKDIR /flaskapp_2
RUN pip install -r requirements.txt
EXPOSE 8080
CMD flask run -h 0.0.0.0 -p 8080
