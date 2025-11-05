# Okimi Shared Libraries

This directory contains shared libraries used across Okimi services.

## Libraries

### core
Common utilities and foundational functionality.
- **Path**: `//libs/core`
- **Language**: C++20

### concurrent
Lock-free data structures and concurrent primitives.
- **Path**: `//libs/concurrent`
- **Language**: C++20
- **Key Features**:
  - SPSC/MPMC queues
  - Lock-free hash tables
  - Atomic operations

### memory
Custom memory management for high-performance allocations.
- **Path**: `//libs/memory`
- **Language**: C++20
- **Key Features**:
  - Memory pools
  - Arena allocators
  - Zero-copy buffers

### observability
Logging, metrics, and tracing infrastructure.
- **Path**: `//libs/observability`
- **Language**: C++20
- **Key Features**:
  - Structured logging
  - Performance metrics
  - Distributed tracing

## Building

Build all libraries:
```bash
bazel build //libs/...
```

Build specific library:
```bash
bazel build //libs/core
```

## Testing

Run all tests:
```bash
bazel test //libs/...
```

Run specific test:
```bash
bazel test //libs/memory:memory_test
```

## Usage

Include in your BUILD file:
```python
cc_binary(
    name = "my_service",
    srcs = ["my_service.cc"],
    deps = [
        "//libs/core",
        "//libs/concurrent",
        "//libs/memory",
    ],
)
```

## Development Guidelines

- Follow C++20 standards
- Use snake_case for naming
- Prefer lock-free designs
- Minimize allocations
- Always include tests
- Document public APIs
