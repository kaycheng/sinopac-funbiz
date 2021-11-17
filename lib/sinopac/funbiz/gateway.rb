module Sinopac::Funbiz
  class Gateway
    def initialize(shop_no:, end_point:, hashes:)
      @shop_no = shop_no
      @end_point = end_point
      @hashes = hashes
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