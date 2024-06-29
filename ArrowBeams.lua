-- Written by itsDenDenn 29/06/2024

--[[

This module was created to make the process of creating beams that point players to their objectives easier,

Documentation:

##
local Beam = arrowBeams.new(parent, properties)
This function creates a beam with the given arguments, if no parent is given the beam is parented to Terrain, if no properties are sent the beam gets the default properties.


Beam:setTarget(target)
The target argument can be a BasePart or a Vector3, if it is a Vector3 the Attachment will be parented to Terrain and given the right position in the world.

Beam:setAttachment0(target)
Sets the Attachment0 position to the target, it can be a Vector3 or a BasePart.

Beam:setAttachment1(target)
Sets the Attachment1 position to the target, it can be a Vector3 or a BasePart.

Beam:setTexture(textureID)
Sets the texture of the beam to the provided ID.

Beam:setParent(newParent)
Parents the beam to the instance provided.

Beam:Enable()
Enables the beam.

Beam:Disable()
Disables the beam.

Beam:resetDefault()
Resets the beam properties to the default values.

Beam:Destroy()
Destroys the beam completely.
##

]]

-- Variables

local arrowBeams = {}
arrowBeams.__index = arrowBeams

local defauleBeamProperties = {
	Enabled = true,
	Brightness = 1,
	LightEmission = 1,
	LightInfluence = 0,
	Texture = "rbxassetid://11552476728",
	TextureLength = 4,
	TextureSpeed = 3,
	Transparency = NumberSequence.new(0),
	ZOffset = 0,
	FaceCamera = true,
	CurveSize0 = 0,
	CurveSize1 = 0,
	Segments = 5,
	Width0 = 4,
	Width1 = 4
}

-- Functions

local function throwWarning(text)
	warn(`[ARROW BEAMS] {text}`)
end

--	[[ CONSTRUCTOR ]]
function arrowBeams.new(parent, properties)
	local self = setmetatable({
		Attachment0 = Instance.new("Attachment"),
		Attachment1 = Instance.new("Attachment"),
		Beam = Instance.new("Beam"),
		Parent = parent or workspace.Terrain
	}, arrowBeams)
	
	self:resetDefault()
	
	-- Set Custom properties if any are provided.
	if properties then
		for prop, value in properties do
			local done, failed = pcall(function()
				self.Beam[prop] = value
			end)

			if failed then
				throwWarning(failed)
			end
		end
	end
	--
	
	self.Attachment0.Parent = self.Parent
	self.Beam.Attachment0 = self.Attachment0
	self.Beam.Attachment1 = self.Attachment1
	self.Beam.Parent = self.Parent
	
	self:Enable()
	return self
end

function arrowBeams:setTarget(target)
	if typeof(target) == "Instance" then
		self.Attachment1.Parent = target
	elseif typeof(target) == "Vector3" then
		self.Attachment1.Parent = workspace.Terrain
		self.Attachment1.WorldCFrame = CFrame.new(target)
	else
		throwWarning(`{target.Name} is not a supported type.\nType: {typeof(target)}`)
	end
end

function arrowBeams:setAttachment0(target)
	if typeof(target) == "Instance" then
		self.Attachment0.Parent = target
	elseif typeof(target) == "Vector3" then
		self.Attachment0.Parent = workspace.Terrain
		self.Attachment0.WorldCFrame = CFrame.new(target)
	else
		throwWarning(`{target.Name} is not a supported type.\nType: {typeof(target)}`)
	end
end

function arrowBeams:setAttachment1(target)
	if typeof(target) == "Instance" then
		self.Attachment1.Parent = target
	elseif typeof(target) == "Vector3" then
		self.Attachment1.Parent = workspace.Terrain
		self.Attachment1.WorldCFrame = CFrame.new(target)
	else
		throwWarning(`{target.Name} is not a supported type.\nType: {typeof(target)}`)
	end
end

function arrowBeams:setTexture(textureID)
	local argType = typeof(textureID)
	
	if argType == "string" then
		self.Beam.Texture = textureID
	elseif argType == "number" then
		self.Beam.Texture = `rbxassetid://{textureID}`
	else
		throwWarning(`TextureID is not a valid ID. {argType}`)
	end
end

function arrowBeams:setParent(newParent)
	self.Parent = newParent
	self.Beam.Parent = self.Parent
end

function arrowBeams:Enable()
	self.Beam.Enabled = true
end

function arrowBeams:Disable()
	self.Beam.Enabled = false
end

function arrowBeams:resetDefault()
	for prop, value in defauleBeamProperties do
		local done, failed = pcall(function()
			self.Beam[prop] = value
		end)

		if failed then
			throwWarning(failed)
		end
	end
end

function arrowBeams:Destroy()
	self.Attachment0:Destroy()
	self.Attachment1:Destroy()
	self.Beam:Destroy()
	
	for k, _ in self do
		self[k] = nil
	end
	setmetatable(self, nil)
end

return arrowBeams