FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o GoSimpleForwardingServer .

FROM alpine:latest
WORKDIR /app
RUN apk --no-cache add ca-certificates

COPY --from=builder /app/GoSimpleForwardingServer .

# Koyeb akan mengarahkan traffic ke port ini
EXPOSE 443

# Target default (bisa diubah nanti di Environment Variable Koyeb)
ENV TARGET="global.pearlfortune.org:443"

CMD ["sh", "-c", "./GoSimpleForwardingServer -sp 443 -target ${TARGET}"]
