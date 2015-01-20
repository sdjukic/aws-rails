class User < ActiveRecord::Base
	has_many :user_resources, dependent: :destroy
	accepts_nested_attributes_for :user_resources, allow_destroy: true
end
