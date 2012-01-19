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
  

end
