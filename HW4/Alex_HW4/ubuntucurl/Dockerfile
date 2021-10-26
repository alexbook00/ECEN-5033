FROM ubuntu

RUN apt update -y
RUN apt upgrade -y
RUN apt install curl -y
RUN apt install iproute2 -y
RUN apt install dnsutils -y

ADD . /ubuntucurl
WORKDIR /ubuntucurl
COPY manycurl.sh /ubuntucurl/

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
