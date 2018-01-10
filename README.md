# jpn_stock

## Support

- [株式投資メモ](https://kabuoji3.com/)

## Usage

Example is here.

### Day data (code = 1321, date = 2018/01/04)

```ruby
JpnStock.configure do |config|
	config.code  = '1321'
	config.year  = '2018'
	config.month = '01'
	config.day   = '04'
	config.mode  = 'day'
end

stock = JpnStock::Fetch.new
stock.header[:english]
# => ['date', 'open', 'high', 'low', 'close', 'volume', 'adj_close']
stock.data
# => [
#	 	['2018-01-04', '23770', '24150', '23770', '24150', '611004', '24150']
#	 ]
```

### Year data (code = 1321, date = 2017)

```ruby
JpnStock.configure do |config|
	config.code  = '1321'
	config.year  = '2017'
	config.mode  = 'year'
end

stock = JpnStock::Fetch.new
stock.header[:english]
# => ['date', 'open', 'high', 'low', 'close', 'volume', 'adj_close']
stock.data
# => [
#	 	['2017-01-04', '19790', '20100', '19780', '20080', '749647', '20080'], 
#	 	['2017-01-05', '20100', '20120', '19960', '20020', '679991', '20020'], 
#	 	['2017-01-06', '19850', '19980', '19830', '19950', '474555', '19950'], 
#	 			:
#	 			:
#	 	['2017-12-27', '23510', '23570', '23500', '23530', '132280', '23530'], 
#	 	['2017-12-28', '23550', '23590', '23360', '23390', '174425', '23390'], 
#	 	['2017-12-29', '23480', '23510', '23370', '23410', '231315', '23410']
#	 ]
```

---

## Directory structure
```
/										  
├─	/lib								  
│	├─	/jpn_stock						  
│	│	├─	client.rb					  
│	│	├─	configuration.rb			  
│	│	├─	fetch.rb					  
│	│	└─	version.rb					  
│	└─	jpn_stock.rb					  
├─	/test								  
│	└─	test.rb							  
├─	/tmp								  
├─	LICENSE								  
└─	README.md							  
```
