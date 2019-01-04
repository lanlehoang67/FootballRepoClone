class Team < ApplicationRecord
  belongs_to :league, optional: true
  belongs_to :stadium

  has_many :rankings, dependent: :destroy
  has_many :team1_matches, class_name: Match.name,
    foreign_key: :team_id1, dependent: :destroy
  has_many :team2_matches, class_name: Match.name,
    foreign_key: :team_id2, dependent: :destroy

  delegate :name, to: :stadium, prefix: true
  scope :newest, ->{order created_at: :desc}
  scope :search_by_country, ->(nation){where "nation like?", "%#{nation}%"}
end
