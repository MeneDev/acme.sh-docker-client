#!/bin/sh
set -e

if [ -n "$DNS_CLOUDFLARE_API_TOKEN" ] || ( [ -n "$DNS_CLOUDFLARE_EMAIL" ] && [ -n "$DNS_CLOUDFLARE_API_KEY" ] ); then
  cloudflare_secret_path=$PWD/cloudflare.ini

  if [ "$1" = 'certonly' ]; then
    case "$@" in
    *"--dns-cloudflare-credentials $cloudflare_secret_path"* ) ;;
    *       ) echo "[WARN] Cloudflare secret file created in path ${cloudflare_secret_path} but this file is not used in --dns-cloudflare-credentials argument" ;;
    esac
  fi

  touch $cloudflare_secret_path
  chmod 600 $cloudflare_secret_path

  if [ -n "$DNS_CLOUDFLARE_API_TOKEN" ]; then
    printf "dns_cloudflare_api_token = $DNS_CLOUDFLARE_API_TOKEN" > $cloudflare_secret_path
  else
    printf "dns_cloudflare_email = $DNS_CLOUDFLARE_EMAIL\n" > $cloudflare_secret_path
    printf "dns_cloudflare_api_key = $DNS_CLOUDFLARE_API_KEY" >> $cloudflare_secret_path
  fi
fi

exec certbot "$@"