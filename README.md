# Terraform Automation for Linode with GitLab Runner

This project automates the deployment and management of Linode instances using Terraform, triggered by GitLab Runner. It includes scripts for instance creation, custom configuration, image creation, and resource cleanup.

## Overview

The project uses Terraform to provision and manage Linode instances. It's designed to be triggered by a GitLab Runner, ensuring that the infrastructure is automatically managed as part of your CI/CD pipeline. The process includes:

- **Instance Creation**: Automatically create Linode instances.
- **Custom Script Execution**: Execute custom scripts on the instances for specific configurations or setups.
- **Image Creation**: Create images from the configured instances.
- **Resource Cleanup**: Automatically clean up and remove resources that are no longer needed.

## Prerequisites

Before you begin, ensure you have the following:

- A Linode account with an API token.
- A GitLab account with a configured GitLab Runner.
- Terraform installed on your local machine.

## Setup and Configuration

1. **Linode API Token**: Ensure your Linode API token is stored securely and is accessible by Terraform and GitLab Runner.

2. **GitLab Runner Configuration**: Configure your GitLab Runner to trigger Terraform scripts. See [GitLab Runner documentation](https://docs.gitlab.com/runner/) for more details.

3. **Terraform Configuration**: Update the Terraform scripts to match your Linode environment and requirements.

