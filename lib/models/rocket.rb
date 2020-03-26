class Rocket < ActiveRecord::Base
    has_many :missions
    has_many :astronauts, through: :missions
end