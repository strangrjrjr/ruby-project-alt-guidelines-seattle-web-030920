# rockets
rocket_data = JSON.parse(RestClient.get("https://api.spacexdata.com/v3/rockets"))
rocket_array = rocket_data.map do |rocket|
    rocket["rocket_name"]
end
rocket_array.each do |rocket|
    Rocket.create(name: rocket, capacity: 1 + rand(5))
end

# astronauts
roles = ["commander", "pilot", "specialist", "copilot"]
10.times do
    name = Faker::Name.name
    Astronaut.create(name: name, skill: roles.sample)
end

# missions
mission_data = JSON.parse(RestClient.get("https://api.spacexdata.com/v3/missions"))
mission_array = mission_data.map do |mission|
    mission["mission"]
end
mission_array.each do |mission|
    Mission.create(name: mission, completed: false, rocket_id: Rocket.all.sample.id, astronaut_id: Astronaut.all.sample.id)
end
