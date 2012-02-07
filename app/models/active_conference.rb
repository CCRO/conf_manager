class ActiveConference < ActiveRecord::Base
  has_many :active_calls
  
  validates :sid, :uniqueness => true
  
  def self.update_all_participant_lists
    conferences = all
    conferences.each do |conf|
      update_participant_list(conf.friendly_name)
    end unless conferences.nil?
  end
  
  def self.update_participant_list(conf_name)
    begin
      #create client
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken, :ssl_verify_peer => false)
      
      #is the conf still active?
      the_conf = where("friendly_name = ?",conf_name).first
      if the_conf.nil? 
        return false
      end
      
      conf_id = the_conf.id
      if conf_id.nil? or conf_id.blank?
        return false
      end
      
      #get the list of participants in the conference
      old_part_list = []
      find(conf_id).active_calls.each do |call|
        old_part_list << call.sid
      end          
      
      #pull conference from web
      conference = client.account.conferences.list(:FriendlyName => conf_name,:status => 'in-progress')
      

      #loop throught he participants and update the calls.
      participants = conference[0].participants unless conference.empty?
      participants.list.each do |participant|
        caller = ActiveCall.where("sid = ?", participant.call_sid).first
        if  !caller.nil?
           conf_to_join = find(conf_id)
           if !conf_to_join.nil?
              caller.active_conference = conf_to_join
              caller.save
           end
        end
      end unless participants.nil? #end participant.list.each

      
      #get the updated list
      new_part_list = []
      find(conf_id).active_calls.each do |call|
        new_part_list << call.sid
      end
      
      #disasociate the outdated calls
      part_to_remove = old_part_list - new_part_list
      
      part_to_remove.each do |part_sid|
        call = ActiveCall.where("sid = ?",part_sid).first
        #check to see if the call is still active
        if !call.nil?
          #check if the call moved to a different conference
          if call.active_conference == the_conf
            #removed the calls from the conference
            call.active_conference = nil
          end
        end
      end
      
    end #end begin  
  end # end update_participant_list
  
  def self.update_conference_list
    begin
      #create client
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken, :ssl_verify_peer => false)
      
      #http gets the active conference list from twilio
      conf_list = client.account.conferences.list(:status => 'in-progress')
      
      #build a call_list sid vector from twilio
      conf_web_sid_list = []
      conf_list.each do |web_conf|
        conf_web_sid_list << web_conf.sid     
      end
            
      #build an Active_Conference sid vector from the db
      conf_db_sid_list = []
      conf_db_sid_list = select(:sid).map { |c| c.sid } unless (select(:sid).nil? or select(:sid).empty?)
       
      #find confs in db and not in web list
      confs_to_remove = conf_db_sid_list - conf_web_sid_list
      
      #remove calls from db by sid
      if !confs_to_remove.empty?
        destroy_all(:sid => confs_to_remove)
      end
      
      #find confs in web list but not db
      confs_to_add = conf_web_sid_list - conf_db_sid_list

      #add confs to the db, have to iterate through existing conf list, or make a web request per call
      conf_list.each do |web_conf|
        if confs_to_add.include?(web_conf.sid)
          #create the conf in the db
          added_conf = new(
            :sid => web_conf.sid,
            :friendly_name => web_conf.friendly_name
          )
          added_conf.save

        end
      end #end conf_list.each

    end #end begin
  end #end update_conf_list
  
end #end class
