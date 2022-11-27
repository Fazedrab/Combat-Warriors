--Status Variables (Used Once)
local antiCheatBypassed = false
local emotesUnlocked = false

--getRemote Variables and functions
local network
local remotes_table
local events_table
local remotes
function defineRemotes()
 network = rawget(nevermore_modules, "Network") -- network is the place where the remote handling shit is
 remotes_table = getupvalue(getsenv(network).GetEventHandler, 1)
 events_table = getupvalue(getsenv(network).GetFunctionHandler, 1)
 remotes = {}
    table.foreach(remotes_table, function(i,v)
        if rawget(v, "Remote") then
            remotes[rawget(v, "Remote")] = i
        end
    end)
    
    table.foreach(events_table, function(i,v)
        if rawget(v, "Remote") then
            remotes[rawget(v, "Remote")] = i
        end
    end)
end


--Utility Functions
--Gets remote by name
function getRemote(name)
    for i,v in pairs(remotes) do
        if i.Name == name then
            return i
        end
    end
end

function bypassAnticheat()
    local fw = require(game.ReplicatedStorage.Framework.Nevermore);
syn_context_set(2)
local acc = fw("AntiCheatHandlerClient")
syn_context_set(7)
local func = acc.createNotification
hookfunc(func, function() return end)
local hook
hook = hookmetamethod(game, "__namecall", function(self, ...)
   if getnamecallmethod() == "FireServer" and self.Name == "LogKick" then
       return wait(9e9)
   end
   if getcallingscript() == "AntiCheatHandler" and getnamecallmethod() == "Destroy" then
       return wait(9e9)
   end
   if getnamecallmethod() == "Kick" and not checkcaller() then
       return wait(9e9)
   end
   
   return hook(self, ...)
end)
nhk = hookfunc(Instance.new, function(...)
   if getcallingscript() == "AntiCheatHandler" then
       return wait(9e9) end
   return nhk(...)
end)
lolz = hookfunc(task.spawn, function(...)
   if getcallingscript() == "AntiCheatHandler" then return wait(9e9) end
   if getcallingscript() == "AntiCheatHandlerClient" then return wait(9e9) end
   return lolz(...)
end)
syn_context_set(2)
local acc = fw("Flag")
syn_context_set(7)

local func = acc.setFlags
local func1 = acc.addFlags
local func2 = acc.getIsMaxed
local func3 = acc.getFlags
hookfunc(func, function() return wait(9e9) end)
hookfunc(func1, function() return wait(9e9) end)
hookfunc(func2, function() return wait(9e9) end)
hookfunc(func3, function() return wait(9e9) end)
syn_context_set(2)
hookfunc(string.format, function()
   if getcallingscript() == "AntiCheatHandler" then
       return
   end
end)
hookfunc(fw("AntiCheatHandler").punish, function()
   return;
end)
end

--Script Functions
function expandHitbox()
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()

    for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") then
            for i,v in pairs(v.Hitboxes.Hitbox:GetChildren()) do
                if v.Name == "DmgPoint" then
                v.Position = v.Position + Vector3.new(0, math.random(-2, 10), 0)
                v.Visible = true
                end
            end
        end
        end
end

function autoParry()
    local Magnitude = 15

    local players = game:GetService("Players")
    local client = players.LocalPlayer
    local camera = workspace.CurrentCamera

    local function iskeydown(enum)
    return game:GetService("UserInputService"):IsKeyDown(enum)
    end
    local function keyclick(enum)
    local vim = game:GetService("VirtualInputManager")
    return vim:SendKeyEvent(true, enum, false, game) and task.wait() and vim:SendKeyEvent(false, enum, false, game)
    end

    local function lookAt(character)
    spawn(function()
        for i=0, 1, 0.1  do
            local goal = camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, character.HumanoidRootPart.Position), i)
            camera.CFrame = goal
            task.wait()
        end
    end)
    end
    local function islooking(chr, sensitivity)
    return chr.HumanoidRootPart.CFrame.LookVector:Dot(client.Character.HumanoidRootPart.Position) >= sensitivity
    end

    function Update(plr : Player)
    if plr ~= client then
        local function onRespawn(chr)
            local tool;
            repeat
                task.wait()
                if chr:FindFirstChild("SemiTransparentShield") and chr:FindFirstChild("HumanoidRootPart") and chr:FindFirstChildOfClass("Tool") and chr:FindFirstChildOfClass("Tool"):FindFirstChild("Hitboxes") then
                    tool = chr:FindFirstChildOfClass("Tool")
                end
            until tool and tool:IsA("Tool") and tool:FindFirstChild("Hitboxes")
            print(plr.DisplayName..":)")

            do -- [[Auto Parry]]
                local function autoParry(child)
                    if client.Character:FindFirstChildOfClass("Tool") and client.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Hitboxes") and child:IsA("Sound") and not iskeydown(Enum.KeyCode.C) and child:IsA("Sound") and (chr.HumanoidRootPart.Position - client.Character.HumanoidRootPart.Position).Magnitude < Magnitude then
                        local looking = islooking(chr, 0.25)
                        if looking then
                            keyclick(Enum.KeyCode.F)
                        else
                            lookAt(chr)
                            keyclick(Enum.KeyCode.F)
                        end
                    end
                end

                if tool.Hitboxes:FindFirstChild("Hitbox") then
                    print("applied")
                    tool.Hitboxes.Hitbox.ChildAdded:Connect(autoParry)
                elseif tool.Hitboxes:FindFirstChild("Weapon1Hitbox") and tool.Hitboxes:FindFirstChild("Weapon2Hitbox") then
                    print("applied")
                    tool.Hitboxes.Weapon1Hitbox.ChildAdded:Connect(autoParry)
                    tool.Hitboxes.Weapon2Hitbox.ChildAdded:Connect(autoParry)
                end
            end

            do -- [[Anti Parry]]
                local function antiParry(child)
                    if child:IsA("Sound") and client.Character:FindFirstChildOfClass("Tool") and client.Character:FindFirstChildOfClass("Tool"):FindFirstChild("Hitboxes") and (chr.HumanoidRootPart.Position - client.Character.HumanoidRootPart.Position).Magnitude < Magnitude then
                        local looking = islooking(chr, 0.25)
                        if looking then
                            local tool = client.Character:FindFirstChildOfClass("Tool")
                            client.Character.Humanoid:UnequipTools()
                            chr.SemiTransparentShield:GetPropertyChangedSignal("Transparency"):Wait()
                            client.Character.Humanoid:EquipTool(tool)
                        end
                    end
                end
                chr.SemiTransparentShield.ChildAdded:Connect(antiParry)
            end
        end

        if plr.Character ~= nil then
            task.spawn(onRespawn, plr.Character)
        end
        plr.CharacterAdded:Connect(function(chr)
            warn('respawning', chr)
            task.spawn(onRespawn, chr)
        end)
    end
    end

    for _,v in next, players:GetPlayers() do
    task.spawn(Update, v)
    end
    players.PlayerAdded:Connect(function(plr)
    task.spawn(Update, plr)
    end)
end
function toClipboard(String)
	local clipBoard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
	if clipBoard then
		clipBoard(String)
		print('Clipboard','Copied to clipboard')
	else
		print('Clipboard',"Your exploit doesn't have the ability to use the clipboard")
	end
end

function unlockEmotes()
    for i,v in pairs(getgc(true)) do
        if typeof(v) == "table" and rawget(v, "gamepassIdRequired") then
            if v.gamepassIdRequired ==  "danceEmotes" then
                v.gamepassIdRequired = nil
            elseif v.gamepassIdRequired == "toxicEmotes" then
                v.gamepassIdRequired = nil
            elseif v.gamepassIdRequired == "respectEmotes" then
                v.gamepassIdRequired = nil
            end
        end
    end
end
function disableRagdoll()
    local val = true
    for i,v in pairs(getgc(true)) do
        if typeof(v) == "table" and rawget(v, "toggleRagdoll") then
            local old = v.toggleRagdoll
            v.toggleRagdoll = function(among, us, irl)
                if val then
                    return
                else
                    return old(among, us, irl)
                end
            end
        end
    end    
end
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
	Name = "DXLR Hub",
	LoadingTitle = "DXLR's Combat Warriors Hub",
	LoadingSubtitle = "by Zylex",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil, -- Create a custom folder for your hub/game
		FileName = "DXLR Hub"
	},
        Discord = {
        	Enabled = True,
        	Invite = "ryyqx9T9JM", -- The Discord invite code, do not include discord.gg/
        	RememberJoins = true -- Set this to false to make them join the discord every time they load it up
        },
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "DXLR HUB Hub",
		Subtitle = "Key System",
		Note = "Join the discord for the free key! (https://discord.gg/zsuHWTJeCD)",
		FileName = "DXLR HUB Key",
		SaveKey = true,
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = "pablozb284n*$93zs"
	}
})


local Tab = Window:CreateTab("Combat Warriors", 4483362458)
local Tab2 = Window:CreateTab("Credits", 4483362458)
local Tab3 = Window:CreateTab("Misc", 4483362458)

--Combat Modifiers Section
local Section = Tab:CreateSection("Combat")

--Auto Parry Button
local Button = Tab:CreateButton({
	Name = "Enable Auto Parry",
	Callback = function()
        autoParry()
		Rayfield:Notify({
            Title = "Cheat Activated",
            Content = "Auto/Anti Parry has been Enabled.",
            Duration = 1,
            Image = 4483362458,
            Actions = { -- Notification Buttons
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user tapped Okay!")
                    end
                },
            },
        })
	end,
})
--Hitbox Keybind
local Keybind = Tab:CreateKeybind({
	Name = "Hitbox Expander Keybind",
	CurrentKeybind = "V",
	HoldToInteract = false,
	Flag = "Keybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Keybind)
		expandHitbox()
	end,
})
local Label = Tab:CreateLabel("Make sure to equip the weapon before using the hitbox expander!")

local Button = Tab:CreateButton({
    Name = "Anti Ragdoll",
    Callback = function()
        disableRagdoll()
    end,
 })

 local Section = Tab:CreateSection("Essential")

local Button = Tab:CreateButton({
	Name = "Bypass Anticheat",
	Callback = function()
		if antiCheatBypassed == false then
            bypassAnticheat()
            antiCheatBypassed = true
        end
	end,
})

local Section = Tab:CreateSection("Misc")

local Button = Tab:CreateButton({
	Name = "Unlock All Emotes",
	Callback = function()
        if emotesUnlocked == false then
            unlockEmotes()
            emotesUnlocked = true
            Rayfield:Notify({
                Title = "All Emotes Unlocked!",
                Content = "Toxic, Respectful, and Dance emotes have been unlocked successfully!",
                Duration = 1,
                Image = 4483362458,
                Actions = { -- Notification Buttons
                    Ignore = {
                        Name = "Okay!",
                        Callback = function()
                            print("The user tapped Okay!")
                        end
                    },
                },
            })
        end

	end,
})

local Section = Tab2:CreateSection("Main")
local Label = Tab2:CreateLabel("Combat Warriors Hub Created By: Zylex")
local Section = Tab2:CreateSection("Contributors")
local Label = Tab2:CreateLabel("Auto/Anti Parry Created By: ydnac#2110 cuz idk")
local Label = Tab2:CreateLabel("Weapon Hitbox Expander Created By: Zylex")
local Label = Tab2:CreateLabel("Anti Cheat Bypass Created By: Zylex")

local Section = Tab3:CreateSection("Discord")
local Label = Tab3:CreateLabel("Check out our other scripts and request more games/features For DXLR HUB")
local Button = Tab3:CreateButton({
	Name = "Copy Discord Invite",
	Callback = function()
		toClipboard("https://discord.gg/ryyqx9T9JM")
	end,
})

local Section = Tab3:CreateSection("Destruction")
local Button = Tab3:CreateButton({
	Name = "Destroy GUI",
	Callback = function()
        Rayfield:Destroy()
	end,
})
