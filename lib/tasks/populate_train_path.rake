namespace :populate_train_path do
  desc "Arnav: Usage -> rake RAILS_ENV=development onetime:one VERSION=populate_roles"
  task :do => :environment do
    Train.includes(:train_stations).find_each do |train|
      train_stations = train.train_stations.order(:station_number)
      train_stations.each_with_index do |train_station,index|
        if train_stations[index + 1]
          train_stations[(index + 1)..-1].each do |next_station|
            tp = TrainPath.create(:from_station => train_station.station,:to_station => next_station.station,:train => train,:running_days => train_station.running_days,
                                :duration => ((next_station.arrival_time - train_station.departure_time)/3600).round(2))
          end
        end
      end
    end
  end

end
