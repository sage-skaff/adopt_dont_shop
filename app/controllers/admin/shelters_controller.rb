class Admin::SheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_name
    @pending_shelters = Shelter.apps_pending
  end

  def show
    # @shelter = Shelter.find(params[:id])
    @shelter = Shelter.sql_find_by_id(params[:id])
    @pets = @shelter.pets 
  end
end

