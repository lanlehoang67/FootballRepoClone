class Comment < ApplicationRecord
  belongs_to :new
  belongs_to :user

  delegate :name, to: :user, prefix: true

  scope :newest, ->{order created_at: :desc}
end
