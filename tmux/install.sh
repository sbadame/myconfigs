#!/bin/bash

#Get the absolute path that this script is in.
scriptdir="$(dirname $(readlink -f $0))"

ln -s "${scriptdir}/.tmux.conf" ~/.tmux.conf
