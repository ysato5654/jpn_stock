#! /opt/local/bin/ruby
# coding: utf-8

require 'open-uri'
require 'nokogiri'

require File.expand_path(File.dirname(__FILE__) + '/client')

module JpnStock
	class Fetch
		attr_reader :header
		# => {
		   # 	:japanese => ['日付', '始値', '高値', '安値', '終値', '出来高', '終値調整'], 
		   # 	:english => ['date', 'open', 'high', 'low', 'close', 'volume', 'adj_close']
		   # }
		attr_reader :data
		# => [
		   # 	['2018-01-04', '23770', '24150', '23770', '24150', '611004', '24150'], 
		   # 	['2018-01-05', '24280', '24390', '24170', '24370', '495513', '24370']
		   # ]

		def initialize
			@header = Array.new
			@data = Array.new

			client = JpnStock::Client.new

			JpnStock.configure do |config|
				client.code = config.code
				client.year = config.year
			end

			url = client.get
			# => "https://kabuoji3.com/stock/1321/2018/"

			charset = nil
			html = open(url) do |f|
				charset = f.charset
				f.read
			end

			html_doc = Nokogiri::HTML.parse(html, nil, charset)

=begin
			begin
				html_doc = Nokogiri::HTML.parse(html, nil, charset)
			rescue
				STDOUT.puts 'Warning: Wait 1 mitunes...'
				sleep(30)
				STDOUT.puts 'Retry'
				retry
			end
=end

			mode = Configuration::DEFAULT_MODE

			JpnStock.configure do |config|
				mode = config.mode
			end

			if Configuration::MODE.index(mode).nil?
				if mode.nil?
					STDERR.puts "#{__FILE__}:#{__LINE__}:Error: wrong mode of configuration - Nil"
				else
					STDERR.puts "#{__FILE__}:#{__LINE__}:Error: wrong mode of configuration - #{mode}"
				end
			else
				@header = client.stock_data_table_header
				# => {
				   # 	:japanese => ['日付', '始値', '高値', '安値', '終値', '出来高', '終値調整'], 
				   # 	:english => ['date', 'open', 'high', 'low', 'close', 'volume', 'adj_close']
				   # }

				# pick up 'stock data table'
				@data = parse(html_doc)
				# => [
				   # 	['2018-01-04', '23770', '24150', '23770', '24150', '611004', '24150'], 
				   # 	['2018-01-05', '24280', '24390', '24170', '24370', '495513', '24370']
				   # ]

				case mode
				# 'year'
				#when Configuration::MODE[0]
				# 'month'
				#when Configuration::MODE[1]
				# 'day'
				when Configuration::MODE[2]
					date = ''
					JpnStock.configure do |config|
						if config.year.nil?
							STDERR.puts "#{__FILE__}:#{__LINE__}:Error: year is Nil"
							# data is initialized due to error
							@data.clear
							break
						end

						if config.month.nil?
							STDERR.puts "#{__FILE__}:#{__LINE__}:Error: month is Nil"
							# data is initialized due to error
							@data.clear
							break
						end

						if config.day.nil?
							STDERR.puts "#{__FILE__}:#{__LINE__}:Error: day is Nil"
							# data is initialized due to error
							@data.clear
							break
						end

						date = config.year + '-' + config.month + '-' + config.day
						# => '2018-01-05'

						begin
							t = Time.parse(date)
						rescue => error
							STDERR.puts "#{__FILE__}:#{__LINE__}:Error: #{error.message} (#{error.class})"

							# data is initialized due to error
							@data = []
						else
							tmp = Array.new
							index = @header[:english].index('date')

							# search and extract target data corresponding to date
							@data.each{ |e|
								if t == Time.parse(e[index])
									tmp = e
									break
								end
							}

							@data.clear

							# if could not search target data, then @data is stil empty
							# if could search target one, @data is updated
							@data.push tmp unless tmp.empty?
						end
					end

				end
			end
		end

		private
		def parse html_doc
			nodesets = html_doc.xpath('//table[@class="stock_table stock_data_table"]').children

			# nodesets.class
			# => Nokogiri::XML::NodeSet

			if nodesets.empty?
				STDERR.puts "#{__FILE__}:#{__LINE__}:Error: #{nodesets.class} is empty"

=begin
				html_doc.xpath('//div[@class="base_box_desc"]').children.each{ |nodeset|
					nodeset.children.each{ |_noseset|
						STDERR.print _noseset.text
					}
				}
				STDERR.puts
=end

				return []
			end

			header = Array.new
			data = Array.new

			nodesets.each{ |nodeset|
				# if node is not element, then skip
				next unless nodeset.element?

				# nodeset.class
				# => Nokogiri::XML::Element

				if nodeset.node_name == 'thead'
					header = xpath_tr(nodeset.children)
					# => ['日付', '始値', '高値', '安値', '終値', '出来高', '終値調整']

				elsif nodeset.node_name == 'tbody'
					data.push xpath_tr(nodeset.children)
					# => ['2018-01-04', '23770', '24150', '23770', '24150', '611004', '24150']

				elsif nodeset.node_name == 'tr'
					data.push xpath_th(nodeset.children)
					# => ['2018-01-05', '24280', '24390', '24170', '24370', '495513', '24370']

				else
					STDERR.puts "#{__FILE__}:#{__LINE__}:Error: mismatch node name"
					STDERR.puts nodeset.node_name
					return []
				end
			}

			unless header == @header[:japanese]
				STDERR.puts "#{__FILE__}:#{__LINE__}:Error: mismatch header"

=begin
				STDERR.puts header
=end

				return []
			end

			header.clear

			data
			# => [
			   # 	['2018-01-04', '23770', '24150', '23770', '24150', '611004', '24150'], 
			   # 	['2018-01-05', '24280', '24390', '24170', '24370', '495513', '24370']
			   # ]
		end

		private
		def xpath_tr nodesets
			array = Array.new
			nodesets.each{ |nodeset|
				# if node is not element, then skip
				next unless nodeset.element?

				array.push xpath_th(nodeset.children)
			}

			unless array.size == 1
				STDERR.puts "Error"
			end

			array.first
		end

		private
		def xpath_th nodesets
			array = Array.new
			nodesets.each{ |nodeset|
				# if node is not element, then skip
				next unless nodeset.element?

				array.push nodeset.children.text
			}

			array
		end
	end
end
