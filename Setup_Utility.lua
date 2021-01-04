Setup_VERSION = "2.0"
local success = false
function newScreen()
    term.clear()
    term.setCursorPos(1, 1)
    print("IMail Setup V"..Setup_VERSION)
end
while (true) do
    newScreen()
    print("")
    print("Choose Machine Type")
    print("")
    print("1 - iMail Client")
    print("2 - iMail Server")
    print("3 - Rednet Relay")
    print("4 - Rednet Monitor")
    print("")
    print("Press enter to confirm")
    term.write("Option : ")
    local mtype = read()
    if (mtype == "1") then
        while (true) do
            newScreen()
            print("")
            print("Choose Install Type")
            print("")
            print("1 - OS")
            print("2 - Application")
            print("")
            print("Press enter to confirm")
            term.write("Option : ")
            local itype = read()
            if (itype == "1") then
                fs.copy("disk/apis/iMail.lua", "iMail/apis/iMail.lua")
                fs.copy("disk/apis/lEncrypt.lua", "iMail/apis/lEncrypt.lua")
                fs.copy("disk/programs/Client.lua", "iMail/programs/Client.lua")
                os.loadAPI("iMail/apis/lEncrypt.lua")
                lEncrypt.genKey()
                if (fs.exists("startup.lua")) then
                    local startup = fs.open("startup.lua", "a")
                    startup.write("-- iMail --\n")
                    startup.write('shell.run("iMail/programs/Client.lua")\n')
                    startup.write("-- iMail --\n")
                    startup.close()
                else
                    local startup = fs.open("startup.lua", "w")
                    startup.write("-- iMail --\n")
                    startup.write('shell.run("iMail/programs/Client.lua")\n')
                    startup.write("-- iMail --\n")
                    startup.close()
                end
                newScreen()
                print("")
                print("Remove the install disk and press enter")
                read()
                print("Restarting in 3 seconds")
                os.sleep(3)
                os.reboot()
            elseif (itype == "2") then
                fs.copy("disk/apis/iMail.lua", "iMail/apis/iMail.lua")
                fs.copy("disk/apis/lEncrypt.lua", "iMail/apis/lEncrypt.lua")
                fs.copy("disk/programs/Client.lua", "iMail/programs/Client.lua")
                os.loadAPI("iMail/apis/lEncrypt.lua")
                lEncrypt.genKey()
                if (fs.exists("startup.lua")) then
                    local startup = fs.open("startup.lua", "a")
                    startup.write("-- iMail --\n")
                    startup.write('local iMail_Client = multishell.launch({}, "iMail/programs/Client.lua")\n')
                    startup.write('multishell.setTitle(iMail_Client, "iMail Client")\n')
                    startup.write("-- iMail --\n")
                    startup.close()
                else
                    local startup = fs.open("startup.lua", "w")
                    startup.write("-- iMail --\n")
                    startup.write('local iMail_Client = multishell.launch({}, "iMail/programs/Client.lua")\n')
                    startup.write('multishell.setTitle(iMail_Client, "iMail Client")\n')
                    startup.write("-- iMail --\n")
                    startup.close()
                end
                newScreen()
                print("")
                print("Remove the install disk and press enter")
                read()
                print("Restarting in 3 seconds")
                os.sleep(3)
                os.reboot()
            else
                newScreen()
                print("")
                print("Unvalid choice")
                os.sleep(2)
            end
        end
    elseif (mtype == "2") then
        fs.copy("disk/apis/iMail.lua", "iMail/apis/iMail.lua")
        fs.copy("disk/apis/lEncrypt.lua", "iMail/apis/lEncrypt.lua")
        fs.copy("disk/programs/Server.lua", "iMail/programs/Server.lua")
        fs.copy("disk/programs/Server_Client.lua", "iMail/programs/Server_Client.lua")
        fs.copy("disk/programs/Service_CommandReceiver.lua", "iMail/programs/Service_CommandReceiver.lua")
        fs.copy("disk/programs/Service_InboxSender.lua", "iMail/programs/Service_InboxSender.lua")
        fs.copy("disk/programs/Service_IncomingReceiver.lua", "iMail/programs/Service_IncomingReceiver.lua")
        os.loadAPI("iMail/apis/lEncrypt.lua")
        lEncrypt.genKey()
        if (fs.exists("startup.lua")) then
            local startup = fs.open("startup.lua", "a")
            startup.write("-- iMail --\n")
            startup.write('shell.run("iMail/programs/Server.lua")\n')
            startup.write("-- iMail --\n")
            startup.close()
        else
            local startup = fs.open("startup.lua", "w")
            startup.write("-- iMail --\n")
            startup.write('shell.run("iMail/programs/Server.lua")\n')
            startup.write("-- iMail --\n")
            startup.close()
        end
        newScreen()
        print("")
        print("Remove the install disk and press enter")
        read()
        print("Restarting in 3 seconds")
        os.sleep(3)
        os.reboot()
    elseif (mtype == "3") then
        newScreen()
        print("")
        if (fs.exists("startup.lua")) then
            local startup = fs.open("startup.lua", "a")
            startup.write("-- iMail --\n")
            startup.write('shell.run("repeat")\n')
            startup.write("-- iMail --\n")
            startup.close()
        else
            local startup = fs.open("startup.lua", "w")
            startup.write("-- iMail --\n")
            startup.write('shell.run("repeat")\n')
            startup.write("-- iMail --\n")
            startup.close()
        end
        print("Remove the install disk and press enter")
        read()
        print("Restarting in 3 seconds")
        os.sleep(3)
        os.reboot()
    elseif (mtype == "4") then
        fs.copy("disk/apis/iMail.lua", "iMail/apis/iMail.lua")
        fs.copy("disk/programs/Rednet_monitor.lua", "iMail/programs/Rednet_monitor.lua")
        while (true) do
            if (success == true) then
                break
            end
            newScreen()
            print("")
            print("Do you want the program to run on a external monitor?")
            print("")
            print("1 - Yes")
            print("2 - No")
            print("")
            print("Press enter to confirm")
            term.write("Option : ")
            local itype = read()
            if (itype == "1") then
                while (true) do
                    newScreen()
                    print("")
                    print("Select the monitor you want to use")
                    print("")
                    local monitors = {}
                    peripherals = peripheral.getNames()
                    for _, pSide in pairs(peripherals) do
                        if (peripheral.getType(pSide) == "monitor") then
                            table.insert(monitors, pSide)
                        end
                    end
                    for index, monitor in pairs(monitors) do
                        print(index.." - "..monitor)
                    end
                    print("")
                    print("Press enter to confirm")
                    term.write("Use monitor : ")
                    local monitor = tonumber(read())
                    if (monitors[monitor] ~= nil) then
                        if (fs.exists("startup.lua")) then
                            local startup = fs.open("startup.lua", "a")
                            startup.write("-- iMail --\n")
                            startup.write('shell.run("monitor '..monitors[monitor]..' iMail/programs/Rednet_monitor.lua")\n')
                            startup.write("-- iMail --\n")
                            startup.close()
                        else
                            local startup = fs.open("startup.lua", "w")
                            startup.write("-- iMail --\n")
                            startup.write('shell.run("monitor '..monitors[monitor]..' iMail/programs/Rednet_monitor.lua")\n')
                            startup.write("-- iMail --\n")
                            startup.close()
                        end
                        success = true
                        break
                    else
                        newScreen()
                        print("")
                        print("Unvalid choice")
                        os.sleep(2)
                    end
                end
            elseif (itype == "2") then
                if (fs.exists("startup.lua")) then
                    local startup = fs.open("startup.lua", "a")
                    startup.write("-- iMail --\n")
                    startup.write('shell.run("iMail/programs/Rednet_monitor.lua")\n')
                    startup.write("-- iMail --\n")
                    startup.close()
                else
                    local startup = fs.open("startup.lua", "w")
                    startup.write("-- iMail --\n")
                    startup.write('shell.run("iMail/programs/Rednet_monitor.lua")\n')
                    startup.write("-- iMail --\n")
                    startup.close()
                end
                break
            else
                newScreen()
                print("")
                print("Unvalid choice")
                os.sleep(2)
            end
        end
        newScreen()
        print("")
        print("Remove the install disk and press enter")
        read()
        print("Restarting in 3 seconds")
        os.sleep(3)
        os.reboot()
    else
        newScreen()
        print("")
        print("Unvalid choice")
        os.sleep(2)
    end
end