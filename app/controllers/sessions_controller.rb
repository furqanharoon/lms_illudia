require 'will_paginate/array'
class SessionsController < ApplicationController
before_filter :authenticate_rights, :only => [:getQuota , :show , :month_record , :admin_page , :index , :edit , :update ,:delete ,:destroy]
before_filter :check_admin, :only => [:admin_page , :user_record]
  
  def authenticate_rights
    if !session[:user_id]
      redirect_to :action => 'new'
    end
  end

  def check_admin
    if session[:user_id]
      user = User.check_user(session[:user_id])
      if !user
        redirect_to :action => 'new' and return
      end
    else
      redirect_to :action => 'new' and return
    end
  end
  
  def getQuota
    @quota = Quota.all
  end

  def user_record
    @users = User.where("id!=#{session[:user_id]}&& admin = 'false'")
    @month = params[:month]
    @uname = params[:param_user]
    if !@month.blank? && !@uname.blank?
      @month_start , @month_end , @mname = Leave.getDate(@month)
      @by_month , @by_year ,@lm =Leave.dateDiff(@month_start,@month_end,@uname)
    else
      if !params[:commit].nil?
        flash[:notice]="Select both fields!!"
      end
    end
  end

  def month_record
    @month = params[:month]
    if @month.blank?
      @tm = Time.now.strftime("/%m/%d")
      @tm = @tm.to_s
      @month_start , @month_end , @mname = Leave.getDate(@tm)
    else
      @month_start , @month_end , @mname = Leave.getDate(@month)
    end
    current_id = session[:user_id]
    @by_month , @by_year ,@lm =Leave.dateDiff(@month_start,@month_end,current_id)
  end

  def admin_page
    @users = User.where("id!=#{session[:user_id]}&& admin = 'false'")
    @leaves = Leave.where("status!='Pending'").select(:status).uniq
    st = params[:param_status]
    us = params[:param_user]
    if !st.blank?
      @pend = 0
      @leave = Leave.where("status = ?", params[:param_status]).all.order('id DESC').paginate(page: params[:page], per_page: 5)
    elsif !us.blank?
      @pend = 0
      @leave = Leave.where("user_id=?",params[:param_user]).all.order('id DESC').paginate(page: params[:page], per_page: 5)
    else
      @leave = Leave.where("status='Pending'").all.order('id DESC').paginate(page: params[:page], per_page: 5)
      @pend = 1
    end 
  end

  def index
    if session[:user_id]
      @leaves = Leave.where("status!='Pending'").select(:status).uniq
      id = session[:user_id]
      user = User.check_user(session[:user_id])
      if user
        redirect_to :controller => 'sessions', :action => 'admin_page' and return
      else
        @params_status = params[:param_status]
        if !@params_status.blank?
          @leave = Leave.where("user_id=? AND status = ?",id,@params_status).all
          render 'index' and return
        end
        @leave = Leave.where("user_id=?",id).all
      end
    else
      render 'new' and return
    end
  end

  def show
  end

  def new
    if session[:user_id]
      redirect_to :action => 'index' and return
    else
      render 'new' and return
    end
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to :controller => 'sessions', :action => 'index'#, :id => session[:user_id]
    else
      redirect_to :action => 'new' , :alert => "Access denied."
      
    end
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
    session[:user_id] = nil
    redirect_to :action => 'new'
  end
end