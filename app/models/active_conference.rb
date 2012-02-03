class ActiveConference < ActiveRecord::Base
  has_many :active_calls
  
  validates :sid, :uniqueness => true
  
  def self.update_all_participant_lists
    
  end
  
  def self.update_participant_list(conf_name)
    puts "test5"
    begin
      #create client
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
      
      #is the conf still active?
      conf_id = ActiveConference.where("friendly_name = ?",conf_name).first.id
      if conf_id.nil? or conf_id.blank?
        puts "test6"
        return false
      end
                
      #pull conference from web
      conference = client.account.conferences.list(:FriendlyName => conf_name,:status => 'in-progress')

      #loop throught he participants and 
      if !conference.empty?
        puts "test7"
          participants = conference[0].participants
          participants.list.each do |participant|
            caller = ActiveCall.where("sid = ?", participant.call_sid).first
            if  !caller.nil?
               puts "test8"
               conf_to_join = ActiveConference.find(conf_id)
               if !conf_to_join.nil?
                  puts "test9"
                  caller.active_conference = conf_to_join
               end
               puts "test10"
              caller.save
            end
          end#end participant.list.each
      end
    end #end begin  
    puts "test11"
  end # end update_participant_list
  
  def self.update_conference_list
    begin
      #create client
      client = Twilio::REST::Client.new( TwilioAccountSID , TwilioAuthToken)
      
      #http gets the active conference list from twilio
      conf_list = client.account.conferences.list(:status => 'in-progress')
      
      #build a call_list sid vector from twilio
      conf_web_sid_list = []
      conf_list.each do |web_conf|
        conf_web_sid_list << web_conf.sid     
      end
            
      #build an Active_Conference sid vector from the db
      conf_db_sid_list = []
      ActiveConference.all.each do |active_conf|
        conf_db_sid_list << active_conf.sid
      end
       
      #find confs in db and not in web list
      confs_to_remove = conf_db_sid_list - conf_web_sid_list
      
      #remove calls from db by sid
      if !confs_to_remove.empty?
        ActiveConference.destroy_all(:sid => confs_to_remove)
      end
      
      #find confs in web list but not db
      confs_to_add = conf_web_sid_list - conf_db_sid_list

      #add confs to the db, have to iterate through existing conf list, or make a web request per call
      conf_list.each do |web_conf|
        if confs_to_add.include?(web_conf.sid)
          #create the conf in the db
          added_conf = ActiveConference.new(
            :sid => web_conf.sid,
            :friendly_name => web_conf.friendly_name
          )
          added_conf.save

        end
      end #end conf_list.each

    end #end begin
  end #end update_conf_list
  
end #end class
