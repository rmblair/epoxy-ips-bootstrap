#!/bin/sh

git clone --single-branch \
  https://github.com/omniti-labs/omnios-build --branch template \
  omnios-build

git clone \
  https://github.com/rmblair/epoxy-ips --branch master \
  omnios-build/build

# if we have a customized site.sh -- note this is in .gitignore
if [ -f config/site.sh ]; then
  cp config/site.sh omnios-build/lib/site.sh
else # we only have the example copy
  cp config/site.sh.dist omnios-build/lib/site.sh
fi

