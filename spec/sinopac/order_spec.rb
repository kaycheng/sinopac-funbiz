RSpec::describe Sinopac::FunBiz::Order do
  it "can build a valid order" do
    order_no = "TS001"
    amount = 1000
    product_name = "Test"
    memo = "Testing is interesting."

    order = Sinopac::FunBiz::Order.new(
      order_no: order_no,
      amount: amount,
      product_name: product_name,
      memo: memo
    )

    expect(order).to be_valid
    expect(order.currency).to eq 'TWD'
    expect(order.memo).to eq 'Testing is interesting.'
  end

  it "can build a valid order by factory" do
    order = build(:order, amount: 500, param1: 'Factory')

    expect(order).to be_valid
    expect(order.amount).to be 500
    expect(order.param1).to eq 'Factory'
  end

  it "won't be valid if no product name" do
    order = build(:order, product_name: '')

    expect(order).not_to be_valid
  end
end