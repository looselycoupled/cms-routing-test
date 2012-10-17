class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :check_routing_version


  private

  def check_routing_version
    # Initialize timestamp if needed
    Rails.application.config.router_timestamp = Time.now unless Rails.application.config.router_timestamp
    # get latest router timestamp
    last_update = Rails.cache.fetch("router_timestamp") do
      Time.now
    end

    logger.info "Comparing router timestamps..."

    # Reload routing table if out of date
    if Rails.application.config.router_timestamp <= last_update
      logger.info "Reloading routing table"
      reload_routes
      Rails.application.config.router_timestamp = last_update
    end
  end

  def update_router_timestamp
    Rails.cache.write("router_version", Time.now)
  end

  def reload_routes
    Routing::Application.reload_routes!
  end



end
