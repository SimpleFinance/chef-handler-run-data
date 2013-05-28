# chef-handler-run-data.rb
# 
# Author: Simple Finance <ops@simple.com>
# Copyright 2013 Simple Finance Technology Corporation.
# Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Exports node data to disk at the end of a successful Chef run

require 'rubygems'
require 'chef'
require 'chef/handler'

class RunData < Chef::Handler
  attr_reader :config

  def initialize(options = defaults)
    @path = options[:path]
  end

  def defaults
    return {
      :path => Chef::Config[:file_cache_path] }
  end

  def report
    if run_status.success?
      Chef::Log.info "Writing node information to #{@path}/successful-run-data.json"
      Chef::FileCache.store('successful-run-data.json', Chef::JSONCompat.to_json_pretty(data), 0640)
    else
      Chef::Log.error 'Chef run was not successful! Cancelling successful run data write'
    end
  end
end

