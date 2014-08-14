class CreateTrainStations < ActiveRecord::Migration
  def change
    create_table :train_stations do |t|
      t.integer :station_id
      t.integer :train_id
      t.datetime :arrival_time
      t.datetime :departure_time
      t.integer :station_number
      t.string :running_days,:length => 7
      t.timestamps
    end
  end
end
