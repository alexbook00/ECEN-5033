FROM python:3
ENV PYTHONUNBUFFERED 1
ADD . /client
WORKDIR /client
RUN pip install -r requirements.txt
CMD python client.py
