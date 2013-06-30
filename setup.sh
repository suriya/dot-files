#!/usr/bin/env bash

#
# $Id: setup.sh 1166 2008-12-31 17:21:52Z suriya $
#

# Please read the accompanying README file Run this script from its own
# directory to set the links properly. Do this when you are moving to a new
# system.  Remember to backup/remove the original files before doing so

# CreateSymlink does some sanity checks before doing
# ln -sv $1 $2

BLUE="[34;01m"
CYAN="[36;01m"
GREEN="[32;01m"
OFF="[0m"
RED="[31;01m"

function CannotCreate() {
    FILE=$1
    LINK=$2
    echo "${RED}Cannot symlink ${FILE} to ${LINK}">&2
    echo "${LINK} already exists${OFF}">&2
    exit 1
}

function CreateSymlink() {
    FILE=$1
    LINK=$2
    if [ -e ${LINK} ]
    then
        if [ -L ${LINK} ]
        then
            if [ `readlink ${LINK}` == ${FILE} ]
            then
                echo "${GREEN}${LINK} already points to ${FILE}${OFF}">&2
                return
            else
                CannotCreate $1 $2
            fi
        else
            CannotCreate $1 $2
        fi
    fi
    echo -n "${CYAN}">&2
    ln -sv ${FILE} ${LINK}
    echo -n "${OFF}">&2
}

#
# For bash
#
pushd ..
CreateSymlink    .mine/bash_files/bashrc         .bashrc
CreateSymlink    .mine/bash_files/bash_logout    .bash_logout
CreateSymlink    .mine/bash_files/bash_profile   .bash_profile
popd

#
# For vim
# 
pushd ..
CreateSymlink    .mine/vimrc                     .vimrc
CreateSymlink    .mine/vim                       .vim
popd

#
# Making less excellent
#
pushd ..
CreateSymlink    .mine/lessfilter       .lessfilter
popd

#
# Use gdbinit
#
pushd ..
CreateSymlink    .mine/gdbinit          .gdbinit
popd

#
# ~/bin
#
pushd ..
CreateSymlink    .mine/bin              bin
popd

#
# For compilercache
#
# pushd compilercache
# case `uname -m` in
# *86)
#     CreateSymlink  compilercacheunifier.x86 compilercacheunifier;
#     ;;
# ppc)
#     CreateSymlink  compilercacheunifier.powerpc compilercacheunifier;
#     ;;
# esac
# chmod +x compilercacheunifier
# python2.5 compilercacherc.template.py > compilercacherc
# popd
# pushd ~
# CreateSymlink  .mine/compilercache/compilercacherc .compilercacherc
# popd

#
# For xmodmap
#
pushd ~
CreateSymlink .mine/keymaps/X11-vim-keymap .Xmodmap
popd

#
# Programs in /p on UTCS machines
#
if [ ${HOSTNAME#*.} == "cs.utexas.edu" ]
then
    mkdir -p ~/.p
    pushd ~/.p
    for i in /p/graft/catdoc-0.93.4.orig/bin \
             /p/graft/cscope-15.5/bin \
             /p/graft/ctags-5.6/bin \
             /p/graft/jgraph-8.3/bin \
             /p/graft/pinfo-0.6.8/bin \
             /p/graft/tree-1.5.0/bin \
             /p/graft/urlview-0.9/bin \
             /p/graft/graphviz-2.2/bin \
             /p/graft/vim7/bin \
             /p/graft/scons-0.96.1/bin \
             /p/graft/hevea-1.08/bin \
             /p/graft/recode-3.6/bin \
             /p/graft/gnupod-0.99/bin
    do
        for j in $i/*
        do
            CreateSymlink $j `basename $j`
        done
    done
    CreateSymlink /p/graft/firefox-2.0.0.2/firefox firefox
    CreateSymlink /p/graft/id3v2/bin/id3v2 id3v2
    CreateSymlink /p/graft/rss2email/r2e r2e
    CreateSymlink /bin/readlink readlink
    CreateSymlink /lusr/python/bin/ipython ipython
    CreateSymlink /p/graft/grepm/bin/grepm gm
    popd
fi

#
# For .rc files
#
pushd ~
CreateSymlink .mine/rcfiles/charmrc     .charmrc
CreateSymlink .mine/rcfiles/s3cfg       .s3cfg
CreateSymlink .mine/rcfiles/colordiffrc .colordiffrc
CreateSymlink .mine/rcfiles/subversion  .subversion
CreateSymlink .mine/rcfiles/hgk         .hgk

UNAME=`uname`
CreateSymlink .mine/rcfiles/hgrc.${UNAME} .hgrc
popd

