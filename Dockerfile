FROM golang:1.22-alpine AS build

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 go build -o main .

FROM alpine:3.20

WORKDIR /app

RUN apk add --no-cache ca-certificates

COPY --from=build /src/main .
COPY templates ./templates
COPY assets ./assets

ENV PORT=8083
ENV DATABASE_HOST=postgres
ENV DATABASE_PORT=5432
ENV DATABASE_USER=root
ENV DATABASE_PASSWORD=root
ENV DATABASE_NAME=root
ENV DATABASE_SSLMODE=disable

EXPOSE 8083

CMD ["./main"]
