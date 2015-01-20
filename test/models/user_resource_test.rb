require 'test_helper'

class UserResourceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = users(:slav)
  	@user_resource = @user.user_resources.build(resource_url: "www.example.com/resource", resource_size: 100000, resource_name: "resource")
  end

  test "should be valid" do
    assert @user_resource.valid?
  end

  test "user id should be present" do
  	@user_resource.user_id = nil
  	assert_not @user_resource.valid?
  end

  test "resource url should be present" do
  	@user_resource.resource_url = "  "
  	assert_not @user_resource.valid?
  end

  test "resource name should be present" do
    @user_resource.resource_name = " "
    assert_not @user_resource.valid?
  end

  test "resource size should be 4MB maximum, but greater than 0" do
  	@user_resource.resource_size = 420000
  	assert_not @user_resource.valid?
  	@user_resource.resource_size = 0
  	assert_not @user_resource.valid?
  end

end
