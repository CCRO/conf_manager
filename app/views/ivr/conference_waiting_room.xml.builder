xml.instruct!
xml.Response do
    xml.Say "Entering the waiting room."
    xml.Dial do
    	xml.Conference "CF827b8578e057de54bbb6263ed59410ad", :muted => false, :startConferenceOnEnter => false
    end
end