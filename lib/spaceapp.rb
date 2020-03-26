
class SpaceApp
    def welcome
        puts "Welcome, Mission Manager"
    end

    def login
        puts "What is your username?"
        username = gets.chomp
        @user = User.find_or_create_by(name: username)
    end

    def menu
        puts "Please select from the following options:"
        puts "1) Create new mission"
        puts "2) View missions"
        puts "3) Update missions"
        puts "4) Abort mission"

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
        else
            menu
        end
    end

    def create_mission
        puts "Please choose from the available spacecraft:"
        rocket_array
    end

    def view_missions
        puts "Missions in progress:"
        #
        puts "Completed missions:"
        #
    end

    def complete_mission(mission)

    end

    def abort_mission(mission)

    end

    def generate_mission

    end
end