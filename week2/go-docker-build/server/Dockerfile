# syntax=docker/dockerfile:1
FROM golang:1.21 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /bin/tcp_server tcp_server.go

FROM scratch
COPY --from=builder /bin/tcp_server /bin/tcp_server
CMD ["/bin/tcp_server"]
