FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY go.mod ./
COPY go.sum* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /app/server ./cmd/api

FROM alpine:3.21
WORKDIR /root/
COPY --from=builder /app/server .
EXPOSE 8080
ENTRYPOINT ["./server"]