#
# Cookbook Name:: collectd
# Recipe:: default
#
# Copyright 2013, DrillingInfo, Inc
#
#
#

include_recipe 'build-essential'

execute 'install collectd' do
  filename = File.basename(node['collectd']['url'])
  dirname = File.basename(node['collectd']['url'], ".tar.gz")
  command <<CMD
cd /usr/src
rm -rf #{dirname}
wget #{node['collectd']['url']}
tar xzf #{filename}
cd #{dirname}
./configure
make
make install
CMD
  creates node['collectd']['base_dir']
end

template '/etc/init.d/collectd' do
  source 'collectd.init.erb'
  owner 'root'
  group 'root'
  mode '755'
  notifies :restart, 'service[collectd]', :delayed
end

service 'collectd' do
  supports :restart => true, :status => true
end

directory node['collectd']['base_dir'] do
  owner 'root'
  group 'root'
  mode '755'
  recursive true
end

directory node['collectd']['conf_dir'] do
  owner 'root'
  group 'root'
  mode '755'
  recursive true
end

template "#{node['collectd']['base_dir']}/etc/collectd.conf" do
  source 'collectd.conf.erb'
  owner 'root'
  group 'root'
  mode '644'
  notifies :restart, 'service[collectd]'
end

service 'collectd' do
  action [:enable, :start]
end




graphite_host = "10.128.3.26"

collectd_plugin "write_graphite" do
    template "write_graphite_plugin.conf.erb"
    config 'Host' => graphite_host
end

collectd_plugin "cpu"
collectd_plugin "disk"
collectd_plugin "memory"
collectd_plugin "swap"

collectd_plugin "df" do
  config :report_reserved=>false,
          "FSType"=>["proc", "sysfs", "fusectl", "debugfs", "securityfs", "devtmpfs", "devpts", "tmpfs"],
          :ignore_selected=>true
end

collectd_plugin "interface" do
  config :interface=>"lo", :ignore_selected=>true
end

collectd_plugin "syslog" do
  config :log_level=>"Info"
end