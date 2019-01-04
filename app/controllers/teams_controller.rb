class TeamsController < ApplicationController
  before_action :load_teams, only: :index

  def index; end

  private

  def load_teams
    @teams = Team.newest.search_by_country(params[:search])
                 .paginate page: params[:page], per_page: Settings.teams.page
  end
end
