class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  has_many :balances, dependent: :destroy
end
