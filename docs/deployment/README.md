# Deployment Guide

## Prerequisites

- Ubuntu 20.04 LTS or later
- 4GB RAM minimum (8GB recommended)
- 20GB disk space
- sudo access
- Internet connection for package installation

## Quick Deployment

### One-Command Setup

```bash
git clone https://github.com/sandeep-jaiswar/okimi.git
cd okimi
./scripts/setup.sh
```

This script will:
1. Install system dependencies
2. Set up PostgreSQL and Redis
3. Install and configure Keycloak
4. Build and deploy Okimi services
5. Create systemd service units
6. Start all services

### Verify Deployment

```bash
./scripts/check-status.sh
```

Expected output:
```
Okimi Services Status

postgresql:          ✓ Running
redis:               ✓ Running
keycloak:            ✓ Running
okimi-auth:          ✓ Running
okimi-user:          ✓ Running
okimi-gateway:       ✓ Running
```

## Manual Deployment

### 1. Install Dependencies

```bash
sudo apt-get update
sudo apt-get install -y \
    python3 python3-pip \
    postgresql postgresql-contrib \
    redis-server \
    openjdk-17-jdk \
    git curl netcat-openbsd
```

### 2. Install Bazel

```bash
wget https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64
chmod +x bazelisk-linux-amd64
sudo mv bazelisk-linux-amd64 /usr/local/bin/bazel
```

### 3. Build Services

```bash
cd okimi
bazel build //services/...
```

### 4. Configure Databases

```bash
# PostgreSQL
sudo -u postgres createdb okimi
sudo -u postgres createuser okimi -P

# Redis (default configuration is usually sufficient)
sudo systemctl enable redis-server
sudo systemctl start redis-server
```

### 5. Install Keycloak

```bash
cd /opt
sudo wget https://github.com/keycloak/keycloak/releases/download/23.0.3/keycloak-23.0.3.tar.gz
sudo tar -xzf keycloak-23.0.3.tar.gz
sudo mv keycloak-23.0.3 keycloak
sudo chown -R okimi:okimi /opt/keycloak
```

### 6. Install Service Units

```bash
sudo cp config/systemd/*.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable okimi-auth okimi-user okimi-gateway
```

### 7. Start Services

```bash
sudo systemctl start postgresql redis keycloak
sudo systemctl start okimi-auth okimi-user okimi-gateway
```

## Ansible Deployment

For automated deployment across multiple hosts:

```bash
cd ansible
ansible-playbook -i inventory.ini playbooks/setup.yml
```

### Inventory Configuration

Edit `ansible/inventory.ini`:

```ini
[okimi_servers]
server1 ansible_host=192.168.1.10
server2 ansible_host=192.168.1.11

[okimi_servers:vars]
ansible_user=ubuntu
ansible_python_interpreter=/usr/bin/python3
```

## Configuration

### Service Configuration Files

Located in `/opt/okimi/config/`:

- `auth-service.yml`: Auth service configuration
- `user-service.yml`: User service configuration
- `gateway-service.yml`: Gateway configuration

### Environment Variables

Create `/opt/okimi/.env`:

```bash
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=okimi
DB_USER=okimi
DB_PASSWORD=<secure-password>

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379

# Keycloak
KEYCLOAK_URL=http://localhost:8080
KEYCLOAK_REALM=okimi
KEYCLOAK_CLIENT_ID=okimi-client
KEYCLOAK_CLIENT_SECRET=<client-secret>

# JWT
JWT_SECRET=<jwt-secret>
JWT_EXPIRATION=3600
```

## Service Management

### Start Services
```bash
sudo systemctl start okimi-auth
sudo systemctl start okimi-user
sudo systemctl start okimi-gateway
```

### Stop Services
```bash
sudo systemctl stop okimi-gateway
sudo systemctl stop okimi-user
sudo systemctl stop okimi-auth
```

### Check Status
```bash
sudo systemctl status okimi-auth
sudo systemctl status okimi-user
sudo systemctl status okimi-gateway
```

### View Logs
```bash
sudo journalctl -u okimi-auth -f
sudo journalctl -u okimi-user -f
sudo journalctl -u okimi-gateway -f
```

## Health Checks

### Automated Health Check
```bash
./scripts/health-check.sh
```

### Manual Health Checks

```bash
# Auth service
curl http://localhost:8081/health

# User service
curl http://localhost:8082/health

# API Gateway
curl http://localhost:8000/health

# Keycloak
curl http://localhost:8080/health
```

## Troubleshooting

### Service Won't Start

1. Check logs:
   ```bash
   sudo journalctl -u okimi-auth -n 50
   ```

2. Verify dependencies:
   ```bash
   sudo systemctl status postgresql redis keycloak
   ```

3. Check port availability:
   ```bash
   netstat -tuln | grep -E '8000|8081|8082|8080|5432|6379'
   ```

### Database Connection Issues

```bash
# Test PostgreSQL connection
psql -h localhost -U okimi -d okimi

# Check Redis
redis-cli ping
```

### Permission Issues

```bash
# Ensure okimi user exists
sudo useradd -r -s /bin/bash okimi

# Fix ownership
sudo chown -R okimi:okimi /opt/okimi
```

## Backup and Recovery

### Database Backup

```bash
# PostgreSQL
sudo -u postgres pg_dump okimi > okimi_backup_$(date +%Y%m%d).sql

# Redis
redis-cli BGSAVE
```

### Service Configuration Backup

```bash
tar -czf okimi_config_$(date +%Y%m%d).tar.gz /opt/okimi/config
```

## Upgrading

1. Stop services:
   ```bash
   ./scripts/stop-services.sh
   ```

2. Backup data and configuration

3. Pull latest code:
   ```bash
   git pull origin main
   ```

4. Rebuild:
   ```bash
   bazel build //...
   ```

5. Restart services:
   ```bash
   ./scripts/start-services.sh
   ```

## Production Checklist

- [ ] All services running and healthy
- [ ] Database backups configured
- [ ] Monitoring and alerting set up
- [ ] Log rotation configured
- [ ] SSL/TLS certificates installed
- [ ] Firewall rules configured
- [ ] Resource limits tuned in systemd units
- [ ] Security hardening applied
- [ ] Documentation updated
- [ ] Disaster recovery plan tested
