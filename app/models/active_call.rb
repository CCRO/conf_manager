class ActiveCall < ActiveRecord::Base
  belongs_to :active_conference

  validates :sid, :presence => true, :uniqueness => true
  
  
  def self.get_caller_name(web_call)
    #see if user is in db
    if web_call.direction == 'inbound'
      caller = Contact.where("phone like ?", web_call.from[2..-1]).first
    elsif call.direction == 'outbound'
      caller = Contact.where("phone like ?", web_call.to[2..-1]).first
    end
    #if user is in db, use that name, else caller id, else "Uknown Caller"
    if !caller.nil?
      callerstr = caller.user
    elsif !web_call.caller_name.nil? 
      callerstr = web_call.caller_name
    else
     callerstr = 'Unknown Caller'     
    end
    return callerstr 
  end
  
  def self.update_call_list
    begin
      #create client
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
      #gets the call list
      call_list = client.account.calls.list(:status => 'in-progress')
      
      #build an Active_calls sid vector
      call_db_list = []
      ActiveCall.all.each do |active_call|
        call_db_list << active_call.sid
      end
      
      #build a call_list sid vector
      call_web_list = []
      call_list.each do |web_call|
        call_web_list << web_call.sid     
      end
      
      #find calls in db and not in call_list
      calls_to_remove = (call_db_list - call_web_list )
      #remove calls from db by sid
      if !calls_to_remove.empty?
        ActiveCall.destroy_all(:sid => calls_to_remove)
      end
      
      #find call in call_list but not db
      calls_to_add = ( call_web_list - call_db_list)
      #add calls to the db, have to iterate through existing call list, or make a web request per call
      call_list.each do |web_call|
        #if the call needs to be added
        if calls_to_add.include?(web_call.sid)
          #format name
          callerstr = ActiveCall.get_caller_name(web_call)
       
          #create the clal in the db
          added_call = ActiveCall.new(
              :sid => web_call.sid,
              :to => web_call.to[2..-1],
              :from => web_call.from[2..-1],
              :direction => web_call.direction,
              :caller_name => callerstr,
              :muted => false,
              :ended => false              
            )
            #save the call
            added_call.save
        end
      end
      
    end
  end #end update_call_list
  
end #end class
