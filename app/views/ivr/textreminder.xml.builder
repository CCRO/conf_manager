xml.instruct!
xml.Response do
    xml.Gather(:action => @post_to, :numDigits => 1) do
        xml.Say "press 1 to repeat. 2 for directions. Or 3 to hang up."
    end
end