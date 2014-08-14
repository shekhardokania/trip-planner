class Train < ActiveRecord::Base
  has_many :train_stations
  has_many :stations, through: :train_stations
  belongs_to :start_station, class_name: :Station,foreign_key: :start_station_id
  belongs_to :end_station, class_name: :Station,foreign_key: :end_station_id
  validates_presence_of :name,:number,:start_station_id,:end_station_id
end
