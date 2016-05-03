class Admin::TaskMastersController < ApplicationController
  load_resource :subject

  def index
    @task_masters = @subject.task_masters

    add_breadcrumb "All Subjects", :admin_subjects_path
    add_breadcrumb @subject.name, :admin_subject_task_masters_path
  end
end
