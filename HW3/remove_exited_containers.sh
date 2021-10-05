#!/bin/bash
docker rm $(docker ps --filter status=exited -q)
