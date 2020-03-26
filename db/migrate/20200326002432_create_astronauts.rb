class CreateAstronauts < ActiveRecord::Migration[5.2]
  def change
    create_table :astronauts do |t|
      t.string :name
      t.string :skill
    end
  end
end