### Build
FROM golang:1.19-buster AS build
ARG VERSION=1.0.0
WORKDIR /app

COPY go.mod ./
RUN go mod download && go mod verify

COPY *.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-X main.version=${VERSION}" -o /bin/go-demo .

### Deploy
FROM alpine:3.16.2
COPY --from=build /bin/go-demo /app/go-demo
EXPOSE 8080
ENTRYPOINT ["/app/go-demo"]