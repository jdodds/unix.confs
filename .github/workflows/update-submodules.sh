#!/usr/bin/env bash

auth_header="$(git config --local --get http.https://github.com/.extraheader)"
git submodule sync
git -c "http.extraheader=$auth_header" -c protocol.version=2 submodule.update --init --depth=1
