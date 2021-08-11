# Part-Orbit
basically makes a part orbit around another part. specially coded for tf2 unusual effects on roblox

# API
Variant Orbit.new(Instance origin, Instance orbittingPart) -> function that makes the orbittingPart orbit around the origin part

void Orbit.IDStop(int ID) -> executing the .new function also creates an ID for the maid so you can stop the orbitting afterwards. The ID should be printed out in the output.

void Orbit:Stop() -> Stop Rotation.

void Orbit:SetSpeed(speed: number) -> Set rotation speed.
