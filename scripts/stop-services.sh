#!/bin/bash

set -euo pipefail

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
    "redis-server"
    "postgresql"
)

for service in "${services[@]}"; do
    # Stop only if active
    if sudo systemctl is-active --quiet "$service"; then
        echo -n "Stopping $service... "
        if sudo systemctl stop "$service"; then
            echo -e "${GREEN}✓${NC}"
        else
            echo -e "${RED}Failed${NC}"
            echo -e "${RED}Error stopping $service. Check logs with: journalctl -u $service${NC}"
            continue
        fi
    else
        echo -e "${YELLOW}$service not active, skipping${NC}"
    fi
done

echo -e "\n${GREEN}All requested services processed${NC}"
