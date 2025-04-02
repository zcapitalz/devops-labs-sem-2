FROM alpine:3.21.3

WORKDIR /app

COPY --from=auth-server-build:latest /app/server ./server
COPY --from=auth-server-build:latest /app/migrations ./migrations

ENTRYPOINT ["./server"]
