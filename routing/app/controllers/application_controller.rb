class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :check_routing_version


  private

  def check_routing_version
    # get latest router version
    last_update = Rails.cache.fetch("router_version") do
      0
    end

    logger.info "Comparing router versions...(App:#{Rails.application.config.router_version} vs Cache:#{last_update})"

    # Reload routing table if out of date
    if Rails.application.config.router_version < last_update
      reload_routes
      Rails.application.config.router_version = last_update
    end
  end

  def update_router_version
    Rails.cache.write("router_version", Rails.cache.read("router_version") + 1)
    reload_routes
  end

  def reload_routes
    logger.info "Loading routing table"
    Routing::Application.reload_routes!
  end



end
