# Okimi Services

This directory contains all microservices for the Okimi platform.

## Services

### auth
Authentication and authorization service.
- **Port**: 8081
- **Language**: Java 17
- **Framework**: Spring Boot
- **Build**: `bazel build //services/auth:auth_service`

### user
User management and profile service.
- **Port**: 8082
- **Language**: Java 17
- **Framework**: Spring Boot
- **Build**: `bazel build //services/user:user_service`

### gateway
API Gateway for routing and aggregation.
- **Port**: 8000
- **Language**: Java 17
- **Framework**: Spring Cloud Gateway
- **Build**: `bazel build //services/gateway:gateway_service`

## Building Services

Build all services:
```bash
bazel build //services/...
```

Build specific service:
```bash
bazel build //services/auth:auth_service
```

## Running Services

Services are managed by systemd. Use the provided scripts:

```bash
# Start all services
./scripts/start-services.sh

# Stop all services
./scripts/stop-services.sh

# Check status
./scripts/check-status.sh
```

## Development

### Adding a New Service

1. Create service directory:
   ```bash
   mkdir services/myservice
   ```

2. Create BUILD file:
   ```python
   java_library(
       name = "myservice_lib",
       srcs = glob(["src/main/java/**/*.java"]),
       deps = [
           # dependencies
       ],
   )
   
   java_binary(
       name = "myservice",
       main_class = "com.okimi.myservice.MyServiceApplication",
       runtime_deps = [":myservice_lib"],
   )
   ```

3. Create systemd service file in `config/systemd/`

4. Add to `scripts/start-services.sh` and `scripts/check-status.sh`

## Naming Conventions

- Service names: kebab-case (e.g., `auth-service`)
- Java classes: CamelCase
- Main class: `{Service}Application` (e.g., `AuthServiceApplication`)
- Package structure: `com.okimi.{service}`
