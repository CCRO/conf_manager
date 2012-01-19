xml.instruct!
xml.Response do
    xml.Say "Entering the waiting room."
    xml.Dial do
    	xml.Conference "Waiting Room", :muted => false, :startConferenceOnEnter => false
    end
end