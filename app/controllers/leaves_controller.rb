class LeavesController < ApplicationController
  before_filter :check_admin, :only => [:edit , :update]
  def check_admin
    if session[:user_id]
      user = User.check_user(session[:user_id])
      if !user
        redirect_to :controller => 'sessions', :action => 'new' and return
      end
    else
      redirect_to :controller => 'sessions', :action => 'new' and return
    end
  end

  def index
  end

  def show
  end

  def new
    if session[:user_id] && !User.check_user(session[:user_id])
      quota = Quota.find_by_user_id(session[:user_id])
      if !quota.blank? && quota.exceed >=15
        flash[:warning]="You have already exceeded your annual Quota"
      end
      @leave = Leave.new
    else
      redirect_to :controller => 'sessions' , :action => 'new'
    end
  end

  def create
    #@leave = Leave.new(leave_params)
    #if @leave.save
    #  redirect_to :controller => 'sessions' , :action => 'index'
    #else
      render 'new' and return
    #end
  end

  def edit
    @leave = Leave.find(params[:id])
    #render 'edit' and return
  end

  def update
    @leave = Leave.find(params[:id])
    leave_status = params[:leave][:status]
    leave_days = params[:leave][:total_days]
    user_id = params[:leave][:user_id]
    @leave = @leave.update_attributes(leave_params)

    if leave_status == "Approved"
      quota = Quota.addQuota(leave_days,user_id)
    end
    redirect_to :controller => 'sessions' , :action => 'index'
  end
  def leave_action
    @leave = Leave.find(params[:id])
    chk = params[:verify]
    if chk == "yes"
      if @leave.update_attribute(:status, "Approved")
        Quota.addQuota(params[:tdays],params[:uid])
      end
    elsif chk == "no"
      @leave.update_attribute(:status, "Disapproved")
    else
      @leave.status="Pending"
    end
    redirect_to :controller => 'sessions' , :action => 'admin_page'
  end

  def delete
  end

  def destroy
  end
  private
  def leave_params
    params.require(:leave).permit(:user_id, :start_date, :end_date, :description, :status, :total_days)
  end
end