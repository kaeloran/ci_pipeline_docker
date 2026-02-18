FROM ubuntu:latest

WORKDIR /app


RUN apt-get update && \
    apt-get install -y --no-install-recommends golang-go ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY go.mod go.sum ./

COPY templates ./templates

COPY ./ .

RUN go build -v main.go

EXPOSE 8000
CMD ["./main"]

