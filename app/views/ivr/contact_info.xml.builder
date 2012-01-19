xml.instruct!
xml.Response do
	xml.Pause :length => 1
    xml.Say "For more information about being active with the CCRO, email us at info, at, ccro, dot, org. or give us a call at 2 8 1. 8 2 5. 4 8 7 0."
    xml.Say "CCRO is located at 9 5 9 5."
    xml.Say "Six Pines Drive."
    xml.Say "Suite 8 3 4 0. In the Woodlands, Texas."
    xml.Say "Zipcode 7 7 3 8 0."
    xml.Pause :length => 1
    xml.Say "All of our members share the need for clear guidance towards today’s best practices that support their ongoing financial health and an outlook for sustainable growth."
    xml.Say "Our member companies are continuously improving themselves and our energy industry through CCRO practice development, publication, promotion, and training."
    xml.Pause :length => 1
    xml.Redirect @redirect_to
end