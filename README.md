# jpn_stock

## Support

- [株式投資メモ](https://kabuoji3.com/)

## Usage

Example is here.

```ruby
JpnStock.configure do |config|
	config.code  = '4755'
	config.year  = '2018'
	config.month = '01'
	config.day   = '04'
	config.mode  = 'day'
end

stock = JpnStock::Fetch.new
stock_data = stock.data
# => [
#	 	["date", "open", "high", "low", "close", "volume", "adj_close"],
#	 	["2018-01-04", "1044", "1044", "1024", "1032", "8289400", "1032"]
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
├─	/tmp													  
└─	README.md												  
```
