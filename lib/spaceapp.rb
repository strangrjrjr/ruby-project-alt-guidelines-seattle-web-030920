
class SpaceApp
    def welcome
        puts "Welcome, Mission Manager"
    end

    def login
        puts "What is your username?"
        username = gets.chomp
        @manager = Manager.find_or_create_by(name: username)
    end

    def menu
        puts "Please select from the following options:"
        puts "1) Create new mission"
        puts "2) View missions"
        puts "3) Update missions"
        puts "4) Generate a new mission automatically"
        puts "Q) Exit program"

        choice = gets.chomp

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
        mission.create(name:name, rocket_id:rocket.id, astronaut_id:astro.id, completed: false, manager_id:@manager.id)
        rocket.in_space = true
        astro.in_space = true
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
            puts "#{mission.id}) #{mission.name}"
        end
        menu
    end

    def update_mission
        puts "Which mission would you like to update?"
        # list missions
        view_incomplete_missions
        # select mission

        puts "Is this mission complete, or aborted?"
        # complete_mission
        # abort_mission
        menu
    end

    #### HELPER METHODS ####

    def select_rocket
        puts "Please choose from the available spacecraft:"
        rocket_array = Rocket.all.select {|rocket| rocket.in_space == false}
        rocket_array.each do |rocket|
            puts "#{rocket.id}) #{rocket.name}: Capacity #{rocket.capacity}"
        end
        rocket = gets.chomp
        # choose by id and !in_space
        # loop for bad input
        # update in_space
    end

    def select_astronaut
        puts "Who will crew your spacecraft?"
        astronaut_array = Astronaut.all.select {|astro| astro.in_space == false}
        astronaut_array.each do |astro|
            puts "#{astro.id}) #{astro.name}: #{astro.skill}"
        end

        astro = gets.chomp
        # choose by id and !in_space
        # loop for bad input
        # update in_space
    end

    def view_incomplete_missions
        Mission.all.select {|mission| mission.completed == false}
    end

    def view_completed_missions
        Mission.all.select {|mission| mission.completed != false}
    end

    def complete_mission(mission)
        mission.completed = true
        mission.astronaut.in_space = false
        mission.rocket.in_space = false
        puts "Mission #{mission.name} completed!"
        menu
    end

    def abort_mission(mission)
        mission.completed = nil
        mission.rocket.in_space = false
        mission.astronaut.in_space = false
        puts "MISSION #{mission.name} ABORTED"
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