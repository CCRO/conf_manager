module DashboardHelper
  def get_caller_name(call)
    if call.direction == 'inbound'
      caller = Contact.where("phone like ?", call.from[2..-1]).first
    elsif call.direction == 'outbound'
      caller = Contact.where("phone like ?", call.to[2..-1]).first
    end
    
    if !caller.nil?
      callerstr = caller.user
    elsif !call.caller_name.nil? 
      callerstr = call.caller_name
    else
     callerstr = 'Unknown Caller'     
    end 
    
    return callerstr    
  end #end get_caller_name(call)
  
  def link_to_hangup_call(sid)
    js = 'var url = "' + BASE_URL + '/dashboard/hangup_call/?sid=' + sid + '"; $.post(url);'
    link_to_function image_tag('/redx.png', :style => "float: right;" ), js
  end

  def get_conf_pin(conf)
    return pinstr = Conference.where("confname = ?", conf).first.pin
  end
  
  def invite_by_call(conf)
  end
  
  def invite_by_txt(conf)
    link_to "Text", :controller => 'dashboard', :action => 'send_text_invite', :conf => conf
  end
  
end
