#! /opt/local/bin/ruby
# coding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/jpn_stock/configuration')
require File.expand_path(File.dirname(__FILE__) + '/jpn_stock/fetch')
require File.expand_path(File.dirname(__FILE__) + '/jpn_stock/version')

module JpnStock
	extend Configuration
end
