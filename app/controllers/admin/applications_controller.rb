class Admin::ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @application.update_ap_status_approved(params[:approved_pet]) unless params[:approved_pet].nil?
    @apps_and_pets = @application.join_pet_with_app_pets

    @application.evaluate_app_status
    @rejected_pets_id = @application.update_ap_status_rejected(params[:rejected_pet]) unless params[:rejected_pet].nil?
  end
end

