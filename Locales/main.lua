Global("Locales", {})

function getLocale()
	return Locales[common.GetLocalization()] or Locales["eng"]
end

--------------------------------------------------------------------------------
-- Russian
--------------------------------------------------------------------------------

Locales["rus"]={}
Locales["rus"]["useAtmoEffects"]="����������� �������:"
Locales["rus"]["usePostEffects"]="����-�������:"
Locales["rus"]["useLightEffects"]="������� ��������:"
Locales["rus"]["useMageEffects"]="������ �����:"
Locales["rus"]["useGrass"]="����������� �����:"
Locales["rus"]["useProcTextures"]="����������� ��������:"
Locales["rus"]["effectTransparency"]="��������� ����� �������� (10-100%):"
Locales["rus"]["configHeader"]="���������"
Locales["rus"]["okButton"]="���������"
Locales["rus"]["headerBG"]="��� ��"
Locales["rus"]["headerNormal"]="� ��������� ����"
Locales["rus"]["useInRatingPVP"]="������������ � 3*3 6*6:"
Locales["rus"]["useInAnyBG"]="������������ � ����� ��� ��:"


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

