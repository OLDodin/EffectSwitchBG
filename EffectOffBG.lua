local g_flagEnabled = nil
local m_mainForm = nil

local IsAOPanelEnabled = GetConfig( "EnableAOPanel" ) or GetConfig( "EnableAOPanel" ) == nil

function onAOPanelStart( params )
	if IsAOPanelEnabled then
	
		local SetVal = { val = userMods.ToWString( "Eo") }
		local params = { header = SetVal, ptype = "button", size = 30 }
		userMods.SendEvent( "AOPANEL_SEND_ADDON",
			{ name = common.GetAddonName(), sysName = common.GetAddonName(), param = params } )

		hide(getChild(mainForm, "EFButton"))
	end
end

function onAOPanelLeftClick( params )
	if params.sender == common.GetAddonName() then
		swap(m_mainForm)
	end
end

function onAOPanelChange( params )
	if params.unloading and params.name == "UserAddon/AOPanelMod" then
		show(getChild(mainForm, "EFButton"))
	end
end

function enableAOPanelIntegration( enable )
	IsAOPanelEnabled = enable
	SetConfig( "EnableAOPanel", enable )

	if enable then
		onAOPanelStart()
	else
		show(getChild(mainForm, "EFButton"))
	end
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
								if optionIndex == 8 then
									if anEnabled then
										options.SetOptionCurrentIndex( optionId, settings.groupBG.useProcTextures and 1 or 0)
									else
										options.SetOptionCurrentIndex( optionId, settings.groupNormal.useProcTextures and 1 or 0)
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

local m_reactions={}

function AddReaction(name, func)
	if not m_reactions then m_reactions={} end
	m_reactions[name]=func
end

function RunReaction(widget)
	local name=getName(widget)
	if not name or not m_reactions or not m_reactions[name] then return end
	m_reactions[name]()
end

function ButtonPressed(params)
	RunReaction(params.widget)
	changeCheckBox(params.widget)
end

function Init()
	local template = getChild(mainForm, "Template")
	setTemplateWidget(template)
		
	local button=createWidget(mainForm, "EFButton", "Button", WIDGET_ALIGN_LOW, WIDGET_ALIGN_LOW, 40, 25, 300, 120)
	setText(button, "Eo")
	DnD:Init(button, button, true)
	
	m_mainForm = CreateMainSettingsForm()
	
	common.RegisterReactionHandler(ButtonPressed, "execute")
	common.RegisterEventHandler(OnEventSecondTimer, "EVENT_SECOND_TIMER")
	
	
	AddReaction("EFButton", function () swap(m_mainForm) end)
	AddReaction("closeButton", function (aWdg) swap(m_mainForm) end)
	AddReaction("okButton", function (aWdg) SaveMainFormSettings(m_mainForm) g_flagEnabled=nil swap(m_mainForm) end)
	
	
	LoadMainFormSettings(m_mainForm)
	
	common.RegisterEventHandler( onAOPanelStart, "AOPANEL_START" )
	common.RegisterEventHandler( onAOPanelLeftClick, "AOPANEL_BUTTON_LEFT_CLICK" )
	common.RegisterEventHandler( onAOPanelChange, "EVENT_ADDON_LOAD_STATE_CHANGED" )
end

if avatar.IsExist() then
	Init()
else
	common.RegisterEventHandler(Init, "EVENT_AVATAR_CREATED")
end