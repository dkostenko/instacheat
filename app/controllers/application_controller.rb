class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
    
    def authorize
      if session[:access_token].nil?
        redirect_to :controller => 'sessions', :action => 'new'
      end
    end
end
