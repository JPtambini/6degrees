require 'sinatra'
require 'rest-client'
require 'json'

get "/" do
	#setting variables
	@actor1 =  params[:actor1] || "kevin bacon"
	@actor2 =  params[:actor2] || "john travolta (I)"
	#substituting space for plus sign
	A1 =@actor1.to_s.gsub(' ','+')
	A2 =@actor2.to_s.gsub(' ','+')
	#sending information to address where json file comes from
	connection_url = "http://oracleofbacon.org/cgi-bin/json?enc=utf-8&p=jpt10221984&a=#{@actor1}&b=#{@actor2}&u=1&rt=1&sy=1850&ey=2050&gm=0xef3ef7f&dir=0&co="
	movie_poster_url = "http://api.themoviedb.org/3/search/movie?api_key=8a6476299c496ff49fa6e273f21689c6&query=true+lies"
	# url3 = "https://api.themoviedb.org/3/movie/550?api_key=8a6476299c496ff49fa6e273f21689c6"
	#This line returns data from the url and returns a string.
	@string1 = RestClient.get(connection_url)
		if @string1["status"] === "spellcheck"
		end
	@string2 = RestClient.get(movie_poster_url)
	# @string3 = RestClient.get(url3)
	#This line takes the @string parses through it and returns a Hash
	@connections = JSON.parse(@string1)
	@movie = JSON.parse(@string2)
	# @actor =JSON.parse(@string3)

	#list of all actors
	actors = @connections["link"].select.with_index { |actor, index| index % 2 == 0}
	#list of movies
	movies = @connections["link"].select.with_index { |movie, index| index % 2 == 1}

	# list of actor images
	actormap = actors.map do |actor|
		 actor_img = actor.split("(")[0].gsub(" ","+")

			@actor_image_path = "http://api.themoviedb.org/3/search/person?api_key=8a6476299c496ff49fa6e273f21689c6&query=#{actor_img}"
			actor_image_string = RestClient.get(@actor_image_path)
			act_img_path = JSON.parse(actor_image_string)["results"][0]["profile_path"]
			

	end
	# list of movie images
	moviemap = movies.map do |movie|
		movie_img = movie.split("(")[0].gsub(" ","+")

			movie_image_path = "http://api.themoviedb.org/3/search/movie?api_key=8a6476299c496ff49fa6e273f21689c6&query=#{movie_img}"
			@movie_image_string = RestClient.get(movie_image_path)
			mov_img_path = JSON.parse(@movie_image_string)["results"][0]["poster_path"]
#may need this part to fix no movie poster problem 
			# mov_back_path = JSON.parse(@movie_image_string)["results"][0]["backdrop_path"]
			@movie_poster = "https://image.tmdb.org/t/p/original" + mov_img_path
	end

	@connect = actors.zip(movies,actormap,moviemap)
	@connect.pop
	erb :home
end