class Manager < ActiveRecord::Base
    has_many :missions
    has_many :rockets, through: :missions
    has_many :astronauts, through: :missions
end