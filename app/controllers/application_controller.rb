class ApplicationController < ActionController::Base
  protect_from_forgery

        def get_domain(url)
           require 'uri'
           URI.parse(url).host.to_s
        end

end
