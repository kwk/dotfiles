#!/usr/bin/env bash

# Turn off signing git commits when committing from a remote host.
# Store the setting in the global ~/.gitconfig file which isn't tracked
# in this repository, thus not causing any change when the command runs.

if on-local-machine.sh; then
    git config --file ~/.gitconfig commit.gpgsign true
else
    git config --file ~/.gitconfig commit.gpgsign false
fi
