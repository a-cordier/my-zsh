function myip() {
	curl https://ipinfo.io/ip
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