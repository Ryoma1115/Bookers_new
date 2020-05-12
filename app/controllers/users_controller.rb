class UsersController < ApplicationController
	before_action :authenticate_user!

  def index
  	@users = User.all.order(id: "DESC")

  	@user = User.find(current_user.id)
  	@book = Book.new
  end

  def show
  	@user = User.find(params[:id])
  	@book = Book.new
  	@books = @user.books.order(id: "DESC")
  end

  def edit
  	@user = User.find(params[:id])
  	if current_user.id != @user.id
  	  redirect_to user_path(current_user)
  end
end

def update
	user = User.find(current_user.id)
	if user.update(user_params)
      redirect_to user_path(current_user.id)
      flash[:notice] = "You have updated user successfully."
	else
	  @user = user
      render :edit
	end
end

private
  #更新する項目　:name :profile_image :introduction
  def user_params
    params.require(:user).permit(:name,:profile_image,:introduction)
  end

end