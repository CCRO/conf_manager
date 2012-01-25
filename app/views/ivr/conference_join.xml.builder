xml.instruct!
xml.Response do
    xml.Say "Joining conference"
    xml.Say @conf_to_join
    xml.Dial do
    	xml.Conference @conf_to_join, :muted => true, :startConferenceOnEnter => true, :beep => true
    end
end