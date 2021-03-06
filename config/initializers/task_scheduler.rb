require 'rubygems'
require 'rufus/scheduler'

## to start scheduler
scheduler = Rufus::Scheduler.start_new

#update the active calls
scheduler.every("2500") do
  ActiveCall.update_call_list
  ActiveConference.update_conference_list
  ActiveConference.update_all_participant_lists
  ActiveRecord::Base.connection_pool.clear_stale_cached_connections!
  ActiveRecord::Base.connection_pool.clear_reloadable_connections!  
end

#update the active conferences
scheduler.every("3000") do
  #ActiveConference.update_all_participant_lists
end

scheduler.every("5000") do
  #ActiveRecord::Base.connection_pool.clear_stale_cached_connections!
  #ActiveRecord::Base.connection_pool.clear_reloadable_connections!
end