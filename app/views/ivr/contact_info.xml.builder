xml.instruct!
xml.Response do
	xml.Pause :length => 1
    xml.Say "For more information about being active with the CCRO, visit our website, CCRO. dot. org."
    xml.Say "Email us at info, at, CCRO. dot. org. or give us a call at 2 8 1. 8 2 5. 4 8 7 0."
    xml.Pause :length => 1
    xml.Redirect @redirect_to
end