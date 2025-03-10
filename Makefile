.PHONY: up
up: ## Run the web app
	docker compose -f deploy/docker-compose.yml up --build

.PHONY: up_old
up_old: ## Run the web app, used for old vs. Docker
	docker-compose -f deploy/docker-compose.yml up --build

.PHONY: down
down: ## Stop the container
	docker compose -f deploy/docker-compose.yml down

.PHONY: down_old
down_old: ## Stop the container, used for old vs. Docker
	docker-compose -f deploy/docker-compose.yml down

.PHONY: clean
clean: ## Remove the container
	docker rm -f $$(docker ps -qa)
