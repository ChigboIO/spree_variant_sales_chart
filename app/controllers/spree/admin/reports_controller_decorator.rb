Spree::Admin::ReportsController.class_eval do
  before_action :spree_variant_sales_reports_setup, only: :index

  def variant_sales_chart
  end

  private

  def spree_variant_sales_reports_setup
    Spree::Admin::ReportsController.add_available_report!(:variant_sales_chart)
  end
end
