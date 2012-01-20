class DashboardController < ApplicationController
  require 'twilio-ruby'
  layout 'dashboard'
  
  def index
    @contacts = Contact.all
    @conferences = Conference.all

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
      #conf_waiting_room = client.account.conferences.list(:FriendlyName => 'Waiting Room')
      
      #get participant list from twilio
      @waiting_participants = []
      @conference_sid_in_use = ""
      
      #waiting_participants = client.account.conferences.get('Waiting Room').participants 
      waiting_participants = client.account.conferences.list(:FriendlyName => 'Waiting Room')
      waiting_participants.list.each do |call|
          @waiting_participants << client.account.conferences.get('Waiting Room').participants.get(call)
      end 

      #client.account.conferences.list.each do |conf|
      #Conference.all.each do |conf|
      #  waiting_participants = client.account.conferences.get(conf.sid).participants
      #  waiting_participants.list.each do |call|
      #    @waiting_participants << client.account.conferences.get(conf.sid).participants.get(call)
      #    if !@waiting_participants.empty?
      #      @conference_sid_in_use = conf.sid.to_s
      #    end
      #  end
      #end
      
      #waiting_participants.list.each do |call|
      #  @waiting_participants << call
      #end
      #set the count for the view
      @wait_count = @waiting_participants.count.to_s
      respond_to do |format|
        format.html  {render :layout => false}
      end
  end
  

end
