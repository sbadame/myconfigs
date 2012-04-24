#!/bin/bash

#Get the absolute path that this script is in.
scriptdir="$(dirname $(readlink -f $0))"

ln -s "${scriptdir}/.bash_aliases" ~/.bash_aliases
ln -s "${scriptdir}/.bash_arch" ~/.bash_arch
ln -s "${scriptdir}/.dircolors" ~/.dircolors
ln -s "${scriptdir}/.path" ~/.path

source ~/.bash_aliases
