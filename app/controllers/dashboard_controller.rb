class DashboardController < ApplicationController
  require 'twilio-ruby'
  layout 'dashboard'
  
  def index

  end
  
  def update_call_list
      #create client
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
      #gets the call list
      call_list = client.account.calls.list(:status => 'in-progress')

      #call_list that is displayed in the view
      @call_list = []
      call_list.each do |call|
        @call_list << call
      end
      #set the count for the view
      @call_count = call_list.count.to_s
      respond_to do |format|
        format.html  {render :layout => false}
      end
  end
  
  def update_waiting_room_list
      #create client
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
     
      #Find Conference by friendly name
      conf_waiting_room = client.account.conferences.list(:FriendlyName => 'Waiting Room')
      
      conf_waiting_room.each do |conf|
        conf.participants.list
      end
      
      #get participant list from twilio
      waiting_participants = client.account.conferences.get('CF58122a3cb34c67f9a799c395903e9d59').participants 
            
      @waiting_participants = []
      waiting_participants.list.each do |call|
        @waiting_participants << call
      end
      #set the count for the view
      @wait_count = @waiting_participants.count.to_s
      respond_to do |format|
        format.html  {render :layout => false}
      end
  end
  

end
