#!/bin/bash

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Starting Okimi services...${NC}\n"

services=(
    "postgresql"
    "redis"
    "keycloak"
    "okimi-auth"
    "okimi-user"
    "okimi-gateway"
)

for service in "${services[@]}"; do
    if sudo systemctl is-enabled "$service" >/dev/null 2>&1; then
        echo -n "Starting $service... "
        sudo systemctl start "$service"
        sleep 2
        if sudo systemctl is-active --quiet "$service"; then
            echo -e "${GREEN}✓${NC}"
        else
            echo "Failed to start $service"
        fi
    fi
done

echo -e "\n${GREEN}All services started${NC}"
