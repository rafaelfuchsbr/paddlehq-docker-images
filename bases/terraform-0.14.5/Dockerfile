#copied from terraform-aws as is
FROM golang:1.14-alpine

RUN apk add bash git gcc g++ libc-dev openssh

ENV GO111MODULE=on
RUN go get github.com/mercari/tfnotify@v0.7.0

RUN apk --update add ca-certificates

COPY --from=hashicorp/terraform:0.14.5 /bin/terraform /bin/terraform

WORKDIR /app