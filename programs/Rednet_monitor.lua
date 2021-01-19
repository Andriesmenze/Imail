Rednet_Monitor_VERSION = "1.4"
os.loadAPI("iMail/apis/iMail.lua")
rednet.open(iMail.getModem())
term.clear()
term.setCursorPos(1, 1)
print("Rednet Monitor V"..Rednet_Monitor_VERSION.." (API : "..iMail.iMail_VERSION..")")
print("")
while (true) do
    a, b, c = rednet.receive()
    print("Source : "..a)
    print("Protocol : "..c)
    print("Data : "..tostring(b))
    print("")
end