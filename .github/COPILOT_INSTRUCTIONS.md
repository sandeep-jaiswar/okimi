Copilot Instructions – Okimi Platform
Overview

    Build high-frequency, low-latency microservices with custom data structures and optimized algorithms.

    Monorepo, Ubuntu-native, systemd (not Docker/K8s), open-source stack.

    Use Bazel build system, modular workspace, and code explicit for performance.

Project Principles

    Performance First: Minimize latency, maximize throughput (target microseconds, not ms).

    Custom Data Structures: Invent or adapt where standard libs show lock contention or gc pressure.

    Maintainability: Clean layering, no silent globals, single responsibility per module.

    Scalability: Modular architecture; each service builds & runs independently.

    Observability: Log, metrics, and tracing are mandatory and must be lightweight.

Tech Stack

    C++20: Latency-critical core logic (queues, memory pools, market data, etc.)

    Java 21+: Business services (auth, user management, API gateway)

    Bazel/bzlmod: Unified build for multi-language monorepo

    Systemd: Service supervision, restarts, resource limits (see /config/systemd/*.service)

    Postgres/Redis/Keycloak: Open-source for state, cache, identity

Coding and Architectural Guidelines

    Memory Management:
    Prefer pools & arenas over heap per object.
    Example:

cpp
okimi::MemoryPool<Order, 10000> pool;
auto* order = pool.allocate(args...);
// ... do work ...
pool.deallocate(order);

Minimize allocations during request paths, batch where possible.

Concurrency:
Prefer lock-free structures.
Avoid mutexes on hot paths; always benchmark for false sharing or cache-line contention.

cpp
okimi::SPSCQueue<Event> q(1024);
q.push(e); // lock-free single producer/consumer

Networking:
Favor async, zero-copy, and kernel bypass where possible (DPDK/io_uring).

Build System:
All modules must define Bazel BUILD files.

    text
    bazel build //services/...
    bazel test //libs/core/...

    Configuration:
    Use static env files config, never load from mutable location in prod.

    Systemd Integration:

        Service files in /etc/systemd/system

        Memory/CPU limits in service unit

        Service must SIGTERM-gracefully and exit 0 for health

Best Practices for Copilot

    Use one file per component/service.

    Place shared code in /libs/core/ or /libs/observability/.

    Proper error handling—never silently catch.

    Log start/stop, errors, critical path timings.

    Write tests:

        C++: GoogleTest, Bazel targets as *_test.cc

        Java: JUnit5, gradle or Bazel tested

Naming and Style

    Use snake_case for C++/C, CamelCase for Java classes.

    Main executable for each service should be named as [servicename]_service (e.g., auth_service).

    Prefer explicit types, avoid auto if type isn't immediately obvious.

Example Directory Layout

text
/
  ├─ services/
  |   ├─ auth/
  |   ├─ user/
  |   └─ gateway/
  ├─ libs/
  |   ├─ core/
  |   ├─ concurrent/
  |   ├─ memory/
  |   └─ observability/
  ├─ config/
  ├─ systemd/
  └─ tests/

Common Build Commands

text
# Build all
bazel build //...

# Test C++
bazel test //libs/core/memory:memory_pool_test

# Run linter
clang-tidy *.cc

Troubleshooting

    Always check systemd/log/journalctl for service crash details.

    Run Bazel with --sandbox_debug --verbose_failures for build issues.

    For weird memory bugs: instrument with ASAN, repeat with leak sanitizer on.

    Flush redis/postgres if startup fails on bind.

Copilot Tips

    Suggest lock-free patterns by default for core objects (queue, hashtable).

    For network I/O, suggest async or non-blocking solutions before thread-pool or fork.

    For config, enforce compile-time consts unless customization is necessary at boot.

    When suggesting error handling: prefer fail-fast in critical paths.

For more details, see:

    .github/COPILOT_INSTRUCTIONS.md

    /docs/architecture/

    /systemd-templates.md

    /complete-setup-summary.md

    /ansible-setup-guide.md
