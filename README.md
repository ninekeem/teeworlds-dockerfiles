# teeworlds-dockerfiles
Dockerfiles of my teeworlds servers

How to build docker images:  
`docker build -f Dockerfile.teeworlds -t teeworlds .`

How to run server:  
`docker run -d
--network=host
-e EC_PORT=8303
-e SV_PORT=8303
-e SV_MOTD='Welcome to my teeworlds server'
-e SV_NAME='Teeworlds Server' teeworlds:latest`
