Astronaut.destroy_all
Mission.destroy_all
Rocket.destroy_all
Manager.destroy_all

3.times do
    name = Faker::Name.name
    Manager.create(name: name)
end

# rockets
rocket_data = JSON.parse(RestClient.get("https://api.spacexdata.com/v3/rockets"))
rocket_array = rocket_data.map do |rocket|
    rocket["rocket_name"]
end
rocket_array.each do |rocket|
    Rocket.create(name: rocket, capacity: 1 + rand(5), in_space: false)
end

# astronauts
roles = ["commander", "pilot", "specialist", "copilot"]
10.times do
    name = Faker::Name.name
    Astronaut.create(name: name, skill: roles.sample, in_space: false)
end

# missions
mission_data = JSON.parse(RestClient.get("https://api.spacexdata.com/v3/missions"))
mission_array = mission_data.map do |mission|
    mission["mission_name"]
end
mission_array.each do |mission|
    Mission.create(name: mission, completed: false, rocket_id: Rocket.all.sample.id, astronaut_id: Astronaut.all.sample.id, manager_id: Manager.all.sample.id)
end

puts "Seed complete!"
