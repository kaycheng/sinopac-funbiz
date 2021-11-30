module Sinopac::FunBiz
  class Order
    attr_accessor :order_no, :amount, :product_name, :currency
    attr_accessor :memo, :param1, :param2, :param3

    def initialize(order_no:, amount:, product_name:, **options)
      @order_no = order_no
      @amount = amount
      @product_name = product_name
      @currency = options[:currency] || 'TWD'
      @memo = options[:memo] || ''
      @param1 = options[:param1] || ''
      @param2 = options[:param2] || ''
      @param3 = options[:param3] || ''
    end

    def valid?
      @amount > 0 && @order_no != '' && @product_name != ''
    end
  end
end