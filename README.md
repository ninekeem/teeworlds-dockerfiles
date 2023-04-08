# teeworlds-dockerfiles
Dockerfiles of my teeworlds servers

How to build docker images:  
`cd refng`  
`docker build -t refng .`

How to run server:  
`docker run -d -e EC_PORT=8303
-e SV_PORT=8303
-e SV_MOTD='Welcome to my refng server'
-e SV_NAME='refng server' refng:latest`
