require_relative '../config/environment'

# space = SpaceApp.new
# SpaceApp.run
rocket_data = JSON.parse(RestClient.get("https://api.spacexdata.com/v3/rockets"))
binding.pry
0
