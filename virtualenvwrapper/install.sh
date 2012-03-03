#!/bin/bash

#Get the absolute path that this script is in.
scriptdir="$(dirname $(readlink -f $0))"

if [ ! -z "$VIRTUALENVWRAPPER_HOOK_DIR" ]; then
    ln -s "${scriptdir}/postactivate" ${VIRTUALENVWRAPPER_HOOK_DIR}/postactivate
    ln -s "${scriptdir}/postdeactivate" ${VIRTUALENVWRAPPER_HOOK_DIR}/postdeactivate
else
    echo "Environment variable: VIRTUALENVWRAPPER_HOOK_DIR not set"
fi
