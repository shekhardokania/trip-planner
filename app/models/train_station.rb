class TrainStation < ActiveRecord::Base
  belongs_to :train
  belongs_to :station
  validates_presence_of :station_id,:train_id,:arrival_time,:departure_time,:running_days,:station_number
  DAYS =  {sunday: 0, monday: 1, tuesday: 2, wednesday: 3,thursday: 4,friday: 5,saturday: 6}.invert.freeze

  def self.get_running_days_from_code(code)
    running_days_hash  = {}
    code.split('').each_with_index do |day_flag,index|
      running_days_hash[DAYS[index]] = true if day_flag == '1'
    end
    running_days_hash
  end

  def self.get_running_days_for_ui(code)
    hash = get_running_days_from_code(code)
    hash.keys.map{|m| m[0..2]}.join(',').upcase
  end




end
