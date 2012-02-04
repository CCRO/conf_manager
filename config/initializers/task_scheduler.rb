require 'rubygems'
require 'rufus/scheduler'

## to start scheduler
scheduler = Rufus::Scheduler.start_new

#update the active calls
scheduler.every("2000") do
  ActiveCall.update_call_list
end

#update the active conferences
scheduler.every("2000") do
  ActiveConference.update_conference_list
  ActiveConference.update_all_participant_lists
end