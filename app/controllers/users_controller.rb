class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:index, :new, :create]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save 
      redirect_to products_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    @total_messages = []
    @user.products.each do |product|
      product.messages.each do |message|
        @total_messages << message
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to products_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
