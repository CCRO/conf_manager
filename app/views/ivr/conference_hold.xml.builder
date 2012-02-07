xml.instruct!
xml.Response do
	xml.Gather(:action => @post_to, :numDigits => 4) do
		xml.Pause :length => 1
		xml.Say "To join a conference. Enter your 4 digit PIN number." 
		xml.Say "Press 9 to go to the root menu."
        xml.Pause :length => 5
        xml.Say "Sorry, We did not hear a response."
    end
    xml.Redirect @redirect_to
end