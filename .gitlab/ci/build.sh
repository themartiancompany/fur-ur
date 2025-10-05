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

readonly \
  platform="${1}" \
  arch="${2}"

fur_mini_opts=(
  "${platform}"
)
fur_opts=(
  -v
  -p
    "pacman"
)
_fur_mini \
  "libcrash-bash" \
  "${fur_mini_opts[@]}"
_fur_mini \
  "fur" \
  "${fur_mini_opts[@]}"
fur_opts=(
  -v
  -p
    "pacman"
)
pacman \
  -S \
  --noconfirm \
  "sudo"
fur \
  "${fur_opts[@]}" \
  "reallymakepkg"

# vim:set sw=2 sts=-1 et:
