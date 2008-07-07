# Load the plugin testing framework
$:.unshift("#{File.dirname(__FILE__)}/../../plugin_test_helper/lib")

# Use the test helper for testing ActiveRecord
require 'rubygems'
require 'plugin_test_helper'
