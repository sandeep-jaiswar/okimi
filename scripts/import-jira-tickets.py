#!/usr/bin/env python3
"""
Jira Ticket Import Script for Okimi Platform

This script imports Jira tickets from the Okimi project and creates
corresponding GitHub issues for tracking and integration.

Required environment variables:
- JIRA_URL: Jira instance URL (e.g., https://okimi.atlassian.net)
- JIRA_EMAIL: User email for Jira authentication
- JIRA_TOKEN: Jira API token
- GITHUB_TOKEN: GitHub personal access token (optional, uses gh CLI if not set)
"""

import os
import sys
import json
import requests
from typing import List, Dict, Optional

# Colors for terminal output
class Colors:
    GREEN = '\033[0;32m'
    RED = '\033[0;31m'
    YELLOW = '\033[1;33m'
    NC = '\033[0m'

def log_info(msg: str):
    print(f"{Colors.YELLOW}{msg}{Colors.NC}")

def log_success(msg: str):
    print(f"{Colors.GREEN}{msg}{Colors.NC}")

def log_error(msg: str):
    print(f"{Colors.RED}{msg}{Colors.NC}", file=sys.stderr)

def get_env_var(name: str) -> Optional[str]:
    """Get environment variable with helpful error message."""
    value = os.getenv(name)
    if not value:
        log_error(f"✗ Environment variable {name} is not set")
        return None
    return value

def fetch_jira_tickets(jira_url: str, email: str, token: str, project_key: str = "OKIMI") -> List[Dict]:
    """Fetch all tickets from Jira project."""
    log_info(f"Fetching tickets from Jira project {project_key}...")
    
    auth = (email, token)
    headers = {"Accept": "application/json"}
    
    # JQL query to get all tickets
    jql = f"project = {project_key} ORDER BY created DESC"
    
    url = f"{jira_url}/rest/api/3/search"
    params = {
        "jql": jql,
        "maxResults": 100,
        "fields": "summary,description,status,priority,issuetype,assignee,labels,created,updated"
    }
    
    try:
        response = requests.get(url, auth=auth, headers=headers, params=params)
        response.raise_for_status()
        data = response.json()
        
        tickets = data.get("issues", [])
        log_success(f"✓ Fetched {len(tickets)} tickets from Jira")
        return tickets
        
    except requests.exceptions.RequestException as e:
        log_error(f"✗ Failed to fetch Jira tickets: {e}")
        return []

def create_github_issue(ticket: Dict, repo: str = "sandeep-jaiswar/okimi"):
    """Create a GitHub issue from a Jira ticket."""
    key = ticket["key"]
    fields = ticket["fields"]
    
    title = f"[{key}] {fields['summary']}"
    description = fields.get("description", {})
    
    # Extract description text (handle different Jira description formats)
    body = "## Imported from Jira\n\n"
    if isinstance(description, dict):
        # New Jira API format (Atlassian Document Format)
        content = description.get("content", [])
        for block in content:
            if block.get("type") == "paragraph":
                for item in block.get("content", []):
                    if item.get("type") == "text":
                        body += item.get("text", "") + "\n"
    else:
        body += str(description) + "\n"
    
    body += f"\n**Jira Link:** [{key}]({os.getenv('JIRA_URL')}/browse/{key})\n"
    body += f"**Status:** {fields['status']['name']}\n"
    body += f"**Priority:** {fields['priority']['name']}\n"
    body += f"**Issue Type:** {fields['issuetype']['name']}\n"
    
    # Add labels
    labels = fields.get("labels", [])
    labels.append("jira-import")
    
    log_info(f"Creating GitHub issue for {key}...")
    
    # Use GitHub CLI if available, otherwise use API
    github_token = os.getenv("GITHUB_TOKEN")
    if not github_token:
        log_error(f"✗ GITHUB_TOKEN not set, cannot create issue for {key}")
        return False
    
    url = f"https://api.github.com/repos/{repo}/issues"
    headers = {
        "Authorization": f"token {github_token}",
        "Accept": "application/vnd.github.v3+json"
    }
    
    payload = {
        "title": title,
        "body": body,
        "labels": labels
    }
    
    try:
        response = requests.post(url, headers=headers, json=payload)
        response.raise_for_status()
        issue_url = response.json()["html_url"]
        log_success(f"✓ Created issue: {issue_url}")
        return True
    except requests.exceptions.RequestException as e:
        log_error(f"✗ Failed to create issue for {key}: {e}")
        return False

def main():
    log_info("=" * 60)
    log_info("  Okimi Jira Ticket Import")
    log_info("=" * 60)
    
    # Check required environment variables
    jira_url = get_env_var("JIRA_URL")
    jira_email = get_env_var("JIRA_EMAIL")
    jira_token = get_env_var("JIRA_TOKEN")
    
    if not all([jira_url, jira_email, jira_token]):
        log_error("\nMissing required environment variables. Please set:")
        log_error("  export JIRA_URL='https://okimi.atlassian.net'")
        log_error("  export JIRA_EMAIL='your-email@example.com'")
        log_error("  export JIRA_TOKEN='your-api-token'")
        log_error("  export GITHUB_TOKEN='your-github-token'  # Optional, for issue creation")
        sys.exit(1)
    
    # Fetch tickets from Jira
    tickets = fetch_jira_tickets(jira_url, jira_email, jira_token)
    
    if not tickets:
        log_info("\nNo tickets found or unable to fetch tickets")
        sys.exit(0)
    
    # Display tickets
    log_info(f"\nFound {len(tickets)} tickets:")
    for ticket in tickets:
        key = ticket["key"]
        summary = ticket["fields"]["summary"]
        status = ticket["fields"]["status"]["name"]
        print(f"  {key}: {summary} [{status}]")
    
    # Ask user if they want to create GitHub issues
    github_token = os.getenv("GITHUB_TOKEN")
    if not github_token:
        log_info("\nGITHUB_TOKEN not set. Set it to create GitHub issues automatically.")
        sys.exit(0)
    
    response = input(f"\nCreate GitHub issues for these {len(tickets)} tickets? (y/N): ")
    if response.lower() != 'y':
        log_info("Skipping GitHub issue creation")
        sys.exit(0)
    
    # Create GitHub issues
    success_count = 0
    for ticket in tickets:
        if create_github_issue(ticket):
            success_count += 1
    
    log_info("\n" + "=" * 60)
    log_success(f"✓ Import complete: {success_count}/{len(tickets)} issues created")
    log_info("=" * 60)

if __name__ == "__main__":
    main()
