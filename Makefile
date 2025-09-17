# BI Platform - Apache Superset Makefile
# Provides convenient commands for managing the Docker Compose services

# Default target
.DEFAULT_GOAL := help

# Load environment variables from compose.env if it exists
ifneq (,$(wildcard ./compose.env))
    include compose.env
    export
endif

# Set default Superset version if not specified
SUPERSET_VERSION ?= 5.0.0

# Colors for output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
WHITE := \033[1;37m
NC := \033[0m # No Color

##@ Basic Commands

.PHONY: help
help: ## Display this help message
	@echo "$(BLUE)BI Platform - Apache Superset$(NC)"
	@echo "$(YELLOW)Available commands:$(NC)"
	@awk 'BEGIN {FS = ":.*##"; printf "\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  $(CYAN)%-15s$(NC) %s\n", $$1, $$2 } /^##@/ { printf "\n$(PURPLE)%s$(NC)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: start
start: ## Start all services
	@echo "$(GREEN)🚀 Starting BI Platform services...$(NC)"
	@echo "$(YELLOW)Using Superset version: $(SUPERSET_VERSION)$(NC)"
	@docker-compose up -d
	@echo "$(GREEN)✅ Services started successfully!$(NC)"
	@echo "$(CYAN)Access the platform at: http://localhost:8088$(NC)"

.PHONY: stop
stop: ## Stop all services
	@echo "$(YELLOW)🛑 Stopping BI Platform services...$(NC)"
	@docker-compose down
	@echo "$(GREEN)✅ Services stopped successfully!$(NC)"

.PHONY: restart
restart: ## Restart all services
	@echo "$(YELLOW)🔄 Restarting BI Platform services...$(NC)"
	@docker-compose down
	@echo "$(BLUE)Using Superset version: $(SUPERSET_VERSION)$(NC)"
	@docker-compose up -d
	@echo "$(GREEN)✅ Services restarted successfully!$(NC)"
	@echo "$(CYAN)Access the platform at: http://localhost:8088$(NC)"

.PHONY: status
status: ## Show status of all services
	@echo "$(BLUE)📊 BI Platform Service Status$(NC)"
	@echo "$(YELLOW)Using Superset version: $(SUPERSET_VERSION)$(NC)"
	@echo ""
	@docker-compose ps

##@ Advanced Commands

.PHONY: logs
logs: ## Show logs for all services
	@echo "$(BLUE)📝 Showing logs for all services$(NC)"
	@docker-compose logs -f

.PHONY: logs-superset
logs-superset: ## Show logs for Superset application only
	@echo "$(BLUE)📝 Showing Superset application logs$(NC)"
	@docker-compose logs -f superset

.PHONY: build
build: ## Build/rebuild all services
	@echo "$(YELLOW)🔨 Building BI Platform services...$(NC)"
	@echo "$(BLUE)Using Superset version: $(SUPERSET_VERSION)$(NC)"
	@docker-compose build --no-cache
	@echo "$(GREEN)✅ Build completed successfully!$(NC)"

.PHONY: pull
pull: ## Pull latest images
	@echo "$(YELLOW)📥 Pulling latest images...$(NC)"
	@docker-compose pull
	@echo "$(GREEN)✅ Images pulled successfully!$(NC)"

.PHONY: clean
clean: ## Stop services and remove containers, networks, volumes
	@echo "$(RED)🧹 Cleaning up BI Platform resources...$(NC)"
	@echo "$(YELLOW)This will remove all containers, networks, and volumes!$(NC)"
	@read -p "Are you sure? (y/N) " -n 1 -r; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo ""; \
		docker-compose down -v --remove-orphans; \
		docker system prune -f; \
		echo "$(GREEN)✅ Cleanup completed!$(NC)"; \
	else \
		echo ""; \
		echo "$(YELLOW)Cleanup cancelled.$(NC)"; \
	fi

##@ Database Commands

.PHONY: db-shell
db-shell: ## Connect to PostgreSQL database shell
	@echo "$(BLUE)💾 Connecting to PostgreSQL database...$(NC)"
	@docker-compose exec db psql -U superset -d superset

.PHONY: db-backup
db-backup: ## Backup database to backup.sql
	@echo "$(YELLOW)💾 Creating database backup...$(NC)"
	@docker-compose exec db pg_dump -U superset superset > backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)✅ Database backup created!$(NC)"

##@ Development Commands

.PHONY: dev
dev: ## Start services in development mode with live reload
	@echo "$(GREEN)🛠️  Starting BI Platform in development mode...$(NC)"
	@echo "$(YELLOW)Using Superset version: $(SUPERSET_VERSION)$(NC)"
	@docker-compose up

.PHONY: shell
shell: ## Access Superset application shell
	@echo "$(BLUE)🐚 Accessing Superset shell...$(NC)"
	@docker-compose exec superset bash

.PHONY: init
init: ## Initialize/reinitialize Superset (run migrations, create admin user)
	@echo "$(YELLOW)🔧 Initializing Superset...$(NC)"
	@docker-compose exec superset superset db upgrade
	@docker-compose exec superset superset init
	@echo "$(GREEN)✅ Superset initialized successfully!$(NC)"

##@ Information Commands

.PHONY: version
version: ## Show current configuration and versions
	@echo "$(BLUE)📋 BI Platform Configuration$(NC)"
	@echo "$(YELLOW)Superset Version:$(NC) $(SUPERSET_VERSION)"
	@echo "$(YELLOW)Docker Compose Version:$(NC) $(shell docker-compose --version)"
	@echo "$(YELLOW)Docker Version:$(NC) $(shell docker --version)"
	@echo ""
	@echo "$(BLUE)📊 Service URLs:$(NC)"
	@echo "$(CYAN)• Superset:$(NC) http://localhost:8088"
	@echo "$(CYAN)• PostgreSQL:$(NC) localhost:15432"
	@echo "$(CYAN)• Redis:$(NC) localhost:16379"

.PHONY: health
health: ## Check health status of all services
	@echo "$(BLUE)🩺 Health Check$(NC)"
	@echo "$(YELLOW)Service Status:$(NC)"
	@docker-compose ps --format "table {{.Service}}\t{{.State}}\t{{.Status}}"
	@echo ""
	@echo "$(YELLOW)Container Health:$(NC)"
	@docker-compose exec superset curl -f http://localhost:8088/health || echo "$(RED)Superset health check failed$(NC)"
