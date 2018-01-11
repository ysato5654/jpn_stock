#! /opt/local/bin/ruby
# coding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../lib/jpn_stock')

class Test
	attr_reader :test_num
	attr_reader :pass_num
	attr_reader :result

	PARAM = {
				# test for 'parse' method in fetch.rb
				:test1 => {
							:description => 'unset configure', 
							:code => JpnStock::Configuration::DEFAULT_CODE, 
							:year => JpnStock::Configuration::DEFAULT_YEAR, 
							:month => JpnStock::Configuration::DEFAULT_MONTH, 
							:day => JpnStock::Configuration::DEFAULT_DAY, 
							:mode => JpnStock::Configuration::DEFAULT_MODE
						}, 
				# test for 'parse' method in fetch.rb
				:test2 => {
							:description => 'wrong year: 1900', 
							:code => '1321', 
							:year => '1900', 
							:month => JpnStock::Configuration::DEFAULT_MONTH, 
							:day => JpnStock::Configuration::DEFAULT_DAY, 
							:mode => 'year'
						}, 
				# test for 'parse' method in fetch.rb
				:test3 => {
							:description => 'wrong code: 999', 
							:code => '999', 
							:year => '2017', 
							:month => JpnStock::Configuration::DEFAULT_MONTH, 
							:day => JpnStock::Configuration::DEFAULT_DAY, 
							:mode => 'year'
						}, 
				# test for 'mode' in fetch.rb
				:test4 => {
							:description => 'unset month', 
							:code => '1321', 
							:year => '2018', 
							:month => JpnStock::Configuration::DEFAULT_MONTH, 
							:day => '05', 
							:mode => 'day'
						}, 
				# test for 'mode' in fetch.rb
				:test5 => {
							:description => 'unset day', 
							:code => '1321', 
							:year => '2018', 
							:month => '01', 
							:day => JpnStock::Configuration::DEFAULT_DAY, 
							:mode => 'day'
						}, 
				# test for 'mode' in fetch.rb
				:test6 => {
							:description => 'wrong date: 2018-01-99', 
							:code => '1321', 
							:year => '2018', 
							:month => '01', 
							:day => '99', 
							:mode => 'day'
						}, 
				# test for 'mode' in fetch.rb
				:test7 => {
							:description => 'fail search: 2018-01-06 -> this day is Saturday', 
							:code => '1321', 
							:year => '2018', 
							:month => '01', 
							:day => '06', 
							:mode => 'day'
						}
			}

	def initialize
		@test_num = PARAM.keys.size
		@pass_num = 0
		@result = false
	end

	def start
		@pass_num = 0

		PARAM.each{ |key, val|
			STDOUT.puts '-----------------------'
			STDOUT.puts '  ' + val[:description]
			STDOUT.puts '-----------------------'

			# prevent from use before value
			JpnStock.reset

			JpnStock.configure do |config|
				config.code = val[:code]
				config.year = val[:year]
				config.month = val[:month]
				config.day = val[:day]
				config.mode = val[:mode]
			end

			stock = JpnStock::Fetch.new
			stock_data = stock.data

			STDOUT.puts

			if stock_data.empty?
				@pass_num += 1
				STDOUT.puts '** PASS **'
			else
				STDOUT.puts '** FAIL **'
			end

			STDOUT.puts

		}

		@result = true if @pass_num == @test_num

		return @result
	end
end

if $0 == __FILE__
	test = Test.new
	test.start

	STDOUT.puts
	STDOUT.puts "Pass Num / Test Num = #{test.pass_num} / #{test.test_num}"
	STDOUT.puts

end
