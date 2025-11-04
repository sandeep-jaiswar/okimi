#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Okimi Services Status${NC}\n"

services=(
    "postgresql"
    "redis"
    "keycloak"
    "okimi-auth"
    "okimi-user"
    "okimi-gateway"
)

for service in "${services[@]}"; do
    if sudo systemctl is-active --quiet "$service"; then
        status="${GREEN}✓ Running${NC}"
    else
        status="${RED}✗ Stopped${NC}"
    fi
    printf "%-20s %b\n" "$service:" "$status"
done

echo -e "\n${YELLOW}Port Status:${NC}"

ports=(
    "5432:PostgreSQL"
    "6379:Redis"
    "8080:Keycloak"
    "8081:Auth Service"
    "8082:User Service"
    "8000:API Gateway"
)

for port_info in "${ports[@]}"; do
    port=$(echo $port_info | cut -d: -f1)
    name=$(echo $port_info | cut -d: -f2)
    if nc -z localhost $port 2>/dev/null; then
        printf "%-20s ${GREEN}✓${NC} Listening\n" "$name:"
    else
        printf "%-20s ${RED}✗${NC} Not listening\n" "$name:"
    fi
done
