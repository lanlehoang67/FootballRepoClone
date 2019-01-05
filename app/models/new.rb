class New < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  delegate :name, to: :user, prefix: true
  scope :newest, ->{order created_at: :asc}
end
