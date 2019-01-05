class ScoreBetsController < ApplicationController
  before_action :check_valid_bet, only: :create
  before_action :load_score_bet, only: [:edit, :update, :destroy]
  before_action :check_update, only: :update
  before_action :check_deleted, only: :destroy
  def new
    @score_bet = ScoreBet.new
  end

  def create; end

  def edit; end

  def update; end

  def destroy
    respond_to do |f|
      f.html{redirect_to user_path(current_user)}
      f.js
    end
  end

  private

  def score_params
    params.require(:score_bet).permit :price, :outcome
  end

  def load_score_bet
    @score_bet = ScoreBet.find_by id: params[:match_id]
    return if @score_bet
    flash[:error] = t "score_bet.controller.cannot_find_record"
    redirect_to user_path(current_user)
  end

  def check_deleted
    return if @score_bet.match.status = Match.statuses[:finished]
    if @score_bet.destroy
      flash[:alert] = t "score_bet.controller.delete_success"
    else
      flash[:error] = t "score_bet.controller.delete_fail"
    end
  end

  def check_update
    if @score_bet.update_attributes score_params
      flash[:alert] = t "score_bet.controller.success_updated"
      redirect_to user_path(current_user)
    else
      render :edit
      flash[:error] = t "score_bet.controller.fail_updated"
    end
  end

  def create_score_bet
    if create_bet
      redirect_to match_path(@match)
      flash[:alert] = t "score_bet.controller.success_bet"
    else
      render :new
      flash[:error] = t "score_bet.controller.fail_bet"
    end
  end

  def create_bet
    bet = @match.score_bets.create user_id: current_user.id,
      price: params[:score_bet][:price], status: :pending,
        outcome: params[:score_bet][:outcome]
    create_notify current_user.name, bet
    current_user.reduce_money params[:score_bet][:price]
  end

  def check_date
    if @match.match_date >= Time.now && @match.not_occur?
      create_score_bet
    else
      flash[:error] = t "score_bet.controller.late_bet"
      redirect_to match_path(@match)
    end
  end

  def check_valid_bet
    if logged_in?
      @match = Match.find_by id: params[:match_id]
      if params[:score_bet][:price].to_f <= current_user.money.to_f
        check_date
      else
        flash[:error] = t "score_bet.controller.not_enough_money"
      end
    else
      redirect_to login_path
    end
  end

  def create_notify name, bet
    message = t("score_bet.controller.has_bet", name: name,
      team: bet.match.team1_name, outcome: bet.outcome)
    bet.notifications.create! user_id: current_user.id, message: message
  end
end
