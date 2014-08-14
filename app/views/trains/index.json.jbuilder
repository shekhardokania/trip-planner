json.array!(@trains) do |train|
  json.extract! train, :id, :name, :number, :start_time, :end_time, :start_station_id, :end_station_id
  json.url train_url(train, format: :json)
end
