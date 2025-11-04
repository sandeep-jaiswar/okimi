Title:
[Setup Verification] Confirm Okimi Platform Automated Setup on Ubuntu

Body:
Checklist

Please complete the following to verify that the Okimi platform, provisioned via one-command setup, is fully operational:

    Cloned repo: git clone https://github.com/sandeep-jaiswar/okimi.git

    Made scripts executable: chmod +x scripts/*.sh

    Ran setup: ./scripts/setup.sh (no errors)

    All Ansible playbooks executed successfully

    All required system dependencies installed (build-essential, bazel, postgresql-15, redis-server, openjdk-21-jdk)

    Bazel CLI is available: bazel version

    Systemd units installed for:

        PostgreSQL

        Redis

        Keycloak

        okimi-auth

        okimi-user

        okimi-gateway

    All services started with ./scripts/start-services.sh or automatically after setup

    ./scripts/check-status.sh shows all services ✓ Running

    Each port is open:

        5432 PostgreSQL

        6379 Redis

        8080 Keycloak

        8081 Auth

        8082 User

        8000 Gateway

    Can access Keycloak admin: http://localhost:8080/admin

    Can build and run at least one service: bazel build //services/auth:auth_service

    (optional) Ran python3 scripts/import-jira-tickets.py and confirmed tickets in Jira

Describe any Issues

    Please detail:

        Errors or warnings in setup

        Any systemd services failing or stuck

        Port conflicts/issues

        OS/env details (lsb_release -a, uname -a)

        Excerpts from journalctl -u okimi-auth (or other logs) if failures

Labels: setup, verification, infra, systemd, ansible, okimi-core
