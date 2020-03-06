#!/usr/bin/env bash

archive="unix.confs.zip"
git archive -o $archive HEAD
zip -d $archive .gitmodules

#shellcheck disable=SC2016
git submodule -q foreach 'cd $toplevel; zip -ru '$archive' $path -x $path/.git/\* $path/.github/\* $path/.git $path/.github'

tag="${GITHUB_REF}"
today="$(date "+%Y-%m-%d")"
name="Release #$tag -- $today"
description="$(git log -n1 --format='%s%b')"

# shellcheck disable=SC2154
auth="Authorization: token ${access_token} "
length="Content-Length: $(stat -c%s $archive)"
type="Content-Type: application/zip"

create_url="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases"

printf -v json '{"tag_name": "%s", "name":"%s", "body":"%s"}' "$tag" "$name" "$description"


upload_url=$(curl -s -H "$auth" -d "$json" "$create_url" | jq -r '.upload_url')
upload_url="${upload_url%\{*}"

curl -f -sSL -XPOST \
     -H "$auth" -H "$length" -H "$type" \
     --upload-file "$archive" \
     "$upload_url?name=${archive}&label=unix.confs.bare.zip"
