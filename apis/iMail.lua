iMail_VERSION = "1.3"
function serializeToFile(mail, subject)
    local file = fs.open(subject,"w")
    file.write(textutils.serialize(mail))
    file.close()
end
function unserializeFromFile(mail)
    local file = fs.open(mail,"r")
    local data = file.readAll()
    file.close()
    return textutils.unserialize(data)
end
function getMail(user)
    local mails = {}
    local mailfiles = fs.list("Users/"..user)
    for _, file in ipairs(mailfiles) do
        local i = unserializeFromFile("Users/"..user.."/"..file)
        table.insert(mails, i)
    end
    return mails
end
function send(fromin, toin, subjectin, messagein)
    local mail = {}
    table.insert(mail, 1, fromin)
    table.insert(mail, 2, toin)
    table.insert(mail, 3, subjectin)
    table.insert(mail, 4, messagein)
    rednet.broadcast(textutils.serialize(mail), "sendIMail")
end
function sortMail(mailin)
    local mail = textutils.unserialize(mailin)
    local user = mail[2]
    local filename = mail[3]
    local currentInbox = fs.list("Users/"..user)
    if (fs.exists("Users/"..user.."/"..filename)) then
        local duplicatecode = 1
        while true do
            if (fs.exists("Users/"..user.."/"..filename.."("..duplicatecode..")")) then
                duplicatecode = duplicatecode + 1
            else
                break
            end
        end
        finalfilename = "Users/"..user.."/"..filename.."("..duplicatecode..")"
    else
        finalfilename = "Users/"..user.."/"..filename
    end
    local file = fs.open(finalfilename,"w")
    file.write(textutils.serialize(mailin))
    file.close()
end
function serverReceive()
    local a, b, c = rednet.receive("sendIMail")
    sortMail(b)
end
function request(user)
    rednet.broadcast(user, "requestIMail")
    while (true) do
        local a, b, c = rednet.receive("awnserIMail")
        local awnser = textutils.unserialize(b)
        if (awnser[1] == user) then
            if awnser[2] ~= false then
                local mails = awnser[2]
                return mails
            else
                return false
            end
        end
    end
end
function awnser(userin)
    local awnser = {}
    table.insert(awnser, 1, userin)
    if fs.exists("Users/"..userin) then
        local mail = getMail(userin)
        table.insert(awnser, 2, mail)
        rednet.broadcast(textutils.serialize(awnser), "awnserIMail")
    else
        table.insert(awnser, 2, false)
        rednet.broadcast(textutils.serialize(awnser), "awnserIMail")
    end
end
function indexMail(rawinbox)
    index = 1
    inbox = {}
    if next(rawinbox) == nil then
        print("Inbox is empty")
        return false
    else
        for _, mail in pairs(rawinbox) do
            mail = textutils.unserialize(mail)
            print(tostring(index).." - From "..mail[1].." Subject "..mail[3])
            table.insert(inbox, index, mail)
            index = index + 1
        end
        return inbox
    end
end
function newScreen()
    term.clear()
    term.setCursorPos(1, 1)
    print("IMail Client V"..iMail_VERSION)
end
function emptyInbox(user)
    local mails = fs.list("Users/"..user)
    for _, file in pairs(mails) do
        if (fs.exists("Users/Garbage/"..user.."/"..file)) then
            local duplicatecode = 1
            while true do
                if (fs.exists("Users/Garbage/"..user.."/"..file.."("..duplicatecode..")")) then
                    duplicatecode = duplicatecode + 1
                else
                    break
                end
            end
            fs.move("Users/"..user.."/"..file, "Users/Garbage/"..user.."/"..file.."("..duplicatecode..")")
        else
            fs.move("Users/"..user.."/"..file, "Users/Garbage/"..user.."/"..file)
        end
    end
    return true
end
function getModem()
    local devices = peripheral.getNames()
    for _, device in pairs(devices) do
        if (peripheral.getType(device) == "modem") then
            modem_present = true
            return device
        end
    end
    if (modem_present ~= true) then
        return false
    end
end
function authenticateClient(user, password, senderid)
    requestid = iMail.serverCommand("iMail.authenticateServer('"..user.."', '"..password.."', '"..senderid.."')")
    a, b, c = rednet.receive("serverCommandAwnser("..requestid..")")
    return b
end
function authenticateServer(user, password, senderid)
    password = lEncrypt.decode(password, senderid)
    if (password ~= false) then
        password = lEncrypt.encode(password)
        if (user == "Admin") then
            settings.load(".settings")
            local passonfile = settings.get("Admin")
            if (password == passonfile) then
                return true
            else
                return false
            end
        else
            if (fs.exists("Users/"..user)) then
                settings.load(".settings")
                local passonfile = settings.get(user)
                if (password == passonfile) then
                    return true
                else
                    return false
                end
            else
                return false
            end
        end
    else
        return false
    end
end
function serverCommand(command)
    local requestid = tostring(math.random(999))
    local requesttable = {}
    table.insert(requesttable, 1, command)
    table.insert(requesttable, 2, requestid)
    request = textutils.serialize(requesttable)
    rednet.broadcast(request, "serverCommand")
    return requestid
end
function changePassword(user, password, senderid)
    password = lEncrypt.decode(password, senderid)
    password = lEncrypt.encode(password)
    settings.set(user , password)
    settings.save(".settings")
    return true
end
function decryptTest(datastring, senderid)
    if (lEncrypt.decode(datastring, tonumber(senderid)) == "True") then
        return true
    else
        return false
    end
end
function registerClientAtServer(datastring ,senderid, session_id)
    settings.load(".settings")
    local registery_key = settings.get("Registery_key")
    local step_1 = tonumber(datastring)/tonumber(session_id)
    local step_2 = step_1+tonumber(registery_key)
    settings.set(senderid, step_2)
    settings.save(".settings")
    return true
end
function registerClient(registery_key, senderid)
    settings.load(".settings")
    local client_key = settings.get("key")
    local session_id = tostring(math.random(999))
    local step_1 = client_key-tonumber(registery_key)
    local step_2 = step_1*tonumber(session_id)
    local requesttable = {}
    table.insert(requesttable, 1, "iMail.registerClientAtServer('"..step_2.."', '"..senderid.."', '"..session_id.."')")
    table.insert(requesttable, 2, session_id)
    request = textutils.serialize(requesttable)
    rednet.broadcast(request, "serverCommand")
    a, b, c = rednet.receive("serverCommandAwnser("..session_id..")")
    if (b == true) then
        local test_string = lEncrypt.encode("True")
        local check_id = iMail.serverCommand("iMail.decryptTest('"..test_string.."', '"..senderid.."')")
        d, e, f = rednet.receive("serverCommandAwnser("..check_id..")")
        return e
    else
        return false
    end
end
function createUser(username)
    settings.set(username, "")
    settings.save(".settings")
    fs.makeDir("Users/"..username)
end