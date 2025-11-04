# Okimi Platform

A high-frequency, low-latency microservices platform built with performance-first principles.

## Overview

Okimi is a modern microservices platform designed for high-frequency trading and low-latency applications. Built on Ubuntu with systemd service management, it emphasizes custom data structures, lock-free concurrency, and optimized algorithms.

## Tech Stack

- **C++20**: Latency-critical core logic (queues, memory pools, market data)
- **Java 17+**: Business services (auth, user management, API gateway)
- **Bazel**: Unified build system for multi-language monorepo
- **Systemd**: Service supervision and resource management
- **PostgreSQL**: Relational database
- **Redis**: In-memory cache
- **Keycloak**: Identity and access management

## Quick Start

### Prerequisites

- Ubuntu 20.04+ (or compatible Linux distribution)
- Python 3.8+
- Git
- sudo privileges

### Installation

```bash
git clone https://github.com/sandeep-jaiswar/okimi.git
cd okimi
./scripts/setup.sh
```

The setup script will:
1. Install system dependencies (Ansible, Python packages)
2. Configure and start all required services
3. Set up systemd service units
4. Verify service health

### Verify Installation

```bash
./scripts/check-status.sh
```

## Project Structure

```
okimi/
├── services/          # Microservices (auth, user, gateway)
├── libs/              # Shared libraries (core, concurrent, memory, observability)
├── config/            # Configuration files and systemd templates
├── scripts/           # Setup and management scripts
├── ansible/           # Ansible playbooks for automated deployment
├── docs/              # Documentation
└── .github/           # GitHub workflows and Copilot instructions
```

## Building

```bash
# Build all services
bazel build //...

# Build specific service
bazel build //services/auth:auth_service

# Run tests
bazel test //...
```

## Service Management

```bash
# Start all services
./scripts/start-services.sh

# Stop all services
./scripts/stop-services.sh

# Check service status
./scripts/check-status.sh

# Health check
./scripts/health-check.sh
```

## Services

| Service | Port | Description |
|---------|------|-------------|
| PostgreSQL | 5432 | Database |
| Redis | 6379 | Cache |
| Keycloak | 8080 | Identity Management |
| Auth Service | 8081 | Authentication |
| User Service | 8082 | User Management |
| API Gateway | 8000 | API Gateway |

## Development

### Coding Standards

- **C++**: Use snake_case, prefer lock-free structures, custom memory pools
- **Java**: Use CamelCase, Spring Boot conventions
- **Error Handling**: Always explicit, never silent catch
- **Observability**: Mandatory logging, metrics, and tracing

### Performance Guidelines

- Minimize allocations in hot paths
- Use memory pools and arenas
- Prefer lock-free concurrent structures
- Always benchmark for contention and false sharing

### Testing

```bash
# Run all tests
bazel test //...

# Run specific test suite
bazel test //libs/core:memory_pool_test

# Run with ASAN
bazel test --config=asan //...
```

## Documentation

See [docs/](docs/) for detailed documentation:
- Architecture overview
- Service design patterns
- Performance tuning guides
- Deployment procedures

## Contributing

Please read [.github/COPILOT_INSTRUCTIONS.md](.github/COPILOT_INSTRUCTIONS.md) for development guidelines and coding standards.

## License

See LICENSE file for details.

## Support

For issues and questions:
- GitHub Issues: https://github.com/sandeep-jaiswar/okimi/issues
- Jira: https://okimi.atlassian.net