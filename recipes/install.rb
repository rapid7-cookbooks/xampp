#
# Cookbook Name:: xampp
# Recipe:: install
#
# Copyright (c) 2013, Rapid7
#
# All Rights Reserved - Do Not Redistribute
#

include_recipe "apt" # TODO: Don't assume Ubuntu/Debian

package "ia32-libs"

version = if File.exists?("#{node[:xampp][:dir]}/lampp/lib/VERSION")
  File.read("#{node[:xampp][:dir]}/lampp/lib/VERSION").strip
end

unless version.eql?(node[:xampp][:version])
  remote_file "#{Chef::Config[:file_cache_path]}/#{node[:xampp][:tarball]}" do
    action :create_if_missing
    source node[:xampp][:url]
  end

  bash "install_xampp" do
    user "root"
    cwd Chef::Config[:file_cache_path]
    code <<-eos
      rm -rf #{node[:xampp][:dir]}/lampp &&
      tar -xzf #{node[:xampp][:tarball]} -C #{node[:xampp][:dir]} &&
      #{node[:xampp][:dir]}/lampp/lampp restart &&
      ln -s #{node[:xampp][:dir]}/lampp/lampp /etc/init.d/lampp &&
      update-rc.d -f lampp defaults &&
      chmod +x /etc/init.d/lampp
    eos
  end
end
