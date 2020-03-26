### Module 1 Final Project

# TERRESTRIAL EVALUATION EXERCISE: NEW MISSION OPERATIONS MANAGER

### Installation

* After cloning or downloading the project folder, make sure to open a terminal inside the main folder and run `bundle install` to grab the required gems.
* Once `bundle install` is complete, run `rake db:migrate` to create your database.
  * You may also run `rake db:seed` to populate the database with some values; this step is not necessary, however.

### Usage
* From a terminal inside the main folder, run `ruby bin/run.rb`
* After the starting splash, you will be prompted to enter a TEENMOM username.
  * Usernames can be any input, however they are unique. 
  * Any missions a user creates will be tied to that username, however the currently logged on TEENMOM has access to all missions.
* A menu will prompt the user for a variety of actions.
  * Navigation takes place by item numbers alone, signified by `#)`. If an input is not valid, the user will be continually reprompted.
  * Quit, is not case sensitive.
* Missions require a name, rocket, astronaut, and manager.
  * The user will create the mission name, and select a rocket and crew from those available.
  * The user can automatically generate missions if they desire.
* Rockets and crew already in space cannot be selected for new missions until they return to Earth.
* In the event of a crew or rocket shortage, the user can create new ones on the fly.

