# syntax=docker/dockerfile:1
FROM golang:1.21 AS builder
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -o /bin/tcp_client tcp_client.go

FROM scratch
COPY --from=builder /bin/tcp_client /bin/tcp_client
CMD ["/bin/tcp_client"]
