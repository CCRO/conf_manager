class DashboardController < ApplicationController
  layout 'dashboard'
  
  def index
    #begin
      #create client
      #client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
      #gets the call list
      #call_list = client.account.calls.list(:status => 'in-progress')
      
      #call_list that is displayed in the view
      #@call_list = []
      #call_list.each do |call|
        #@call_list << call
      #end
      #set the count for the view
      #@call_count = call_list.count.to_s     
    #rescue StandardError => bang
      #redirect_to :action => '.', 'msg' => "Error #{bang}"
      #return
    #end
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
      
      #conf_waiting_room = client.account.conferences.list(:FriendlyName => 'WaitingRoom')
      
      waiting_participants = client.account.conferences.get('CF827b8578e057de54bbb6263ed59410ad').participants
      
      #gets the participant list
      #waiting_participants = conf_waiting_room.participants
      
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
