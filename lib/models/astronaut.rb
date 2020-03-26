class Astronaut < ActiveRecord::Base
    has_many :missions
    has_many :rockets, through: :missions
end