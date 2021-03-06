require 'net/http'
require 'uri'
require 'json'

module Sinopac::FunBiz
  module Nonce
    def self.get_nonce(shop_no:, end_point:)
      url = URI("#{end_point}/Nonce")
      data = { "ShopNo": shop_no }.to_json
      header = { "Content-Type" => "application/json" }

      nonce = Net::HTTP.post(url, data, header)
      JSON.parse(nonce.body)["Nonce"]
    end
  end
end