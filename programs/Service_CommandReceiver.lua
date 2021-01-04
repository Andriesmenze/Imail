os.loadAPI("iMail/apis/iMail.lua")
os.loadAPI("iMail/apis/lEncrypt.lua")
while true do
    local a, b, c = rednet.receive("serverCommand")
    local requesttable = textutils.unserialize(b)
    local requestid = requesttable[2]
    local command = assert(loadstring("return "..requesttable[1]))
    local status, rtn = pcall(command)
    rednet.broadcast(rtn, "serverCommandAwnser("..requestid..")")
end