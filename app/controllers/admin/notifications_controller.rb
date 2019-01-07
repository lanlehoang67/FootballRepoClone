class Admin::NotificationsController < Admin::BaseController
  skip_before_action :verify_authenticity_token, only: :destroy
  before_action :load_notification, only: :destroy

  def index
    @notifications = Notification.newest.paginate page:
      params[:page], per_page: Settings.notifies.page
  end

  def destroy
    if @notification.destroy
      flash[:success] = "deleted success"
      redirect_to admin_notifications_path
    else
      flash[:warning] = "deleted failed"
    end
  end

  private

  def load_notification
    @notification = Notification.find_by id: params[:id]
  end
end
