#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
OKIMI_HOME="${HOME}/okimi"
ANSIBLE_DIR="${OKIMI_HOME}/ansible"
REPO_URL="https://github.com/sandeep-jaiswar/okimi.git"

echo -e "${GREEN}=====================================\n"
echo "  Okimi Platform Setup Script"
echo "  =====================================\n${NC}"

# Step 1: Check prerequisites
echo -e "${YELLOW}[1/6]${NC} Checking system prerequisites..."

check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}✗ $1 is not installed${NC}"
        return 1
    fi
    echo -e "${GREEN}✓ $1 is installed${NC}"
    return 0
}

check_command "python3" || { echo "Python3 required"; exit 1; }
check_command "git" || { echo "Git required"; exit 1; }

# Step 2: Clone repository (if not already present)
echo -e "\n${YELLOW}[2/6]${NC} Cloning repository..."
if [ -d "$OKIMI_HOME" ]; then
    echo -e "${YELLOW}Repository already exists at ${OKIMI_HOME}${NC}"
else
    git clone $REPO_URL $OKIMI_HOME
    echo -e "${GREEN}✓ Repository cloned${NC}"
fi

cd $OKIMI_HOME

# Step 3: Install Ansible
echo -e "\n${YELLOW}[3/6]${NC} Installing Ansible..."
if ! command -v ansible &> /dev/null; then
    python3 -m pip install ansible jinja2 -q
    echo -e "${GREEN}✓ Ansible installed${NC}"
else
    echo -e "${GREEN}✓ Ansible already installed${NC}"
fi

# Step 4: Run Ansible playbook
echo -e "\n${YELLOW}[4/6]${NC} Running Ansible playbook..."
cd $ANSIBLE_DIR
ansible-playbook -i inventory.ini playbooks/setup.yml --extra-vars "okimi_home=$OKIMI_HOME" -K

# Step 5: Import Jira tickets
echo -e "\n${YELLOW}[5/6]${NC} Importing Jira tickets..."
if [ -z "$JIRA_URL" ] || [ -z "$JIRA_TOKEN" ] || [ -z "$JIRA_EMAIL" ]; then
    echo -e "${YELLOW}Skipping Jira import (credentials not set)${NC}"
    echo -e "${YELLOW}To import later, run:${NC}"
    echo "  export JIRA_URL='https://okimi.atlassian.net'"
    echo "  export JIRA_EMAIL='your-email@example.com'"
    echo "  export JIRA_TOKEN='your-api-token'"
    echo "  python3 scripts/import-jira-tickets.py"
else
    python3 scripts/import-jira-tickets.py
fi

# Step 6: Start services
echo -e "\n${YELLOW}[6/6]${NC} Starting services..."
bash scripts/start-services.sh

echo -e "\n${GREEN}=====================================\n"
echo "  Setup Complete!"
echo "  =====================================\n${NC}"

echo -e "${GREEN}Services Status:${NC}"
bash scripts/check-status.sh

echo -e "\n${GREEN}Access URLs:${NC}"
echo "  Keycloak:     http://localhost:8080"
echo "  Auth Service: http://localhost:8081"
echo "  User Service: http://localhost:8082"
echo "  API Gateway:  http://localhost:8000"

echo -e "\n${YELLOW}Default Keycloak Admin:${NC}"
echo "  Username: admin"
echo "  Password: admin123"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "  1. Configure Keycloak realm and clients"
echo "  2. Update service configurations in config/app/"
echo "  3. Run 'bazel build //...' to build services"
echo "  4. Run 'bazel test //...' to run tests"
