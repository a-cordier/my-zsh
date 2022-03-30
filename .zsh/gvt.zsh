##
# Some utilities to work with the Gravitee.io Open Source Project.
##

APIM_DIR="${APIM_DIR:-$HOME/src/gravitee/gravitee-api-management}"
GTW_DIR="${APIM_DIR}/gravitee-apim-gateway"
API_DIR="${APIM_DIR}/gravitee-apim-rest-api"
API_PLUGINS="${API_DIR}/gravitee-apim-rest-api-standalone/gravitee-apim-rest-api-standalone-distribution/target/distribution/plugins"
GTW_PLUGINS="${GTW_DIR}/gravitee-apim-gateway-standalone/gravitee-apim-gateway-standalone-distribution/target/distribution/plugins"

assert_directory_is_clean() {
    if [ -z "$(git status --porcelain)" ]; then
        echo "Working Directory is clean, proceeding"
    else
        echo "Working Directory is not clean, please commit or stash your changes before proceeding"
        exit 1
    fi
}

switch_branch() {
    echo "Switching ref to ${VERSION}"

    pushd "${APIM_DIR}"
        assert_directory_is_clean
        git checkout "${VERSION}"
        git pull
    popd
}

install_rest_api() {
    pushd "${APIM_DIR}/gravitee-apim-rest-api"
        mvn clean install -DskipTests
    popd
}

install_gateway() {
    pushd "${APIM_DIR}/gravitee-apim-gateway"
        mvn clean install -DskipTests
    popd
}

install_console_ui() {
    pushd "${APIM_DIR}/gravitee-apim-console-webui"
        fnm use && npm ci
    popd
}

install_portal_ui() {
    pushd "${APIM_DIR}/gravitee-apim-portal-webui"
        fnm use && npm ci
    popd
}

clean() {
    pushd "${APIM_DIR}"
        git checkout .
    popd
}

package_repository() {
    pushd "${APIM_DIR}/gravitee-apim-repository"
        mvn clean install -DskipTests
        
        MONGO_PLUGIN=$(find gravitee-apim-repository-mongodb/target -name "gravitee-apim-repository-mongodb-*-SNAPSHOT.zip")

        find "${API_PLUGINS}" -name "gravitee-apim-repository-mongodb-*-SNAPSHOT.zip" -delete
        find "${GTW_PLUGINS}" -name "gravitee-apim-repository-mongodb-*-SNAPSHOT.zip" -delete

        cp "${MONGO_PLUGIN}" "${API_PLUGINS}"
        cp "${MONGO_PLUGIN}" "${GTW_PLUGINS}"
    popd
}

gvt-apim-switch() {
    VERSION="$1"

    switch_branch
    install_rest_api
    install_gateway
    install_console_ui
    install_portal_ui
    package_repository
    clean
}

gvt_ci_compile() {
    pushd "${APIM_DIR}"
        mvn -pl '!gravitee-apim-console-webui, !gravitee-apim-portal-webui' clean install -Dskip.validation=true -DskipTests -T 2C
    popd
}

gvt_ci_install() {
    pushd "${APIM_DIR}"
        mvn -pl '!gravitee-apim-console-webui, !gravitee-apim-portal-webui' clean install -Dskip.validation=true -T 2C
    popd
}

gvt_ci_all() {
    pushd "${APIM_DIR}"
        mvn -pl '!gravitee-apim-console-webui, !gravitee-apim-portal-webui' clean install -T 2C
    popd
}
