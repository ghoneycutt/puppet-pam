# Class: pam
#
# This module manages pam and is included in the generic module for all hosts
#
# Sample Usage: include pam
#
class pam {

    $sshd   = "sshd"
    $access = "/etc/security/access.conf"

    File { links => follow }

    file {
        "/etc/pam.d/login":
            source => "puppet:///modules/pam/$operatingsystem/login";
        "/etc/pam.d/$sshd":
            source => "puppet:///modules/pam/$operatingsystem/$sshd";
    } # file

    exec {"prep access.conf":
        command => "echo - : ALL : ALL > $access",
        unless  => "tail -n 1 $access | grep '^\\- : ALL : ALL'",
    } # exec

    # Definition: pam::accesslogin
    #
    # allow specified groups to login to system
    #       
    # Parameters:    
    #   $origins - default is "ALL"
    #   $ensure  - default is present
    #
    # Actions:
    #   adds the group to the access.conf
    #       
    # Sample Usage:  
    # this would allow members of the root and systems groups to login
    #
    #    accesslogin { ["root", "systems"]: ; }
    #
    define accesslogin($origins = "ALL", $ensure = "present") {
        case $ensure {
            present: {
                exec {"$ensure : $name : $origins":
                    command => "sed -i '\$i+ : $name : $origins' ${pam::access}",
                    unless  => "grep '$perm : $name : $origins' ${pam::access}",
                    require => Exec["prep access.conf"],
                } # exec
            } # 'present'
            default: {
                exec {"$ensure : $name : $origins":
                    command => "sed -i '/+ : $name : $origins/d' ${pam::access}",
                    onlyif  => "grep '$perm : $name : $origins' ${pam::access}",
                    require => Exec["prep access.conf"],
                } # exec
            } # default
        } # case $ensure
    } # define accesslogin

    # Only members of these groups can login to systems by default
    # if you want to allow other groups the ability to login, the proper
    # way to handle this is to add a line such as the one below to the node
    # definition
    #
    # node 'foo' inherits default {
    #     pam::accesslogin { "somegroup": }
    # }
    accesslogin { ["root", "systems"]: ; }

} # class pam
