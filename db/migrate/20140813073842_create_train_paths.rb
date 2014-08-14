class CreateTrainPaths < ActiveRecord::Migration
  def change
    create_table :train_paths do |t|
      t.integer :to_station_id
      t.integer :from_station_id
      t.integer :train_id
      t.string :running_days,:length => 7
      t.decimal :duration,:precision => 4, :scale => 2
      t.timestamps
    end
  end
end
