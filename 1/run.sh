docker run \
    --name mynginx \
    -p 81:81 \
    -v ./assets:/var/www/devops:ro \
    -v ./nginx.conf:/etc/nginx/nginx.conf:ro \
    mynginx