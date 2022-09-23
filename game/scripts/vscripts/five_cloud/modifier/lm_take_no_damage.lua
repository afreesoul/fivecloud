lm_take_no_damage = class({})

local public = lm_take_no_damage

function public:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}

	return funcs
end

function public:IsHidden()
	return false
end

function public:GetTexture()
	return "modifier_invulnerable"
end

function public:OnCreated()
	if IsServer() then
		local particle = ParticleManager:CreateParticle(
			"panorama/layout/custom_game/five_cloud/particles/custom/custom_glyph_creeps_tube.vpcf", PATTACH_ABSORIGIN_FOLLOW,
			self:GetParent())
		self.particle = particle
		ParticleManager:SetParticleControl(particle, 2, Vector(self:GetParent():GetModelScale(), 0, 0))
	end
end

function public:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, true)  
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function public:GetAbsoluteNoDamageMagical( params )
	return 1
end

function public:GetAbsoluteNoDamagePhysical( params )
	return 1
end

function public:GetAbsoluteNoDamagePure( params )
	return 1
end