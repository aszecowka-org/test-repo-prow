# Job Waiter Docker Image

## Overview

This folder contains a Docker image used for waiting for other jobs.

This image consists of:

- alpine linux 3.8
- openssl
- curl
- base64
- kubectl (1.13)
- wait script

## Installation

To build the Docker image, run this command:

```bash
docker build -t job-waiter .
```
