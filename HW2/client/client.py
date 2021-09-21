import requests
import time
import os

def main():
	period = os.environ['PERIOD']
	ip_address = os.environ['IP_ADDRESS']
	for i in range(20):
		req = requests.get(f'http://{ip_address}:80/')
		print(req.text)
		time.sleep(int(period))

if __name__ == '__main__':
	main()
