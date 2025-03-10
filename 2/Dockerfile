FROM golang:1.22.3-alpine as builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY internal ./internal
COPY cmd ./cmd
RUN GOOS=linux go build -a -o server cmd/app/main.go

FROM alpine:latest

WORKDIR /app
COPY --from=builder app/server .
COPY migrations ./migrations

EXPOSE ${HTTP_SERVER_PORT}

CMD ["./server"]