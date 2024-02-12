# teeworlds-dockerfiles

## Build
### Docker
`docker build -f Dockerfile.teeworlds -t teeworlds .`

## Usage
You should specify your main config if you use custom name or path with `command` in docker compose like:
`command: -f config/entrypoint`

## Examples
### Docker
#### docker-compose.yaml
```
services:
  teeworlds:
    build:
      context: .
      dockerfile: ../teeworlds-dockerfiles/Dockerfile.teeworlds
    command: -f config/entrypoint # custom config path
    container_name: tw
    network_mode: host # optional, but try to avoid non-direct forwaring like 8310:8303 if you don't know what to do
    restart: always
    volumes: # use you own config
      - ./config:/tw/data/config
```

### Kubernetes
#### Deployment.yaml
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: teeworlds
  name: teeworlds
spec:
  replicas: 1 # Don't set number bigger than 1 if you don't want "strange" LoadBalancer behaviour
  selector:
    matchLabels:
      app: teeworlds
  strategy:
    rollingUpdate:
      maxSurge: 50%
      maxUnavailable: 0%
    type: RollingUpdate # For faster server restarts
  template:
    metadata:
      labels:
        app: teeworlds
    spec:
      containers:
      - args: # custom config path
        - -f
        - config/teeworlds/config
        image: docker.registry.example.com/teeworlds:latest
        name: server
        ports:
        - containerPort: 8000
          name: econ # don't forward ECON it you don't need it
          protocol: TCP
        - containerPort: 8303
          name: server # try to avoid non-direct forwaring like 8310:8303 if you don't know what to do
          protocol: UDP
        readinessProbe: # container health check for ECON, optional, don't use it if you don't need ECON
          failureThreshold: 3 # numbers can vary, this is optimal solution
          initialDelaySeconds: 10
          periodSeconds: 5
          successThreshold: 1
          tcpSocket:
            port: 8000
          timeoutSeconds: 1
        volumeMounts: # custom config path
        - mountPath: /tw/config
          name: config
      dnsPolicy: ClusterFirst # can be both ClusterFirst and Default
      imagePullSecrets:
      - name: docker-registry-example
      volumes:
      - name: config
        persistentVolumeClaim:
          claimName: config
```
#### server.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: teeworlds-server
spec:
  externalTrafficPolicy: Local # useful if you need to see real client IP, not cluster
  internalTrafficPolicy: Cluster
  ports:
  - port: 8310
    protocol: UDP
    targetPort: server
  selector:
    app: teeworlds
  sessionAffinity: ClientIP # For more than 1 replicas. If player connects dummy, dummy stay on same server as player, who connected it
  type: LoadBalancer # Can be NodePort, but LB is more flexible
```
#### econ.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: teeworlds-econ
spec:
  internalTrafficPolicy: Cluster # I have no reason to set Local here. Use Cluster.
  ports:
  - port: 8000
    protocol: TCP
    targetPort: econ
  selector:
    app: teeworlds
  type: ClusterIP # Makes ECON visible in Cluster only. Useful for custom ECON services like bridge(s), antivpn, custom command spammers and other
```
