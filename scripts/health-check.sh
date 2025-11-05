#!/bin/bash

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Okimi Services Health Check${NC}\n"

# Exit code tracker
exit_code=0

# Ensure required tools
missing_tools=()
for cmd in nc curl free df uptime; do
    if ! command -v $cmd >/dev/null 2>&1; then
        missing_tools+=("$cmd")
    fi
done
if [ ${#missing_tools[@]} -ne 0 ]; then
    echo -e "${YELLOW}Warning: missing tools: ${missing_tools[*]}. Install them for more accurate checks.${NC}"
fi

# Service health checks
check_service() {
    local service=$1
    local port=$2
    local endpoint=$3

    printf "%-25s" "$service:"

    # Check if service is running
    if ! sudo systemctl is-active --quiet "$service"; then
        echo -e "${RED}✗ Service not running${NC}"
        exit_code=1
        return
    fi

    # Check if port is listening (if specified)
    if [ -n "$port" ]; then
        if command -v nc >/dev/null 2>&1 && nc -z localhost "$port" 2>/dev/null; then
            :
        else
            echo -e "${RED}✗ Port $port not listening${NC}"
            exit_code=1
            return
        fi
    fi

    # Check HTTP endpoint (if specified)
    if [ -n "$endpoint" ]; then
        if command -v curl >/dev/null 2>&1 && curl -sf "$endpoint" >/dev/null 2>&1; then
            echo -e "${GREEN}✓ Healthy${NC}"
        else
            echo -e "${YELLOW}⚠ Service running but endpoint unreachable${NC}"
            exit_code=1
        fi
    else
        echo -e "${GREEN}✓ Running${NC}"
    fi
}

# Database services
echo -e "${YELLOW}Database Services:${NC}"
check_service "postgresql" "5432"
check_service "redis-server" "6379"

# Identity service
echo -e "\n${YELLOW}Identity Service:${NC}"
check_service "keycloak" "8080" "http://localhost:8080/health"

# Okimi services
echo -e "\n${YELLOW}Okimi Services:${NC}"
check_service "okimi-auth" "8081" "http://localhost:8081/health"
check_service "okimi-user" "8082" "http://localhost:8082/health"
check_service "okimi-gateway" "8000" "http://localhost:8000/health"

# System resources check
echo -e "\n${YELLOW}System Resources:${NC}"
printf "%-25s" "Memory available:"
mem_available=$(free -m | awk 'NR==2{printf "%.0f MB", $7}')
echo -e "${GREEN}$mem_available${NC}"

printf "%-25s" "Disk available:"
disk_available=$(df -h / | awk 'NR==2{print $4}')
echo -e "${GREEN}$disk_available${NC}"

printf "%-25s" "CPU load:"
cpu_load=$(uptime | awk -F'load average:' '{print $2}' | xargs)
echo -e "${GREEN}$cpu_load${NC}"

# Final status
echo -e "\n${YELLOW}Overall Health:${NC}"
if [ $exit_code -eq 0 ]; then
    echo -e "${GREEN}✓ All services healthy${NC}"
else
    echo -e "${RED}✗ Some services have issues${NC}"
    echo -e "${YELLOW}Run 'journalctl -u <service-name>' to check logs${NC}"
fi

exit $exit_code
