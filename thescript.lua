local antiCheatBypassed = false

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


local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
	Name = "DXLR Hub",
	LoadingTitle = "DXLR's Combat Warriors Hub",
	LoadingSubtitle = "by zylex",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil, -- Create a custom folder for your hub/game
		FileName = "DXLR HUB"
	}

local Tab = Window:CreateTab("Combat Warriors", 4483362458)
local Tab2 = Window:CreateTab("Credits", 4483362458)
local Tab3 = Window:CreateTab("Misc", 4483362458)

local Section = Tab:CreateSection("Auto Parry")

local Button = Tab:CreateButton({
	Name = "Enable Auto/Anti Parry",
	Callback = function()
        autoParry()
		Rayfield:Notify({
            Title = "Cheat Activated",
            Content = "Auto/Anti Parry has been Enabled.",
            Duration = 5,
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

local Section = Tab:CreateSection("Weapon Hitbox Modifiers")

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

local Section = Tab:CreateSection("Anti Cheat Bypassers")

local Button = Tab:CreateButton({
	Name = "Bypass Anti Cheat",
	Callback = function()
        if antiCheatBypassed == false then
            bypassAnticheat()
            antiCheatBypassed = true
            Rayfield:Notify({
                Title = "Anti Cheat Bypassed",
                Content = "Combat Warriors anti cheat successfully disabled.",
                Duration = 6.5,
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

local Section = Tab3:CreateSection("Destruction")
local Button = Tab3:CreateButton({
	Name = "Destroy GUI",
	Callback = function()
        Rayfield:Destroy()
	end,
})
