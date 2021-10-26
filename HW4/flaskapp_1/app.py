from flask import Flask, request
import socket

app = Flask(__name__)

@app.route('/')
def main():
	# remote address through Flask: https://stackoverflow.com/questions/3759981/get-ip-address-of-visitors-using-flask-for-python
	print(f'Received request from {request.remote_addr}')
	# host name through python: https://stackoverflow.com/questions/4271740/how-can-i-use-python-to-get-the-system-hostname
	hostname = socket.gethostname()
	print(f'You\'ve hit {hostname}')
	return 'Message for version 1'

if __name__ == '__main__':
	app.run()
