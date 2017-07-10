Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin, path: Spree.admin_path do
    resources :reports, only: [] do
      collection do
        get :variant_sales_chart, path: 'variant-sales-chart'
      end
    end
  end
end
