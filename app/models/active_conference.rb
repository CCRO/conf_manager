class ActiveConference < ActiveRecord::Base
  has_many :active_calls
  
  validates :sid, :uniqueness => true
  
  
  
  
  
end
