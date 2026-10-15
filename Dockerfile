FROM golang:1.22-alpine AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o /out/main .

FROM alpine:3.20

RUN apk add --no-cache ca-certificates \
    && adduser -D -H -u 10001 appuser

WORKDIR /app

COPY --from=build /out/main /app/main
COPY --from=build /src/templates /app/templates
COPY --from=build /src/assets /app/assets

RUN chmod 755 /app/main \
    && chown -R appuser:appuser /app

USER appuser

ENV PORT=8083
ENV GIN_MODE=release
ENV DATABASE_SSLMODE=require

EXPOSE 8083

CMD ["./main"]
