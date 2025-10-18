#!/usr/bin/env bash

# SPDX-License-Identifier: AGPL-3.0

#    ----------------------------------------------------------------------
#    Copyright © 2022, 2023, 2024, 2025  Pellegrino Prevete
#
#    All rights reserved
#    ----------------------------------------------------------------------
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.


# This script is run within a virtual environment to build
#  pakcage
# $1: platform
# $2: architecture

set \
  -euo \
    pipefail
shopt \
  -s \
    extglob

_upload() {
  local \
    _assets_links=() \
    _release_cli_create_opts=() \
    _msg=()
  pwd
  ls
  for _file \
    in "dogeos-"*".pkg.tar."*; do
    _msg=(
      "Uploading '${_file}'."
    )
    echo \
      "${_msg[*]}"
    curl \
      --silent \
      --header \
        "JOB-TOKEN: ${ci_job_token}" \
      --upload-file \
        "$(pwd)/${_file}" \
      "${package_registry_url}/${_file}"
    _assets_links+=(
      --asset-link
      "'{ \"name\": \"$(pwd)/${_file}\", \"url\": \"${package_registry_url}/${_file}\" }'"
    )
  done
  _release_cli_create_opts+=(
    --name
      "Release: ${tag}"
    --tag-name
      "${tag}"
    "${_assets_links[@]}"
  )
  _msg=(
    "Running 'release-cli'"
    "with options"
    "create ${_release_cli_create_opts[@]}'."
  )
  echo \
    "${_msg[*]}"
  release-cli \
    --verbose \
    create \
    "${_release_cli_create_opts[@]}"
}

readonly \
  platform="${1}" \
  arch="${2}" \
  ns="${3}" \
  pkg="${4}" \
  commit="${5}" \
  tag="${6}" \
  ci_job_token="${7}"
  package_registry_url="${8}"

_upload

# vim:set sw=2 sts=-1 et:
