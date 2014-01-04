#!/bin/bash
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2014 Ryan Blair.  All rights reserved.
# Use is subject to license terms.
#

# this needs to be loaded after omnios-build/lib/functions.sh
# it provides supplemental functions over the top of the OmniTI ones
# for much of the private prefix -related templating

# hack up a local.mog for make_package to consume based on local.mog.tmpl,
# all of the files in epoxy-ips-bootstrap/lib/transforms,
# and environment variables
generate_localmog() {
  LOCAL_MOG_DIST=$PWD/local.mog.tmpl
  OUT_MOG=$PWD/local.mog
  TRANSFORMS_DIR=$PWD/../../../lib/transforms

  if [[ ! -f $LOCAL_MOG_DIST ]]; then
    unset LOCAL_MOG_DIST
  fi

  # don't say you weren't warned about using bare local.mog files
  rm -f $OUT_MOG

  # prevent $TRANSFORMS_DIR/*.mog.tmpl from being passed literally if there are
  # no extra transforms
  shopt -s nullglob

  # remember that pkgmogrify contents should be handled with NO LEADING SLASH
  # for example: <transform dir path=usr/.* -> drop>
  MOD_PREFIX=$(echo $PREFIX | sed s@^/@@g)
  SED_COMMAND="s@{{PREFIX}}@${MOD_PREFIX}@g"

  echo "Fixing up pkgmogrify transforms templates"
  echo "### THIS IS A GENERATED FILE, DO NOT EDIT" >> ${OUT_MOG}
  echo "### instead, customize local.mog.tmpl in this package build" \
    >> ${OUT_MOG}
  for infile in $TRANSFORMS_DIR/*.mog.tmpl $LOCAL_MOG_DIST; do
    echo "--- $(basename ${infile})"
    echo "### BEGIN template file \"$(basename ${infile})\"" >> ${OUT_MOG}
    sed ${SED_COMMAND} < ${infile} >> ${OUT_MOG}
    echo "### END template file \"$(basename ${infile})\"" >> ${OUT_MOG}
  done

}
