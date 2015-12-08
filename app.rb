require 'sinatra'
require 'net/http'
require 'rest-client'
require 'json'

get "/" do
	#setting variables
	@actor1 =  params[:actor1] || "kevin bacon"
	@actor2 =  params[:actor2] || "john travolta (I)"
	#substituting space for plus sign
	@actor1.to_s.gsub(' ','+')
	@actor2.to_s.gsub(' ','+')
	#sending information to address where json file comes from
	url1 = "http://oracleofbacon.org/cgi-bin/json?enc=utf-8&p=jpt10221984&a=#{@actor1}&b=#{@actor2}&u=1&rt=1&sy=1850&ey=2050&gm=0xef3ef7f&dir=0&co="
	#This line returns data from the url and returns a string.
	@string = RestClient.get(url1)
	#This line takes the @string parses through it and returns a Hash
	@connections = JSON.parse(@string)

	#The hash below has 2 keys of "link" and "status"

	#link is the degrees of seperation

	#status is if it was succesfull, if theres a spelling error or multiple actors with same name
	@connections["link"].each do |s|
		puts s
	end
	erb :home
end