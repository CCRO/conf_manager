class DashboardController < ApplicationController
  require 'twilio-ruby'
  layout 'dashboard'
  
  def index
    @contacts = Contact.all
    @conferences = Conference.all
  end
  
  def update_conference_list
    #create client
    client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
    @conferences = Conference.all
    
    #will store the confname => participants array 
    @participants_hash = Hash.new
    
    @conferences.each do |conference|
      conf_list = client.account.conferences.list(:FriendlyName => conference.confname)
      participants_array = Array.new
      conf_list.each do |conf|
        participants = conf.participants
        participants.list.each do |participant|
          participants_array << participant.call_sid
        end
      end
      @participants_hash[conference.confname] = participants_array
    end
    
    @active_conf = Array.new
    @empty_conf = Array.new
    
    @conferences.each do |conference|
      if @participants_hash[conference.confname].count < 1
         @empty_conf << conference.confname
      else
         @active_conf << conference.confname
      end     
    end
    
    respond_to do |format|
        format.html  {render :layout => false}
    end
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
      
      #get participant list from twilio
      @waiting_participants = []
      @conference_sid_in_use = ""
      
      waiting_room_confs  = client.account.conferences.list(:FriendlyName => 'Waiting Room')
      waiting_room_confs.each do |conf|
        tmp_participants = client.account.conferences.get(conf.sid).participants
        tmp_participants.list.each do |caller|
          #@waiting_participants << caller.call_sid
          @waiting_participants << client.account.calls.get(caller.call_sid)
        end
      end
    
      #set the count for the view
      @wait_count = @waiting_participants.count.to_s
      respond_to do |format|
        format.html  {render :layout => false}
      end
  end
  

end
