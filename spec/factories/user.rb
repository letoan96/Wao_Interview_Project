require 'faker'

FactoryBot.define do
  factory :user do |user|
    sequence :email do |n|
      "person#{n}#{Faker::Internet.email}"
    end
  end
end
