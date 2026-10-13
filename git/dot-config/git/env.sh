#!/usr/bin/env bash

# Turn off signing git commits when committing from a remote host.

on-local-machine.sh

if [ $? -ne 0 ]; then
    git config --global commit.gpgsign false
fi
