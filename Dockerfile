## Base image that contains everything needed for local dev
FROM golang:1.17-alpine AS development

# Install everything for development
RUN apk add bash git gcc g++ libc-dev openssh curl