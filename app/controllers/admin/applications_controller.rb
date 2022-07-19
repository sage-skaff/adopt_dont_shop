class Admin::ApplicationsController < ApplicationController 
    def show 
        @application = Application.find(params[:id])
        if params[:approved_pet] != nil 
            @application.update_ap_status_approved(params[:approved_pet])
        end
        @apps_and_pets = @application.join_pet_with_app_pets

        @application.evaluate_app_status 
    end
end