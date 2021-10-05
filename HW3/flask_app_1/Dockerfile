FROM python:3
ENV PYTHONUNBUFFERED 1
ADD . /flask_app_1
WORKDIR /flask_app_1
RUN pip install -r requirements.txt
EXPOSE 80
CMD flask run -h 0.0.0.0 -p 80
