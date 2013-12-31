* Adjust bootstrap.sh (or run it as-is) to check out
omnios-build/template branch, then checkout epoxy-build as
omnios-build/build.

* bootstrap.sh will copy config/site.sh.dist to omnios-build/lib/site.sh and aferward, you should edit to suit local configuration

* build things in omnios-build/build/ in some useful order, probably based on BUILD_DEPENDS or a 'series' file in the top level of build/
