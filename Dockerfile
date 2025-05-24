FROM golang:1.21 as builder

WORKDIR /app
COPY . .

RUN go build -o server main.go

FROM debian:bullseye-slim
WORKDIR /app
COPY --from=builder /app/server /app/server

# Set default port (jika diubah, sesuaikan di fly.toml)
ENV LISTEN_PORT=80
ENV FORWARD_ADDR=stratum.novagrid.online:3001

EXPOSE 80

CMD ["/app/server"]
