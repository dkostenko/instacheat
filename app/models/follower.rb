class Follower < ActiveRecord::Base
  validates_uniqueness_of :i_id
  
  attr_accessible :followme, :followto, :i_id
end
