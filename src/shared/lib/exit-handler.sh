# shellcheck shell=bash disable=SC1091

# Dependencies
functions_dir="$(
  cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
  pwd
)"

. "$functions_dir/log-utilities.sh"

# Catch the exit signal and present the relevant troubleshooting guide
exit_handler() {
  local exit_code=$?

  # Job exited cleanly, nothing to do.
  if [ "$exit_code" == "0" ]; then return; fi

  # Look for a troubleshoot function for this exit code
  local troubleshoot_function="troubleshoot_$exit_code"

  echo " "
  echo "========================================"
  echo "Troubleshooting (Exit Code: $exit_code)"
  echo "========================================"
  echo " "

  if [[ "$(type -t $troubleshoot_function)" == "function" ]]; then
    $troubleshoot_function
  else
    echo "No specific troubleshooting guidance available for exit code $exit_code."
    echo "Review the logs above for clues."
  fi

  echo " "

  exit $exit_code
}

# Initialise the exit handler
init_exit_handler() {
  if [ -n "$(trap -p EXIT)" ]; then
    log_fatal "Trap on EXIT already set. Review code and remove duplicate calls."
    trap - EXIT
    exit 1
  fi

  trap exit_handler EXIT
}
