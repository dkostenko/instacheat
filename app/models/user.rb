class User < ActiveRecord::Base
  validates_uniqueness_of :i_id
  
  attr_accessible :i_id, :i_name, :profile_picture
end
