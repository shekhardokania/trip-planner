class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.string :code,:length => 4
      t.timestamps
    end
  end
end
