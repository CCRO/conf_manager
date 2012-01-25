class IvrController < ApplicationController
#ivr root, landing page for phone system
  
  #perfect
  def index
    @post_to = BASE_URL + '/ivr/handle_user_input_from_ivr'
    @redirect_to = BASE_URL + '/ivr/index'
    render :action => "index.xml.builder", :layout => false    
  end
  
  #perfect
  #handle input from the ivr
  def handle_user_input_from_ivr    
    #if 1 was pressed
    if params['Digits'] == '1'
      #go to conference_hold
      redirect_to :action => 'conference_hold'
      return
    end
    
    #if 2 was pressed
    if params['Digits'] == '2'
      #go to contact info
      redirect_to :action => 'contact_info'
      return
    end
    
    #if 3 was pressed
    if params['Digits'] == '3'
      #go to address
      redirect_to :action => 'address'
      return
    end
    
    #bad or no input
    redirect_to :action => 'index'
  end
  
  #perfect
  #says contact info then redirects to the ivr root 
  def contact_info 
    @redirect_to = BASE_URL + '/ivr/index'
    render :action => "contact_info.xml.builder", :layout => false 
  end
  
  #perfect
  #says address then redirects to the ivr root 
  def address 
    @redirect_to = BASE_URL + '/ivr/index'
    render :action => "address.xml.builder", :layout => false 
  end
  
  #asks for pin, then posts to conference Join
  def conference_hold
    @post_to = BASE_URL + '/ivr/conference_join'
    @redirect_to = BASE_URL + '/ivr/conference_hold'
    render :action => "conference_hold.xml.builder", :layout => false 
  end
  
  #menu for the conference system
  def conference_join
    #checks if caller wants to return to root menu
    if params['Digits'] == '9'
      redirect_to :action => "index"
      return
    end
    
    #park the call in the Waiting Room
    if params['Digits'] == '7'
      redirect_to :action => "conference_waiting_room"
      return
    end
    
    
    #checks if pin is exists and is long enough
    if !params['Digits'] or params['Digits'].length != 4
      redirect_to :action => "conference_join_failed"
      return      
      #render :action => "conference_join_failed.xml.builder", :layout => false 
      #return
    end
 
    #checks if pin exists in the list of conferences
    conf_to_join = Conference.where("pin = ?", params['Digits'] ).first
    if conf_to_join.nil
      redirect_to :action => "conference_join_failed"
      return 
    else
       @conf_to_join = conf_to_join.confname
       render :action => "conference_join.xml.builder", :layout => false 
       return
    end
  end
  
  def conference_join_failed
    @redirect_to = BASE_URL + '/ivr/conference_hold'
    render :action => "conference_join_failed.xml.builder"
  end
  
  def conference_waiting_room
    render :action => "conference_waiting_room.xml.builder"
  end
  
  def hangup
     render :action => "hangup.xml.builder", :layout => false
  end

end
