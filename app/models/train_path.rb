class TrainPath < ActiveRecord::Base
  belongs_to :to_station, class_name: :Station
  belongs_to :from_station, class_name: :Station
  belongs_to :train

  # get direct trains between stations on given date.
  # Expects:
  # * <tt>start_station</tt>: Source station id for trip
  # * <tt>end_station</tt>: Destination station id for trip
  # * <tt>journey_date</tt>: date of the journey

  def self.get_direct_trains_between_stations(params)
    all_path = where(:from_station => params[:start_station],:to_station => params[:end_station]).includes(:to_station,:from_station,:train).all
    return all_path if params[:journey_date].blank?
    all_path.select do |train_path|
      TrainStation.get_running_days_from_code(train_path.running_days)[params[:journey_date].strftime("%A").downcase.to_sym]
    end
  end

  # get connected trains between stations on given date.
  #
  # * <tt>start_station</tt>: Source station id for trip
  # * <tt>end_station</tt>: Destination station id for trip
  # * <tt>journey_date</tt>: date of the journey

  def self.get_via_trains_between_stations(params)
    start_station_trains_path = []
    where(:from_station => params[:start_station]).includes(:to_station,:from_station,:train).each do |train_path|
      if TrainStation.get_running_days_from_code(train_path.running_days)[params[:journey_date].strftime("%A").downcase.to_sym]
        start_station_trains_path << train_path
      end
    end
    return [] unless start_station_trains_path.present?

    end_station_trains_path = where(:to_station => params[:end_station]).includes(:to_station,:from_station,:train).all
    return [] unless end_station_trains_path.present?

    to_stations_for_from_station = start_station_trains_path.collect(&:to_station_id)
    from_stations_for_to_station = end_station_trains_path.collect(&:from_station_id)
    via_stations = to_stations_for_from_station & from_stations_for_to_station
    return [] if via_stations.empty?

    all_pos_trains = {}
    via_stations.uniq.each do |vs|
     all_pos_trains[vs] ||= {:to => [],:from => []}
     all_pos_trains[vs][:to] += get_direct_trains_between_stations(:start_station => params[:start_station],:end_station => vs,:journey_date => params[:journey_date])
     all_pos_trains[vs][:from] += get_direct_trains_between_stations(:start_station => vs,:end_station => params[:end_station])
  end
    all_pos_trains
  end

  # get trains between stations on given date.
  #
  # * <tt>start_station</tt>: Source station id for trip
  # * <tt>end_station</tt>: Destination station id for trip
  # * <tt>journey_date</tt>: date of the journey

  def self.get_trains_between_stations(params)
    direct_trains = get_direct_trains_between_stations(params)
    return {:direct => direct_trains} if direct_trains.present?
    via_trains = get_via_trains_between_stations(params)
    return via_trains  if via_trains.present?
    []
  end

end
