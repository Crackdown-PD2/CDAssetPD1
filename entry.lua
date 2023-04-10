local mod_path = ModPath

--register and load voice lines for grenadier from ogg files
local function on_cd_setup(framework)
	
	--setup xaudio; can safely be called multiple times
	blt.xaudio.setup()
	
	--register unit to use this voiceline
	framework:register_unit("grenadier")
	
	--find the folder for each of the line types (eg. "contact", "use_gas", "spawn", "death"),
	--inside, register each variant ogg file
	local voicelines_path = mod_path .. "assets/oggs/voiceover/grenadier/"
	for _,line_type in pairs(file.GetDirectories(voicelines_path)) do 
		local path = Application:nice_path("./" .. voicelines_path .. line_type,true)
		framework.register_line_type("grenadier_voiceline", "grenadier", tostring(line_type))
		for _,variant_filename in pairs(file.GetFiles(path)) do 
			framework:register_voiceline("grenadier", tostring(line_type), Application:nice_path(path .. tostring(variant_filename)))
		end
	end
end

--depends on voiceline framework object instantiated by deathvox core class;
--mod loading order is not guaranteed, so...
if deathvox and deathvox._voiceline_framework then
	--...if already instantiated, load immediately
	on_cd_setup(deathvox._voiceline_framework)
else
	--...else, if not instantiated, queue the voiceline loading to after voiceline framework
	Hooks:Add("crackdown_on_setup_voiceline_framework","crackdown_faction_classics_setup_gren_voice",on_cd_setup)
end
