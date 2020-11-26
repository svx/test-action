#!/usr/bin/env bash
set -eo pipefail

tw_lines=""  # Lines containing trailing whitespaces.

#OUTPUT="$(cat /tmp/log/out)"

# Make the temp directory
mkdir -p /tmp/log


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
  echo ::set-output name=result::$"(cat /tmp/log/out)"
  echo -e "\n***** Lines containing trailing whitespace *****\n"
  echo -e "${tw_lines[@]}" >/tmp/log/out 2>&1
  #echo -e "\n\nFailed!\n"
  echo -e "show out"
  cat /tmp/log/out
  exit_code=1
fi

exit $exit_code