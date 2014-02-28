class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy] 
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page:params[:page])
  end

  def new
   if signed_in?
      flash[:error] = "You already have an account logged in."
      redirect_to(root_url)
   else 
    @user = User.new
  end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy   
    if !User.find(params[:id]).admin
    flash[:success] = "User destroyed."
    User.find(params[:id]).destroy
    redirect_to users_url
  else
    flash[:error] = "Cannot destory admin user."
    redirect_to users_url
  end
  
end


  def create
    @user = User.new(user_params)
    if @user.save
       sign_in @user
       flash[:success] =  "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end


def edit
    #@user = User.find(params[:id])  #to be removed
  end

def update
    #@user = User.find(params[:id])   #to be removed
    #if @user.update_attributes(params[:user])    #this doesn't work
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end


    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end


end
