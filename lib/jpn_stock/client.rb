#! /opt/local/bin/ruby
# coding: utf-8

module JpnStock
	class Client
		attr_reader :url, :stock_data_table_keyname
		attr_writer :code, :year

		def initialize
			@url = ''
			@stock_data_table_keyname = {
											:expect => [
															'日付',
															'始値',
															'高値',
															'安値',
															'終値',
															'出来高',
															'終値調整'
														], 
											:english => [
															'date',
															'open',
															'high',
															'low',
															'close',
															'volume',
															'adj_close'
														]
										}

			@code = ''
			@year = ''

			@base = base
			@stock = stock
		end

		# reference: case of 4755 (Rakuten)
		# => https://kabuoji3.com/stock/4755/2018/
		public
		def get
			if @code.empty? and @year.empty?
				url = [@base, @stock].join('/')
				url += '/'
				# => https://kabuoji3.com/stock/
			elsif @code.empty? and !@year.empty?
				url = [@base, @stock].join('/')
				url += '/'
				# => https://kabuoji3.com/stock/
			elsif !@code.empty? and @year.empty?
				url = [@base, @stock, @code].join('/')
				url += '/'
				# => https://kabuoji3.com/stock/4755/
			else
				url = [@base, @stock, @code, @year].join('/')
				url += '/'
				# => https://kabuoji3.com/stock/4755/2018/
			end

			url
		end

		private
		def base
			'https://kabuoji3.com'
		end

		private
		def stock
			'stock'
		end
	end
end

# example
if $0 == __FILE__
	client = JpnStock::Client.new

	example = [
					{
						:description => 'no code and no year', 
						:code => '', 
						:year => ''
					}, 
					{
						:description => 'no code', 
						:code => '', 
						:year => '2018'
					}, 
					{
						:description => 'no year', 
						:code => '1322', 
						:year => ''
					}, 
					{
						:description => 'set code and year', 
						:code => '1322', 
						:year => '2018'
					}
				]

	example.each_with_index{ |e, idx|
		STDOUT.puts "<Example #{idx + 1}>"
		STDOUT.puts e[:description]

		client.code = e[:code]
		client.year = e[:year]

		url = client.get

		STDOUT.puts url
		STDOUT.puts
	}
end
