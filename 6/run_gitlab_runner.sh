set -euo pipefail

# General variables
script_path="$(realpath "${BASH_SOURCE[0]}")"
project_dir="$(dirname "$script_path")"
compose_env_path="${project_dir}/.env"
templates_dir="${project_dir}/templates"
docker_compose_path="${project_dir}/docker-compose.gitlab-runner.yml"

# GitLab runner variables
gitlab_runner_token="$1"
gitlab_runner_dir=${GITLAB_RUNNER_DIR:-"${project_dir}/.gitlab-runner"}
gitlab_runner_image_tag=${GITLAB_RUNNER_IMAGE_TAG:-"alpine3.19-85638733"}
gitlab_runner_helper_image="gitlab/gitlab-runner-helper:alpine3.18-x86_64-85638733-pwsh"
gitlab_runner_config="${project_dir}/gitlab_runner.config.toml"
[ ! -d "$gitlab_runner_dir" ] && mkdir "$gitlab_runner_dir"

# GitLab runner config
runner_token="$gitlab_runner_token" \
runner_helper_image="$gitlab_runner_helper_image" \
j2 "${templates_dir}/gitlab_runner.config.toml.jinja" \
    -f env \
    -o "$gitlab_runner_config"

# Run GitLab runner
[ -f "$compose_env_path" ] && rm "$compose_env_path"
echo "GITLAB_RUNNER_DIR=${gitlab_runner_dir}" >> "$compose_env_path"
echo "GITLAB_RUNNER_CONFIG=${gitlab_runner_config}" >> "$compose_env_path"
echo "GITLAB_RUNNER_IMAGE_TAG=${gitlab_runner_image_tag}" >> "$compose_env_path"
docker compose \
    -f "$docker_compose_path" \
up -d gitlab-runner
