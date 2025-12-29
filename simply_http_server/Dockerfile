FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -o simply

FROM alpine:3.20

WORKDIR /app
RUN mkdir -p /app/front/laba
COPY ./front/laba/dist /app/front/laba/dist
COPY ./config.json /app/config.json
COPY --from=builder /app/simply /app/simply

ENTRYPOINT ["/app/simply", "run", "--conf=config.json"]
