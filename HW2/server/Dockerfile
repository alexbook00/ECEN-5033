FROM python:3
ENV PYTHONUNBUFFERED 1
ADD . /server
WORKDIR /server
RUN pip install -r requirements.txt
CMD flask run -h 0.0.0.0 -p 80
