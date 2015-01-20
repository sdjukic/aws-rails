class UserResource < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :resource_url, presence: true
  validates :resource_name, presence: true
  validates_numericality_of :resource_size, :only_integer => true
  validates_inclusion_of :resource_size, :in => 1..4000000, :message => "Can be between 0 and 4MB"
end
