# **DEPRECATED** #

## Please use [https://github.com/ghoneycutt/puppet-module-pam](https://github.com/ghoneycutt/puppet-module-pam)

<br/>

===

pam

This is the pam module.

Released 20100625 - Garrett Honeycutt - GPLv2

## Definition: pam::accesslogin ##

allow specified groups to login to system

### Parameters: ###
  $origins - default is "ALL"
  $ensure  - default is present

### Actions: ###
  adds the group to the access.conf

### Sample Usage: ###
this would allow members of the root and systems groups to login

   accesslogin { ["root", "systems"]: ; }
