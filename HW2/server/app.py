from flask import Flask
import os

app = Flask(__name__)
message = os.environ['MESSAGE']

@app.route('/', methods=['GET'])
def main():
	return message

if __name__ == '__main__':
	app.run()
