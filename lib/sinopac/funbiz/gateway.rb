module Sinopac::Funbiz
  class Gateway
    attr_accessor :shop_no
    
    def initialize(shop_no: nil, end_point: nil, hashes: nil)
      @shop_no = shop_no || ENV['FUNBIZ_SHOP_NO']
      @end_point = end_point || ENV['FUNBIZ_END_POINT']
      @hashes = hashes  || {
        a1: ENV['FUNBIZ_HASH_A1'],
        a2: ENV['FUNBIZ_HASH_A2'],
        b1: ENV['FUNBIZ_HASH_B1'],
        b2: ENV['FUNBIZ_HASH_B2']
      }
    end

    def get_nonce
      Nonce.get_nonce(shop_no: @shop_no, end_point: @end_point)
    end

    def hash_id
      Hash.hash_id(
        a1: @hashes[:a1],
        a2: @hashes[:a2],
        b1: @hashes[:b1],
        b2: @hashes[:b2],
      )
    end
  end
end