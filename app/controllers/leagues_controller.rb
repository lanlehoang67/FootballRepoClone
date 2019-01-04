class LeaguesController < ApplicationController
  before_action :load_league, :load_rankings_by_league, only: :show

  def index
    @leagues = League.newest.includes(:rankings, :teams).paginate page:
      params[:page], per_page: Settings.rankings.page
  end

  def show; end

  private

  def load_league
    @league = League.find_by id: params[:league_id]
    return if @league
    flash[:danger] = t "rankings.controller.not_found"
    redirect_to leagues_path
  end

  def load_rankings_by_league
    @rankings = @league.rankings.newest
  end
end
