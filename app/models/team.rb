class Team < ApplicationRecord
  belongs_to :league, optional: true
  belongs_to :stadium

  has_many :rankings, dependent: :destroy
  has_many :team1_matches, class_name: Match.name,
    foreign_key: :team_id1, dependent: :destroy
  has_many :team2_matches, class_name: Match.name,
    foreign_key: :team_id2, dependent: :destroy

  delegate :name, to: :league, prefix: true
  delegate :name, to: :stadium, prefix: true
  scope :newest, ->{order created_at: :desc}
  scope :looking_for, ->(search){joins(:league).where("leagues.country like? or nation like?","%#{search.strip}%", "%#{search.strip}%")}
end
