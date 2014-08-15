class PlannerController < ApplicationController

  def index
   @stations = Station.all
  end

  #journey_date,start_station,end_station,journey_type,return_date,via_station,journey_date2

  def list_trains_one_way
    begin
      tp = Trip::Planner.new(params)
      @options = tp.plan
      if @options.blank?
        redirect_to :back,:flash => { :error => "No Direct trains" }
      end
    #rescue
     # redirect_to :back,:flash => { :error => "Invalid params" }
    end
    render "list_trains_#{params[:journey_type]}"
  end

end
