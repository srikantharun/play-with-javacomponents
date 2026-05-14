# shellcheck shell=bash

# A series of utilities for writing output to the CI job log.

log_base() {
  local prefix=$1
  local color="\033[1;${2}m"
  local color_body="\033[0;${2}m"
  local msg=$3
  local lead="${color_body}[ ${prefix} ] \033[0m"

  echo "$msg" | awk '$0="'"${lead}${color}"'"$0"\033[0m"' | sed -e 's;^$; ;' >&2
}

log_debug() {
  if [ -n "${CI_DEBUG:-}" ]; then
    log_base "DEBUG" "90" "$1"
  fi
}

log_fail() {
  log_base "FAIL" "31" "$1"
}

log_fatal() {
  log_base "FATAL" "31" "$1"
}

log_info() {
  log_base "INFO" "34" "$1"
}

log_ok() {
  log_base "OK" "32" "$1"
}

log_warn() {
  log_base "WARN" "33" "$1"
}
