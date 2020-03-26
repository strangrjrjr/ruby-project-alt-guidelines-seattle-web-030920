
class SpaceApp
    def welcome
        puts "Welcome to:"
        banner = Artii::Base.new :font => 'slant'
        puts banner.asciify("Terrestrial Evaluation Exercise New")
        puts banner.asciify("Mission Operations Manager")
        puts " "
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
        puts "1) Create new mission"
        puts "2) View missions"
        puts "3) Update missions"
        puts "4) Generate a new mission automatically"
        puts "Q) Exit program"

        choice = gets.chomp.downcase

        case choice
        when "1"
            create_mission
        when "2"
            view_missions
        when "3"
            update_mission
        when "4"
            generate_mission
        when "q"
            exit
        else
            menu
        end
    end

    def create_mission
        puts "What is your mission name?"
        name = gets.chomp
        rocket = select_rocket
        astro = select_astronaut
        Mission.create(name:name, rocket_id:rocket.id, astronaut_id:astro.id, completed: false, manager_id:@manager.id)
        rocket.update(in_space: true)
        astro.update(in_space: true)
        puts " "
        puts "Mission created! #{astro.name} will crew the #{rocket.name} on mission #{mission.name}."
        puts " "
        menu
    end

    def view_missions
        puts "Missions in progress:"
        view_incomplete_missions.each do |mission|
            puts "#{mission.id}) #{mission.name}"
        end
        puts " "
        puts "Completed missions:"
        view_completed_missions.each do |mission|
            if mission.completed == nil
                puts "#{mission.id}) #{mission.name} ABORTED"
            else
                puts "#{mission.id}) #{mission.name}"
            end
        end
        puts " "
        menu
    end

    def update_mission
        puts "Which mission would you like to update?"
        # list missions
        mission_array = view_incomplete_missions
        ids = []
        mission_array.each do |mission|
            puts "#{mission.id}) #{mission.name}"
            ids << mission.id
        end
        # select mission by id
        choice = gets.chomp
        while !ids.include?(choice.to_i)
            puts "Invalid selection, please choose from available missions by number."
            choice = gets.chomp
        end
        mission = Mission.all.find{|mission| mission.id == choice.to_i}
        puts "1) Complete mission"
        puts "2) Abort mission"
        input = gets.chomp.downcase
        case input
        when "1"
            # complete_mission
            complete_mission(mission)
        when "2"
            # abort_mission
            abort_mission(mission)
        else
            puts "Invalid selection, please try again"
            update_mission
        end
        menu
    end

    #### HELPER METHODS ####

    def select_rocket
        puts "Please choose from the available spacecraft:"
        rocket_array = Rocket.all.select {|rocket| rocket.in_space == false}
        ids = []
        rocket_array.each do |rocket|
            puts "#{rocket.id}) #{rocket.name}: Capacity #{rocket.capacity}"
            ids << rocket.id
        end
        choice = gets.chomp
        while !ids.include?(choice.to_i)
            puts "Invalid selection, please choose from available rockets by number."
            choice = gets.chomp
        end
        rocket = Rocket.all.find{|rocket| rocket.id == choice.to_i}
        rocket.update(in_space: true)
        rocket
    end

    def select_astronaut
        puts "Who will crew your spacecraft?"
        astronaut_array = Astronaut.all.select {|astro| astro.in_space == false}
        ids = []
        astronaut_array.each do |astro|
            puts "#{astro.id}) #{astro.name}: #{astro.skill}"
            ids << astro.id
        end

        choice = gets.chomp
        while !ids.include?(choice.to_i)
            puts "Invalid selection, please choose from available missions by number."
            choice = gets.chomp
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
        # mission.completed = true
        # mission.astronaut.in_space = false
        # mission.rocket.in_space = false
        mission.update(completed: true)
        mission.astronaut.update(in_space: false)
        mission.rocket.update(in_space: false)
        binding.pry
        puts "Mission #{mission.name} completed!"
        puts " "
        menu
    end

    def abort_mission(mission)
        # mission.completed = nil
        # mission.rocket.in_space = false
        # mission.astronaut.in_space = false
        mission.update(completed: nil)
        mission.astronaut.update(in_space: false)
        mission.rocket.update(in_space: false)
        puts "MISSION #{mission.name} ABORTED"
        puts " "
        menu
    end

    def generate_mission
        # pull down info from api
        # create mission
    end

    def run
        welcome
        login
        menu
    end
end