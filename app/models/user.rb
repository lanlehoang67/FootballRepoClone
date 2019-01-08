class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save{email.downcase!}

  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :news
  has_many :score_bets, dependent: :destroy

  validates :name,  presence: true,
    length: {maximum: Settings.users.name_length}
  validates :email, presence: true,
    length: {maximum: Settings.users.email_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.users.password_length}, allow_nil: true
  has_secure_password
  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  def reduce_money price
    ActiveRecord::Base.transaction do
      new_money = money.to_f - price.to_f
      update_attributes! money: new_money
    end
  end
end
