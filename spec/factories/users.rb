FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    role { 'user' }
    password { 'password123' }
    phone { Faker::PhoneNumber.phone_number }

    trait :owner do
      role { 'owner' }
    end

    trait :broker do
      role { 'broker' }
    end
    trait :admin do
      role { 'admin' }
end
end
end
