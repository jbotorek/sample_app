class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user, 	 only: [:edit, :update]
  before_filter :admin_user,	 only: :destroy
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
	@microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def index
	@users = User.paginate(page: params[:page], per_page: 3)
  end
  
  def edit
  end
  
  
  def update
    @user = User.find(params[:id])
	if @user.update_attributes(params[:user])
		flash[:success] = "PROFILE OF USER: #{@user.name} WAS UPDATED"
		sign_in @user
		redirect_to @user
	else
		render 'edit'
	end
  end
  
  def destroy
	user = User.find(params[:id])
	user.destroy
	flash[:success] = "User #{user.name} was deleted"
	redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  
  private 
  
  
  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
	  redirect_to(root_path)
	  flash[:notice] = "You can not alter profile of #{@user.name} "
    end
  end
	
  def admin_user
	redirect_to(root_path) unless current_user.admin?
  end
end
