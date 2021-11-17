RSpec::describe Sinopac::Funbiz::Gateway do
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

      gateway = Sinopac::Funbiz::Gateway.new(
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

    gateway = Sinopac::Funbiz::Gateway.new(
      shop_no: shop_no,
      end_point: end_point, 
      hashes: hashes
    )
    hash_id = gateway.hash_id

    expect(hash_id).to eq "4DA70F5E2D800D50B43ED3B537480C64"
  end

  it "can build a new gateway without arguments" do
    gateway = Sinopac::Funbiz::Gateway.new

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
    order = build(:order, memo: 'memo test')
    gateway = build(:gateway, :ithome)

    result = gateway.build_atm_order(order: order, expired_after: 10)

    expect(result[:Memo]).to eq 'memo test'
    expect(result[:PayType]).to eq 'A'
    expect(result[:AtmParam][:ExpireDate]).to eq '20211127'
  end
end