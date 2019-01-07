class Admin::UsersController < Admin::BaseController
  skip_before_action :verify_authenticity_token
  before_action :load_user, except: [:index, :new, :create]

  def index
    @users = User.paginate page: params[:page],
      per_page: Settings.users.page
  end

  def new
    @user = User.new
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.users_controller.profile_updated"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "users.create.success"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.users_controller.user_deleted"
      redirect_to admin_users_path
    else
      flash[:warning] = t "users.users_controller.failed"
    end
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t "users.users_controller.not_found"
    redirect_to admin_user_path
  end

  def user_params
    params.require(:user).permit :name, :email, :money, :password,
      :password_confirmation
  end
end
