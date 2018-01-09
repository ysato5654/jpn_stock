#! /opt/local/bin/ruby
# coding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../lib/jpn_stock')

class Test
	attr_reader :test_num
	attr_reader :pass_num
	attr_reader :result

	PARAM = {
				:test1 => {
							:description => 'wrong year: 1900', 
							:code => '1321', 
							:year => '1900'
						}, 
				:test2 => {
							:description => 'wrong code: 999', 
							:code => '999', 
							:year => '1900'
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

			JpnStock.configure do |config|
				config.code = val[:code]
				config.year = val[:year]
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
