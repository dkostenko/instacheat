require "instagram"

class SessionsController < ApplicationController
  def connect
    redirect_to Instagram.authorize_url(:redirect_uri => CALLBACK_URL, :scope => 'likes comments relationships')
  end

  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
    @user = User.find_by_i_id(response.user.id)
    session[:access_token] = response.access_token
    if @user
      session[:i_id] = @user.i_id
    else
      session[:i_id] = response.user.id 
      @user = User.create(:i_id => response.user.id, :i_name => response.user.username, :profile_picture => response.user.profile_picture)
    end
    
    redirect_to :controller => 'users', :action => 'index'
  end
  
  def new
    if !session[:access_token].nil?
      redirect_to :controller => 'users', :action => 'index'
    else    
      respond_to do |format|
        format.html
      end
    end
  end
  
  def destroy
    session[:access_token] = nil
    redirect_to :controller => 'sessions', :action => 'new'
  end
end
