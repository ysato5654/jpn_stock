#! /opt/local/bin/ruby
# coding: utf-8

require 'open-uri'
require 'nokogiri'

require File.expand_path(File.dirname(__FILE__) + '/client')

module JpnStock
	class Fetch
		attr_reader :data

		def initialize
			@data = Array.new

			client = JpnStock::Client.new
			@keyname = client.stock_data_table_keyname

			JpnStock.configure do |config|
				client.code = config.code
				client.year = config.year
			end

			url = client.get
			# => "https://kabuoji3.com/stock/4755/2018/"

			charset = nil
			html = open(url) do |f|
				charset = f.charset
				f.read
			end

			begin
				html_doc = Nokogiri::HTML.parse(html, nil, charset)
			rescue
				STDOUT.puts 'Warning: Wait 1 mitunes...'
				sleep(30)
				STDOUT.puts 'Retry'
				retry
			end

			@data = stock_data_table(html_doc)
		end

		private
		def stock_data_table html_doc
			nodesets = html_doc.xpath('//table[@class="stock_table stock_data_table"]').children

			# nodesets.class
			# => Nokogiri::XML::NodeSet

			if nodesets.empty?
				STDERR.puts 'Error'
				return []
			end

			keyname = Array.new
			stock_data = Array.new

			nodesets.each{ |nodeset|
				# if node is not element, then skip
				next unless nodeset.element?

				# nodeset.class
				# => Nokogiri::XML::Element

				if nodeset.node_name == 'thead'
					keyname = xpath_tr(nodeset.children)
					# => ['日付', '始値', '高値', '安値', '終値', '出来高', '終値調整']

				elsif nodeset.node_name == 'tbody'
					stock_data.push xpath_tr(nodeset.children)
					# => ["2018-01-04", "1044", "1044", "1024", "1032", "8289400", "1032"]

				elsif nodeset.node_name == 'tr'
					stock_data.push xpath_th(nodeset.children)
					# => ["2018-01-05", "1025.5", "1025.5", "988", "1013.5", "15142500", "1013.5"]

				else
					STDERR.puts 'Error'
					STDERR.puts nodeset.node_name
					return []
				end
			}

			unless keyname == @keyname[:expect]
				STDERR.puts 'Error: mismatch keyname'
				STDERR.puts keyname
				return []
			end

			stock_data.unshift @keyname[:english]

			stock_data
			# => [
			   # 	['date', 'open', 'high', 'low', 'close', 'volume', 'adj_close'], 
			   # 	["2018-01-04", "1044", "1044", "1024", "1032", "8289400", "1032"], 
			   # 	["2018-01-05", "1025.5", "1025.5", "988", "1013.5", "15142500", "1013.5"]
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
