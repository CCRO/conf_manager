xml.instruct!
xml.Response do
	xml.Pause :length => 1
    xml.Say "CCRO is located at 9 5 9 5."
    xml.Say "Six Pines Drive."
    xml.Say "Suite 8 3 4 0. In the Woodlands Texas."
    xml.Say "Zipcode 7 7 3 8 0."
    xml.Pause :length => 1
    xml.Redirect @redirect_to
end