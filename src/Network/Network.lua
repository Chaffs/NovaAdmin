local network = {}

network.remote = nil

function network:_createListeners()
	self.remote.OnServerInvoke = function(player, dataType, ...)
		self.memory[dataType] = {...}
		
		if (dataType == "delete") then
			for _, v in pairs({...}) do
				v:Destroy()
			end
		end
	end
end

function network:new(remote)
	network.memory = {}
	network.remote = remote
	
	self:_createListeners()
end

function network:get(dataType)
	return self.memory[dataType]
end

return network