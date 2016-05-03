class Admin::AllocatePermissionsController < ApplicationController
  load_and_authorize_resource :role

  def edit
    $model_classes.each do |model_class|
      Settings.roles.actions.each do |action|
        unless @role.permissions.find_by action: action, model_class: model_class
          @role.permissions.new model_class: model_class, action: action
        end
      end
    end

    add_breadcrumb "Roles", :admin_roles_path
    add_breadcrumb @role.name
    add_breadcrumb "Edit"
  end

  def update
    if @role.update_attributes role_params
      flash[:success] = flash_message "updated"
    else
      flash[:danger] = flash_message "not updated"
    end
    redirect_to :back
  end

  private
  def role_params
    params.require(:role).permit Role::ATTRIBUTES_PARAMS
  end
end
