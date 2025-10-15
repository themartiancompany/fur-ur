# SPDX-License-Identifier: AGPL-3.0

#    ----------------------------------------------------------------------
#    Copyright © 2024, 2025  Pellegrino Prevete
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

# Maintainer:
#   Truocolo
#     <truocolo@aol.com>
#     <truocolo@0x6E5163fC4BFc1511Dbe06bB605cc14a3e462332b>
#   Pellegrino Prevete (dvorak)
#     <pellegrinoprevete@gmail.com>
#     <dvorak@0x87003Bd6C074C713783df04f36517451fF34CBEf>

_os="$( \
  uname \
    -o)"
_evmfs_available="$( \
  command \
    -v \
    "evmfs" || \
    true)"
if [[ ! -v "_evmfs" ]]; then
  if [[ "${_evmfs_available}" != "" ]]; then
    _evmfs="true"
  elif [[ "${_evmfs_available}" == "" ]]; then
    _evmfs="false"
  fi
fi
_offline="false"
_git="false"
_git_http_host="gitlab"
_archive_format="tar.gz"
if [[ "${_git_http_host}" == "gitlab" ]]; then
  _archive_format="tar.gz"
elif [[ "${_git_http_host}" == "github" ]]; then
  _archive_format="zip"
fi
_py="python"
_pkg=fur
pkgname="${_pkg}"
pkgver="1.0.0.0.0.0.0.0.0.0.0.0.0.1.1.1.1"
_commit="7abf8e2cd7c5a447c8bfdfd7e61e6537a56b2480"
pkgrel=1
_pkgdesc=(
  "Fallback Ur."
)
pkgdesc="${_pkgdesc[*]}"
arch=(
  'any'
)
_http="https://github.com"
_ns="themartiancompany"
url="${_http}/${_ns}/${_pkg}"
license=(
  'AGPL3'
)
depends=(
  "git"
  "libcrash-bash"
  "pacman"
)
_gh_dl_optdepends=(
  "gh-dl:"
    "to retrieve Gur continuous"
    "integration built binary packages."
)
_inteppacman_optdepends=(
  "inteppacman:"
    "support for managing Android"
    "applications"
)
optdepends=(
  "${_gh_dl_optdepends[*]}"
)
if [[ "${_os}" != "GNU/Linux" ]] && \
   [[ "${_os}" == "Android" ]]; then
  optdepends+=(
    "${_inteppacman_optdepends[*]}"
  )
fi
makedepends=(
  "make"
  "${_py}-docutils"
)
checkdepends=(
  "shellcheck"
)
_url="${url}"
_tag="${_commit}"
_tag_name="commit"
_tarname="${_pkg}-${_tag}"
if [[ "${_offline}" == "true" ]]; then
  _url="file://${HOME}/${_pkg}"
fi
_archive_sum="5319da4e100430551104825f06f8de58136f744b9dd90df99d60ea1bc178b03c"
_archive_sig_sum="ec5f7364a8c51c1d8f53c85f90aa791e7e7c98997a76e6852e19a4142e8fd200"
_evmfs_network="100"
_evmfs_address="0x69470b18f8b8b5f92b48f6199dcb147b4be96571"
_evmfs_ns="0x87003Bd6C074C713783df04f36517451fF34CBEf"
_evmfs_dir="evmfs://${_evmfs_network}/${_evmfs_address}/${_evmfs_ns}"
_evmfs_archive_uri="${_evmfs_dir}/${_archive_sum}"
_evmfs_archive_src="${_tarname}.${_archive_format}::${_evmfs_archive_uri}"
_archive_sig_uri="${_evmfs_dir}/${_archive_sig_sum}"
_archive_sig_src="${_tarname}.${_archive_format}.sig::${_archive_sig_uri}"
source=()
sha256sums=()
if [[ "${_evmfs}" == "true" ]]; then
  makedepends+=(
    "evmfs"
  )
  if [[ "${_git}" == "false" ]]; then
    _src="${_evmfs_archive_src}"
    _sum="${_archive_sum}"
    source+=(
      "${_archive_sig_src}"
    )
    sha256sums+=(
      "${_archive_sig_sum}"
    )
  fi
elif [[ "${_evmfs}" == "false" ]]; then
  if [[ "${_git}" == true ]]; then
    makedepends+=(
      "git"
    )
    _src="${_tarname}::git+${_url}#${_tag_name}=${_tag}?signed"
    _sum="SKIP"
  elif [[ "${_git}" == false ]]; then
    if [[ "${_tag_name}" == 'pkgver' ]]; then
      _src="${_tarname}.tar.gz::${_url}/archive/refs/tags/${_tag}.tar.gz"
      _sum="${_archive_sum}"
    elif [[ "${_tag_name}" == "commit" ]]; then
      _src="${_tarname}.${_archive_format}::${_url}/archive/${_tag}.${_archive_format}"
      _sum="${_archive_sum}"
    fi
  fi
fi
source+=(
  "${_src}"
)
sha256sums+=(
  "${_sum}"
)
validpgpkeys=(
  # Truocolo
  #   <truocolo@aol.com>
  '97E989E6CF1D2C7F7A41FF9F95684DBE23D6A3E9'
  'DD6732B02E6C88E9E27E2E0D5FC6652B9D9A6C01'
  #   <truocolo@0x6E5163fC4BFc1511Dbe06bB605cc14a3e462332b>
  'F690CBC17BD1F53557290AF51FC17D540D0ADEED'
  # Pellegrino Prevete (dvorak)
  #   <dvorak@0x87003Bd6C074C713783df04f36517451fF34CBEf>
  '12D8E3D7888F741E89F86EE0FEC8567A644F1D16'
)

check() {
  cd \
    "${_tarname}"
  make \
    -k \
    check
}

package() {
  cd \
    "${_tarname}"
  make \
    PREFIX="/usr" \
    DESTDIR="${pkgdir}" \
    install
}

# vim: ft=sh syn=sh et
