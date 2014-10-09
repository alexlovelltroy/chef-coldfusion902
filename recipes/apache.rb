#
# Cookbook Name:: coldfuison902
# Recipe:: apache
#
# Copyright 2012, Nathan Mische
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Disable the default site
apache_site "000-default" do
  enable false  
end

# Add ColdFusion site
web_app "coldfusion" do
  cookbook "coldfusion902"
  template "coldfusion-site.conf.erb"
end

# Link httpd.conf
link "#{node['apache']['dir']}/sites-available/coldfusion.conf" do
  to "#{node['apache']['dir']}/sites-enabled/"
  notifies :restart, "service[apache2]", :delayed
end

# Make sure CF is running
execute "start_cf_for_coldfusion902_wsconfig" do
  command "/bin/true"
  notifies :start, "service[coldfusion]", :immediately
end

# Run wsconfig
execute "wsconfig" do
  command "#{node['cf902']['install_path']}/runtime/bin/wsconfig -server coldfusion -ws Apache -dir #{node['apache']['dir']} -bin #{node['apache']['binary']} -script /usr/sbin/apache2ctl -coldfusion -v"
  action :run
  not_if "grep 'jrun_module' #{node['apache']['dir']}/httpd.conf"
  notifies :restart, "service[apache2]", :delayed
end
