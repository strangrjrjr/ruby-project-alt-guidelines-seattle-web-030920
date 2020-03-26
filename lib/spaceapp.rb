
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
        puts "4) Abort mission"
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
            abort_mission
        when "q"
            exit
        else
            menu
        end
    end

    def create_mission
        puts "What is your mission name?"
        name = gets.chomp
        puts "Please choose from the available spacecraft:"
        rocket_array = Rocket.all.select {|rocket| rocket.in_space == false}
        rocket_array.each do |rocket|
            puts "#{rocket.id}) #{rocket.name}: Capacity #{rocket.capacity}"
        end
        # choose by id
        rocket = gets.chomp
        # loop for bad input
        #update in_space
        puts "Who will crew your spacecraft?"
        astronaut_array = Astronaut.all.select {|astro| astro.in_space == false}
        astronaut_array.each do |astro|
            puts "#{astro.id}) #{astro.name}: #{astro.skill}"
        end

        astro = gets.chomp
        # choose by id
        #loop for bad input
        #update in_space
        mission.create(name:name, rocket_id:rocket.id, astronaut_id:astro.id, completed: false, manager_id:@manager.id)
        menu
    end

    def view_missions
        puts "Missions in progress:"
        in_prog = Mission.all.select {|mission| mission.completed == false}
        in_prog.each do |mission|
            puts "#{mission.id}) #{mission.name}"
        end
        puts " "
        puts "Completed missions:"
        complete = Mission.all.select {|mission| mission.completed == true}
        complete.each do |mission|
            puts "#{mission.id}) #{mission.name}"
        end
        menu
    end

    def complete_mission(mission)
        mission.completed = true
        puts "Mission #{mission.name} completed!"
        menu
    end

    def abort_mission(mission)
        mission.completed = false
        mission.astronaut_id = nil
        mission.rocket_id = nil
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