os.loadAPI("iMail/apis/iMail.lua")
local modem = iMail.getModem()
if (modem == false) then
    print("No Modem Present")
else
    rednet.open(modem)
    local CommandReceiver = multishell.launch({}, "iMail/programs/Service_CommandReceiver.lua")
    local InboxSender = multishell.launch({}, "iMail/programs/Service_InboxSender.lua")
    local incomingReceiver = multishell.launch({}, "iMail/programs/Service_incomingReceiver.lua")
    multishell.setTitle(CommandReceiver, "CommandReceiver")
    multishell.setTitle(InboxSender, "InboxSender")
    multishell.setTitle(incomingReceiver, "incomingReceiver")
    shell.run("iMail/programs/Server_Client.lua")
end