class ActiveConference < ActiveRecord::Base
  has_many :active_calls
end
