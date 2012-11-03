require "instagram"

class UsersController < ApplicationController
  before_filter :authorize
  
  # GET /users
  def index
    @users = User.all

    client = Instagram.client(:access_token => session[:access_token])
    @user = client.user


    respond_to do |format|
      format.html
    end
  end
end
