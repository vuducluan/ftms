class Admin::SubjectsController < ApplicationController
  load_and_authorize_resource

  def index
    @subject = Subject.new
    @search = Subject.recent.search(params[:q])
    @subjects = @search.result

    add_breadcrumb "All Subjects"
  end

  def show
    @course = Course.includes(course_subjects:
      [:tasks, user_subjects: [:user, user_tasks:
      [:user, :task]]]).find params[:course_id]
    @course_subject = @course.course_subjects.find do |course_subject|
      course_subject.subject_id == @subject.id
    end
    @user_subjects = @course_subject.user_subjects
    @unassign_tasks = @course_subject.tasks.not_assigned_trainee
    @user_subjects_not_finishs = @user_subjects.not_finish @user_subjects.finish
  end

  def new
    @subject.documents.build
    @subject.task_masters.build.documents.build

    add_breadcrumb "All Subjects", :admin_subjects_path
    add_breadcrumb "New Subject", :new_admin_subject_path
  end

  def create
    @subject = Subject.new subject_params
    if @subject.save
      flash[:success] = flash_message "created"
      redirect_to admin_subjects_path
    else
      flash[:failed] = flash_message "not_created"
      render :new
    end
  end

  def edit
    add_breadcrumb "All Subjects", :admin_subjects_path
    add_breadcrumb @subject.name, :admin_subject_path
    add_breadcrumb "Edit"
  end

  def update
    if @subject.update_attributes subject_params
      flash[:success] = flash_message "updated"
      redirect_to admin_subjects_path
    else
      flash[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    if @subject.destroy
      flash[:success] = flash_message "deleted"
    else
      flash.now[:failed] = flash_message "not_deleted"
    end
    respond_to do |format|
      format.html {redirect_to admin_subjects_path}
    end
  end

  private
  def subject_params
    params.require(:subject).permit Subject::SUBJECT_ATTRIBUTES_PARAMS
  end
end
