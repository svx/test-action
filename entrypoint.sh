#!/usr/bin/env bash
set -eo pipefail

# Vars
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_GREEN=$ESC_SEQ"32;01m"

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
  echo -en "$COL_YELLOW\n***** Lines containing trailing whitespace *****$COL_RESET\n"
  echo -e "${tw_lines[@]}"
  echo -en "$COL_RED\n\nFailed!$COL_RESET\n"
  exit_code=1
fi

exit $exit_code