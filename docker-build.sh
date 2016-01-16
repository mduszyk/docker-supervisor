#!/bin/bash
OS=${1:-ubuntu}
docker build -t mdevel/supervisor-$OS -f Dockerfile.$OS .
