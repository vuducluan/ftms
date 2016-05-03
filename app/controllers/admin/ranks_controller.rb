class Admin::RanksController < ApplicationController
  load_and_authorize_resource

  def index
    @rank = Rank.new

    add_breadcrumb "Ranks"
  end

  def new
    add_breadcrumb "Ranks", :admin_ranks_path
    add_breadcrumb "New"
  end

  def edit
    add_breadcrumb "Ranks", :admin_ranks_path
    add_breadcrumb "Edit"
  end

  def create
    if @rank.save
      flash[:success] = flash_message "created"
      redirect_to admin_ranks_path
    else
      flash[:failed] = flash_message "not_created"
      render :new
    end
  end

  def update
    if @rank.update_attributes rank_params
      flash[:success] = flash_message "updated"
      redirect_to admin_ranks_path
    else
      flash_message[:failed] = flash_message "not_updated"
      render :edit
    end
  end

  def destroy
    if @rank.destroy
      flash[:success] = flash_message "deleted"
    else
      flash[:failed] = flash_message "not_deleted"
    end
    redirect_to :back
  end

  private
  def rank_params
    params.require(:rank).permit Rank::ATTRIBUTES_PARAMS
  end
end
