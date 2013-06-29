# XAMPP [![Build Status](https://secure.travis-ci.org/rapid7-cookbooks/xampp.png)](http://travis-ci.org/rapid7-cookbooks/xampp) [![Dependency Status](https://gemnasium.com/rapid7-cookbooks/xampp.png)](https://gemnasium.com/rapid7-cookbooks/xampp)
## Description

Installs and configures xampp and it's dependencies.

## Requirements
### Platform
* Ubuntu (Tested on 12.04)

## Cookbooks
* xampp

## Attributes
* `node[:dvwa][:dir]` - Where xampp will be installed.
* `node[:dvwa][:version]` - The version number of xampp to install.
* `node[:dvwa][:url]` - The location to download xampp from.
* `node[:dvwa][:tarball]` - The name of the xampp tarball.

## Usage
Using `knife bootstrap IP_ADDR -x SUDOER -r recipe[xampp] --sudo`
will install xampp on the node after prompting for the sudoer's password.
The service will be running on port 80 of the host.

Using `knife bootstrap IP_ADDR -x SUDOER -r recipe[xampp::uninstall] --sudo`
will uninstall xampp on the node after being prompted for the sudoer's
password.

## License and Author
Authors: Trevor Highland (trevor_highland@rapid7.com)

Copyright (c) 2013, Rapid7. All Rights Reserved.
