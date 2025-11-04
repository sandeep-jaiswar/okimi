#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Stopping Okimi services...${NC}\n"

services=(
    "okimi-gateway"
    "okimi-user"
    "okimi-auth"
    "keycloak"
    "redis"
    "postgresql"
)

for service in "${services[@]}"; do
    if sudo systemctl is-enabled "$service" >/dev/null 2>&1; then
        echo -n "Stopping $service... "
        sudo systemctl stop "$service" || {
            echo -e "${RED}Failed${NC}"
            echo -e "${RED}Error stopping $service. Check logs with: journalctl -u $service${NC}"
            continue
        }
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${YELLOW}$service not enabled, skipping${NC}"
    fi
done

echo -e "\n${GREEN}All services stopped${NC}"
