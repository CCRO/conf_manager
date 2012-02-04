class DashboardController < ApplicationController
  require 'twilio-ruby'
  layout 'dashboard'
  
  def index
    @contacts = Contact.all
    @conferences = Conference.all
  end
  
  def drop_into_waiting_room
    sid = params[:sid]
    
    if sid.nil?
      return
    end
    
    begin
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
      url = BASE_URL + '/ivr/conference_waiting_room'
      client.account.calls.get(sid).update({:url => url})
    end
  end
  
  def drop_sid_into_conf
    sid = params[:sid]
    conf_name = params[:conf_name] #this is already url safe as in conf-name-format
    
    if sid.nil? or conf_name.nil?
      return
    end
    
    begin
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
      url = BASE_URL + '/ivr/conference_join_by_name/?conf=' + conf_name
      client.account.calls.get(sid).update({:url => url})
    end
    
  end
  
  def hangup_call
    sid = params[:sid]
    
    if sid.nil?
      return
    end
    
    begin
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
      url = BASE_URL + '/ivr/hangup'
      client.account.calls.get(sid).update({:url => url})
    end
    render :nothing => true
  end
  
  def hangup_call_immediate
    sid = params[:sid]
    
    if sid.nil?
      return
    end
    
    begin
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
      url = BASE_URL + '/ivr/hangup_immediate'
      client.account.calls.get(sid).update({:url => url})
    end
    render :nothing => true
  end
  
  def mute_call
    sid = params[:sid]
    
    if sid.nil?
      return
    end
    
    begin
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
      client.account.calls.get(sid).update({:muted => 'true'})
    end
    render :nothing => true
  end
  
  def unmute_call
    sid = params[:sid]
    
    if sid.nil?
      return
    end
    
    begin
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
      client.account.calls.get(sid).update({:muted => 'false'})
    end
    render :nothing => true
  end
  
  def update_conference_participant_list
    #pull conf name from params
    @conf_name = params[:conf_name].to_s.gsub('-',' ')
    @conf_name_css_safe = params[:conf_name]
    @part_count = 0
    
    #confirm not nil
    if @conf_name.nil?
      return
    end
    
    begin
      #create client
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
      
      #pull conference 
      conference = client.account.conferences.list(:FriendlyName => @conf_name,:status => 'in-progress')
      
      #array to store the participants 
      @participants = Array.new
    
      if !conference.empty?
          #iterate through the conference list building the participant array
          participants = conference[0].participants
          participants.list.each do |participant|
            @participants << client.account.calls.get(participant.call_sid)
          end
          @part_count = @participants.count
      end  

    end

    #render default update_conference_neat_list
    respond_to do |format|
        format.html  {render :layout => false}
    end
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
      if @participants_hash[conference.confname].nil? or @participants_hash[conference.confname].empty?
         @empty_conf << conference.confname
      else
         @active_conf << conference.confname
      end     
    end
    
    respond_to do |format|
        format.html  {render :layout => false}
    end
  end
  
  def update_participant_list_from_db
    #passed in sidstr= &conf_name=
    sid_passed_in = params[:sidstr]
    @conf_name = params[:conf_name]
    
    #if no conference is sent in, do nothing
    if @conf_name.nil? or conf_name.blank?
      render :nothing => true
      return
    end
    
    #just in case
    if sid_passed_in.nil?
      sid_passed_in = ""
    end
    
    #split the sids into an array
    web_sid_list = []
    if !sid_passed_in.blank?
      web_sid_list = sid_passed_in.split('-')
    end
    
    @part_sid_list = []
    @part_count = 0
    
    conf = ActiveConference.where("friendly_name = ?",@conf_name).first
    if !conf.empty?
      @participants = conf.active_calls.all
      @participants.each do |part|
        @part_sid_list << part.sid
      end
      @part_count = @participants.count
    end
    
    @part_sid_to_remove = web_sid_list - @part_sid_list 
    
    respond_to do |format|
        format.html  {render :layout => false}
    end
  end
  
  def update_call_list_from_db
    #get sidlist passed in
    sid_passed_in = params[:sidstr]
    
    if sid_passed_in.nil?
      sid_passed_in = ""
    end
        
    sid_list = []
    
    #split the sids into an array
    if !sid_passed_in.blank?
      sid_list = sid_passed_in.split('-')
    end
    
    #build array of calls
    sid_from_db = []
    allcalls = ActiveCall.all
    allcalls.each do |dbcall|
      sid_from_db << dbcall.sid
    end
    
    #identify new calls, all the active calls minus what is already there
    new_sid_list = sid_from_db - sid_list
    @new_calls = ActiveCall.where(:sid => new_sid_list)
    
    #sid list to be removed, 
    @sid_to_remove = sid_list - sid_from_db
    
    @call_count = sid_from_db.count
        
    #sid list that is loaded into the hidden value
    @sid_list = sid_from_db.join('-')
    
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
