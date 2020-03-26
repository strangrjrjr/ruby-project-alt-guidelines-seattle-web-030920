### Module 1 Final Project

# [TERRESTRIAL EVALUATION EXERCISE: NEW MISSION OPERATIONS MANAGER][*]

### Installation

* After cloning or downloading the project folder, make sure to open a terminal inside the main folder and run `bundle install` to grab the required gems.
* Once `bundle install` is complete, run `rake db:migrate` to create your database.
  * You may also run `rake db:seed` to populate the database with some values; this step is not necessary, however.

### Usage
* From a terminal inside the main folder, run `ruby bin/run.rb`
* After the starting splash, you will be prompted to enter a TEENMOM username.
  * Usernames can be any combination of characters, and each username in the database is guaranteed to be unique.
  * Any missions a TEENMOM creates will be tied to that username, however the currently logged on TEENMOM has access to all missions.
  * For compliance, TEENMOMs cannot be deleted.
* A menu will prompt the user for a variety of actions.
  * Navigation takes place by item numbers alone, signified by `#)`. If an input is not valid, the user will be continually reprompted.
  * Quit is not case sensitive.
* Missions require a name, rocket, astronaut, and manager.
  * The user will create the mission name, and select a rocket and crew from those available.
  * The user can automatically generate missions if they desire.
  * TEENMOMs will update the mission status based on its success or failure.
  * In the event of adverse conditions, missions can be aborted.
  * Once a mission status is updated, the crew and rockets return to the queue for future missions.
* Rockets and crew already in space cannot be selected for new missions until they return to Earth.
* In the event of a crew or rocket shortage, the user can create new ones on the fly.
* If your budget gets cut or you really want to see if that rocket can do a flip, astronauts can be fired, and rockets can be 'stress tested'.
* Don't forget to check out the leaderboard for some good stats!


### Sources
[Public APIs](https://github.com/public-apis/public-apis#index)

[SpaceX API](https://docs.spacexdata.com/?version=latest#intro)

[artii](https://rubygems.org/gems/artii)

[faker](https://rubygems.org/gems/faker)

[colorize](https://rubygems.org/gems/colorize)

[awesome_print](https://rubygems.org/gems/awesome_print)

ENJOY!

[*]: TEENMOM is a reference to the podcast [Mission To Zyxx](https://missiontozyxx.space) and the beloved Temporary Emergency Emissarial New Missions Operation Manager Nermut Bundaloy.
