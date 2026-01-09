class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # before_action :require_admin

  # GET /users
  def index
    if params[:q].present?
      query = params[:q]
      @users = User.where("CAST(id AS TEXT) ILIKE ? OR name ILIKE ?", "%#{query}%", "%#{query}%")
    else
      @users = User.all
    end
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.role = "customer"
    if @user.save 
      session[:user_id] = @user.id
      redirect_to users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /users/:id
  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email_address, :role, :phone_number, :password, :password_confirmation, :credit)
  end
end