token="$1"
command="gitlab-runner register  --url http://172.17.0.1:8929  --token $token"

docker exec -it gitlab-runner $command