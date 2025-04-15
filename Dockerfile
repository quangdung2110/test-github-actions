# Chose small base image (specify version)
# Multi-stage
# Specifying a working directory
# Exclude file and folder with .dockerignore and only copy specific files (ex: in build stage not need node_modules)
# Order layer (copy dependency file -> install -> copy remaining source code)
# Make some caching
# Use non-root user for safe

# syntax=docker/dockerfile:1.4
# Stage 1: Build dependencies
FROM node:22-alpine AS build

WORKDIR /app

COPY package*.json .
RUN npm ci --omit=dev
COPY . .

# Stage 2: Runtime
FROM node:22-alpine 

WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=build /app .
RUN chown -R appuser:appgroup /app
USER appuser:appgroup

CMD [ "npm", "start" ]


