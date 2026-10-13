#!/usr/bin/env bash

[ "${SSH_CLIENT}" == "" ] && exit 0 || exit 1
