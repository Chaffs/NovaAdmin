local pers = {}

pers.remote = nil
pers.logging = false
pers.bans = {}

function pers:load(remote)
	pers.remote = remote
end

function pers:banLoop()
	for p, r in pairs(self.bans) do
		local plr = game:GetService("Players"):FindFirstChild(p)
		
		if (plr ~= nil) then
			self.remote:InvokeClient(plr, r)
		end
	end
end

function pers:log(message)
	print("(⌐■_■): " .. message)
	
end

return pers