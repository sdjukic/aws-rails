require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = User.new(name: "Some user", avatar_url: "www.example.com/avatar")
  end

  test "associated resources should be destroyed" do
  	@user.save
  	@user.user_resources.create!(resource_url: "www.example.com/resource", resource_size: 100000)
  	assert_difference 'UserResources.count', -1 do
  		@user.destroy
  	end
  end
end
