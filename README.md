The general idea of this repository is to be able to use
omnios-build's template branch without having to maintain
our own copy, while superceding a few bits of it to allow
for a custom publisher and file system prefix (normally
/opt/$PKGPUBLISHER).

pkgmogrify transform files (in this repository, as \*.mog.tmpl)
are templated with {{PREFIX}} so that they are fixed up on the fly.
Base templates are in epoxy-ips-bootstrap/lib/transforms, and
the per-package transforms template is local.mog.tmpl.

Usage:

* Adjust bootstrap.sh (or run it as-is) to check out
omnios-build/template branch, then checkout epoxy-ips as
omnios-build/build.

* bootstrap.sh will copy config/site.sh[.dist] to
omnios-build/lib/site.sh. If you provide site.sh, which
git is configured to ignore, it will use that in preference
to the example copy provided as site.sh.dist.

* build things in omnios-build/build/ in some useful order,
probably based on BUILD\_DEPENDS or a 'series' file in the top
level of build/

