PWD := $(shell pwd)
FRONT_PATH=front
build:
	go build -o simply
build-docker:
	docker build -t simply:0.0.1 .
node:
	docker run -it --rm \
		-v $(PWD)/$(FRONT_PATH):/app \
		-w /app/laba \
		node:25 bash
		
front-dev:
	docker run -it --rm \
		-p 5173:5173 \
		-v $(PWD)/$(FRONT_PATH):/app \
		-w /app/laba \
		node:25 npm run dev -- --host 0.0.0.0

front-build:
	docker run -it --rm \
		-v $(PWD)/$(FRONT_PATH):/app  \
		-w /app/laba \
		node:25 npm run build

run-simply:
	docker compose up -d
