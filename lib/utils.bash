#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/nektro/zigmod"
TOOL_NAME="zigmod"

TOOL_TEST="zigmod version"

supporting_zigmod_version_pattern='^r'

filter_supporting_zigmod_versions() {
	grep -E "$supporting_zigmod_version_pattern"
}

is_supporting_zigmod_version() {
	echo "$ASDF_INSTALL_VERSION" | grep -qE "$supporting_zigmod_version_pattern"
}

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3-
}

list_all_versions() {
	list_github_tags
}

# We dropped to support v era since https://github.com/jdx/mise/issues/1637, no need to consider sort logics here
list_sorted_all_supporting_versions() {
	list_all_versions | filter_supporting_zigmod_versions
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	local platform

	case "$OSTYPE" in
	darwin*) platform="macos" ;;
	linux*) platform="linux" ;;
	*) fail "Unsupported platform" ;;
	esac

	local architecture

	case "$(uname -m)" in
	x86_64*) architecture="x86_64" ;;
	aarch64 | arm64) architecture="aarch64" ;;
	*) fail "Unsupported architecture" ;;
	esac

	# Snapshot of the addressies are below
	#   - https://github.com/nektro/zigmod/releases/download/r83/zigmod-x86_64-linux
	# Note
	#   - "zigmod" uploads non archived binary files to the GitHub releases.
	#   - "zigmod" changed versioning prefix from "v*" to "r*".
	#       - Since r75. - https://github.com/nektro/zigmod/compare/v98...r75#diff-7618f5168e5222f8c0abc2df987536d51d98f2ef5e34958e08420a187ffc5613L7-R5
	#       - No reasons were written. - https://github.com/nektro/zigmod/commit/410c2e98a2c986885ce7677160b7212db69d223e
	local url="$GH_REPO/releases/download/${version}/zigmod-${architecture}-${platform}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"

		cp "${ASDF_DOWNLOAD_PATH}/zigmod" "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
