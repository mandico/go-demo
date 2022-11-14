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

### Build App + Build Image
``` shell
sh scripts/01.build_image.sh IMAGE_NAME IMAGE_TAG
#Example
sh scripts/01.build_image.sh go-demo 1.2.3
```

### Deployment
``` shell
### Helm Template
helm template go-demo \
  --set green.enabled=true \
  --set blue.enabled=true \
  --set deployment.image.blue.repository=go-demo \
  --set deployment.image.blue.tag=1.0.0 \
  --set deployment.image.green.repository=go-demo \
  --set deployment.image.green.tag=2.0.0

### Helm Install
### 1. Install V1
helm upgrade go-demo-dev go-demo \
  --set productionSlot=blue \
  --set green.enabled=true \
  --set deployment.image.green.repository=luizmandico/go-demo \
  --set deployment.image.green.tag=1.0.0 \
  --reuse-values \
  --install

### 2. Swap to Prd
helm upgrade go-demo-dev go-demo \
  --set productionSlot=green \
  --set green.enabled=true \
  --reuse-values \
  --install

### 3. Install V2 in Stage
helm upgrade go-demo-dev go-demo \
  --set blue.enabled=true \
  --set deployment.image.blue.repository=luizmandico/go-demo \
  --set deployment.image.blue.tag=2.0.0 \
  --reuse-values \
  --install

### 4. Swap to Prd
helm upgrade go-demo-dev go-demo \
  --set productionSlot=blue \
  --reuse-values \
  --install
```