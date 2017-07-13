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
      Spree::Product.active.joins(:orders).
        where("spree_orders.state = 'complete'").
        where("spree_orders.completed_at >= '#{200.days.ago}'")
    end

    def variants_sales_data_for(product_id)
      Spree::Variant.select('spree_variants.sku, SUM(spree_line_items.quantity) AS total_qty_sold').
        joins('LEFT OUTER JOIN spree_line_items ON spree_line_items.variant_id = spree_variants.id').
        where('spree_variants.product_id' => product_id).
        group('spree_variants.id').
        order('total_qty_sold ASC').map { |e| [e.sku, e.total_qty_sold || 0] }
    end
  end
end
