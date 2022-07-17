class Admin::ApplicationsController < ApplicationController 
    def show 
        @application = Application.find(params[:id])
        if params[:approved_pet] != nil 
            @approved_pets_id = @application.update_ap_status_approved(params[:approved_pet])
        end
    end
end