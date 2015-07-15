class Admin::UsersController < AdminController
  before_action :find_from_params_id, only: [:show, :destroy]

  def index
    @users = User.all
  end

  def show
  end

  def destroy
    @user.errors[:base] << :is_current_user if @user == current_user
    if @user.errors.empty? && @user.destroy
      flash[:notice] = t(:'controllers.users.destroy.flash.success')
    else
      flash[:error] = t(:'controllers.users.destroy.flash.error')
    end
    redirect_to action: :index
  end

  private

  def find_from_params_id
    @user = User.find params[:id]
  end
end
