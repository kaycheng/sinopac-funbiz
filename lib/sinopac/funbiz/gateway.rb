require 'net/http'
require 'uri'
require 'json'

module Sinopac::FunBiz
  class Gateway
    attr_accessor :shop_no

    def initialize(shop_no: nil, end_point: nil, hashes: nil, return_url: nil, backend_url: nil)
      @shop_no = shop_no || ENV['FUNBIZ_SHOP_NO']
      @end_point = end_point || ENV['FUNBIZ_END_POINT']
      @hashes = hashes  || {
        a1: ENV['FUNBIZ_HASH_A1'],
        a2: ENV['FUNBIZ_HASH_A2'],
        b1: ENV['FUNBIZ_HASH_B1'],
        b2: ENV['FUNBIZ_HASH_B2']
      }
      @return_url = return_url || ENV['FUNBIZ_RETURN_URL']
      @backend_url = backend_url || ENV['FUNBIZ_BACKEND_URL']
    end

    def get_nonce
      @nonce ||= Nonce.get_nonce(shop_no: @shop_no, end_point: @end_point)
    end

    def hash_id
      Hash.hash_id(
        a1: @hashes[:a1],
        a2: @hashes[:a2],
        b1: @hashes[:b1],
        b2: @hashes[:b2],
      )
    end

    def build_creditcard_order(order:, **options)
      build_order(order: order, type: :credit_card, **options)
    end

    def build_atm_order(order:, **options)
      build_order(order: order, type: :atm, **options)
    end

    def order_create_request_params(order_params:)
      build_request_params(order_params: order_params, service_type: "OrderCreate")
    end

    def order_pay_query_request_params(data:)
      build_request_params(order_params: data, service_type: "OrderPayQuery")
    end

    def order_query_request_params(data:)
      build_request_params(order_params: data, service_type: "OrderQuery")
    end

    def query_order(shop_no: nil, order_no:)
      data = {
        ShopNo: shop_no || @shop_no,
        OrderNo: order_no
      }

      request_params = order_query_request_params(data: data)

      url = URI("#{@end_point}/Order")
      header = { "Content-Type" => "application/json" }

      resp = Net::HTTP.post(url, request_params.to_json, header)
      result = decrypt_message(content: JSON.parse(resp.body))

      OrderResult.new(result)
    end

    def query_pay_order(shop_no: nil, pay_token:)
      data = {
        ShopNo: shop_no || @shop_no,
        PayToken: pay_token
      }

      result = order_pay_query_request_params(data: data)
      
      url = URI("#{@end_point}/Order")
      header = { "Content-Type" => "application/json" }

      resp = Net::HTTP.post(url, result.to_json, header)
      result = decrypt_message(content: JSON.parse(resp.body))

      TransactionResult.new(result)
    end

    def pay!(order:, pay_type:, **options)
      order_params = case pay_type
      when :atm
        build_atm_order(order: order, **options)
      when :credit_card
        build_creditcard_order(order: order, **options)
      else
        raise "The payment method isn't supported yet!"
      end

      request_params = order_create_request_params(order_params: order_params)
      url = URI("#{@end_point}/Order")
      header = { "Content-Type" => "application/json" }

      resp = Net::HTTP.post(url, request_params.to_json, header)
      result = decrypt_message(content: JSON.parse(resp.body))

      Result.new(result)
    end

    private
    def build_request_params(order_params:, service_type:)
      {
        Version: "1.0.0",
        ShopNo: @shop_no,
        APIService: service_type,
        Sign: sign(content: order_params),
        Nonce: get_nonce,
        Message: encrypt_message(content: order_params)
      }
    end

    def decrypt_message(content:)
      message = content["Message"]
      nonce = content["Nonce"]

      Message.decrypt(
        content: message,
        key: hash_id,
        iv: Message.iv(nonce: nonce)
      )
    end

    def encrypt_message(content:)
      Message.encrypt(
        content: content,
        key: hash_id,
        iv: Sinopac::FunBiz::Message.iv(nonce: get_nonce)
      )
    end

    def sign(content:)
      Sign.sign(
        content: content,
        nonce: get_nonce,
        hash_id: hash_id
      )
    end

    def build_order(order:, type:, **options)
      content = {
        ShopNo: @shop_no,
        OrderNo: order.order_no,
        Amount: order.amount * 100,
        CurrencyID: options[:currency] || 'TWD',
        PrdtName: order.product_name,
        Memo: order.memo,
        Param1: order.param1,
        Param2: order.param2,
        Param3: order.param3,
        ReturnURL: @return_url,
        BackendURL: @backend_url
      }

      case type
      when :atm
        expired_after = options[:expired_after] || 10
        content.merge!({
          PayType: 'A',
          AtmParam: {
            ExpireDate: (Date.today + expired_after).strftime('%Y%m%d')
          }
        })
      when :credit_card
        content.merge!({
          PayType: 'C',
          CardParam: {
            AutoBilling: options[:auto_billing] ? 'Y' : 'N',
            ExpBillingDays: options[:auto_billing] ? '' : options[:expired_billing_days] || 7,
            ExpMinutes: options[:expired_minutes] || 10,
            PayTypeSub: 'ONE'
          }
        })
      else
        raise "The payment method isn't supported yet!"
      end
    end
  end
end