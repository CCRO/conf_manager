xml.instruct!
xml.Response do
    xml.Dial do
    	xml.Conference @conf_to_join, :muted => false, :startConferenceOnEnter => true, :beep => true
    end
end