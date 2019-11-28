class User < ApplicationRecord
  validate :email, presence: true, uniqueness: true
  has_many :balances, dependent: :destroy
end
