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
    js = '$("[id$=' + sid + ']").find(":first").attr("class","btn hangup_phone");'
    js += 'var url = "' + BASE_URL + '/dashboard/hangup_call_immediate/?sid=' + sid + '"; $.post(url);'
    js += '$("[id$=' + sid + ']").find(":first").fadeOut(2000).delay(1000);'
    #this only selects the one that was clicked
    #js = '$(this).parent().parent().attr("class","btn hangup_phone"); var url = "' + BASE_URL + '/dashboard/hangup_call_immediate/?sid=' + sid + '"; $.post(url);'
    link_to_function image_tag('/redx.png', :style => "float: right; margin-right: -10px;" ), js, :confirm => "Hang up call?"
  end
  
  def link_to_toggle_mute_call(sid)
    #check if caller is muted
    call = ActiveCall.where("sid = ?",sid).first
    color = "green"
    if !call.nil?
      if call.muted?
        color = "red"
      end
    end
    #js = 'var tmp = $(this).parent().parent().attr("style");alert(tmp); var url = "' + BASE_URL + '/dashboard/mute_call/?sid=' + sid + '"; $.post(url);'
    js = 'var url = "/dashboard/mute_call/?sid=' + sid + '"; $.post(url);'
    js += '$("[id$=' + sid + ']").find("[class=mute-link]").disable;'
    js += '$currcolor = $("[id$=' + sid + ']").find("[class=mute-img]").css("background");'
    js += '$("[id$=' + sid + ']").find("[class=mute-img]").css("background","white");'
    js += 'if (currcolor == "green"){$("[id$=' + sid + ']").find("[class=mute-img]").css("background","red").delay(2000);}'
    js += 'else{$("[id$=' + sid + ']").find("[class=mute-img]").css("background","green").delay(2000);}'
    js += '$("[id$=' + sid + ']").find("[class=mute-link]").enable.delay(4000);'
    
    init_style = "float: right; background: " + color + "; margin-right: -10px;"
    link_to_function image_tag('/microphone.png', :style => init_style , :class => "mute-img" ), js, :class => "mute-link"
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
