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
  when 'debian'
    package 'ia32-libs'
  end
end

version = File.read("#{node[:xampp][:dir]}/lampp/lib/VERSION").strip rescue nil

tarball_path = "#{Chef::Config[:file_cache_path]}/#{node[:xampp][:tarball]}"
remote_file tarball_path do
  source node[:xampp][:url]
  not_if { version.eql? node[:xampp][:version] }
end

directory "#{node[:xampp][:dir]}/lampp" do
  action :delete
  recursive true
  not_if { version.eql? node[:xampp][:version] }
end

execute 'unarchive xampp' do
  command "tar -xzf #{tarball_path} -C #{node[:xampp][:dir]}"
  not_if { version.eql? node[:xampp][:version] }
end

template "#{node[:xampp][:dir]}/lampp/etc/extra/httpd-xampp.conf" do
  variables({
    :security_policies => node[:xampp][:security_policies],
    :paths => node[:xampp][:match_paths]
  })
end

link '/etc/init.d/lampp' do
  to "#{node[:xampp][:dir]}/lampp/lampp"
end

service 'xampp' do
  action [:enable, :start]

  # TODO: Add Windows/Mac support?
  service_name 'lampp'
end
