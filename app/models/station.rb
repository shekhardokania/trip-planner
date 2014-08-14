class Station < ActiveRecord::Base
  has_many :train_stations
  has_many :trains, through: :train_stations
  validates_presence_of :name,:code
end
