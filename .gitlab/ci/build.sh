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

_fur_mini() {
  local \
    _pkg="${1}" \
    _platform="${2}" \
    _clone_opts=() \
    _mktemp_opts=() \
    _orig_pwd \
    _tmp_dir \
    _tmp_dir_base
  _orig_pwd="${PWD}"
  _tmp_dir_base="${_orig_pwd}/tmp"
  _mktemp_opts+=(
    --dry-run
    --directory
    --tmpdir="${_tmp_dir_base}"
  )
  _clone_opts+=(
    --branch="${_pkg}"
    --single-branch
    --depth=1
  )
  _tmp_dir="$( \
    mktemp \
      "${_mktemp_opts[@]}")"
  git \
    clone \
      "${_clone_opts[@]}" \
      "https://github.com/themartiancompany/fur" \
      "${_tmp_dir}/fur"
  rm \
    -rf \
    "${_tmp_dir}/fur/${_platform}/any/"*".pkg.tar."*".sig"
  pacman \
    -Udd \
    --noconfirm \
    "${_tmp_dir}/fur/${_platform}/any/"*".pkg.tar."*
  rm \
    -rf \
    "${_tmp_dir}/fur"
}

_requirements() {
  local \
    _fur_mini_opts=() \
    _fur_opts=()
  _fur_mini_opts+=(
    "${platform}"
  )
  _fur_mini \
    "libcrash-bash" \
    "${_fur_mini_opts[@]}"
  _fur_mini \
    "fur" \
    "${_fur_mini_opts[@]}"
  _fur_opts+=(
    -v
    -p
      "pacman"
  )
  pacman \
    -S \
    --noconfirm \
    "sudo"
  fur \
    "${_fur_opts[@]}" \
    "reallymakepkg"
  _gl_dl_mini_test
}

_gl_dl_mini_test() {
  _gl_dl_ns="themartiancompany"
  _gl_dl_commit="e8bb71f575af061e516bc8d330db002568482de5"
  _gl_dl_url="https://gitlab.com/${_gl_dl_ns}/gh-dl/-/archive/${_commit}/gh-dl-${_commit}.tar.gz"
  _gl_dl_mini \
    "${_gl_dl_url}"
}

_gl_dl_mini() {
  local \
    _url="${1}" \
    _token_private \
    _token \
    _curl_opts=() \
    _output_file
  _output_file="${HOME}/$( \
    basename \
      "${_url#https://}")"
  _token_private="${HOME}/.config/gitlab.com/default.txt"
  if [[ ! -e "${_token_private}" ]]; then
    echo \
      "Missing private token at '${HOME}/.config/gitlab.com/default.txt'."
    echo \
      "Set the GL_DL_PRIVATE_TOKEN variable in your Gitlab.com" \
      "CI namespace configuration."
    
  fi
  _token="PRIVATE-TOKEN: $( \
    cat \
      "${_token_private}")"
  _curl_opts+=(
    --header
      "${_token}"
    -o 
      "${_output_file}"
  )
  curl \
    "${_curl_opts[@]}" \
    "${_url}"
}

readonly \
  platform="${1}" \
  arch="${2}"

_requirements

# vim:set sw=2 sts=-1 et:
