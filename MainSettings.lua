local m_template = nil

function CreateMainSettingsForm()
	m_template = getChild(mainForm, "Template")
	setTemplateWidget(m_template)
	
	local form=createWidget(mainForm, "mainSettingsForm", "Panel", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 700, 420, 200, 100)
	hide(form)
	priority(form, 5)


	setLocaleText(createWidget(form, "configHeader", "TextView",  WIDGET_ALIGN_CENTER, nil, 100, 20, nil, 20))
	setText(createWidget(form, "closeButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_LOW, 20, 20, 20, 20), "x")

	setLocaleText(createWidget(form, "okButton", "Button", WIDGET_ALIGN_CENTER, WIDGET_ALIGN_HIGH, 200, 30, nil, 15))
	
	
	local groupBG = createWidget(form, "groupBG", "Panel")
	align(groupBG, WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW)
	resize(groupBG, 340, 250)
	move(groupBG, 4, 50)
	setLocaleText(createWidget(groupBG, "headerBG", "TextView",  WIDGET_ALIGN_CENTER, nil, 90, 20, nil, 2))
	FillGroupSettings(groupBG)
	
	local groupNormal = createWidget(form, "groupNormal", "Panel")
	align(groupNormal, WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW)
	resize(groupNormal, 340, 250)
	move(groupNormal, 350, 50)
	setLocaleText(createWidget(groupNormal, "headerNormal", "TextView",  WIDGET_ALIGN_CENTER, nil, 150, 20, nil, 2))
	FillGroupSettings(groupNormal)
	
	createWidget(form, "useInRatingPVP", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 310)
	createWidget(form, "useInAnyBG", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 340)
	
	DnD:Init(form, form, true)
		
	return form
end

function FillGroupSettings(aGroup)
	createWidget(aGroup, "useAtmoEffects", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 30)
	createWidget(aGroup, "usePostEffects", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 60)
	createWidget(aGroup, "useLightEffects", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 90)
	createWidget(aGroup, "useMageEffects", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 120)
	createWidget(aGroup, "useGrass", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 150)
	createWidget(aGroup, "useProcTextures", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 180)

	setLocaleText(createWidget(aGroup, "effectTransparency", "TextView", nil, nil, 300, 25, 10, 214))
	createWidget(aGroup, "effectTransEdit", "EditLine", nil, nil, 35, 25, 299, 210, nil, nil)
end

local m_currSettings = nil
function CheckPercents(aValue)
	local val = tonumber(aValue)
	if not val then 
		aValue = "100" 
	elseif val < 10 then 
		aValue = "10"
	elseif val > 100 then 
		aValue = "100" 
	end
	
	return aValue
end

function SaveMainFormSettings(aForm)
	local mySettings = {}
	
	mySettings.useInRatingPVP = getCheckBoxState(getChild(aForm, "useInRatingPVP"))
	mySettings.useInAnyBG = getCheckBoxState(getChild(aForm, "useInAnyBG"))
	
	local groupBG = getChild(aForm, "groupBG")
	local groupNormal = getChild(aForm, "groupNormal")
	
	mySettings.groupBG = SetSettingsForGroup(groupBG)
	mySettings.groupNormal = SetSettingsForGroup(groupNormal)


	m_currSettings = mySettings
	userMods.SetGlobalConfigSection("EffectsOff", mySettings)
	LoadMainFormSettings(aForm)
end

function SetSettingsForGroup(aGroupWdg)
	group = {}
	group.useAtmoEffects = getCheckBoxState(getChild(aGroupWdg, "useAtmoEffects"))
	group.usePostEffects = getCheckBoxState(getChild(aGroupWdg, "usePostEffects"))
	group.useLightEffects = getCheckBoxState(getChild(aGroupWdg, "useLightEffects"))
	group.useMageEffects = getCheckBoxState(getChild(aGroupWdg, "useMageEffects"))
	group.useGrass = getCheckBoxState(getChild(aGroupWdg, "useGrass"))
	group.useProcTextures = getCheckBoxState(getChild(aGroupWdg, "useProcTextures"))
	group.effectTransTxt = CheckPercents(getTextString(getChild(aGroupWdg, "effectTransEdit")))
	
	return group
end

function LoadSettingsForGroup(aGroup, aSettings)
	setLocaleText(getChild(aGroup, "useAtmoEffects"), aSettings.useAtmoEffects)
	setLocaleText(getChild(aGroup, "usePostEffects"), aSettings.usePostEffects)
	setLocaleText(getChild(aGroup, "useLightEffects"), aSettings.useLightEffects)
	setLocaleText(getChild(aGroup, "useMageEffects"), aSettings.useMageEffects)
	setLocaleText(getChild(aGroup, "useGrass"), aSettings.useGrass)
	setLocaleText(getChild(aGroup, "useProcTextures"), aSettings.useProcTextures)
	setText(getChild(aGroup, "effectTransEdit"), aSettings.effectTransTxt)
end

function LoadMainFormSettings(aForm)
	local savedSettings = userMods.GetGlobalConfigSection("EffectsOff")
	if not savedSettings then
		savedSettings = {}
		savedSettings.useInRatingPVP = true
		savedSettings.useInAnyBG = true
		
		savedSettings.groupBG = {}
		savedSettings.groupBG.useAtmoEffects = false
		savedSettings.groupBG.usePostEffects = false
		savedSettings.groupBG.useLightEffects = false
		savedSettings.groupBG.useMageEffects = false
		savedSettings.groupBG.useGrass = false
		savedSettings.groupBG.useProcTextures = false
		savedSettings.groupBG.effectTransTxt = "30"
		
		savedSettings.groupNormal = ReadGameSettings()
		
		userMods.SetGlobalConfigSection("EffectsOff", savedSettings)
	end
	
	LoadSettingsForGroup(getChild(aForm, "groupBG"), savedSettings.groupBG)
	LoadSettingsForGroup(getChild(aForm, "groupNormal"), savedSettings.groupNormal)
	
	setLocaleText(getChild(aForm, "useInRatingPVP"), savedSettings.useInRatingPVP)
	setLocaleText(getChild(aForm, "useInAnyBG"), savedSettings.useInAnyBG)
	
	m_currSettings = savedSettings
end

function ReadGameSettings()
	local groupNormal = {}
	
	options.Update()
	local pageIds = options.GetPageIds()
	for pageIndex = 0, GetTableSize( pageIds ) - 1 do
		local pageId = pageIds[pageIndex]
		if pageIndex == 1 or pageIndex == 3 then
			local groupIds = options.GetGroupIds(pageId)
			if groupIds then
				for groupIndex = 0, GetTableSize( groupIds ) - 1 do
					local groupId = groupIds[groupIndex]
					local blockIds = options.GetBlockIds( groupId )
					for blockIndex = 0, GetTableSize( blockIds ) - 1 do
						local blockId = blockIds[blockIndex]
						local optionIds = options.GetOptionIds( blockId )
						for optionIndex = 0, GetTableSize( optionIds ) - 1 do
							local optionId = optionIds[optionIndex]
							local optionInfo = options.GetOptionInfo( optionId )
							if pageIndex == 1 and groupIndex == 0 and blockIndex == 0 then 
								if optionIndex == 8 then
									groupNormal.useProcTextures = optionInfo.currentIndex == 1
								end
							end
							if pageIndex == 1 and groupIndex == 0 and blockIndex == 3 then 
								if optionIndex == 0 then
									groupNormal.useAtmoEffects = optionInfo.currentIndex == 1
								elseif 	optionIndex == 1 then
									groupNormal.usePostEffects = optionInfo.currentIndex == 1
								elseif 	optionIndex == 2 then
									groupNormal.useLightEffects = optionInfo.currentIndex == 1
								end
							end
							if pageIndex == 1 and groupIndex == 0 and blockIndex == 4 then 
								if optionIndex == 0 then
									groupNormal.useGrass = optionInfo.currentIndex == 1
								end
							end
							if pageIndex == 3 and groupIndex == 1 and blockIndex == 0 then 
								if optionIndex == 0 then
									groupNormal.effectTransTxt = tostring((optionInfo.currentIndex+1)*10)
								elseif 	optionIndex == 1 then
									groupNormal.useMageEffects = optionInfo.currentIndex == 0
								end							
							end
						end
					end
				end		
			end
		end
	end
	return groupNormal
end

function GetCurrentSettings()
	return m_currSettings
end