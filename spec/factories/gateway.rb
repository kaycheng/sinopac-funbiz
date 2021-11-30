FactoryBot.define do
  factory :gateway, class: Sinopac::FunBiz::Gateway do
    shop_no { "NA0001_001" }
    end_point { ENV['FUNBIZ_END_POINT'] }
    hashes

    initialize_with { new(**attributes) }

    trait :ithome do
      shop_no { ENV['FUNBIZ_SHOP_NO'] }
      association :hashes, factory: [:hashes, :ithome]
    end
  end
end