require 'io/console'
class SpaceApp

    def run
        welcome
        login
        menu
    end

    def welcome
        puts " "
        puts "Welcome to:"
        banner = Artii::Base.new :font => 'slant'
        puts banner.asciify("Terrestrial Evaluation Exercise: New")
        puts banner.asciify("Mission Operations Manager")
        puts " "
        system 'say welcome to: terrestrial evaluation exercise: new mission operations manager'
    end

    def login
        puts "What is your username?"
        username = gets.chomp
        @manager = Manager.find_or_create_by(name: username)
        puts " "
        puts "Hello, TEENMOM #{username}"
        puts " "
    end

    def menu
        puts "Please select from the following options:"
        puts "------------------------------------------- "
        puts "1) Create new mission"
        puts "2) View missions"
        puts "3) Update missions"
        puts "4) Generate a new mission automatically"
        puts "5) View rockets"
        puts "6) Build new rocket"
        puts "7) View astronauts"
        puts "8) Hire new astronaut"
        puts "9) Fire astronaut"
        puts "10) Stress test (destroy) rocket"
        puts "L) Leaderboard"
        puts "Q) Exit program"
        puts " "

        choice = STDIN.noecho(&:gets).chomp.downcase

        case choice
        when "1"
            create_mission
        when "2"
            view_missions
        when "3"
            update_mission
        when "4"
            generate_mission
        when "5"
            view_rockets
        when "6"
            create_rocket
        when "7"
            view_astronauts
        when "8"
            create_astronaut
        when "9"
            fire_astronaut
        when "10"
            stress_test_rocket
        when "l"
            leaderboard
        when "q"
            puts ""
            exit
        else
            menu
        end
    end

    def create_mission
        puts "What is your mission name?"
        puts " "
        name = gets.chomp
        puts " "
        puts "Please choose from the available spacecraft:"
        puts "---------------------------------------------"
        rocket = select_rocket
        puts " "
        puts "Who will crew your spacecraft?"
        puts "---------------------------------------------"
        astro = select_astronaut
        mission = Mission.create(name:name, rocket_id:rocket.id, astronaut_id:astro.id, completed: false, manager_id:@manager.id)
        rocket.update(in_space: true)
        astro.update(in_space: true)
        puts " "
        puts "Mission created! #{astro.name} will crew the #{rocket.name} on mission #{mission.name}."
        puts " "
        menu
    end

    def view_missions
        puts "Missions in progress:"
        puts "----------------------------------------"
        view_incomplete_missions.each do |mission|
            puts "#{mission.id}) #{mission.name}".colorize(:blue)
        end
        puts " "
        puts "Completed missions:"
        puts "----------------------------------------"
        view_completed_missions.each do |mission|
            if mission.completed == nil
                puts "#{mission.id}) #{mission.name} ABORTED".colorize(:red)
            else
                puts "#{mission.id}) #{mission.name}".colorize(:green)
            end
        end
        puts " "
        menu
    end

    def update_mission
        puts "Which mission would you like to update?"
        puts "---------------------------------------"
        mission_array = view_incomplete_missions
        ids = []
        mission_array.each do |mission|
            puts "#{mission.id}) #{mission.name}"
            ids << mission.id
        end
        puts " "
        choice = gets.chomp
        while !ids.include?(choice.to_i)
            puts "Invalid selection, please choose from available missions by number."
            puts " "
            choice = gets.chomp
            puts " "
        end
        mission = Mission.all.find{|mission| mission.id == choice.to_i}
        puts "1) Complete mission"
        puts "2) Abort mission"
        input = gets.chomp.downcase
        case input
        when "1"
            complete_mission(mission)
        when "2"
            abort_mission(mission)
        else
            puts "Invalid selection, please try again"
            update_mission
        end
        menu
    end

    def generate_mission
        rando_rocket = Rocket.all.find {|rocket| rocket.in_space == false}
        randonaut = Astronaut.all.find {|naut| naut.in_space == false}
        randoname = Faker::Company.buzzword + " " + Faker::Space.planet
        rando_mission = Mission.create(name:randoname, rocket_id:rando_rocket.id, astronaut_id:randonaut.id, manager_id:@manager.id, completed:false)
        ap rando_mission
        menu
    end

    def view_rockets
        ap Rocket.all
        menu
    end

    def create_rocket
        rocket_data = JSON.parse(RestClient.get("https://api.spacexdata.com/v3/rockets"))
        rocket_array = rocket_data.map do |rocket|
            rocket["rocket_name"]
        end
        new_rocket = rocket_array.sample 
        Rocket.create(name: new_rocket, capacity: 1 + rand(5), in_space: false)
        puts " "
        puts "Your shiny new #{new_rocket} is ready!".green
        puts " "
        menu
    end

    def view_astronauts
        ap Astronaut.all
        menu
    end

    def create_astronaut
        roles = ["commander", "pilot", "specialist", "copilot"]
        name = Faker::FunnyName.name
        new_astro = Astronaut.create(name: name, skill: roles.sample, in_space: false)
        puts " "
        puts "#{new_astro.skill.upcase} #{new_astro.name} just left the academy; reporting for duty!".green
        puts " "
        menu
    end

    def fire_astronaut
        puts "DUE TO BUDGET CUTS, ONE OF YOU UNLUCKY 'NAUTS HAS TO GO:".colorize(:red)
        unlucky = select_astronaut
        puts "Hit the road, former-#{unlucky.skill} #{unlucky.name}. Maybe you should go write that book.".red
        puts " "
        unlucky.destroy
        menu
    end

    def stress_test_rocket
        puts "WE CALL IT A STRESS TEST, BUT IT'S REALLY JUST A CHANCE TO DO SOME BARREL ROLLS"
        unlucky = select_rocket
        theatrics = Artii::Base.new
        puts theatrics.asciify("***BOOOOOOOOM***").yellow.on_red.blink
        puts " "
        unlucky.destroy
        menu
    end

    def leaderboard
        print "MOST PROLIFIC TEENMOM: ".green
        puts most_prolific_teenmom
        puts "\n"
        print "ASTRONAUT WITH THE MOST FLIGHTS: ".yellow
        puts astronaut_with_most_flights
        puts " \n"
        print "ROCKET WITH THE MOST SUCCESSFUL MISSIONS: ".blue
        puts rocket_with_most_successful_missions
        puts " "
        puts " "
        menu
    end

    #### HELPER METHODS ####

    def most_prolific_teenmom
        managers = Mission.all.map {|mission| mission.manager_id}
        max_manager = managers.max_by {|value| managers[value]}
        best = Manager.all.find{|manager| manager.id == max_manager}
        "#{best.id}) #{best.name}"
    end

    def astronaut_with_most_flights
        astros = Mission.all.map {|mission| mission.astronaut_id}
        max_naut = astros.max_by {|value| astros[value]}
        best = Astronaut.all.find {|astro| astro.id == max_naut}
        "#{best.id}) #{best.name}"
    end

    def rocket_with_most_successful_missions
        rockets = Mission.all.map {|mission| mission.completed == true ? mission.rocket_id : nil}.compact
        max_rocket = rockets.max_by {|value| rockets[value]}
        best = Rocket.all.find {|rocket| rocket.id == max_rocket}
        "#{best.id}) #{best.name}"
    end

    def select_rocket
        rocket_array = Rocket.all.select {|rocket| rocket.in_space == false}
        ids = []
        rocket_array.each do |rocket|
            puts "#{rocket.id}) #{rocket.name}: Capacity #{rocket.capacity}"
            ids << rocket.id
        end
        choice = gets.chomp
        puts " "
        while !ids.include?(choice.to_i)
            puts "Invalid selection, please choose from available rockets by id number."
            choice = gets.chomp
            puts " "
        end
        rocket = Rocket.all.find{|rocket| rocket.id == choice.to_i}
        rocket.update(in_space: true)
        rocket
    end

    def select_astronaut
        astronaut_array = Astronaut.all.select {|astro| astro.in_space == false}
        ids = []
        astronaut_array.each do |astro|
            puts "#{astro.id}) #{astro.name}: #{astro.skill}"
            ids << astro.id
        end

        choice = gets.chomp
        puts " "
        while !ids.include?(choice.to_i)
            puts "Invalid selection, please choose from available crew by id number."
            choice = gets.chomp
            puts " "
        end
        astro = Astronaut.all.find {|naut| naut.id == choice.to_i}
        astro.update(in_space: true)
        astro
    end

    def view_incomplete_missions
        Mission.all.select {|mission| mission.completed == false}
    end

    def view_completed_missions
        Mission.all.select {|mission| mission.completed != false}
    end

    def complete_mission(mission)
        mission.update(completed: true)
        mission.astronaut.update(in_space: false)
        mission.rocket.update(in_space: false)
        puts "Mission #{mission.name} completed!".colorize(:green)
        puts " "
        menu
    end

    def abort_mission(mission)
        mission.update(completed: nil)
        mission.astronaut.update(in_space: false)
        mission.rocket.update(in_space: false)
        puts "MISSION #{mission.name} ABORTED".colorize(:red)
        puts " "
        menu
    end
end