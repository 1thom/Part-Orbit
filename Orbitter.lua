-- thom463s
-- Orbit
-- August 11, 2021

local RunService = game:GetService("RunService")

local Orbit = {}
local mtOrbit = {__index = Orbit}
local Maid = require(script.Parent.Maid)

local cos = math.cos
local sin = math.sin
local clock = os.clock

local IDContainer = {}

--default configs
local Configurations = {
	["Speed"] = 1,
	["YAxisSpeed"] = 5,
	["YAxisFrequency"] = 6,
	["YAxisPosition"] = 0,
	["Angle"] = 0,
	["Radius"] = 2,
}

local function Find(Table, target)
	local found = false
	for key, value in pairs(Table) do
		if key == target or value == target then
			found = true
			break
		end
	end
	return found
end

function Orbit.new(origin: BasePart, part: BasePart, configs)
	local self = {}
	
	local configurations = configs
	for key, value in pairs(Configurations) do
		if not Find(configurations, key) then
			configurations[key] = value
		end
	end
	
	print(configurations)
	
	local Origin = origin.CFrame
	local Angle = configurations["Angle"]
	
	self.maid = Maid.new()
	self.Speed = configurations["Speed"]
	self.RPS = math.pi * self.Speed

	self.maid:GiveTask(RunService.Heartbeat:Connect(
		function(dt)
			Angle = (Angle + dt * self.RPS) % (2 * math.pi)
			part.CFrame = Origin * CFrame.new(cos(Angle) * configurations["Radius"], configurations["YAxisPosition"] - cos(clock() * configurations["YAxisSpeed"] * math.pi) / configurations["YAxisFrequency"], sin(Angle) * configurations["Radius"])
		end))

	self.maid:GiveTask(origin:GetPropertyChangedSignal("CFrame"):Connect(
		function()
			Origin = origin.CFrame
		end))

	local ID = #IDContainer + 1
	IDContainer[ID] = self.maid
	print("Maid ID: "..ID)

	return setmetatable(self, mtOrbit), ID
end

function Orbit.IDStop(id)
	IDContainer[id]:Cleanup()
	IDContainer[id] = nil
	print("Cleared maid: "..id)
end

function Orbit:SetSpeed(speed: number)
	self.Speed = speed
	self.RPS *= self.Speed
end

function Orbit:Stop()
	self.maid:Cleanup()
	print("Cleared maid")
end

return Orbit
