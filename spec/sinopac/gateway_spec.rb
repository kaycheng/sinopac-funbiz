require 'timecop'

RSpec::describe Sinopac::FunBiz::Gateway do
  it "can get nonce" do
    VCR.use_cassette("nonce") do
      shop_no = "NA0001_001"
      end_point = "https://sandbox.sinopac.com/QPay.WebAPI/api"
      hashes = {
        a1:"65960834240E44B7",
        a2:"2831076A098E49E7",
        b1:"CB1AFFBF915A492B",
        b2:"7F242C0AA612454F"
      }

      gateway = Sinopac::FunBiz::Gateway.new(
        shop_no: shop_no,
        end_point: end_point,
        hashes: hashes
      )
      nonce = gateway.get_nonce

      expect(nonce).not_to be nil
      expect(nonce.length).to be 108
    end
  end

  it "can calculate hash id" do
    shop_no = "NA0001_001"  
    end_point = "https://sandbox.sinopac.com/QPay.WebAPI/api"
    hashes = {
      a1:"65960834240E44B7",
      a2:"2831076A098E49E7",
      b1:"CB1AFFBF915A492B",
      b2:"7F242C0AA612454F"
    }

    gateway = Sinopac::FunBiz::Gateway.new(
      shop_no: shop_no,
      end_point: end_point, 
      hashes: hashes
    )
    hash_id = gateway.hash_id

    expect(hash_id).to eq "4DA70F5E2D800D50B43ED3B537480C64"
  end

  it "can build a new gateway without arguments" do
    gateway = Sinopac::FunBiz::Gateway.new

    expect(gateway.shop_no).to eq ENV['FUNBIZ_SHOP_NO']
  end

  it "can build a gateway with factory" do
    gateway = build(:gateway, :ithome)
    expect(gateway.hash_id).to eq ENV['FUNBIZ_HASH_ID']
  end

  it "can build an order params for credit card transaction" do
    order = build(:order, product_name: 'learning how to learn')
    gateway = build(:gateway, :ithome)

    result = gateway.build_creditcard_order(
      order: order,
      auto_billing: true
    )

    expect(result[:PrdtName]).to eq 'learning how to learn'
    expect(result[:CurrencyID]).to eq 'TWD'
    expect(result[:PayType]).to eq 'C'
    expect(result[:CardParam][:AutoBilling]).to eq 'Y'
  end

  it "can build an order params for atm transaction" do
    today = Time.local(1995, 04, 29)
    Timecop.freeze(today) do
      order = build(:order, memo: 'memo test')
      gateway = build(:gateway, :ithome)
  
      result = gateway.build_atm_order(order: order, expired_after: 10)
  
      expect(result[:Memo]).to eq 'memo test'
      expect(result[:PayType]).to eq 'A'
      expect(result[:AtmParam][:ExpireDate]).to eq '19950509'
    end
  end

  it "can convert order params to request params" do
    gateway = build(:gateway, :ithome)
    order = build(:order)

    order_params = gateway.build_creditcard_order(
      order: order, 
      auto_billing: true
    )
    result = gateway.order_create_request_params(order_params: order_params)

    expect(result[:APIService]).to eq 'OrderCreate'
  end

  it "can receive api response" do
    order = build(:order)
    gateway = build(:gateway, :ithome)

    result = gateway.pay!(order: order, pay_type: :credit_card)

    expect(result).to be_success
    expect(result.pay_type).to eq :credit_card
    expect(result.payment_url).not_to be_empty
  end

  it "can query pay order" do
    gateway = build(:gateway, :ithome)
    dummy_shop_no = 'NA0249_001'
    dummy_pay_token = "f034c46b85c36515730e193b2db447c27190386eb1869a09c07e3f609fd190b6"

    result = gateway.query_pay_order(
      shop_no: dummy_shop_no,
      pay_token: dummy_pay_token
    )

    expect(result).to be_success
    expect(result.shop_no).to eq dummy_shop_no
    expect(result.order_no).not_to be nil
  end

  it "can query a valid order" do
    dummy_order_no = 'RB20211213LU8DMAF650'
    gateway = build(:gateway, :ithome)

    result = gateway.query_order(order_no: dummy_order_no)
    
    expect(result).to be_success
    expect(result.pay_status).to eq '1A400'
  end
end