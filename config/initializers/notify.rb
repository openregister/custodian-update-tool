ActionMailer::Base.add_delivery_method :govuk_notify, GovukNotifyRails::Delivery, api_key: Rails.application.secrets.notify_api_key
