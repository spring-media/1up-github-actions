#!/usr/bin/env bash

[[ "${inputs_service_name}" == "" ]] \
    && service_suffix="" \
    || service_suffix=" / ${inputs_service_name}"
service_name="${GITHUB_REPOSITORY##*/}$service_suffix"
commit_msg=$(git log -1 --pretty=format:'%s')
gh_pr_num=$(echo $commit_msg | sed -r 's/.*#([0-9]+).*/\1/')
gh_url="https://github.com/${GITHUB_REPOSITORY}"
gha_url="<$gh_url/actions/runs/$GITHUB_RUN_ID|$service_name>"
[[ "$gh_pr_num" =~ ^[0-9]+$ ]] \
    && gh_pr_msg="<$gh_url/pull/$gh_pr_num|$commit_msg>" \
    || gh_pr_msg="$commit_msg"
success_fallback="$gha_url deployed successfully!\n $gh_pr_msg"
success_msg="${inputs_success_message}"
echo "SUCCESS_MESSAGE=${inputs_success_prefix} ${success_msg:-$success_fallback}" >> $GITHUB_ENV
failure_fallback=":boom: $gha_url failed!\n $gh_pr_msg"
failure_msg="${inputs_failure_message}"
echo "FAILURE_MESSAGE=${failure_msg:-$failure_fallback}" >> $GITHUB_ENV
