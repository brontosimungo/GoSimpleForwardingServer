FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o GoSimpleForwardingServer .

FROM alpine:latest
WORKDIR /app
RUN apk --no-cache add ca-certificates

COPY --from=builder /app/GoSimpleForwardingServer .

# Port internal container untuk Koyeb
EXPOSE 8080

# Environment Variable target ke port 443
ENV TARGET="global.pearlfortune.org:443"

CMD ["sh", "-c", "./GoSimpleForwardingServer -sp 8080 -target ${TARGET}"]
