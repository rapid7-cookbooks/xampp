#
# Cookbook Name:: xampp
# Recipe:: default
#
# Copyright (c) 2013, Rapid7
#
# All Rights Reserved - Do Not Redistribute
#

# TODO: More code cleanup
# TODO: Add support for Windows
# REVIEW: Is apt the only package manager that needs to be updated?
case node[:platform_family]
when 'debian'
  include_recipe 'apt'
end

if node[:kernel][:machine].eql?('x86_64')
  case node[:platform_family]
  when 'arch'
    package 'lib32-glibc'
    package 'gcc-libs-multilib'
  when 'debian', 'rhel'
    if platform? 'centos'
      package('glibc') { arch 'i386' }
      package('libstd') { arch 'i386' }
      package('ld-linux.so.2')
    else
      package 'ia32-libs'
    end
  end
end

version = File.read("#{node[:xampp][:dir]}/lampp/lib/VERSION").strip rescue nil

tarball_path = "#{Chef::Config[:file_cache_path]}/#{node[:xampp][:tarball]}"
remote_file tarball_path do
  source node[:xampp][:url]
  not_if { version.eql? node[:xampp][:version] }
end

directory "#{node[:xampp][:dir]}/xampp" do
  action :delete
  recursive true
  not_if { version.eql? node[:xampp][:version] }
end

execute 'unarchive xampp' do
  command "tar -xzf #{tarball_path} -C #{node[:xampp][:dir]}"
  not_if { version.eql? node[:xampp][:version] }
end

link '/etc/init.d/lampp' do
  to "#{node[:xampp][:dir]}/lampp/lampp"
end

# REVIEW: Is it necessary to change the perms on the lampp executable?
# chmod +x /etc/init.d/lampp

service 'xampp' do
  action [:enable, :start]

  # NOTE: This is incorrect for windows.
  service_name 'lampp'
end
