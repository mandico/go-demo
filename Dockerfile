### Build
FROM golang:1.19-buster AS build
WORKDIR /app

COPY code/go.mod ./
RUN go mod download && go mod verify

COPY code/*.go ./
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-X main.version=1.0.0" -o /bin/go-demo .

### Deploy
FROM alpine:3.16.2
COPY --from=build /bin/go-demo /app/go-demo
EXPOSE 8080
ENTRYPOINT ["/app/go-demo"]