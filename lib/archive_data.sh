#!/bin/sh
# SPDX-License-Identifier: Apache-2.0
# shellcheck disable=SC2006

###############################################################################
# Archive files and directories.
# Globals:
#   OPERATING_SYSTEM
#   TEMP_DATA_DIR
#   UAC_DIR
# Requires:
#   None
# Arguments:
#   $1: file containing the list of files to be archived and compressed
#   $2: destination file
# Outputs:
#   None
# Exit Status:
#   Exit with status 0 on success.
#   Exit with status greater than 0 if errors occur.
###############################################################################
archive_data()
{
  ad_source_file="${1:-}"
  ad_destination_file="${2:-}"

  # exit if source file does not exist
  if [ ! -f "${ad_source_file}" ]; then
    printf %b "archive data: no such file or directory: \
'${ad_source_file}'\n" >&2
    return 2
  fi

  case "${OPERATING_SYSTEM}" in
    "aix")
      tar -L "${ad_source_file}" -cf "${ad_destination_file}"
      ;;
    "freebsd"|"netbsd"|"netscaler"|"openbsd")
      tar -I "${ad_source_file}" -cf "${ad_destination_file}"
      ;;
    "android"|"esxi"|"linux")
      # some old tar/busybox versions do not support -T, so a different
      # solution is required to package and compress data
      # checking if tar can create package getting names from file
      printf %b "${UAC_DIR}/uac" >"${TEMP_DATA_DIR}/.tar_check.tmp" 2>/dev/null
                
      if tar -T "${TEMP_DATA_DIR}/.tar_check.tmp" \
        -cf "${TEMP_DATA_DIR}/.tar_check.tar" 2>/dev/null; then
        tar -T "${ad_source_file}" -cf "${ad_destination_file}"
      else
        # use file list as tar parameter
        ad_file_list=`awk '{ printf "\"%s\" ", $0; }' <"${ad_source_file}"`
        # eval is required here
        eval "tar -cf \"${ad_destination_file}\" ${ad_file_list}"
      fi
      ;;
    "macos")
      tar -T "${ad_source_file}" -cf "${ad_destination_file}"
      ;;
    "solaris")
      tar -cf "${ad_destination_file}" -I "${ad_source_file}"
      ;;
  esac
  
}