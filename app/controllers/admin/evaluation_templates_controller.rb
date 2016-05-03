class Admin::EvaluationTemplatesController < ApplicationController
  load_and_authorize_resource

  def index
    @evaluation_template = EvaluationTemplate.new

    add_breadcrumb "Evaluation Templates"
  end

  def new
    add_breadcrumb "Evaluation Templates", :admin_evaluation_templates_path
    add_breadcrumb "New"
  end

  def edit
    add_breadcrumb "Evaluation Templates", :admin_evaluation_templates_path
    add_breadcrumb "Edit"
  end

  def create
    if @evaluation_template.save
      flash[:success] = flash_message "created"
      redirect_to admin_evaluation_templates_path
    else
      flash[:failed] = flash_message "not_created"
      render :new
    end
  end

  def update
    if @evaluation_template.update_attributes evaluation_template_params
      flash[:success] = flash_message "updated"
      redirect_to admin_evaluation_templates_path
    else
      flash_message[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    if @evaluation_template.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:failed] = flash_message "not_deleted"
    end
    redirect_to :back
  end

  private
  def evaluation_template_params
    params.require(:evaluation_template).permit EvaluationTemplate::ATTRIBUTES_PARAMS
  end
end
