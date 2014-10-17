#
# Cookbook Name:: coldfuison9
# Recipe:: default
#
# Copyright 2012, Lew Goettner, Nathan Mische
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

# If Ubuntu 10.04 add the lucid-backports repo
if node['platform'] == 'ubuntu'

  apt_repository "lucid-backports" do
    uri "http://us.archive.ubuntu.com/ubuntu/"
    distribution "lucid-backports"
    components ["main","universe"]
    deb_src true
    action :add
    only_if { node[:platform_version] == "10.04" }
  end

  execute "apt-get update" do
  	action :run
  	only_if { node[:platform_version] == "10.04" }
  end

end

# Install libstdc++5
package "libstdc++5" do
  action :install
end

# Install the unzip package
package "unzip" do
  action :install
end

# Install the ia32 libs because the CF9 installer assumes that 32bit will work
package "multiarch-support" do
    action :install
end
package "ia32-libs" do
    action :install
    only_if { node[:platform_version] == "10.04" }
end

include_recipe "coldfusion902::standalone"
include_recipe "coldfusion902::jvmconfig"
include_recipe "coldfusion902::updates"
