#!/bin/bash
DOCKER_BUILDKIT=1 docker build -t ghcr.io/charlesthomas/dev-box:test-$(date +%F) .
