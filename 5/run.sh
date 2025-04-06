set -eu pipefail

use_config_file="${USE_CONFIG_FILE:-false}"

script_path="$(realpath "${BASH_SOURCE[0]}")"
project_dir="$(dirname "$script_path")"
repo_dir_name="react-spring-app"
repo_dir="${project_dir}/${repo_dir_name}"
backend_dir="${repo_dir}/spring-backend"
frontend_dir="${repo_dir}/react-frontend"
templates_dir="${project_dir}/templates"
config_dir="${project_dir}/.config"
backend_config_path="${config_dir}/application.properties"
nginx_config_path="${config_dir}/nginx.conf"
compose_env_path="${project_dir}/.env"

mkdir -p "$config_dir"

set -a
source "${project_dir}/config.env"
set +a

[ ! -d "$repo_dir" ] && git clone --depth=1 https://gitlab.com/deusops/projects/react-spring-app

source "${frontend_dir}/.env"
backend_url="$REACT_APP_API_BASE_URL"
backend_external_port=$(echo "$backend_url" | awk -F: '{print $3}' | awk -F/ '{print $1}')
echo "Backend external port: ${backend_external_port}"

if [ "$use_config_file" = "true" ]; then
    echo "Using file to configure backend"
    server_port="$backend_internal_port" \
    j2 "${templates_dir}/application.properties.jinja" \
        -f env \
        -o "$backend_config_path"
else
    echo "Using env variables to configure backend"
    cp "${project_dir}/application.properties" "$backend_config_path"
fi

backend_host="$backend_internal_host" \
backend_port="$backend_internal_port" \
j2 "${templates_dir}/nginx.conf.jinja" \
    -f env \
    -o "$nginx_config_path"

[ -f "$compose_env_path" ] && rm "$compose_env_path"

echo "FRONTEND_DIR=${frontend_dir}" >> "$compose_env_path"

echo "NGINX_PORT=${backend_external_port}" >> "$compose_env_path"
echo "NGINX_CONFIG_PATH=${nginx_config_path}" >> "$compose_env_path"

echo "BACKEND_DIR=${backend_dir}" >> "$compose_env_path"
echo "BACKEND_HOST=${backend_internal_host}" >> "$compose_env_path"
echo "BACKEND_CONFIG_PATH=${backend_config_path}" >> "$compose_env_path"

echo "DB_HOST=${db_host}" >> "$compose_env_path"
echo "DB_NAME=${db_name}" >> "$compose_env_path"
echo "DB_USER=${db_user}" >> "$compose_env_path"
echo "DB_PASSWORD=${db_password}" >> "$compose_env_path"
echo "DB_ROOT_PASSWORD=${db_root_password}" >> "$compose_env_path"

cp "${project_dir}/Dockerfile.backend" "${backend_dir}/Dockerfile"
cp "${project_dir}/Dockerfile.frontend" "${frontend_dir}/Dockerfile"

docker_compose_path="${project_dir}/docker-compose.yml"
docker compose -f "$docker_compose_path" build
docker compose -f "$docker_compose_path" -v down
docker compose -f "$docker_compose_path" up
