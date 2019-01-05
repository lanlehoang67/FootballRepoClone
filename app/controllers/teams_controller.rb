class TeamsController < ApplicationController
  before_action :load_teams, only: :index

  def index; end

  private

  def load_teams
    @search_teams = Team.newest.looking_for(params[:search])
    @teams = @search_teams.paginate page: params[:page],
                                    per_page: Settings.teams.page
  end
end
