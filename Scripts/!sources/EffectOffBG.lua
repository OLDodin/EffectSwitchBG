local g_flagEnabled = nil
local m_tickCnt = 0
local m_mainForm = nil

local IsAOPanelEnabled = true

function onAOPanelStart( params )
	if IsAOPanelEnabled then
	
		local SetVal = { val = userMods.ToWString( "Eo") }
		local params = { header = SetVal, ptype = "button", size = 30 }
		userMods.SendEvent( "AOPANEL_SEND_ADDON",
			{ name = common.GetAddonName(), sysName = common.GetAddonName(), param = params } )

		DnD.HideWdg(getChild(mainForm, "EFButton"))
	end
end

function onAOPanelLeftClick( params )
	if params.sender == common.GetAddonName() then
		SwapMainSettingsForm()
	end
end

function onAOPanelChange( params )
	if params.state == ADDON_STATE_NOT_LOADED and string.find(params.name, "AOPanel") then
		DnD.ShowWdg(getChild(mainForm, "EFButton"))
	end
end

function SwapMainSettingsForm()
	if not m_mainForm then
		m_mainForm = CreateMainSettingsForm()
		LoadMainFormSettings(m_mainForm)
	end
	DnD.SwapWdg(m_mainForm)
end

function OnBattleChanged(anEnabled)
	if anEnabled == g_flagEnabled then
		g_flagEnabled = anEnabled
		return
	end
	local settings = GetCurrentSettings()
	local normalTransparency = math.ceil(tonumber(settings.groupNormal.effectTransTxt)/10)-1
	local bgTransparency = math.ceil(tonumber(settings.groupBG.effectTransTxt)/10)-1

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
									if anEnabled then
										options.SetOptionCurrentIndex( optionId, settings.groupBG.useProcTextures and 1 or 0)
									else
										options.SetOptionCurrentIndex( optionId, settings.groupNormal.useProcTextures and 1 or 0)
									end
								end
								if optionIndex == 10 then
									if anEnabled then
										options.SetOptionCurrentIndex( optionId, settings.groupBG.shadowQuality)
									else
										options.SetOptionCurrentIndex( optionId, settings.groupNormal.shadowQuality)
									end
								end
							end
							if pageIndex == 1 and groupIndex == 0 and blockIndex == 3 then 
								if anEnabled then
									if optionIndex == 0 then
										options.SetOptionCurrentIndex( optionId, settings.groupBG.useAtmoEffects and 1 or 0)
									elseif 	optionIndex == 1 then
										options.SetOptionCurrentIndex( optionId, settings.groupBG.usePostEffects and 1 or 0)
									elseif 	optionIndex == 2 then
										options.SetOptionCurrentIndex( optionId, settings.groupBG.useLightEffects and 1 or 0)
									end
								else
									if optionIndex == 0 then
										options.SetOptionCurrentIndex( optionId, settings.groupNormal.useAtmoEffects and 1 or 0)
									elseif 	optionIndex == 1 then
										options.SetOptionCurrentIndex( optionId, settings.groupNormal.usePostEffects and 1 or 0)
									elseif 	optionIndex == 2 then
										options.SetOptionCurrentIndex( optionId, settings.groupNormal.useLightEffects and 1 or 0)
									end
								end
							end
							if pageIndex == 1 and groupIndex == 0 and blockIndex == 4 then 
								if optionIndex == 0 then
									if anEnabled then
										options.SetOptionCurrentIndex( optionId, settings.groupBG.useGrass and 1 or 0)
									else
										options.SetOptionCurrentIndex( optionId, settings.groupNormal.useGrass and 1 or 0)
									end
								end
							end
							if pageIndex == 3 and groupIndex == 1 and blockIndex == 0 then 
								if anEnabled then
									if optionIndex == 0 then
										options.SetOptionCurrentIndex( optionId, bgTransparency )
									elseif 	optionIndex == 1 then
										options.SetOptionCurrentIndex( optionId, settings.groupBG.useMageEffects and 0 or 1)
									end
								else
									if optionIndex == 0 then
										options.SetOptionCurrentIndex( optionId, normalTransparency )
									elseif 	optionIndex == 1 then
										options.SetOptionCurrentIndex( optionId, settings.groupNormal.useMageEffects and 0 or 1 )
									end
								end
								
							end
						end
					end
				end		
			end
			options.Apply( pageId )
		end
	end
	g_flagEnabled = anEnabled
end

local function OnEventSecondTimer()
	m_tickCnt = m_tickCnt + 1
	if m_tickCnt < 5 then 
		return
	else
		m_tickCnt = 0
	end
	local switchActive = false
	if matchMaking.CanUseMatchMaking() and matchMaking.IsEventProgressExist() then
		local battleInfo = matchMaking.GetCurrentBattleInfo()
		if battleInfo and not battleInfo.isPvE then
			local settings = GetCurrentSettings()
			--LogInfo("battleInfo.mechanicsType = ", battleInfo.mechanicsType)
			if (settings.useInRatingPVP or settings.useInAnyBG) and battleInfo.mechanicsType == "ENUM_RATING_ARENA" then
				OnBattleChanged(true)
				switchActive = true
			elseif settings.useInAnyBG then
				OnBattleChanged(true)
				switchActive = true
			end
		end
	end
	if not switchActive then
		OnBattleChanged(false)
	end
end

function Init()
	setTemplateWidget("common")
		
	local button=createWidget(mainForm, "EFButton", "Button", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 32, 32, 300, 120)
	setText(button, "Eo")
	DnD.Init(button, button, true)
	
	InitSettings()
	
	common.RegisterReactionHandler(ButtonPressed, "execute")
	common.RegisterReactionHandler(DropDownBtnPressed, "DropDownBtnPressed")
	common.RegisterReactionHandler(DropDownBtnRightClick, "DropDownBtnRightClick")
	common.RegisterReactionHandler(SelectDropDownBtnPressed, "SelectDropDownBtnPressed")
	common.RegisterReactionHandler(CheckBoxChangedOn, "CheckBoxChangedOn")
	common.RegisterReactionHandler(CheckBoxChangedOff, "CheckBoxChangedOff")

	common.RegisterEventHandler(OnEventSecondTimer, "EVENT_SECOND_TIMER")
	
	
	AddReaction("EFButton", SwapMainSettingsForm)
	AddReaction("closeButton", SwapMainSettingsForm)
	AddReaction("okButton", function (aWdg) SaveMainFormSettings(m_mainForm) g_flagEnabled=nil SwapMainSettingsForm() end)
	
	
	common.RegisterEventHandler( onAOPanelStart, "AOPANEL_START" )
	common.RegisterEventHandler( onAOPanelLeftClick, "AOPANEL_BUTTON_LEFT_CLICK" )
	common.RegisterEventHandler( onAOPanelChange, "EVENT_ADDON_LOAD_STATE_CHANGED" )
end

if avatar.IsExist() then
	Init()
else
	common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")
end