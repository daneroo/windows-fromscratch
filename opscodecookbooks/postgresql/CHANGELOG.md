## v2.0.1:

* [COOK-1406] - pg gem compile is unable to find libpq under Chef full
  stack (omnibus) installation

## v2.0.0:

This version is backwards incompatible with previous versions of the
cookbook due to use of `platform_family`, and the refactored
configuration files using node attributes. See README.md for details
on how to modify configuration of PostgreSQL.

* [COOK-1508] - fix mixlib shellout error on SUSE
* [COOK-1744] - Add service enable & start
* [COOK-1779] - Don't run apt-get update and others in ruby recipe if pg is installed
* [COOK-1871] - Attribute driven configuration files for PostgreSQL
* [COOK-1900] - don't assume ssl on all postgresql 8.4+ installs
* [COOK-1901] - fail a chef-solo run when the postgres password
  attribute is not set

## v1.0.0:

**Important note for this release**

This version no longer installs Ruby bindings in the client recipe by
default. Use the ruby recipe if you'd like the RubyGem. If you'd like
packages for your distribution, use them in your application's
specific cookbook/recipe, or modify the client packages attribute.

This resolves the following tickets.

* COOK-1011
* COOK-1534

The following issues are also resolved with this release.

* [COOK-1011] - Don't install postgresql packages during compile
  phase and remove pg gem installation
* [COOK-1224] - fix undefined variable on Debian
* [COOK-1462] - Add attribute for specifying listen address

## v0.99.4:

* [COOK-421] - config template is malformed
* [COOK-956] - add make package on ubuntu/debian

## v0.99.2:

* [COOK-916] - use < (with float) for version comparison.

## v0.99.0:

* Better support for Red Hat-family platforms
* Integration with database cookbook
* Make sure the postgres role is updated with a (secure) password
