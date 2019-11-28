require 'faker'

FactoryBot.define do
  factory :balance do |f|
    f.balance_name { Faker::Internet.name }
  end
end
