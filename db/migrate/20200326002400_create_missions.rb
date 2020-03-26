class CreateMissions < ActiveRecord::Migration[5.2]
  def change
    create_table :missions do |t|
      t.string :name
      t.boolean :completed
      t.integer :rocket_id
      t.integer :astronaut_id
      t.integer :manager_id
    end
  end
end
