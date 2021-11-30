RSpec::describe Sinopac::FunBiz::Nonce do
  it "can get nonce" do
    VCR.use_cassette("nonce") do
      shop_no = "NA0001_001"
      end_point = "https://sandbox.sinopac.com/QPay.WebAPI/api" 

      result = Sinopac::FunBiz::Nonce.get_nonce(
        shop_no: shop_no,
        end_point: end_point
      )

      expect(result).not_to be nil
      expect(result.length).to be 108
    end
  end
end