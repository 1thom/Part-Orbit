-- thom463s
-- Orbit
-- August 11, 2021

local RunService = game:GetService("RunService")

local Orbit = {}
local mtOrbit = {__index = Orbit}
local Maid = require(script.Maid)

local Radius = 2
local cos = math.cos
local sin = math.sin
local clock = os.clock

local IDContainer = {}

function Orbit.new(origin, part: Instance)
	local originCFrame = origin.CFrame
	local self = {}
	
	self.maid = Maid.new()
	self.Origin = originCFrame
	self.RPS = math.pi
	self.Angle = 0
	
	self.maid:GiveTask(RunService.Heartbeat:Connect(
		function(dt)
			self.Angle = (self.Angle + dt * self.RPS) % (2 * math.pi)
			part.CFrame = self.Origin * CFrame.new(cos(self.Angle) * Radius, 0 - cos(clock() * 5 * math.pi) / 6, sin(self.Angle) * Radius)
		end))

	self.maid:GiveTask(origin:GetPropertyChangedSignal("CFrame"):Connect(
		function()
			self.Origin = origin.CFrame
		end))
	
	local ID = #IDContainer + 1
	IDContainer[ID] = self.maid
	print("Maid ID: "..ID)
	
	return setmetatable(self, mtOrbit)
end

function Orbit.IDStop(id)
	IDContainer[id]:Cleanup()
	IDContainer[id] = nil
	print("Cleared maid #"..id)
end

function Orbit:Stop()
	self.maid:Cleanup()
end

return Orbit
