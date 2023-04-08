# teeworlds-dockerfiles
Dockerfiles of my teeworlds servers

How to build docker images:  
`cd <needed server>`
`docker build -t <image name> .`

How to run server:  
`docker run -d -e EC_PORT=8303
-e SV_PORT=8303
-e SV_MOTD='Welcome to my refng server'
-e SV_NAME='refng server' refng:latest`
