#
# Cookbook Name:: xampp
# Attributes:: default
#
# Copyright (c) 2013, Rapid7
#
# All Rights Reserved - Do Not Redistribute
#

default[:xampp][:dir] = '/opt'
default[:xampp][:version] = '1.8.1'
default[:xampp][:url] = "http://www.apachefriends.org/download.php?xampp-linux-#{default[:xampp][:version]}.tar.gz"
default[:xampp][:tarball] = "xampp-linux-#{default[:xampp][:version]}.tar.gz"
default[:xampp][:match_paths] = %w[xampp security licenses phpmyadmin webalizer server-status server-info]
default[:xampp][:security_policies] =	[
                                        'Order deny,allow',
                                        'Deny from all',
                                        'Allow from ::1 127.0.0.0/8 \
                                        fc00::/7 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16 \
                                        fe80::/10 169.254.0.0/16',
                                        'ErrorDocument 403 /error/XAMPP_FORBIDDEN.html.var'
                                      ]
