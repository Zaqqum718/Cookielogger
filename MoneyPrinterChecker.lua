httprequest = (syn and syn.request) or (http and http.request) or httprequest or (delta and delta.request) or request
HttpService = game:GetService("HttpService")
local model = game.Game.Local.droppable["Money Printer"]
local modelfolder = game.Game.Local.droppable
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local webhookUrl = "https://discord.com/api/webhooks/1255442005392363602/uK1uTr_9FnoNu7tI4_KY9eLA581qhBncq6tbLgA1YsPupX1pOwkSUttQzo2IS3PiYdE6"
local jobID = game.JobId
local printercount = 0

--이건 예전에 중1때 애들이랑 로블록스에서 핵으로 좀 놀때 남는 폰으로 돈벌려고 만든 핵 스크립트 입니다
--양심 찔리긴 한데; 그래도 뭐 보여드려야 해서 보여드립니다 
--teleport함수는 다른곳에서 참고한겁니다











local function teleport()

    PlaceId, JobId = game.PlaceId, game.JobId

    TeleportService = game:GetService("TeleportService")

    if httprequest then
        local servers = {}
        local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", PlaceId)})
        local body = HttpService:JSONDecode(req.Body)
        if body and body.data then
            for i, v in next, body.data do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
                    table.insert(servers, 1, v.id)
                end
            end
        end
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
        else

        end
    end
end


local embedData = {
    ["embeds"] = {{
        ["title"] = "머니프린터봇",
        ["description"] = "서버 아이디: " .. jobID .. "프린터 개수:" .. printercount,
        ["type"] = "rich",
        ["color"] = tonumber(0x00ff00)
    }}
}

local jsonData = HttpService:JSONEncode(embedData)

local httprequest = (syn and syn.request) or (http and http.request) or http_request or (delta and delta.request) or request

local headers = {
    ["Content-Type"] = "application/json"
}

local requestData = {
    Url = webhookUrl,
    Method = "POST",
    Headers = headers,
    Body = jsonData
}

if model then
    for ,object in ipairs(modelfolder:GetDescendants()) do
        if object.Name == "Money Printer" then
            printercount = printercount + 1
        end
    end
    httprequest(requestData)
    teleport()
else
    teleport()
end