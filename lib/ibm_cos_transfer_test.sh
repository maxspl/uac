#!/bin/sh

# Copyright (C) 2020 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the “License”);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an “AS IS” BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###############################################################################
# Test the connectivity to IBM Cloud Object Storage.
# Globals:
#   None
# Requires:
#   None
# Arguments:
#   $1: URL (https://[endpoint]/[bucket-name]/[object-key]).
#   $2: API key / token
# Outputs:
#   None.
# Exit Status:
#   Exit with status 0 on success.
#   Exit with status greater than 0 if errors occur.
###############################################################################
ibm_cos_transfer_test()
{
  ib_url="${1:-}"
  ib_api_key="${2:-}"

  curl \
    --fail \
    --request PUT \
    --header "Authorization: Bearer ${ib_api_key}" \
    --header "Content-Type: application/text" \
    --header "Accept: */*" \
    --header "Expect: 100-continue" \
    --data "Transfer test from UAC" \
    "${ib_url}"

}