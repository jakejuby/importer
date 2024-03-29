module Importer
  class Engine < Rails::Engine
    initialize "importer.load_app_instance_data" do |app|
      Importer.setup do |config|
        config.app_root = app.root
      end
    end
    initialize "importer.load_static_assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end
  end
end
