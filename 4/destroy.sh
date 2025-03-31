SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
PROJECT_DIR="$(dirname "$SCRIPT_PATH")"

docker compose -f "${PROJECT_DIR}/docker-compose.yml" down