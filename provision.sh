#!/bin/bash
docker run --name talaria --privileged=true -it -v /Users/huyhoang/Workspace/talaria/:/tiki/www/tala -p 80:80 talaria/lastest
docker exec -it talaria sh -c 'cd /tiki/www/tala/webroot/frontend/assets/tools && grunt less && grunt requirejs'

docker cp /tiki/www/tala/vendor talaria:/tiki/www/tala/vendor


