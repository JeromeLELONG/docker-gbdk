DOCKER_COMPOSE = docker-compose -f docker-compose.yml
ALL_CONTAINERS = docker ps -aq

start: ## Run ALL the services in development mode
	docker-compose up
	
stop: ## start e2e tests in already running container
	docker-compose down

build: 
	docker build -t gstolarz/gbdk -t gstolarz/gbdk:2.96a .

connect: ## Start a terminal session in server container
	$(DOCKER_COMPOSE) exec docker-gbdk bash

delete:
	docker-compose down
	docker rmi docker-gbdk_docker-gbdk:latest