class Match < ApplicationRecord
  scope :newest, ->{order match_date: :asc}

  enum status: {not_occur: 0, live: 1, finished: 2}
  belongs_to :team1, class_name: Team.name, foreign_key: :team_id1
  belongs_to :team2, class_name: Team.name, foreign_key: :team_id2

  has_one :match_result, dependent: :destroy
  has_many :score_bets, foreign_key: :match_id, dependent: :destroy
  delegate :name, to: :team1, prefix: true
  delegate :name, to: :team2, prefix: true
  delegate :score1, to: :match_result, prefix: true
  delegate :score2, to: :match_result, prefix: true

  validates :team_id1, presence: true
  validates :team_id2, presence: true
  validates :extra_time1, numericality: true
  validates :extra_time2, numericality: true
  validates :time, numericality: true
  validates :round_id, numericality: true

  delegate :name, to: :team1, prefix: true
  delegate :name, to: :team2, prefix: true

  def check_match_finish
    return if score_bets.nil? || match_date >= Time.now
    score_bets.each do |score_bet|
      next unless score_bet.user
      check_status score_bet
    end
  end

  def check_status score_bet
    return unless score_bet&.pending?
    check_outcome score_bet
  end

  def check_outcome score_bet
    if score_bet.outcome == check_result
      score_bet.win
      change_score_bet_status score_bet
      UserMailer.send_success_bet(score_bet.user).deliver_now
    else
      change_score_bet_status score_bet
      UserMailer.send_fail_bet(score_bet.user).deliver_now
    end
  end

  def change_score_bet_status score_bet
    score_bet.status = ScoreBet.statuses[:completed]
    score_bet.save
  end

  def check_result
    if match_result_score1 < match_result_score2
      ScoreBet.outcomes.key(2)
    elsif match_result_score1 > match_result_score2
      ScoreBet.outcomes.key(0)
    else
      ScoreBet.outcomes.key(1)
    end
  end
end
