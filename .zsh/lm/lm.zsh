#!/bin/bash

source $HOME/.credentials.zsh

function login_gke_nprd(){
  gcloud config configurations activate default
  gcloud container clusters --project sp-glob-gke-nprd-cdp --region europe-west1 get-credentials nprd-02-a9ef
  kubectx gke_sp-glob-gke-nprd-cdp_europe-west1_nprd-02-a9ef
  kubens cdp-devportal-gke-euw1-prep
}

function login_gke_prod(){
  gcloud config configurations activate default
  gcloud container clusters --project sp-glob-gke-prod-cdp --region europe-west1 get-credentials prod-04-ce7a
  kubectx gke_sp-glob-gke-prod-cdp_europe-west1_prod-04-ce7a
  kubens cdp-devportal-gke-euw1-prod
}

function login_gke_poc() {
  gcloud config configurations activate default
  gcloud container clusters --project sp-glob-gke-nprd-cdp --region europe-west1 get-credentials nprd-01-ppjq
  kubectx gke_sp-glob-gke-nprd-cdp_europe-west1_nprd-01-ppjq
  kubens cdp-devportal-gateway-poc-dev
}

function login_gke_kong() {
  gcloud config configurations activate default
  gcloud container clusters --project sp-glob-dvp-c7aa-nprd-cdp --region europe-west1-b get-credentials kong-cluster
}

function login_gke_kong3() {
  gcloud config configurations activate default
  gcloud container clusters --project sp-glob-dvp-c7aa-nprd-cdp --region europe-west1-c get-credentials kong-3-cluster
}

function login_gke_kong_public() {
  gcloud config configurations activate default
  gcloud container clusters get-credentials kong-public-cluster --zone europe-west1-d --project sp-glob-dvp-c7aa-nprd-cdp
}

function login_gke_kong_demo() {
  gcloud config configurations activate default
  gcloud container clusters get-credentials kong-demo --zone europe-west1-d --project sp-glob-dvp-c7aa-nprd-cdp
}

function login_gke_apigee() {
  gcloud config configurations activate default
  gcloud container clusters get-credentials apigee-cluster --zone europe-west1-d --project apigee-x-adeo
}

function login_gke_playground() {
  gcloud config configurations activate playground
  gcloud container clusters get-credentials playground --zone europe-west1-b --project agile-tracker-306815
}

function k9s_nprd(){
  login_gke_nprd
  k9s
}

function k9s_prod(){
  login_gke_prod
  k9s
}

### Login to openshift
function loginoc_registry_adeo(){
  loginoc "registry.adeo.com" "8443" "fr-lm-xnet" "registry.adeo.com"
}
function loginoc_adeo_op(){
  loginoc "openshift.op.acp.adeo.com" "443" "frlm-sop-api-adeo-dev" "registry.infra.op.acp.adeo.com"
}

function loginoc_adeo_prep(){
  loginoc "openshift.prep.acp.adeo.com" "443" "frlm-sop-api-adeo-prep" "registry.infra.prep.acp.adeo.com"
}

function loginoc_adeo_prod(){
  loginoc "openshift.acp.adeo.com" "443" "frlm-sop-api-adeo-prod" "registry.infra.acp.adeo.com"
}

function loginoc_gcp_euw3(){
  loginoc "manawa.euw3-gcp1.adeo.cloud" "443" "pllm-api-registry" "docker-registry-default.euw3-gcp1.adeo.cloud"
}

function loginoc_gcp_euw4(){
  loginoc "manawa.euw4-gcp1.adeo.cloud" "443" "frlm-sop-api-gcp-euw4-sit-qa" "docker-registry-default.euw4-gcp1.adeo.cloud"
}

function loginoc() {
  openshift=$1
  port=$2
  ocproject=$3
  registry=$4
  oc login -u $OC_LOGIN -p "$OC_PWD" ${openshift}:${port} && \
  oc project ${ocproject} && \
  docker login -u `oc whoami` -p `oc whoami -t` $4
  unset OC_TOKEN
}

function bastion() {
  sshpass -p "$OC_PWD" ssh -o TCPKeepAlive=yes -o ServerAliveCountMax=20 -o ServerAliveInterval=15 10111277@ubastion.adeo.com
}

function vault_login_api() {
  vault_login frlm/api
}

function vault_login_devportal() {
  vault_login frlm/devportal
}

function vault_login_bomp() {
  vault_login adeo/bomp
}

function vault_login() {
  export VAULT_ADDR="https://vault.factory.adeo.cloud"
  export VAULT_NAMESPACE="$1"
  export VAULT_TOKEN=$(vault login -method=ldap -token-only -namespace=$VAULT_NAMESPACE username="$LM_USERNAME" password="$LM_PASSWORD")
}

function vault_login_kong() {
  namespace="frlm/devportal"
  VAULT_TOKEN=$(vault login -method=ldap -token-only -namespace="$namespace" username="$LM_USERNAME" password="$LM_PASSWORD")
  echo -n "$VAULT_TOKEN" >~/.vault-token-"${namespace/\//-}"
  namespace="adeo/api-gateway"
  VAULT_TOKEN=$(vault login -method=ldap -token-only -namespace="$namespace" username="$LM_USERNAME" password="$LM_PASSWORD")
  echo -n "$VAULT_TOKEN" >~/.vault-token-"${namespace/\//-}"
  export VAULT_TOKEN
  zsh
}

function importcert() {
  export URL="$1" && \
  export SSL_PROTO="$(echo $URL | grep :// | sed -e's,^\(.*://\).*,\1,g')" && \
  export SSL_URL="$(echo ${URL/$SSL_PROTO/})" && \
  export SSL_USER="$(echo $SSL_URL | grep @ | cut -d@ -f1)" && \
  export SSL_HOSTPORT="$(echo ${SSL_URL/$SSL_USER@/} | cut -d/ -f1)" && \
  export SSL_HOST="$(echo $SSL_HOSTPORT | sed -e 's,:.*,,g')" && \
  export SSL_PORT="$(echo $SSL_HOSTPORT | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')" && \
  echo "==> Importing certificate for $SSL_HOST:$SSL_PORT into keychain..." && \
  echo -n | openssl s_client -connect "$SSL_HOST:$SSL_PORT" | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > "/tmp/$SSL_HOST.cert" && \
  sudo security add-trusted-cert -d -r trustAsRoot -p ssl -k /Library/Keychains/System.keychain "/tmp/$SSL_HOST.cert"
}
