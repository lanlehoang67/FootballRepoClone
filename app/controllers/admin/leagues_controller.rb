class Admin::LeaguesController < Admin::BaseController
  before_action :load_league, except: [:index, :new, :create]
  before_action :check_created, only: :create
  skip_before_action :verify_authenticity_token, only: [:destroy, :create]

  def index
    @leagues = League.newest.includes(:rankings, :teams).paginate page:
      params[:page], per_page: Settings.rankings.page
  end

  def edit
  end

  def new
    @league = League.new
  end

  def create
  end

  def update
    if @league.update_attributes league_params
      flash[:success] = "updated successfully"
      redirect_to admin_leagues_path
    else
      flash[:error] = "cannot update"
      render :edit
    end
  end

  def destroy
    if @league.destroy
      flash[:success] = "League deleted"
    else
      flash[:warning] = "cannot delete league"
    end
    redirect_to admin_leagues_path
  end

  private

  def check_created
    @league = League.new league_params
    if @league.save
      flash[:success] = "created successfully"
      redirect_to admin_leagues_path
    else
      flash[:error] = "cannot create"
      render :new
    end
  end

  def load_league
    @league = League.find_by id: params[:id]
    return if @league
    flash[:danger] = t "rankings.controller.not_found"
    redirect_to leagues_path
  end

  def league_params
    params.require(:league).permit(:name, :country, :start_date, :end_date, :continent, :number_of_match, :number_of_team)
  end
end
