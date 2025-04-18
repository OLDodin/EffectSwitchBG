local m_locale = getLocale()

Global("DISABLE_CLICK", 0)
Global("LOW_CLICK", 1)
Global("MEDIUM_CLICK", 2)
Global("HIGH_CLICK", 3)


local m_actionSwitch = {}
m_actionSwitch[DISABLE_CLICK] = m_locale["DISABLE_CLICK"]
m_actionSwitch[LOW_CLICK] = m_locale["LOW_CLICK"]
m_actionSwitch[MEDIUM_CLICK] = m_locale["MEDIUM_CLICK"]
m_actionSwitch[HIGH_CLICK] = m_locale["HIGH_CLICK"]


local m_effectTransSliderBG = nil
local m_effectTransSliderNormal = nil

function CreateMainSettingsForm()
	setTemplateWidget("common")
	
	local form=createWidget(mainForm, "mainSettingsForm", "Panel", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 700, 450, 200, 100)
	hide(form)
	priority(form, 5)


	setLocaleText(createWidget(form, "configHeader", "TextView",  WIDGET_ALIGN_CENTER, nil, 100, 20, nil, 20))
	setText(createWidget(form, "closeButton", "Button", WIDGET_ALIGN_HIGH, WIDGET_ALIGN_LOW, 20, 20, 20, 20), "x")

	setLocaleText(createWidget(form, "okButton", "Button", WIDGET_ALIGN_CENTER, WIDGET_ALIGN_HIGH, 200, 30, nil, 15))
	
	
	local groupBG = createWidget(form, "groupBG", "Panel")
	align(groupBG, WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW)
	resize(groupBG, 340, 280)
	move(groupBG, 4, 50)
	setLocaleText(createWidget(groupBG, "headerBG", "TextView",  WIDGET_ALIGN_CENTER, nil, 90, 20, nil, 2))
	m_effectTransSliderBG = FillGroupSettings(groupBG)
	
	local groupNormal = createWidget(form, "groupNormal", "Panel")
	align(groupNormal, WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW)
	resize(groupNormal, 340, 280)
	move(groupNormal, 350, 50)
	setLocaleText(createWidget(groupNormal, "headerNormal", "TextView",  WIDGET_ALIGN_CENTER, nil, 150, 20, nil, 2))
	m_effectTransSliderNormal = FillGroupSettings(groupNormal)
	
	createWidget(form, "useInRatingPVP", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 340)
	createWidget(form, "useInAnyBG", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 370)
	
	DnD.Init(form, form, true)
		
	return form
end

function FillGroupSettings(aGroup)
	createWidget(aGroup, "useAtmoEffects", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 30)
	createWidget(aGroup, "usePostEffects", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 60)
	createWidget(aGroup, "useLightEffects", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 90)
	createWidget(aGroup, "useMageEffects", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 120)
	createWidget(aGroup, "useGrass", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 150)
	createWidget(aGroup, "useProcTextures", "CheckBox", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 316, 25, 10, 180)
	setLocaleText(createWidget(aGroup, "shadowQualityTxt", "TextView",  WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 150, 25, 10, 210))
	CheckDropDownOrientation(GenerateBtnForDropDown(createWidget(aGroup, "shadowQuality", "DropDownPanel", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 80, 25, 250, 210), m_actionSwitch))
	
	local effectTransSlider = CreateSlider(aGroup, "effectTransSlider", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 320, 25, 10, 240)
	local sliderParams	= {
							valueMin	= 10,
							valueMax	= 100,
							stepsCount	= 9,
							value		= 10,
							description = getLocale()["effectTransparency"],
							sliderWidth		= 46,
							descTextAttr = {
								color = "0xffffffff"
							},
							valueTextAttr = {
							--	color = "0xffffffff"
							},
							formatFunc = function(aValue)
								return common.FormatInt(aValue, '%d').."%"
							end
						}
	effectTransSlider:Init(sliderParams)
	return effectTransSlider
end

local m_currSettings = nil

function GetSwitchIndexByName(anArr, aName)
	for i, v in pairs(anArr) do
		if compareStrWithConvert(v, aName) then
			return i
		end
	end
	return 0
end

function GetCurrentSwitchIndex(aWdg)
	local txtWdg = getChild(getChild(aWdg, "DropDownHeaderPanel"), "ModeNameTextView")
	local currValue = txtWdg:GetWString()
	return GetSwitchIndexByName(m_actionSwitch, currValue)
end

function SetSwitchIndex(aWdg, anIndex)
	if anIndex == nil then
		anIndex = 0
	end
	
	local txtWdg = getChild(getChild(aWdg, "DropDownHeaderPanel"), "ModeNameTextView")
	setText(txtWdg, m_actionSwitch[anIndex], "Neutral", "left", 11)
end

function SwitchActionClickBtn(aWdg)
	local currInd = GetCurrentSwitchIndex(aWdg)
	currInd = currInd + 1
	if currInd > HIGH_CLICK then
		currInd = DISABLE_CLICK
	end
	SetSwitchIndex(aWdg, currInd)
end

--redefine function from ReactionHelper
function GenerateBtnForDropDown(anWidget, aTextArr, aDefaultIndex, aColor)
	local selectPanel = getChild(anWidget, "DropDownSelectPanel")
	setTemplateWidget("common")
	if not aColor then
		aColor = "ColorWhite"
	end
	local cnt = 0
	for i=0, GetTableSize(aTextArr)-1 do
		local btn = createWidget(selectPanel, "modeBtn"..tostring(i), "DropDownSelectButton", WIDGET_ALIGN_BOTH, WIDGET_ALIGN_LOW, nil, 25, 0, 24*(i)+2)
		setText(btn, aTextArr[i], aColor)
		show(btn)
		cnt = cnt + 1
	end
	
	if not aDefaultIndex then
		aDefaultIndex = 0
	end
	setText(getChild(getChild(anWidget, "DropDownHeaderPanel"), "ModeNameTextView"), aTextArr[aDefaultIndex], "Neutral", "left", 11)
	
	resize(anWidget, nil, 24*(cnt+1))
	
	return anWidget
end


function SaveMainFormSettings(aForm)
	local mySettings = {}
	
	mySettings.useInRatingPVP = getCheckBoxState(getChild(aForm, "useInRatingPVP"))
	mySettings.useInAnyBG = getCheckBoxState(getChild(aForm, "useInAnyBG"))
	
	local groupBG = getChild(aForm, "groupBG")
	local groupNormal = getChild(aForm, "groupNormal")
	
	mySettings.groupBG = SetSettingsForGroup(groupBG, m_effectTransSliderBG)
	mySettings.groupNormal = SetSettingsForGroup(groupNormal, m_effectTransSliderNormal)


	m_currSettings = mySettings
	userMods.SetGlobalConfigSection("EffectsOff", mySettings)
	LoadMainFormSettings(aForm)
end

function SetSettingsForGroup(aGroupWdg, aSlider)
	group = {}
	group.useAtmoEffects = getCheckBoxState(getChild(aGroupWdg, "useAtmoEffects"))
	group.usePostEffects = getCheckBoxState(getChild(aGroupWdg, "usePostEffects"))
	group.useLightEffects = getCheckBoxState(getChild(aGroupWdg, "useLightEffects"))
	group.useMageEffects = getCheckBoxState(getChild(aGroupWdg, "useMageEffects"))
	group.useGrass = getCheckBoxState(getChild(aGroupWdg, "useGrass"))
	group.useProcTextures = getCheckBoxState(getChild(aGroupWdg, "useProcTextures"))
	group.effectTransTxt = tostring(aSlider:Get())
	group.shadowQuality = GetCurrentSwitchIndex(getChild(aGroupWdg, "shadowQuality"))
	
	return group
end

function LoadSettingsForGroup(aGroup, aSettings, aSlider)
	setLocaleText(getChild(aGroup, "useAtmoEffects"), aSettings.useAtmoEffects)
	setLocaleText(getChild(aGroup, "usePostEffects"), aSettings.usePostEffects)
	setLocaleText(getChild(aGroup, "useLightEffects"), aSettings.useLightEffects)
	setLocaleText(getChild(aGroup, "useMageEffects"), aSettings.useMageEffects)
	setLocaleText(getChild(aGroup, "useGrass"), aSettings.useGrass)
	setLocaleText(getChild(aGroup, "useProcTextures"), aSettings.useProcTextures)
	aSlider:Set(tonumber(aSettings.effectTransTxt))
	SetSwitchIndex(getChild(aGroup, "shadowQuality"), aSettings.shadowQuality)
end

function InitSettings()
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
		savedSettings.groupBG.shadowQuality = 0
		
		savedSettings.groupNormal = ReadGameSettings()
		
		userMods.SetGlobalConfigSection("EffectsOff", savedSettings)
	end
	
	if savedSettings.groupBG.shadowQuality == nil then	
		savedSettings.groupBG.shadowQuality = 0
	end
	if savedSettings.groupNormal.shadowQuality == nil then	
		savedSettings.groupNormal.shadowQuality = 0
	end
	
	m_currSettings = savedSettings
end

function LoadMainFormSettings(aForm)

	LoadSettingsForGroup(getChild(aForm, "groupBG"), m_currSettings.groupBG, m_effectTransSliderBG)
	LoadSettingsForGroup(getChild(aForm, "groupNormal"), m_currSettings.groupNormal, m_effectTransSliderNormal)
	
	setLocaleText(getChild(aForm, "useInRatingPVP"), m_currSettings.useInRatingPVP)
	setLocaleText(getChild(aForm, "useInAnyBG"), m_currSettings.useInAnyBG)

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
								if optionIndex == 4 then
									groupNormal.useProcTextures = optionInfo.currentIndex == 1
								end
							end
							if pageIndex == 1 and groupIndex == 0 and blockIndex == 2 then 
								if optionIndex == 0 then
									groupNormal.useAtmoEffects = optionInfo.currentIndex == 1
								elseif 	optionIndex == 1 then
									groupNormal.usePostEffects = optionInfo.currentIndex == 1
								elseif 	optionIndex == 2 then
									groupNormal.useLightEffects = optionInfo.currentIndex == 1
								end
							end
							if pageIndex == 1 and groupIndex == 0 and blockIndex == 3 then 
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
							if pageIndex == 1 and groupIndex == 0 and blockIndex == 0 then 
								if optionIndex == 10 then
									groupNormal.shadowQuality = optionInfo.currentIndex
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