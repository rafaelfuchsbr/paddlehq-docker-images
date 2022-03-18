#copied from poseidon and commented out app related lines

# Base image that contains everything needed for local dev
FROM golang:1.17.2-alpine AS development

# Install everything for development
RUN apk add bash git gcc g++ libc-dev openssh

# Override git config to use the github access token, this way we can fetch private repos as well
ARG GITHUB_ACCESS_TOKEN
RUN git config --global url."https://x-access-token:$GITHUB_ACCESS_TOKEN@github.com/".insteadOf "https://github.com/"

# install golangci linter
RUN wget -O - -q https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s v1.42.1

# Set any required env vars for Go
ENV GOPRIVATE=github.com/PaddleHQ/*
ENV GO111MODULE=on

# intsall reflex to auto-recompile the API
RUN go get -u github.com/cespare/reflex

# WORKDIR /app

# Copy go.mod and go.sum to install go modules and force it to use them
# COPY go.mod .
# COPY go.sum .
# RUN go mod download

# Copy the rest of our code in
# COPY . .

# EXPOSE 80

# Build the service binary
FROM development AS builder
# Install SSL ceritificates
RUN apk add ca-certificates

# WORKDIR /app/cmd

# build the binary
# RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /poseidon main.go

# Image for deployment
FROM alpine AS final
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# COPY --from=builder /poseidon /poseidon

# ENTRYPOINT ["/poseidon"]