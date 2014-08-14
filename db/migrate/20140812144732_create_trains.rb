class CreateTrains < ActiveRecord::Migration
  def change
    create_table :trains do |t|
      t.string :name
      t.integer :number
      t.integer :start_station_id
      t.integer :end_station_id
      t.timestamps
    end
  end
end
