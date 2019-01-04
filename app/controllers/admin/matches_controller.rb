class Admin::MatchesController < Admin::BaseController
  skip_before_action :verify_authenticity_token, only: :destroy
  before_action :load_match, except: [:index, :new, :create]

  def index
    @matches = Match.paginate page: params[:page],
      per_page: Settings.matches.page
  end

  def new
    @match = Match.new
  end

  def edit; end

  def update
    if @match.update_attributes match_params
      flash[:success] = t "matches.matches_controller.match_updated"
      redirect_to admin_matches_path
    else
      render :edit
    end
  end

  def create
    @match = Match.new match_params
    if @match.save
      flash[:info] = t "matches.create.success"
      redirect_to admin_matches_path
    else
      flash[:danger] = t "matches.create.error"
      render :new
    end
  end

  def destroy
    if @match.destroy
      flash[:success] = t "matches.matches_controller.match_deleted"
      redirect_to admin_matches_path
    else
      flash[:warning] = t "matches.matches_controller.failed"
    end
  end

  private

  def load_match
    @match = Match.find_by id: params[:id]
    return if @match
    flash[:warning] = t "matches.matches_controller.not_found"
    redirect_to admin_match_path
  end

  def match_params
    params.require(:match).permit :match_date, :extra_time1,
      :extra_time2, :time, :team_id1, :team_id2, :round_id, :status
  end
end
