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
    #attempt to select all of them
    #js = 'var tmp = $("div[class$=' + sid + ']").attr("class"); alert(tmp);'
    #js = 'var tmp = $("[class$=' + sid + ']").find(":nth-child(1)").attr(); alert(tmp);'
    #js = '$("[class$=' + sid+ ']").find(":first").attr("class","btn hangup_phone"); var url = "' + BASE_URL + '/dashboard/hangup_call_immediate/?sid=' + sid + '"; $.post(url);'
    js = '$("[id$=' + sid + ']").find(":first").attr("class","btn hangup_phone"); var url = "' + BASE_URL + '/dashboard/hangup_call_immediate/?sid=' + sid + '"; $.post(url);'
    #this only selects the one that was clicked
    #js = '$(this).parent().parent().attr("class","btn hangup_phone"); var url = "' + BASE_URL + '/dashboard/hangup_call_immediate/?sid=' + sid + '"; $.post(url);'
    link_to_function image_tag('/redx.png', :style => "float: right; margin-right: -10px;" ), js, :confirm => "Hang up call?"
  end
  
  def link_to_toggle_mute_call(sid)
    #check if caller is muted
    js = 'var tmp = $(this).parent().parent().attr("style");alert(tmp); var url = "' + BASE_URL + '/dashboard/mute_call/?sid=' + sid + '"; $.post(url);'
    link_to_function image_tag('/microphone.png', :style => "float: right; background: green; margin-right: -10px;" ), js
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
