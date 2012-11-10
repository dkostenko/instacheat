require "instagram"

class FollowersController < ApplicationController
  before_filter :authorize
  
  # GET /followers
  # GET /followers.json
  def index
    @followme = Follower.find(:all, :conditions => ["followme=?", true])
    @followto = Follower.find(:all, :conditions => ["followto=?", true])
    
    @random_follower = @followto.sample(1).first.i_id
    
    @user_id = session[:i_id]
    @token = session[:access_token]

    respond_to do |format|
      format.html # index.html.erb
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
      else
        format.html { render action: "new" }
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
      else
        format.html { render action: "edit" }
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
  
  
  def add_followme
    @follower = Follower.find_by_i_id(params[:id])
    if @follower
      @follower.followme = true
      @follower.save
    else
      Follower.create(:followto => false, :followme => true, :i_id => params[:id])
    end
    
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
  
  def add_followto
    @follower = Follower.find_by_i_id(params[:id])
    if @follower
      @follower.followto = true
      @follower.save
    else
      Follower.create(:followme => false, :followto => true, :i_id => params[:id])
    end
    
    respond_to do |format|
      format.js { render :nothing => true }
    end
  end
  
  
  def remove_excess_followto  
    @excess_followers = Follower.where("followto = ? AND followme = ?", true, false)
    
    respond_to do |format|
      format.js
    end
  end
  
  def like_recent
    followto = Follower.find(:all, :conditions => ["followto=?", true])
    @random_follower = followto.sample(1).first.i_id
    
    @user_recent_media = Instagram.user_recent_media(params[:id], :access_token => session[:access_token]).data
    
    
    respond_to do |format|
      format.js
    end
  end
  
  
  def dolike
    Instagram.like_media(params[:id], :access_token => session[:access_token])
    
    respond_to do |format|
      format.js { render :nothing => true }
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
