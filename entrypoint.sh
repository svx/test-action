#!/usr/bin/env bash
set -eo pipefail

tw_lines=""  # Lines containing trailing whitespaces.

# TODO (harupy): Check only changed files.
for file in docs/*.md
do
  lines=$(egrep -rnIH " +$" $file | cut -f-2 -d ":")
  if [ ! -z "$lines" ]; then
    tw_lines+=$([[ -z "$tw_lines" ]] && echo "$lines" || echo $'\n'"$lines")
  fi
done

exit_code=0



# If tw_lines is not empty, change the exit code to 1 to fail the CI.
if [ ! -z "$tw_lines" ]; then
  echo ::set-output name=status::failure
  #echo -e "\n***** Lines containing trailing whitespace *****\n"
  #echo -e "${tw_lines[@]}"
  PAYLOAD=$(echo '{}' | jq --arg body "${tw_lines[@]}" '.body = $body')
  COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)
  echo "Commenting on PR $COMMENTS_URL"
  curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL"

  #echo -e "\n\nFailed!\n"
  exit_code=1
fi

exit $exit_code