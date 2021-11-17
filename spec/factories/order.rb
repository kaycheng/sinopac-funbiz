FactoryBot.define do
  factory :order, class: Sinopac::Funbiz::Order do
    order_no { "#{Date.today.strftime('%Y%m%d')}#{[*'A'..'Z', *'1'..'9'].sample(10).join}" }
    product_name { "Test" }
    amount { 2000 }

    initialize_with { new(**attributes) }
  end
end