class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!, :set_locale

  add_breadcrumb "Home", :root_path

  include ApplicationHelper
  include PublicActivity::StoreController

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to main_app.root_path
  end

  def default_url_options options = {}
    {locale: I18n.locale}
  end

  protected
  def current_ability
    @current_ability ||= Ability.new current_user
  end

  def after_sign_in_path_for resource
    current_user.decorate.allow_access_admin ? root_path : courses_path
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    User.human_attribute_name "name"
    User.human_attribute_name "email"
    User.human_attribute_name "password"
    User.human_attribute_name "password_confirmation"
    User.human_attribute_name "role"
    User.human_attribute_name "courses"
    User.human_attribute_name "course_leaders"
    Course.human_attribute_name "name"
    Course.human_attribute_name "start_date"
    Course.human_attribute_name "end_date"
    Course.human_attribute_name "status"
    Course.human_attribute_name "leaders"
    Subject.human_attribute_name "name"
    Subject.human_attribute_name "description"
    Subject.human_attribute_name "courses"
    Subject.human_attribute_name "task_masters"
  end
end
