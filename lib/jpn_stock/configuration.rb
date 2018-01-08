#! /opt/local/bin/ruby
# coding: utf-8

module JpnStock
	module Configuration
		TARGET = [
					:code,
					:year,
					:month,
					:day,
					:mode
				].freeze

		DEFAULT_CODE  = nil
		DEFAULT_YEAR  = nil
		DEFAULT_MONTH = nil
		DEFAULT_DAY   = nil
		DEFAULT_MODE  = nil

		attr_accessor(*TARGET)

		def self.extended(base)
			base.reset
		end

		def configure
			yield self
		end

		def reset
			self.code  = DEFAULT_CODE
			self.year  = DEFAULT_YEAR
			self.month = DEFAULT_MONTH
			self.day   = DEFAULT_DAY
			self.mode  = DEFAULT_MODE
			self
		end
	end
end
