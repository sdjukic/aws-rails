class UserResourcesController < ApplicationController
  

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

  	@user_resource = @current_user.user_resources.create(user_resource_params)
    
  	respond_to do |format|

      if @user_resource.save
        format.html { redirect_to @current_user, notice: 'File was successfully uploaded.' }
        format.json { render :show, status: :created, location: @current_user }
      else
      	puts "failing to save"
        format.html { redirect_to @current_user, notice: "File creation failed"}
        format.json { render json: @user_resource.errors, status: :unprocessable_entity }
      end
    end
  
  end

  def destroy


  end

  def user_resource_params
    @current_user = User.find(2)

    puts "Params in user_resource"
    puts params['user_resource']['resource_url']
    #user_file = S3_BUCKET.objects.find {|obj| obj.key == "uploads/2/#{@user_resource['resource_name']}" }
    numeric_value = { 'resource_size' => params['user_resource']['resource_size'].to_i}
    params['user_resource'].merge!(numeric_value)
    params.require(:user_resource).permit(:resource_name, :resource_url, :resource_size)
  end


end
