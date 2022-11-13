# Example Application Go

### Structure Project
``` shell
.
├── README.md
├── charts >>>>>>>>>>>>>>>>>>>>>>>>>>>> Helm Charts
│   └── go-demo
│       ├── Chart.yaml
│       ├── templates
│       │   ├── NOTES.txt
│       │   ├── _helpers.tpl
│       │   ├── deployment-blue.yaml
│       │   ├── deployment-green.yaml
│       │   ├── hpa.yaml
│       │   ├── ingress.yaml
│       │   ├── service-prd.yaml
│       │   └── service-stage.yaml
│       └── values.yaml
├── code >>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Application Code
│   ├── Dockerfile >>>>>>>>>>>>>>>>>>>> Dockerfile
│   ├── go.mod
│   └── main.go
└── scripts
    └── 01.build_image.sh >>>>>>>>>>>>> Build Image
```

### Build Application
``` shell
go mod download && go mod verify
CGO_ENABLED=0 GOOS=linux go build -o /build/app app.go
```

### Dockerfile
``` Dockerfile
# stage build
FROM golang:1.19 as build

WORKDIR /build

COPY go.mod ./
RUN go mod download && go mod verify

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /build/app app.go

# stage imagem final
FROM alpine:3.16

WORKDIR /apps

COPY --from=build /build/app ./

EXPOSE 8080

CMD [ "./app" ]
```

### Build App + Build Image
``` shell
cd app-go/
docker build . -t go-app:1.0.0 -t go-app:latest
```

### Deployment
``` shell
cd k8s/
kubectl apply -f .
```