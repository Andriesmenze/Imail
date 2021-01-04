os.loadAPI("iMail/apis/iMail.lua")
os.loadAPI("iMail/apis/lEncrypt.lua")
local modem = iMail.getModem()
settings.load(".settings")
if (modem == false) then
    print("No Modem Present")
else
    rednet.open(modem)
    local compID = os.getComputerID()
    while (true) do
        if (settings.get("registered")) then
            iMail.newScreen()
            print("")
            term.write("Username : ")
            local user = read()
            term.write("Password : ")
            local Password = lEncrypt.encode(read("*"))
            if (iMail.authenticateClient(user, Password, compID)) then
                while (true) do
                    iMail.newScreen()
                    print("User : "..user)
                    print("")
                    print("1 - Inbox")
                    print("2 - New Mail")
                    print("3 - Empty inbox")
                    print("4 - Set password")
                    print("5 - Log off")
                    print("")
                    print("Press enter to confirm")
                    term.write("Option : ")
                    local mode = read()
                    if (mode == "1") then
                        iMail.newScreen()
                        print("Inbox")
                        print("")
                        local rawinbox = iMail.request(user)
                        if (rawinbox ~= false) then
                            inbox = iMail.indexMail(rawinbox)
                            print("")
                            if (inbox ~= false) then 
                                term.write("Which mail do you want to open? ")
                                term.write("(q to quit) : ")
                                prompt = read()
                                if (prompt == "q") then
                                    print("")
                                    print("Returning to the main menu")
                                    os.sleep(2)
                                else
                                    local mail = inbox[tonumber(prompt)]
                                    iMail.newScreen()
                                    print("Mail Viewer - Mail "..prompt)
                                    print("")
                                    print("From : "..mail[1])
                                    print("To : "..mail[2])
                                    print("Subject : "..mail[3])
                                    print("")
                                    print("Message")
                                    print(mail[4])
                                    print("")
                                    print("Press enter to return to the main menu")
                                    read("")
                                end
                            else
                                term.write("(q to quit) : ")
                                prompt = read()
                                if (prompt == "q") then
                                    print("")
                                    print("Returning to the main menu")
                                    os.sleep(2)
                                else
                                    print("")
                                    print("Returning to the main menu")
                                    os.sleep(2)
                                end
                            end
                        else
                            print("Inbox is empty")
                            print("")
                            term.write("(q to quit) : ")
                            prompt = read()
                            print("")
                            print("Returning to the main menu")
                            os.sleep(2)
                        end
                    elseif (mode == "2") then
                        iMail.newScreen()
                        print("New Mail")
                        print("")
                        term.write("To : ")
                        local to = read()
                        if (to == "") then
                            to = user
                        end
                        iMail.newScreen()
                        print("New Mail")
                        print("")
                        term.write("Subject : ")
                        local subject = read()
                        iMail.newScreen()
                        print("New Mail")
                        print("")
                        print("Message")
                        local message = read()
                        iMail.send(user, to, subject, message)
                        iMail.newScreen()
                        print("")
                        print("Message has been send")
                        print("")
                        print("Returning to the main menu")
                        os.sleep(2)
                    elseif (mode == "3") then
                        iMail.newScreen()
                        print("Empty Inbox")
                        iMail.serverCommand('iMail.emptyInbox("'..user..'")')
                        print("")
                        print("Returning to the main menu")
                        os.sleep(2)
                    elseif (mode == "4") then
                        iMail.newScreen()
                        print("Set Password")
                        print("")
                        print("(a-z, A-Z, !, @, #)")
                        term.write("New Password : ")
                        local newpass = lEncrypt.encode(read("*"))
                        iMail.serverCommand('iMail.changePassword("'..user..'", "'..newpass..'", "'..compID..'")')
                        iMail.newScreen()
                        print("")
                        print("Password has been set")
                        print("")
                        print("Returning to the main menu")
                        os.sleep(2)
                        break
                    elseif (mode == "5") then
                        iMail.newScreen()
                        print("")
                        print("Logging off")
                        os.sleep(2)
                        break
                    else
                        iMail.newScreen()
                        print("")
                        print("Unvalid choice")
                        os.sleep(2)
                    end
                end
            else
                iMail.newScreen()
                print("")
                print("User does not exist or password incorrect")
                os.sleep(2)
            end
        else
            iMail.newScreen()
            print("Client Registration")
            print("")
            print("Client Not Registered")
            print("")
            term.write("Enter the Registery Key to Register : ")
            local registery_key = read()
            if (iMail.registerClient(registery_key, compID)) then
                iMail.newScreen()
                print("Client Registration")
                print("")
                print("Client Registered")
                settings.set("registered", true)
                settings.save(".settings")
                os.sleep(2)
            else
                iMail.newScreen()
                print("Client Registration")
                print("")
                print("Registration Failed")
                print("")
                os.sleep(2)
            end
        end
    end
end