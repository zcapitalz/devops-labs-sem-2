SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
PROJECT_DIR="$(dirname "$SCRIPT_PATH")"
export REPO_DIR_NAME="auth-tokens"

[ ! -d "${REPO_DIR_NAME}" ] && git clone --depth=1 https://github.com/zcapitalz/auth-tokens
cp "${PROJECT_DIR}/Dockerfile.build" "${PROJECT_DIR}/${REPO_DIR_NAME}/Dockerfile.build"
cp "${PROJECT_DIR}/Dockerfile" "${PROJECT_DIR}/${REPO_DIR_NAME}/Dockerfile"
docker compose down -v
docker compose -f "${PROJECT_DIR}/docker-compose.yml" up --build