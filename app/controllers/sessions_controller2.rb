require 'will_paginate/array'
class SessionsController < ApplicationController
  before_filter :authenticate_rights, :only => [:show , :month_record , :admin_page , :index , :edit , :update ,:delete ,:destroy]
  before_filter :check_admin, :only => [:admin_page , :user_record ,:quota]
  
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
  def quota
    

  end
  
  def month_record
    @month = params[:month]
    if @month.blank?
      @tm = Time.now.strftime("/%m/%d")
      @tm = @tm.to_s
      @month_start , @month_end = Leave.getDate(@tm)
    else
      @month_start , @month_end = Leave.getDate(@month)
    end
    
    current_id = session[:user_id]
    @by_month , @by_year ,@lm =Leave.dateDiff(@month_start,@month_end,current_id)
    @mname = @month_start.strftime("%B")
  end

  def user_record
    @month = params[:month]
    @uname = params[:param_user]
    if !@month.blank? && !@uname.blank?
      puts "Not blank"
      #@month_start , @month_end = Leave.find_date(@month)
      @month_start , @month_end = Leave.getDate(@month)
      @mname = @month_start.strftime("%B")
      @by_month , @by_year ,@lm =Leave.dateDiff(@month_start,@month_end,@uname)
    else
      flash[:notice]="Select both fields!!"
    end
  end

  def name_search
    if !params[:param_user].blank?
      $uid = params[:param_user]
    end
    @leave = Leave.where("user_id=#{$uid}").all.paginate(page: params[:page], per_page: 5)
  end

  def status_search
    if !params[:param_status].blank?
      $status = params[:param_status]
    end
    @leave = Leave.where("status='#{$status}'").all.paginate(page: params[:page],per_page: 5)
  end

  def admin_page
    @chuss = Leave.where("status!='Pending'").select(:status).uniq
    @users = User.where("id!=#{session[:user_id]} && admin ='false'").all
    st = params[:param_status]
    us = params[:param_user]
    if !st.blank?
      @leave = Leave.where("status='#{st}'").all.paginate(page: params[:page], per_page: 5)
    elsif !us.blank?
      @leave = Leave.where("user_id=#{us}").all.paginate(page: params[:page], per_page: 5)
    else
      @leave = Leave.where("status='Pending'").all.paginate(page: params[:page], per_page: 5)
    end 
  end

  def index
    current_id = session[:user_id]
    id = session[:user_id]
    user = User.check_user(session[:user_id])
    if user
      @id = session[:user_id]
      redirect_to :controller => 'sessions', :action => 'admin_page' and return
    else
      @params_status = params[:param_name]
      if !@params_status.blank?
        @leave = Leave.where("user_id = #{id} AND status = '#{@params_status}'").all
        render 'index' and return
      end
      @leave = Leave.where("user_id = #{id}").all
    end
  end

  def show
  end

  def new
    render 'new' and return
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to :controller => 'sessions', :action => 'index', :id => session[:user_id]
    else
      render 'new'
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