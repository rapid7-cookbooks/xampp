#
# Cookbook Name:: xampp
# Recipe:: default
#
# Copyright (c) 2013, Rapid7
#
# All Rights Reserved - Do Not Redistribute
#

# REVIEW: Is apt the only package manager that needs to be updated?
case node[:platform_family]
when 'debian'
  include_recipe 'apt'
end

if architecture
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

version = if File.exists?("#{node[:xampp][:dir]}/lampp/lib/VERSION")
  File.read("#{node[:xampp][:dir]}/lampp/lib/VERSION").strip
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node[:xampp][:tarball]}" do
  action :create_if_missing
  source node[:xampp][:url]
  not_if { version.eql? node[:xampp][:version] }
end

bash 'install_xampp' do
  user 'root'
  cwd Chef::Config[:file_cache_path]
  code <<-eos
    rm -rf #{node[:xampp][:dir]}/lampp &&
    tar -xzf #{node[:xampp][:tarball]} -C #{node[:xampp][:dir]} &&
    #{node[:xampp][:dir]}/lampp/lampp restart &&
    ln -s #{node[:xampp][:dir]}/lampp/lampp /etc/init.d/lampp &&
    update-rc.d -f lampp defaults &&
    chmod +x /etc/init.d/lampp
  eos
  not_if { version.eql? node[:xampp][:version] }
end
