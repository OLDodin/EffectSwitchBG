Global("Locales", {})

function getLocale()
	return Locales[common.GetLocalization()] or Locales["eng"]
end

--------------------------------------------------------------------------------
-- Russian
--------------------------------------------------------------------------------

Locales["rus"]={}
Locales["rus"]["useAtmoEffects"]="Атмосферные эффекты:"
Locales["rus"]["usePostEffects"]="Пост-эффекты:"
Locales["rus"]["useLightEffects"]="Эффекты свечения:"
Locales["rus"]["useMageEffects"]="Стихии магов:"
Locales["rus"]["useGrass"]="Отображение травы:"
Locales["rus"]["useProcTextures"]="Процедурные текстуры:"
Locales["rus"]["effectTransparency"]="Видимость чужих эффектов (10-100%):"
Locales["rus"]["configHeader"]="Настройки"
Locales["rus"]["okButton"]="Сохранить"
Locales["rus"]["headerBG"]="Для БГ"
Locales["rus"]["headerNormal"]="В остальном мире"
Locales["rus"]["useInRatingPVP"]="Активировать в 3*3 6*6:"
Locales["rus"]["useInAnyBG"]="Активировать в любых пвп БГ:"


--------------------------------------------------------------------------------
-- English
--------------------------------------------------------------------------------

Locales["eng"]={}
Locales["eng"]["useAtmoEffects"]="Atmospheric effects:"
Locales["eng"]["usePostEffects"]="Post-effects:"
Locales["eng"]["useLightEffects"]="Glow effects:"
Locales["eng"]["useMageEffects"]="Magic effects:"
Locales["eng"]["useGrass"]="Grass display:"
Locales["eng"]["useProcTextures"]="Procedural textures:"
Locales["eng"]["effectTransparency"]="Visibility enemy effects (10-100%):"
Locales["eng"]["configHeader"]="Settings"
Locales["eng"]["okButton"]="Save"
Locales["eng"]["headerBG"]="BattleGround"
Locales["eng"]["headerNormal"]="World"
Locales["eng"]["useInRatingPVP"]="Enabled for 3*3 6*6:"
Locales["eng"]["useInAnyBG"]="Enabled for any pvp bg:"

