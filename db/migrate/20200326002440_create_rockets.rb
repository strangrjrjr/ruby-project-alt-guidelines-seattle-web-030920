class CreateRockets < ActiveRecord::Migration[5.2]
  def change
    create_table :rockets do |t|
      t.string :name
      t.integer :capacity
    end
  end
end
