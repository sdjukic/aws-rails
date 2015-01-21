class UserResourcesController < ApplicationController
  @@SPACE_AVAILABLE = 10000000.0  


  def new

  	@current_user = User.find(2)
  	@user = User.find(2)
  	user_id = 2
    @user_resource = @current_user.user_resources.new
  
  	@s3_direct_post = S3_BUCKET.presigned_post(key: "uploads/#{user_id}/${filename}", success_action_status: 201, acl: :public_read)

  end

  # have to check whether file already exists in AWS it has to be unique to be saved, but AWS does
  # not return appropriate error code when I try to save file that is already there!
  def create
  	@current_user = User.find(2)

    @user_resources = UserResource.where("user_id = 2")
    space_used = @user_resources.map { |r| r[:resource_size] }.reduce(:+) || 0
    space_used += params['user_resource']['resource_size'].to_i
  
    if space_used < @@SPACE_AVAILABLE 
  	  @user_resource = @current_user.user_resources.create(user_resource_params)
    
  	  respond_to do |format|

        if @user_resource.save
          format.html { redirect_to @current_user, notice: 'File was successfully uploaded.' }
          format.json { render :show, status: :created, location: @current_user }
        else
          format.html { redirect_to @current_user, notice: "File creation failed"}
          format.json { render json: @user_resource.errors, status: :unprocessable_entity }
        end
      end
    else
      # since object has been already uploaded, we have to delete it from the bucket
      file_name = params['user_resource']['resource_url'].match /uploads.*/
      S3_BUCKET.objects.find { |obj| obj.key == "#{file_name}" }.delete
      #S3_BUCKET.delete(file_name)
      redirect_to @current_user, notice: "Total user space exceeded."
    end
  
  end

  def destroy


  end

  def user_resource_params
    @current_user = User.find(2)
    file_name = params['user_resource']['resource_url'].match /uploads.*/
    
    file_size = S3_BUCKET.objects.find { |obj| obj.key == "#{file_name}" }.content_length
    
    numeric_value = { 'resource_size' => file_size}
    params['user_resource'].merge!(numeric_value)
    params.require(:user_resource).permit(:resource_name, :resource_url, :resource_size)
  end


end
