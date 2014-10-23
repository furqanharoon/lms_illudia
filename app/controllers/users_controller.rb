class UsersController < ApplicationController
  def index
  end

  def show
  end

  def new
    render 'new' and return
  end

  def create
    @user = User.new(user_params)
    if @user.save
     redirect_to :controller => 'sessions' ,:action => 'index' and return
    else
      render 'new' and return
    end
  end

  def edit
  end

  def update
  end

  def delete
  end

  def destroy
  end
  private
    def user_params
      params.require(:user).permit(:username , :admin , :login , :password , :email)
    end
end