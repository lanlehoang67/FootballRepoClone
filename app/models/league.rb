class League < ApplicationRecord
  has_many :rounds, dependent: :destroy
  has_many :rankings, dependent: :destroy
  has_many :teams, dependent: :destroy

  scope :newest, ->{order created_at: :desc}
  scope :search_by_country, ->(country){where "country like ?", "%#{country}%"}
end
