build:
	docker build -t nominatim .

start:
	docker run -p 8080:80 nominatim