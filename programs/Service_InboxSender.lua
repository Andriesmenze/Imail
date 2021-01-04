os.loadAPI("iMail/apis/iMail.lua")
os.loadAPI("iMail/apis/lEncrypt.lua")
while (true) do
    local a, b, c = rednet.receive("requestIMail")
    iMail.awnser(b)
end