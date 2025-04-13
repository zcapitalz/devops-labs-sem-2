set -euo pipefail

# General variables
script_path="$(realpath "${BASH_SOURCE[0]}")"
project_dir="$(dirname "$script_path")"
compose_env_path="${project_dir}/.env"
docker_compose_path="${project_dir}/docker-compose.gitlab.yml"

# GitLab variables
gitlab_version=${GITLAB_VERSION:-"17.8.7"}
gitlab_dir=${GITLAB_DIR:-"${project_dir}/.gitlab"}
[ ! -d "$gitlab_dir" ] && mkdir "$gitlab_dir"

# Run GitLab
[ -f "$compose_env_path" ] && rm "$compose_env_path"
echo "GITLAB_DIR=${gitlab_dir}" >> "$compose_env_path"
echo "GITLAB_VERSION=${gitlab_version}" >> "$compose_env_path"
docker compose -f "$docker_compose_path" up gitlab -d
