require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TaskManage
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

        # ここに追加
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # 例: デフォルトの言語も一緒に指定する場合
    config.i18n.default_locale = :ja
    
    # タイムゾーンを日本時間に設定
    config.time_zone = 'Asia/Tokyo'
    
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |g|
      g.helper false              # helper ファイルを生成しない
      g.assets false              # CSS/JSファイルを生成しない
      g.view_specs false          # viewスペックを生成しない（RSpec用）
      g.helper_specs false        # helperスペックを生成しない（RSpec用）
      g.routing_specs false       # routingスペックを生成しない（RSpec用）
      g.controller_specs false    # controllerスペックを生成しない（RSpec用）
      g.model_specs false         # modelスペックを生成しない（RSpec用）
      g.test_framework nil        # そもそも test ディレクトリを生成しない
    end
  end
end
