module Sinopac::Funbiz
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

    def build_creditcard_order(order:, **options)
      build_order(order: order, type: :credit_card, **options)
    end

    def build_atm_order(order:, **options)
      build_order(order: order, type: :atm, **options)
    end

    private
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
            ExpBillingDays: options[:auto_billing] ? '' : options[:expired_billing_days] || 10,
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