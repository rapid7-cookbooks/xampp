#
# Cookbook Name:: dvwa
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
