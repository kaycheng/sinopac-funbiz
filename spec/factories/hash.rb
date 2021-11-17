FactoryBot.define do
  factory :hashes, class: Hash do
    a1 { '65960834240E44B7' }
    a2 { '2831076A098E49E7' }
    b1 { 'CB1AFFBF915A492B' }
    b2 { '7F242C0AA612454F' }

    initialize_with { attributes }

    trait :ithome do
      a1 { ENV['FUNBIZ_HASH_A1'] }
      a2 { ENV['FUNBIZ_HASH_A2'] }
      b1 { ENV['FUNBIZ_HASH_B1'] }
      b2 { ENV['FUNBIZ_HASH_B2'] }
    end
  end
end