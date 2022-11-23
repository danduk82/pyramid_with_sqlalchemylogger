
IMAGE_NAME=pyramidsqlalchemytest

PHONY: .venv
.venv: .venv/timestamp

.venv/timestamp:
	python3 -m venv .venv;
	touch .venv/timestamp

PHONY: install
install: .venv/timestamp
	.venv/bin/pip install -r requirements.txt -e .[dev]

PHONY: serve
serve: 
	.venv/bin/pserve development.ini --reload


PHONY: build
build: 
	docker build -t $(IMAGE_NAME):latest .

PHONY: docker-serve
docker-serve: build
	docker run --rm -d -p 8080:8080 -p 6543:6543 --name=$(IMAGE_NAME) $(IMAGE_NAME):latest

PHONY: docker-serve-fe
docker-serve-fe: build
	docker run --rm -p 8080:8080 -p 6543:6543 --name=$(IMAGE_NAME) $(IMAGE_NAME):latest

PHONY: docker-exec
docker-exec:
	docker exec -it $(IMAGE_NAME) bash

PHONY: docker-logs
docker-logs:
	docker logs $(IMAGE_NAME)

PHONY: docker-logs-follow
docker-logs-follow:
	docker logs -f $(IMAGE_NAME)


PHONY: docker-stop
docker-stop:
	docker rm -f $(IMAGE_NAME)


