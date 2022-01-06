##
# Some utilities to work with the Gravitee.io Open Source Project.
##

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

clean() {
    pushd "${APIM_DIR}"
        git checkout .
    popd
}

package_repository() {
    pushd "${APIM_DIR}/gravitee-apim-repository"
        mvn clean package -DskipTests
        
        MONGO_PLUGIN=$(find gravitee-apim-repository-mongodb/target -name "gravitee-apim-repository-mongodb-*-SNAPSHOT.zip")
        
        API_PLUGINS="${APIM_DIR}/gravitee-apim-rest-api/gravitee-apim-rest-api-standalone/gravitee-apim-rest-api-standalone-distribution/target/distribution/plugins"
        GTW_PLUGINS="${APIM_DIR}/gravitee-apim-gateway/gravitee-apim-gateway-standalone/gravitee-apim-gateway-standalone-distribution/target/distribution/plugins"

        find "${API_PLUGINS}" -name "gravitee-apim-repository-mongodb-*-SNAPSHOT.zip" -delete
        find "${GTW_PLUGINS}" -name "gravitee-apim-repository-mongodb-*-SNAPSHOT.zip" -delete

        cp "${MONGO_PLUGIN}" "${API_PLUGINS}"
        cp "${MONGO_PLUGIN}" "${GTW_PLUGINS}"
    popd
}

gvt-apim-switch() {
    APIM_DIR="${APIM_DIR:-$HOME/src/gravitee/gravitee-api-management}"
    VERSION="$1"

    install_rest_api & install_gateway

    package_repository

    clean
}
