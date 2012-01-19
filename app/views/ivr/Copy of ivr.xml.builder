xml.instruct!
xml.Response do
    xml.Gather(:action => @post_to, :numDigits => 1) do
        xml.Say "Welcome to the C.C.R.O conference channel."
        xml.Say "Press 1 to join a conference."
        xml.Say "press 2 to hear our address."
        xml.Say "press 3 to end the call."
    end
    xml.Play "http://hollow-rain-5753.herokuapp.com/mp3/NobleSissleEubieBlakeWaitinForTheEveningMail.mp3"
    xml.Say "Sorry, I didn't get a response."
    xml.Redirect @redirect_to
end