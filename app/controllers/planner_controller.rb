class PlannerController < ApplicationController
  layout 'application'
  def index
   @stations = Station.all
  end
  #journey_date,start_station,end_station,journey_type,return_date,via_station,journey_date2
  def list_train
    if  params[:journey_date] || params[:start_station] || params[:end_station] || params[:journey_type]
      redirect_to :planner_index_path
    end
    tp = Trip::Planner.new(params)
    redirect_to :planner_index_path unless tp.valid_params?
    case params[:journey_type]
      when "one_way"
        @trip_options = tp.one_way(params)
      when "round_trip"
        tp.round_trip(params)
      when "multi_part"
        tp.multi_part(params)
    end

  end
end
