os.loadAPI("iMail/apis/iMail.lua")
os.loadAPI("iMail/apis/lEncrypt.lua")
while (true) do
    iMail.serverReceive()
end