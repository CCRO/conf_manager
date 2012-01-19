xml.instruct!
xml.Response do
    xml.Say "You entered in"
    sml.Say @digits
    xml.Say "This is where a succesful Conference would send you too"
    xml.Redirect @redirect_to
end