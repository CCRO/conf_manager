module DashboardHelper
  def get_caller_name(call)

    if call.direction == 'inbound'
      caller = Contact.where("phone like ?", call.from[2..-1]).first
    elsif call.direction == 'outbound'
      caller = Contact.where("phone like ?", call.to[2..-1]).first
    end
    
    if !caller.nil?
      callerstr = caller.user
    elsif !call.caller_name.nil? or !call.caller_name.empty?
      callerstr = call.caller_name
    else
     callerstr = 'Unknown Caller'     
    end 
    return callerstr    
  end
end
