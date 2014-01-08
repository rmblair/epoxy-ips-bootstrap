#!/bin/bash

if [[ ! -d omnios-build ]]; then
  git clone --single-branch \
    https://github.com/omniti-labs/omnios-build --branch template \
    omnios-build
else
  echo "omnios-build already exists -- not cloning"
fi

if [[ ! -d omnios-build/build ]]; then
  git clone \
    https://github.com/rmblair/epoxy-ips --branch master \
    omnios-build/build
else
  echo "omnios-build/build already exists -- not cloning"
fi

# if we have a customized site.sh -- note this is in .gitignore
if [ -f config/site.sh ]; then
  cp config/site.sh omnios-build/lib/site.sh
else # we only have the example copy
  echo "Error --"
  echo "  omnios-build/lib/site.sh not configured"
  echo "  you need to copy ./config/site.sh.dist to ./config/site.sh"
  echo "  and configure publisher names and a repository then"
  echo "  re-run this script"
  exit 1
fi

# ignore this call from the site.sh, we just want some info
reset_configure_opts() {
  :
}

# load up the customized configuration so we can try to help some
. omnios-build/lib/site.sh

echo "settings from config/site.sh:"
echo "  PREFIX      : $PREFIX"
echo "  PKGPUBLISHER: $PKGPUBLISHER"
echo "  PKGNAMESPACE: $PKGNAMESPACE"
echo "  PKGSRVR URL : $PKGSRVR"

if [[ ! -z "$(echo $PKGSRVR | grep ^file://)" ]]; then
  pathonly=$(echo $PKGSRVR | sed s@^file://@@)
  echo "using file repository at $pathonly"
  if [[ -d $pathonly ]]; then
    echo "  $pathonly already exists -- ignoring"
  else
    while true; do
      echo -n "  would you like it to be created? (y/n) "
      read reply
      if [[ "y" == "$reply" ]]; then
        # make the repo then
        pkgrepo -s "$pathonly" create
        pkgrepo -s "$pathonly" set publisher/prefix=$PKGPUBLISHER
        break
      elif [[ "n" == "$reply" ]]; then
        # user wants to to ignore
        echo "not creating repository --"
        echo "  if you would like to create it later, either rerun this script,"
        echo "  or run the following commands:"
        echo "$ pkgrepo -s $pathonly create"
        echo "$ pkgrepo -s $pathonly set publisher/prefix=$PKGPUBLISHER"
        break
      else #bad response, repeat the prompt
        :
      fi
    done
  fi
else
  echo "you're using a non-file repository protocol -- ignoring"
fi

echo "if you haven't already, you probably want to add your repository"
echo "to the running system, like so:"
echo "$ sudo pkg set-publisher -g $PKGSRVR $PKGPUBLISHER"
echo
echo "all done -- change directories to omnios-build/build and start compiling!"
