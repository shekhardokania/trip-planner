module Trip
  class Planner
    def initialize(params)
      @start_station = params[:start_station]
      @end_station = params[:end_station]
      @journey_date = Date.parse(params[:journey_date] )
      @journey_type = params[:journey_type]
      @journey_date2 = Date.parse(params[:journey_date2] ) rescue nil
      @via_station = params[:via_station]
    end

    def valid_params?
      return false if (@journey_date.blank? || @start_station.blank? || @end_station.blank? || @journey_type.blank?)
      return false if (@start_station == @end_station)
      return true
    end

    def plan
      tp = nil
      case @journey_type
        when "one_way"
          tp = OneWayPlanner.new(:start_station => @start_station,:end_station => @end_station,:journey_date => @journey_date.to_s,:journey_type => @journey_type)
        when "round_trip"
          tp = RoundTripPlanner.new(:start_station => @start_station,:end_station => @end_station,:journey_date => @journey_date.to_s,:journey_date2 => @journey_date2.to_s,:journey_type => @journey_type)
        when "multi_part"
          tp = MultiPartPlanner.new(:start_station => @start_station,:end_station => @end_station,:journey_date => @journey_date.to_s,:journey_date2 => @journey_date2.to_s,:via_station => @via_station,:journey_type => @journey_type)
      end
      raise "Invalid params" unless tp.valid_params?
      tp.plan
    end

  end

  class OneWayPlanner < Planner

    def initialize(params)
      super(params)
    end

    def valid_params?
      super
    end

    def plan
      train_paths = TrainPath.get_trains_between_stations(:start_station => @start_station, :end_station => @end_station, :journey_date => @journey_date)
      if train_paths.present?
        train_info = {}
        if direct_train_paths = train_paths[:direct]
          all_trains = []
          direct_train_paths.each do |dtp|
            dep_train_station = TrainStation.where(:train_id => dtp.train_id,:station_id => dtp.from_station_id).first
            arr_train_station = TrainStation.where(:train_id => dtp.train_id,:station_id => dtp.to_station_id).first
            all_trains << {:start_station_name => dtp.from_station.name,
                           :end_station_name => dtp.to_station.name,
                           :train_name => dtp.train.name,
                           :train_number => dtp.train.number,
                           :duration => dtp.duration,
                           :running_days => TrainStation.get_running_days_for_ui(dtp.running_days),
                           :departure_time => dep_train_station.departure_time.to_time.strftime("%H:%M"),
                           :arrival_time => arr_train_station.arrival_time.to_time.strftime("%H:%M")
            }
          end
          train_info[:direct] = all_trains
        else
          train_paths.each_pair do |via_station, paths|
            all_trains = {:to => [], :from => []}
            stn_name = Station.find(via_station).name.to_sym
            [:to, :from].each do |way|
              paths[way].each do |tp|
                dep_train_station = TrainStation.where(:train_id => tp.train_id,:station_id => tp.from_station_id).first
                arr_train_station = TrainStation.where(:train_id => tp.train_id,:station_id => tp.to_station_id).first
                all_trains[way] << {
                  :start_station_name => tp.from_station.name,
                  :end_station_name => tp.to_station.name,
                  :train_name => tp.train.name,
                  :train_number => tp.train.number,
                  :duration => tp.duration,
                  :running_days => TrainStation.get_running_days_for_ui(tp.running_days),
                  :departure_time => dep_train_station.departure_time.to_time.strftime("%H:%M"),
                  :arrival_time => arr_train_station.arrival_time.to_time.strftime("%H:%M")
                }
              end
            end
            train_info[stn_name] = all_trains
          end
        end
      end
      train_info
    end

  end

  class RoundTripPlanner < Planner
    def initialize(params)
      super(params)
    end

    def valid_params?
      super && @journey_date2.present? && (@journey_date2 > @journey_date)
    end

    def plan
      to_tp = OneWayPlanner.new(:start_station => @start_station,:end_station => @end_station,:journey_date => @journey_date.to_s,:journey_type => "one_way").plan
      fro_tp = OneWayPlanner.new(:start_station => @end_station,:end_station => @start_station,:journey_date => @journey_date2.to_s,:journey_type => "one_way").plan
      {:to => to_tp,:fro => fro_tp}
    end

  end

  class MultiPartPlanner < Planner
    def initialize(params)
      super(params)
    end

    def valid_params?
      super && @journey_date2.present? && @via_station.present? && (@journey_date2 > @journey_date)  && @start_station != @via_station && @via_station != @end_station
    end

    def plan
      to_tp = OneWayPlanner.new(:start_station => @start_station,:end_station => @via_station,:journey_date => @journey_date.to_s,:journey_type => "one_way").plan
      onward_tp = OneWayPlanner.new(:start_station => @via_station,:end_station => @end_station,:journey_date => @journey_date2.to_s,:journey_type => "one_way").plan
      {:to => to_tp,:fro => onward_tp}
    end
  end

end
