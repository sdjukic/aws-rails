require 'rubygems'
require 'bundler/setup'
require 'aws-sdk'
#require 'uuid'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  @@SPACE_AVAILABLE = 10000000.0 
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @user_resources = @user.user_resources
    
    @new_resource = @user.user_resources.new
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{params[:id]}/${filename}", success_action_status: 201, acl: :public_read)

  end

  # GET /users/new
  def new
    @user = User.new
    if User.last
      user_id = User.last.id + 1
    else
      user_id = 1
    end

    # This creates directory uploads and another directory with random uuid per user where it's storing files
    # not bad but if I want to reuse that uuid I have to look it up from the db
    @s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{user_id}/user_avatar", success_action_status: 201, acl: :public_read)
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @user_resources = UserResource.where("user_id = #{params[:id]}")
    space_used = @user_resources.map { |r| r[:resource_size] }.reduce(:+) || 0
    @percent_used = (space_used / @@SPACE_AVAILABLE) * 100
    if @percent_used < 45
      @pie_color = "#0ff01e"
    elsif @percent_used < 80
      @pie_color = "#eef00f"
    else
      @pie_color = "#f00f31"
    end
      
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      puts "What are our parameters"
      puts user_params
      puts "Format is:"
      puts format

      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

    respond_to do |format|
     
      if @user.update(user_params)
        # parse all elements in the hash that have _destroy = 1
        all_user_files = user_params[:user_resources_attributes]
        all_user_files.each_value do |resource|
          if resource.fetch(:_destroy) == "1"
            S3_BUCKET.objects["uploads/#{@user[:id]}/#{resource.fetch :resource_name}"].delete if S3_BUCKET.objects["uploads/#{@user[:id]}/#{resource.fetch :resource_name}"].exists?
          end
        end
        @user.save
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :avatar_url, user_resources_attributes: [:id, :resource_name, :resource_url, :resource_size, :_destroy])
    end
end
