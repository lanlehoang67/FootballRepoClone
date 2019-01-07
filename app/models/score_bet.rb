class ScoreBet < ApplicationRecord
  enum status: {pending: 0, completed: 1}
  enum outcome: {win: 0, draw: 1, lose: 2}
  belongs_to :user
  belongs_to :match
  has_many :notifications, dependent: :destroy
  validates :price, presence: true
  validates :outcome, presence: true

  def win
    ActiveRecord::Base.transaction do
      bonus_money = price * Settings.bonus
      user.update_attributes! money: user.money + bonus_money
    end
  end
end
