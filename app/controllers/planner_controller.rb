class PlannerController < ApplicationController

  def index
   @stations = Station.all
  end

  #journey_date,start_station,end_station,journey_type,return_date,via_station,journey_date2

  def list_trains
    begin
      tp = Trip::Planner.new(params)
      @options = tp.plan
      if @options.blank?
        redirect_to :back,:flash => { :error => "No Direct trains on selected date" } and return
      end
    rescue
      redirect_to :back,:flash => { :error => "Invalid params" } and return
    end
    render "list_trains_#{params[:journey_type]}"
  end

end
