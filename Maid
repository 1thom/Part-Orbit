-- parent this script under the Orbit module btw

-- SilentsReplacement
-- Maid
-- July 06, 2021

--[[
	Maid.new() --> Maid
	Maid.IsMaid(self : any) --> boolean 
	-- Only when accessed from an object created by Maid.new():
	
	Maid:AddTask(
		task : table | function | RBXScriptConnection,
		customCleanupMethod : string | nil
	) --> task
	Maid:IsDestroyed() --> boolean
	Maid:Destroy() --> nil
	Maid:Cleanup() --> nil
	Maid.DoCleaning = Maid.Cleanup
	Maid.GiveTask = Maid.AddTask
]]

local Maid = {}
Maid.__index = Maid

local LocalConstants = {
	DefaultMethods = {
		Disconnect = true,
		Destroy = true,
		DoCleaning = true,
		Cleanup = true
	},

	ErrorMessages = {
		InvalidArgument = "Invalid argument#%d to %s, expected %s, got %s",
		InvalidMethodCall = "Expected method %s to be called from an object of %s via :"
	}
}

local function GetDefaultMethod(tabl)
	for key, _ in pairs(tabl) do
		if LocalConstants.DefaultMethods[key] then
			return key
		end
	end
end

function Maid.new()
	return setmetatable({
		_tasks = {},
		_isDestroyed = false
	}, Maid)
end

function Maid.IsMaid(self)
	return getmetatable(self) == Maid
end

function Maid:AddTask(task, customCleanupMethod)
	assert(
		Maid.IsMaid(self), 
		LocalConstants.ErrorMessages.InvalidMethodCall:format("Maid:AddTask", "Maid")
	)
	assert(
		typeof(task) == "table" 
			or typeof(task) == "function" 
			or typeof(task) == "RBXScriptConnection", 
		LocalConstants.ErrorMessages.InvalidArgument:format(
			1, 
			"Maid:AddTask", 
			"table or function or RBXScriptConnection", 
			typeof(task)
		)
	)

	if customCleanupMethod then
		assert(
			typeof(customCleanupMethod) == "string" or customCleanupMethod == nil, 
			LocalConstants.ErrorMessages.InvalidArgument:format(
				2, 
				"Maid:AddTask", 
				"string or nil", 
				typeof(customCleanupMethod)
			)
		)
	end

	if typeof(task) == "table" then
		task = {task, customCleanupMethod}
	end

	table.insert(self._tasks, task)

	return task
end

function Maid:IsDestroyed()
	assert(
		Maid.IsMaid(self), 
		LocalConstants.ErrorMessages.InvalidMethodCall:format("Maid:IsDestroyed", "Maid")
	)

	return self._isDestroyed
end

function Maid:Destroy()
	assert(
		Maid.IsMaid(self), 
		LocalConstants.ErrorMessages.InvalidMethodCall:format("Maid:Destroy", "Maid")
	)

	self:Cleanup()
	self._isDestroyed = true
end

function Maid:Cleanup()
	assert(
		Maid.IsMaid(self), 
		LocalConstants.ErrorMessages.InvalidMethodCall:format("Maid:Cleanup", "Maid")
	)

	for _, task in ipairs(self._tasks) do
		if typeof(task) == "function" then
			task()

		elseif typeof(task) == "RBXScriptConnection" then
			task:Disconnect()

		elseif typeof(task) == "table" then
			local method = task[1][task[2]]

			if method then
				method(task[1])
			else
				local defaultMethod = task[1][GetDefaultMethod(task[1])]

				if defaultMethod then
					defaultMethod(task[1])
				end
			end
		end
	end

	self._tasks = {}
end

Maid.DoCleaning = Maid.Cleanup
Maid.GiveTask = Maid.AddTask

return Maid
