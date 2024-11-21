# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'open-uri'
require 'json'

# 1. Clean the database 🗑️
puts 'Cleaning the database...'
Movie.destroy_all
puts 'Database cleaned!'

# Substitua com sua chave da API
TMDB_API_KEY = "8034c469842f4300e397f3aaef37e181"
TMDB_BASE_URL = "https://api.themoviedb.org/3"

POSTER_BASE_URL = "https://image.tmdb.org/t/p/w500"

def fetch_top_rated_movies
  url = "#{TMDB_BASE_URL}/movie/top_rated?api_key=#{TMDB_API_KEY}&language=en-US&page=1"
  response = URI.open(url).read
  JSON.parse(response)
end

movies = fetch_top_rated_movies["results"]

movies.each do |movie|
  Movie.create(
    title: movie["title"],
    overview: movie["overview"],
    poster_url: POSTER_BASE_URL + movie["poster_path"],
    rating: movie["vote_average"]
  )
end
