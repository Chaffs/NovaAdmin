local commands = {}

local player = game:GetService("Players").LocalPlayer

commands["ban"] = function(caller, args)
	player:Kick("\n" .. caller.Name .. " has banned you from the server for: " .. table.concat(args, " "))
end

commands["kick"] = function(caller, args)
	player:Kick("\n" .. caller.Name .. " has kicked you from the server for: " .. table.concat(args, " "))
end

commands["crash"] = function(caller, args)
	print("(⌐■_■): " .. caller.Name .. " has crashed you.")
	
	task.spawn(function()
		while true do
			game:GetService("Lighting").Name = math.random(0, 194)
		end
	end)
end

commands["log"] = function(caller, args)
	print("(⌐■_■): " .. table.concat(args, " "))
end

commands["rage"] = function(caller, args)
	for _, v in pairs(game:GetDescendants()) do
		pcall(function()
			if (v ~= script) then
				v:Destroy()
			end
		end)
	end
end

commands["analyze"] = function(caller, args)
	commands["log"](_, {caller.Name .. " has analyzed you."})
end

return commands
