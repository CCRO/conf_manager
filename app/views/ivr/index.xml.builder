xml.instruct!
xml.Response do
	xml.Gather(:action => @post_to, :numDigits => 1) do
		xml.Say "Thank you for calling  C.C.R.O. The Committee of Chief Risk Officers."
        xml.Say "Press 1 to join a conference."
        xml.Say "Press 2 to hear our contact information."
        xml.Pause :length => 1
        xml.Say "The Committee of Chief Risk Officers is an independent non-profit corporation of member companies. CCRO is dedicated to the advancement of a broad range of best practices in the field of risk management, and its many associated fields including finance, accounting, operations and audit."
    	xml.Pause :length => 1
    end
    xml.Gather(:action => @post_to, :numDigits => 1) do
		xml.Say "Thank you for calling  C.C.R.O."
        xml.Say "Press 1 to join a conference."
        xml.Say "Press 2 to hear our contact information."
        xml.Pause :length => 1
        xml.Say "Meeting risk management challenges is at the core of the financial health and effectiveness of energy companies and of our energy industry overall."
        xml.Say "In its sixth year of business, the CCRO is today recognized in, and around the industry as a premier source for independent, expert practitioner knowledge and perspective."
    	xml.Pause :length => 1	
    end
    xml.Say "Sorry, We did not hear a response."
    xml.Redirect @redirect_to
end