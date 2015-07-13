FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| Faker::Internet.email("user_#{n}") }

    password 'password'
    password_confirmation { password }

    trait :with_facebook_account do
      provider 'facebook'
      sequence(:uid) { |n| "#{provider}-user-#{n}" }
    end

    trait :with_twitter_account do
      provider 'twitter'
      sequence(:uid) { |n| "#{provider}-user-#{n}" }
    end
  end

  factory :admin, parent: :user do
    after(:create) { |user| user.grant :admin }
  end
end
