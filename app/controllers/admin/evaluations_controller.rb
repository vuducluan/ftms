class Admin::EvaluationsController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :user

  before_action :load_template, only: [:new, :create, :edit, :update]
  before_action :load_evaluation, only: [:edit, :update]
  before_action :load_notes, only: :edit

  def index
    role_trainee = Role.trainee
    @search = User.find_by_role(role_trainee).search params[:q]
    @users = @search.result

    add_breadcrumb "Evaluations"
  end

  def new
    @evaluation_templates.each do |template|
      @evaluation.evaluation_details.build(name: template.name,
        point: template.min_point, evaluation_template_id: template.id)
    end

    add_breadcrumb @user.name, @user
    add_breadcrumb "Evaluations", :admin_evaluations_path
    add_breadcrumb "New"
  end

  def create
    if @evaluation.save
      flash[:success] = flash_message "created"
      redirect_to admin_evaluations_path
    else
      flash[:failed] = flash_message "not_created"
      redirect_to :back
    end
  end

  def update
    if @evaluation.update_attributes evaluation_params
      flash[:success] = flash_message "updated"
      redirect_to :back
    else
      flash[:success] = flash_message "not_updated"
      redirect_to :back
    end
  end

  private
  def evaluation_params
    @evaluation_parms = params.require(:evaluation).permit Evaluation::ATTRIBUTES_PARAMS
  end

  def load_template
    @evaluation_templates = EvaluationTemplate.all
  end

  def load_evaluation
    @evaluation = @user.evaluation
  end

  def load_notes
    @notes = @evaluation.notes
  end
end
