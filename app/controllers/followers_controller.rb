require "instagram"

class FollowersController < ApplicationController
  before_filter :authorize
  
  # GET /followers
  # GET /followers.json
  def index
    @followers = Follower.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @followers }
    end
  end

  # GET /followers/1
  # GET /followers/1.json
  def show
    @follower = Follower.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @follower }
    end
  end

  # GET /followers/new
  # GET /followers/new.json
  def new
    @follower = Follower.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @follower }
    end
  end

  # GET /followers/1/edit
  def edit
    @follower = Follower.find(params[:id])
  end

  # POST /followers
  # POST /followers.json
  def create
    @follower = Follower.new(params[:follower])

    respond_to do |format|
      if @follower.save
        format.html { redirect_to @follower, notice: 'Follower was successfully created.' }
        format.json { render json: @follower, status: :created, location: @follower }
      else
        format.html { render action: "new" }
        format.json { render json: @follower.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /followers/1
  # PUT /followers/1.json
  def update
    @follower = Follower.find(params[:id])

    respond_to do |format|
      if @follower.update_attributes(params[:follower])
        format.html { redirect_to @follower, notice: 'Follower was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @follower.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /followers/1.js
  def destroy
    @follower = Follower.find(params[:id])
    Instagram.unfollow_user(@follower.i_id, access_token: session[:access_token])
    @follower.destroy

    respond_to do |format|
      format.js
    end
  end
  
  
  def actualize
    users = Instagram.user_follows(session[:i_id], access_token: session[:access_token], count: 2000)
    
    users.each do |user|
      @follower = Follower.find_by_i_id(user.id)
      if @follower
        @follower.followto = true
        @follower.save
      else
        Follower.create(:followme => false, :followto => true, :i_id => user.id)
      end
    end
    
    users = Instagram.user_followed_by(session[:i_id], access_token: session[:access_token], count: 2000)
    
    users.each do |user|
      @follower = Follower.find_by_i_id(user.id)
      if @follower
        @follower.followme = true
        @follower.save
      else
        Follower.create(:followto => false, :followme => true, :i_id => user.id)
      end
    end
    
    redirect_to :controller => 'followers', :action => 'index'
  end
  
  
  
  def remove_excess_followto  
    @excess_followers = Follower.where("followto = ? AND followme = ?", true, false)
    
    respond_to do |format|
      format.js
    end
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  def test
    client = Instagram.client
    @tag = 'cats'
    @tagged_media = client.tag_recent_media(@tag, count: 1)
    
    for i in 1..30
      @max_tag_id = @tagged_media.pagination.next_max_tag_id
      @tagged_media +=  client.tag_recent_media(@tag, count: 1, max_id: @max_tag_id)
    end
    


    
    respond_to do |format|
      format.html
    end
  end
  
  
  
  
  
  
  
  
  
  
  
  
end
