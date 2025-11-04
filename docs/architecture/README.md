# Okimi Platform Architecture

## Overview

Okimi is a high-performance microservices platform designed for low-latency, high-frequency trading applications. The architecture emphasizes:

- **Performance First**: Microsecond-level latency targets
- **Custom Data Structures**: Lock-free queues, memory pools
- **Modular Design**: Services can be built and deployed independently
- **Observability**: Comprehensive logging, metrics, and tracing

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        API Gateway                          │
│                     (Port 8000)                             │
└────────────┬────────────────────────────┬───────────────────┘
             │                            │
             ▼                            ▼
    ┌────────────────┐         ┌────────────────┐
    │  Auth Service  │         │  User Service  │
    │   (Port 8081)  │         │   (Port 8082)  │
    └────────┬───────┘         └────────┬───────┘
             │                          │
             └──────────┬───────────────┘
                        ▼
             ┌──────────────────┐
             │    Keycloak      │
             │   (Port 8080)    │
             └──────────────────┘
                        │
        ┌───────────────┴───────────────┐
        ▼                               ▼
┌───────────────┐              ┌────────────────┐
│  PostgreSQL   │              │     Redis      │
│  (Port 5432)  │              │  (Port 6379)   │
└───────────────┘              └────────────────┘
```

## Services

### API Gateway
- **Purpose**: Routes and aggregates requests to backend services
- **Technology**: Spring Cloud Gateway
- **Port**: 8000
- **Key Features**:
  - Request routing
  - Load balancing
  - Rate limiting
  - Authentication validation

### Auth Service
- **Purpose**: Authentication and authorization
- **Technology**: Java 17, Spring Boot
- **Port**: 8081
- **Key Features**:
  - JWT token generation and validation
  - Keycloak integration
  - Session management
  - OAuth2 support

### User Service
- **Purpose**: User management and profile operations
- **Technology**: Java 17, Spring Boot
- **Port**: 8082
- **Key Features**:
  - User CRUD operations
  - Profile management
  - Preferences storage
  - Audit logging

## Core Libraries

### libs/core
Common utilities and shared functionality used across all services.

### libs/concurrent
Lock-free data structures optimized for concurrent access:
- Single Producer Single Consumer (SPSC) queues
- Multi Producer Multi Consumer (MPMC) queues
- Lock-free hash tables

### libs/memory
Custom memory management:
- Memory pools for fixed-size allocations
- Arena allocators for batch allocations
- Zero-copy buffers

### libs/observability
Lightweight logging, metrics, and tracing:
- Structured logging
- Performance metrics collection
- Distributed tracing support

## Performance Considerations

### Memory Management
- Prefer stack allocation over heap
- Use memory pools for frequently allocated objects
- Batch allocations when possible
- Minimize allocations in hot paths

### Concurrency
- Use lock-free structures by default
- Avoid mutexes in hot paths
- Design for single-writer when possible
- Benchmark for false sharing and cache-line contention

### Networking
- Async I/O with non-blocking operations
- Zero-copy where possible
- Consider kernel bypass (DPDK/io_uring) for ultra-low latency

## Data Flow

1. Client request → API Gateway
2. Gateway authenticates via Auth Service
3. Gateway routes to appropriate backend service
4. Service processes request using:
   - PostgreSQL for persistent data
   - Redis for caching
   - Keycloak for identity verification
5. Response flows back through Gateway to client

## Deployment Model

Services run as systemd units on Ubuntu, not in containers. This provides:
- Lower overhead
- Better performance predictability
- Direct access to system resources
- Simplified debugging

## Scaling Strategy

- **Horizontal**: Multiple instances behind load balancer
- **Vertical**: Optimize resource limits in systemd units
- **Database**: PostgreSQL read replicas, Redis clustering
- **Monitoring**: Continuous performance profiling

## Security

- All service communication over TLS
- JWT tokens for authentication
- Keycloak for centralized identity management
- No secrets in code or configuration files
- Audit logging for all operations

## Future Enhancements

- C++ services for ultra-low-latency operations
- DPDK/io_uring for network I/O
- Custom protocol buffers for inter-service communication
- Hardware acceleration where applicable
