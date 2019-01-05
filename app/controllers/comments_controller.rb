class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_attribute_for_comment, :check_comment, only: :create
  before_action :load_comment, except: :create
  before_action :check_update, only: :update
  before_action :check_deleted, only: :destroy

  def create; end

  def update; end

  def edit; end

  def destroy; end

  private

  def check_deleted
    if @comment.destroy
      flash[:success] = t "comments.controller.deleted_success"
      respond_to do |format|
        format.html{redirect_to news_path(id: params[:news_id])}
        format.js
      end
    else
      flash[:error] = t "comments.controller.deleted_fail"
      redirect_to news_path(id: params[:news_id])
    end
  end

  def load_comment
    @comment = Comment.find_by id: params[:id]
  end

  def set_attribute_for_comment
    @new = New.find_by id: params[:news_id]
    @comment = Comment.new comment_params
    @comment.user_id = current_user.id
    @comment.new_id = @new.id
  end

  def check_comment
    if @comment.save
      respond_to do |format|
        format.html{redirect_to news_path(id: @comment.new.id)}
        format.js
      end
    else
      flash[:error] = t "comments.controller.error"
      redirect_to news_path(id: @comment.new.id)
    end
  end

  def check_update
    if @comment.update_attributes comment_params
      flash[:success] = t "comments.controller.updated"
    else
      flash[:error] = t "comments.controller.error_edit"
    end
    redirect_to news_path(id: params[:news_id])
  end

  def comment_params
    params.require(:comment).permit(:user_id, :new_id, :message)
  end
end
