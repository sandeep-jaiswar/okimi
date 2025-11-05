#!/bin/bash

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Starting Okimi services...${NC}\n"

services=(
    "postgresql"
    "redis-server"
    "keycloak"
    "okimi-auth"
    "okimi-user"
    "okimi-gateway"
)

for service in "${services[@]}"; do
    # Check if the unit file exists
    if systemctl list-unit-files --type=service --no-legend | grep -q "^${service}\.service"; then
        echo -n "Starting $service... "
        if sudo systemctl start "$service"; then
            sleep 2
            if sudo systemctl is-active --quiet "$service"; then
                echo -e "${GREEN}✓${NC}"
            else
                echo -e "${YELLOW}Started but not active (check logs)${NC}"
            fi
        else
            echo -e "${YELLOW}Failed to start (check logs)${NC}"
        fi
    else
        echo -e "${YELLOW}$service.service not found, skipping${NC}"
    fi
done

echo -e "\n${GREEN}Start sequence completed${NC}"
