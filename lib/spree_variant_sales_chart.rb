require 'spree_core'
require 'chartkick'
require 'groupdate'
require 'spree_variant_sales_chart/engine'
require 'spree_variant_sales_chart/version'

module SpreeVariantSalesChart
  class Base
    def initialize(params = {})
      @params = params
    end

    def products
      @orders = Spree::Order.where(state: 'complete').
                where('completed_at >= ?', get_timeline(@params['period']))
      Spree::Product.distinct.joins(:orders).where('spree_orders.id IN (?)', @orders.pluck(:id))
    end

    def variants_sales_data_for(product_id)
      Spree::Variant.select('spree_variants.sku, SUM(spree_line_items.quantity) AS total_qty_sold').
        joins('LEFT OUTER JOIN spree_line_items ON spree_line_items.variant_id = spree_variants.id').
        where('spree_variants.product_id' => product_id).
        where('spree_line_items.order_id IN (?)', @orders.pluck(:id)).
        group('spree_variants.id').
        order('total_qty_sold DESC').map { |e| [e.sku, e.total_qty_sold || 0] }
    end

    def periods
      timelines.keys
    end

    private

    def get_timeline(period)
      period ||= 'today'
      timelines[period]
    end

    def timelines
      {
        'today' => DateTime.current.beginning_of_day,
        'this-week' => DateTime.current.beginning_of_week,
        'this-month' => DateTime.current.beginning_of_month,
        'this-quarter' => DateTime.current.beginning_of_quarter
      }
    end
  end
end
