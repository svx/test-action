#!/usr/bin/env bash
set -eo pipefail

tw_lines=""  # Lines containing trailing whitespaces.
FILE=test.log
OUTPUT="$(cat $FILE)"


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
  echo -e "\n***** Lines containing trailing whitespace *****\n"
  echo -e "${tw_lines[@]}"
  echo ::set-output name=output::$(echo -e "${tw_lines[@]}")
  echo -e "$tw_lines"
  echo
  echo $OUTPUT
  jq -nc '{"body": "$OUTPUT"}' | \
          curl -sL  -X POST -d @- \
            -H "Content-Type: application/json" \
            -H "Authorization: token ${{ secrets.GITHUB_TOKEN }}" \
            "https://api.github.com/repos/$GITHUB_REPOSITORY/commits/$GITHUB_SHA/comments"

  
  

  #echo -e "\n\nFailed!\n"
  exit_code=1
fi

exit $exit_code