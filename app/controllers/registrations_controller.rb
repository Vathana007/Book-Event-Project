class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role = "customer"
    if @user.save
      start_new_session_for(@user)
      redirect_to customer_bookings_path, notice: "Account created! You are now signed in."
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password, :password_confirmation, :phone_number)
  end
end