xml.instruct!
xml.Response do
    xml.Say "We are sorry. We did not find a conference matching that PIN number."
    xml.Redirect @redirect_to
end