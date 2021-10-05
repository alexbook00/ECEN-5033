from flask import Flask

app = Flask(__name__)

@app.route('/')
def main():
	return 'Message for version 3'

if __name__ == '__main__':
	app.run()
