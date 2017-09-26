require_relative 'boot'

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Openregister gem
require 'openregister'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CustodianUpdateTool
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.time_zone = 'London'
    config.active_record.default_timezone = :local
    config.active_job.queue_adapter = :sidekiq
    config.autoload_paths += %W["#{config.root}/app/validators/"]

    ActionView::Base.default_form_builder = GovukElementsFormBuilder::FormBuilder

    config.to_prepare do
      Devise::Mailer.layout "mailer"
    end
  end
end
