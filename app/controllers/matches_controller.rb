class MatchesController < ApplicationController
  include MatchesHelper
  before_action :load_match, :build_score_bet, only: :show
  before_action only: :show
    @match.set_status_by_time
  end

  def index
    @matches = Match.newest.paginate page: params[:page],
      per_page: Settings.matches.page
  end

  def show; end

  private

  def load_match
    @match = Match.find_by id: params[:id]
    return if @match
    flash[:danger] = t "matches.show.not_found"
    redirect_to matches_path
  end

  def build_score_bet
    @score_bet = @match.score_bets.build
  end
end
