repeat task.wait() until game:IsLoaded()

local npcName = "Janus"

local function serverHop()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local PlaceId = game.PlaceId
    local serversUrl = "https://roblox.com" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(serversUrl))
    end)
    
    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, game.Players.LocalPlayer)
                end)
                task.wait(1)
            end
        end
    end
end

local function checkJanus()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == npcName then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "NPC Encontrado!",
                Text = "Janus está neste servidor!",
                Duration = 15
            })
            return true
        end
    end
    return false
end

task.wait(2)
if not checkJanus() then
    serverHop()
end