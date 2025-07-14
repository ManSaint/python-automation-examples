#!/bin/bash

# Python Automation Examples - Deployment Script
# This script helps deploy the automation system to various environments

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DEFAULT_ENV="development"
DEFAULT_DOMAIN="localhost"
DEFAULT_PORT="5000"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_help() {
    echo "Python Automation Examples - Deployment Script"
    echo ""
    echo "Usage: $0 [OPTIONS] COMMAND"
    echo ""
    echo "Commands:"
    echo "  local      Deploy locally using Docker Compose"
    echo "  staging    Deploy to staging environment"
    echo "  production Deploy to production environment"
    echo "  update     Update existing deployment"
    echo "  backup     Create backup of data and configurations"
    echo "  restore    Restore from backup"
    echo "  status     Show deployment status"
    echo "  logs       Show application logs"
    echo "  clean      Clean up deployment artifacts"
    echo ""
    echo "Options:"
    echo "  -e, --env ENV          Environment (development, staging, production)"
    echo "  -d, --domain DOMAIN    Domain name (default: localhost)"
    echo "  -p, --port PORT        Port number (default: 5000)"
    echo "  -f, --force            Force deployment without confirmation"
    echo "  -v, --verbose          Verbose output"
    echo "  -h, --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 local                           # Deploy locally"
    echo "  $0 -e production -d example.com production  # Production deployment"
    echo "  $0 --verbose update                # Update with verbose output"
    echo ""
}

check_dependencies() {
    log_info "Checking dependencies..."
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        log_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    # Check if Docker is running
    if ! docker info &> /dev/null; then
        log_error "Docker is not running. Please start Docker first."
        exit 1
    fi
    
    log_success "All dependencies are available"
}

setup_environment() {
    log_info "Setting up environment for: $ENVIRONMENT"
    
    # Create necessary directories
    mkdir -p logs temp data backups n8n_workflows
    
    # Copy environment file if it doesn't exist
    if [ ! -f .env ]; then
        if [ -f .env.example ]; then
            cp .env.example .env
            log_warning "Created .env file from template. Please update it with your settings."
        else
            log_error ".env.example file not found. Cannot create environment file."
            exit 1
        fi
    fi
    
    # Set environment-specific variables
    case $ENVIRONMENT in
        "production")
            export FLASK_ENV=production
            export LOG_LEVEL=INFO
            export WEBHOOK_DEBUG=false
            ;;
        "staging")
            export FLASK_ENV=staging
            export LOG_LEVEL=INFO
            export WEBHOOK_DEBUG=false
            ;;
        "development")
            export FLASK_ENV=development
            export LOG_LEVEL=DEBUG
            export WEBHOOK_DEBUG=true
            ;;
    esac
    
    log_success "Environment setup complete"
}

build_images() {
    log_info "Building Docker images..."
    
    if [ "$VERBOSE" = true ]; then
        docker-compose build --no-cache
    else
        docker-compose build --no-cache > /dev/null 2>&1
    fi
    
    log_success "Docker images built successfully"
}

deploy_local() {
    log_info "Deploying locally with Docker Compose..."
    
    # Stop existing containers
    docker-compose down
    
    # Build and start services
    if [ "$VERBOSE" = true ]; then
        docker-compose up -d
    else
        docker-compose up -d > /dev/null 2>&1
    fi
    
    # Wait for services to start
    log_info "Waiting for services to start..."
    sleep 10
    
    # Check health
    check_health
    
    log_success "Local deployment complete!"
    echo ""
    echo "Services available at:"
    echo "  n8n:              http://${DOMAIN}:5678"
    echo "  Python Webhook:   http://${DOMAIN}:${PORT}"
    echo "  File Browser:     http://${DOMAIN}:8080"
    echo ""
    echo "Default credentials:"
    echo "  n8n:           admin / password"
    echo "  File Browser:  admin / admin"
}

deploy_staging() {
    log_info "Deploying to staging environment..."
    
    if [ "$FORCE" != true ]; then
        echo "This will deploy to staging environment."
        read -p "Continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Deployment cancelled"
            exit 0
        fi
    fi
    
    # Run tests first
    log_info "Running tests..."
    python -m pytest tests/ -v
    
    # Deploy
    deploy_local
    
    log_success "Staging deployment complete!"
}

deploy_production() {
    log_info "Deploying to production environment..."
    
    if [ "$FORCE" != true ]; then
        echo "⚠️  WARNING: This will deploy to PRODUCTION environment!"
        echo "Make sure you have:"
        echo "  - Updated .env with production settings"
        echo "  - Tested the deployment in staging"
        echo "  - Created a backup of existing data"
        echo ""
        read -p "Continue with production deployment? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Production deployment cancelled"
            exit 0
        fi
    fi
    
    # Validate production requirements
    validate_production
    
    # Create backup
    create_backup
    
    # Run tests
    log_info "Running production tests..."
    python -m pytest tests/ -v --tb=short
    
    # Deploy
    deploy_local
    
    log_success "Production deployment complete!"
}

validate_production() {
    log_info "Validating production requirements..."
    
    # Check environment variables
    required_vars=("SMTP_SERVER" "SMTP_USERNAME" "SMTP_PASSWORD" "API_KEY" "SECRET_KEY")
    
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            log_error "Required environment variable $var is not set"
            exit 1
        fi
    done
    
    # Check SSL certificate (if HTTPS)
    if [[ $DOMAIN != "localhost" ]] && [[ $DOMAIN != "127.0.0.1" ]]; then
        log_warning "Make sure SSL certificates are configured for $DOMAIN"
    fi
    
    log_success "Production validation passed"
}

check_health() {
    log_info "Checking service health..."
    
    # Check Python webhook
    if curl -f http://${DOMAIN}:${PORT}/health > /dev/null 2>&1; then
        log_success "Python webhook service is healthy"
    else
        log_error "Python webhook service is not responding"
        return 1
    fi
    
    # Check n8n
    if curl -f http://${DOMAIN}:5678/healthz > /dev/null 2>&1; then
        log_success "n8n service is healthy"
    else
        log_warning "n8n service may not be ready yet"
    fi
}

update_deployment() {
    log_info "Updating deployment..."
    
    # Pull latest changes
    git pull origin main
    
    # Rebuild images
    build_images
    
    # Restart services
    docker-compose restart
    
    # Check health
    sleep 5
    check_health
    
    log_success "Deployment updated successfully"
}

create_backup() {
    local backup_dir="backups/$(date +%Y%m%d_%H%M%S)"
    log_info "Creating backup in $backup_dir..."
    
    mkdir -p "$backup_dir"
    
    # Backup data
    if [ -d "data" ]; then
        cp -r data "$backup_dir/"
    fi
    
    # Backup logs
    if [ -d "logs" ]; then
        cp -r logs "$backup_dir/"
    fi
    
    # Backup configuration
    cp .env "$backup_dir/" 2>/dev/null || true
    cp docker-compose.yml "$backup_dir/"
    
    # Backup n8n workflows
    if [ -d "n8n_workflows" ]; then
        cp -r n8n_workflows "$backup_dir/"
    fi
    
    # Create backup archive
    tar -czf "$backup_dir.tar.gz" -C backups "$(basename $backup_dir)"
    rm -rf "$backup_dir"
    
    log_success "Backup created: $backup_dir.tar.gz"
}

restore_backup() {
    log_info "Available backups:"
    ls -la backups/*.tar.gz 2>/dev/null || {
        log_error "No backups found"
        exit 1
    }
    
    echo ""
    read -p "Enter backup filename to restore: " backup_file
    
    if [ ! -f "$backup_file" ]; then
        log_error "Backup file not found: $backup_file"
        exit 1
    fi
    
    log_info "Restoring from $backup_file..."
    
    # Stop services
    docker-compose down
    
    # Extract backup
    tar -xzf "$backup_file" -C backups/
    backup_dir="backups/$(basename $backup_file .tar.gz)"
    
    # Restore data
    if [ -d "$backup_dir/data" ]; then
        rm -rf data
        cp -r "$backup_dir/data" .
    fi
    
    # Restore configuration
    if [ -f "$backup_dir/.env" ]; then
        cp "$backup_dir/.env" .
    fi
    
    # Restart services
    docker-compose up -d
    
    log_success "Backup restored successfully"
}

show_status() {
    log_info "Deployment Status"
    echo ""
    
    # Show running containers
    echo "Running containers:"
    docker-compose ps
    echo ""
    
    # Show service health
    echo "Service health:"
    check_health
    echo ""
    
    # Show resource usage
    echo "Resource usage:"
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
}

show_logs() {
    log_info "Application logs"
    echo ""
    
    if [ $# -eq 0 ]; then
        # Show all logs
        docker-compose logs -f
    else
        # Show specific service logs
        docker-compose logs -f "$1"
    fi
}

clean_deployment() {
    log_info "Cleaning up deployment..."
    
    if [ "$FORCE" != true ]; then
        echo "This will remove all containers, images, and volumes."
        read -p "Continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Cleanup cancelled"
            exit 0
        fi
    fi
    
    # Stop and remove containers
    docker-compose down -v
    
    # Remove images
    docker-compose down --rmi all
    
    # Clean up Docker system
    docker system prune -f
    
    log_success "Cleanup complete"
}

# Parse command line arguments
ENVIRONMENT="$DEFAULT_ENV"
DOMAIN="$DEFAULT_DOMAIN"
PORT="$DEFAULT_PORT"
FORCE=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--env)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -d|--domain)
            DOMAIN="$2"
            shift 2
            ;;
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        local|staging|production|update|backup|restore|status|logs|clean)
            COMMAND="$1"
            shift
            break
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate command
if [ -z "$COMMAND" ]; then
    log_error "No command specified"
    show_help
    exit 1
fi

# Main execution
log_info "Python Automation Examples - Deployment Script"
log_info "Environment: $ENVIRONMENT"
log_info "Domain: $DOMAIN"
log_info "Port: $PORT"
echo ""

# Execute command
case $COMMAND in
    "local")
        check_dependencies
        setup_environment
        build_images
        deploy_local
        ;;
    "staging")
        ENVIRONMENT="staging"
        check_dependencies
        setup_environment
        build_images
        deploy_staging
        ;;
    "production")
        ENVIRONMENT="production"
        check_dependencies
        setup_environment
        build_images
        deploy_production
        ;;
    "update")
        check_dependencies
        update_deployment
        ;;
    "backup")
        create_backup
        ;;
    "restore")
        restore_backup
        ;;
    "status")
        show_status
        ;;
    "logs")
        show_logs "$@"
        ;;
    "clean")
        clean_deployment
        ;;
    *)
        log_error "Unknown command: $COMMAND"
        show_help
        exit 1
        ;;
esac

log_success "Deployment script completed successfully!"
