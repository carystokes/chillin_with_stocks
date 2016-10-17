FactoryGirl.define do
  factory :stock do
  end

  factory :portfolio do
    holding_symbol 'GOOGL'
    number_shares '100'
    price_per_share '800'
  end
end
