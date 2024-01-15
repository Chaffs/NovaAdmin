local players = game:GetService("Players")
local player = players.LocalPlayer
local commands = require(game:GetService("ReplicatedStorage"):WaitForChild("(◣_◢)"):WaitForChild("CommandsClient"))
local remote = game:GetService("ReplicatedStorage"):WaitForChild("(◣_◢)"):FindFirstChildOfClass("RemoteFunction")
local tock = tick()

remote.OnClientInvoke = function(command, caller, args)
	table.remove(args, 1)
	
	task.spawn(function()
		task.wait(.1)
		commands[command](caller, args)
	end)
	
	return "Success"
end

player.CharacterAdded:Wait()

player.Character.ChildAdded:Connect(function(obj)
	if (obj:IsA("Tool") and obj.Name == "Delete") then
		local mouse = player:GetMouse()
		local equipped = false
		local selection = Instance.new("SelectionBox")
		selection.Color3 = Color3.fromRGB(255, 128, 0)
		selection.LineThickness = 0.02
		selection.Parent = workspace
		
		obj.Activated:Connect(function()
			remote:InvokeServer("delete", mouse.Target)
		end)
		
		obj.Equipped:Connect(function()
			mouse.Icon = "rbxasset://textures\\HammerCursor.png"
			
			equipped = true
			
			task.spawn(function()
				while equipped and task.wait() do
					if (obj.Parent == player.Character) then
						if mouse.Target ~= nil then
							selection.Adornee = mouse.Target
							mouse.Icon = "rbxasset://textures/HammerOverCursor.png"
						else
							selection.Adornee = nil
							mouse.Icon = "rbxasset://textures\\HammerCursor.png"
						end
					end
				end
			end)
		end)
		
		obj.Unequipped:Connect(function()
			mouse.Icon = ""
			
			equipped = false
		end)
	end
end)

task.spawn(commands["log"], nil, {"Client loaded in " .. tick() - tock .. "s"})