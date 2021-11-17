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
end