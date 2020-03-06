#!/usr/bin/env bash

git fetch --depth=1 --tags

num_tags=$(git tag | wc -l)

[[ $num_tags -eq 0 ]] && exit 0;

last_tagged=$(git tag -l --sort='-taggerdate' --format='%(taggerdate:iso-strict)' | head -n1)

new_info=''

git submodule -q foreach "
    cd \$toplevel/\$path
    has_changes=\$(git log --oneline --since=\$last_tagged | wc -l)
    [[ \$has_changes -eq 0 ]] && continue
    changes=\$(git log --since=$last_tagged --format='+ %s%n')
    new_info=\"\n$new_info\n## \$name\n\$changes\"
"

if [[ $(git log --oneline --since="$last_tagged" | wc -l) -ne 0 ]] ; then
    new_info="\n$new_info\n## unix.confs\n$(git log --since="$last_tagged" --format='+ %s%n')"
fi

[[ -z $new_info ]] && exit 0;

log=$(tail +2 CHANGELOG)
today=$(date "+%Y-%m-%d")
printf -v newlog "# %s\n%b\n%b\n" "$today" "$new_info" "$log"
echo "$newlog" > CHANGELOG

git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
git add CHANGELOG
git commit -m "As of $today"
git tag -m "$today" "$((num_tags+1))"

# shellcheck disable=SC2154
remote="https://${GITHUB_ACTOR}:${{ access_token }}@github.com/${GITHUB_REPOSITORY}.git"

git push "${remote}" master
git push --tags
