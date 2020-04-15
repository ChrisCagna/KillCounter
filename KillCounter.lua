KillCounterVariables = {
	trackGlobalKills = true
}




-- Set to false to use file-scoped variables or true to use the new addon-scoped variables
-- local useAddonScope = true
-- local addonName, MenuClass
local versionNumber = "1.0"

local KillCounterFont = "Interface\\AddOns\\KillCounter\\Fonts\\Chela.ttf"
local fontSize = 15
local fontFlags = "OUTLINE"
local pinkClr = "|cffE72CA0"

local xpos1 = 0
local ypos1 = 0
local xpos2 = 0
local ypos2 = 0
local xpos3 = 0
local ypos3 = 0


local tStart = time()
local sessionTime = 0

local names = "Go Git Sumtin"
local counts = ""
local total = 0

local timeSinceUpdate = 0
local updateInterval = 1

local playerName = UnitName("player")



killLog = { }

SLASH_KILLCOUNTER1 = "/kc"

local function handler(msg, editBox)
	if(msg == "test") then
	
	
		print(DEFAULT_CHAT_FRAME.editBox:GetText())
		
		--print("Kill Counter Working")
		--SendChatMessage(total, "PARTY", "COMMON", nil)
		--SendToChat()
		--killLog = { }
		
		

	elseif(msg == "+") then
		fontSize = fontSize + 5
		updateFontSize()
		
	elseif(msg == "-") then
		fontSize = fontSize - 5
		updateFontSize()
	end
	
	
	
end

SlashCmdList["KILLCOUNTER"] = handler;

local Variables_Frame = CreateFrame("Frame")
Variables_Frame:RegisterEvent("ADDON_LOADED")
Variables_Frame:SetScript("OnEvent",
	function(self, event, ...)

		local arg1 = ...
		if(arg1 == "KillCounter") then
			DEFAULT_CHAT_FRAME:AddMessage(print(pinkClr .. "KillCounter " .. versionNumber .. " Loaded!"))
			print(KillCounterVariables.trackGlobalKills)
			if (KillCounterVariables.trackGlobalKills == nil) then
				print("It was nil")
				KillCounterVariables.trackGlobalKills = false
			end			
		end
	end)

BackdropDefault = function(alpha)

background = "Interface\\TutorialFrame\\TutorialFrameBackground"
edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border"
backdrop =
{
    bgFile = background,
    edgeFile = edge,
    tile = false, tileSize = 16, edgeSize = 16,
    insets = { left = 0, right = 0, top = 0, bottom = 0 }
}

end

local CreateFrames = function()
	KCFrame=CreateFrame("Frame","KCFrame",UIParent)
	KCNames=KCFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
	KCCounts=KCFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
	KCTitle=KCFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
	KCSessionTime=KCFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
	KCPostButton=CreateFrame("Button","KCPostButton",KCFrame,"UIPanelButtonGrayTemplate")
	KCResetButton=CreateFrame("Button","KCResetButton", KCFrame,"UIPanelButtonGrayTemplate")
	KCTrackModeButton=CreateFrame("Button","KCTrackModeButton", KCFrame, "UIPanelButtonGrayTemplate")
	KCLockButton=CreateFrame("Button","KCLockButton", KCFrame, "UIPanelButtonGrayTemplate")
	KCChatFrame=CreateFrame("Frame","ChatFrame",UIParent)
	
end

local CreatePostMenu = function()
	 	KCPostMenu = CreateFrame("Frame", "KC_PostMenu")
		KCPostMenu.displayMode = "MENU"
		KCPostMenu.info = {}
end

local SetDefaults = function()
	KCFrame:SetPoint("CENTER")
	KCFrame:SetSize(200,200)
	KCFrame:RegisterForDrag("LeftButton")
	KCFrame:SetMovable(true)
	KCFrame:SetAlpha(1)
	KCFrame:SetClampedToScreen(true)
	KCFrame:SetUserPlaced(true)
	KCFrame:EnableMouse()
	KCFrame:SetScript("OnUpdate", KCFrame.OnUpdate)
	KCFrame:SetBackdrop(backdrop)
	KCFrame:SetBackdropColor(1,1,1,0.5)
	
	KCNames:SetPoint("TOPLEFT")
	KCNames:SetJustifyH("LEFT")
	KCNames:SetText("Name1\nName2")
	KCNames:SetFont(KillCounterFont, fontSize, fontFlags)
	
	KCCounts:SetPoint("TOPRIGHT")
	KCCounts:SetJustifyH("RIGHT")
	KCCounts:SetText("##")
	KCCounts:SetFont(KillCounterFont, fontSize, fontFlags)
	
	KCTitle:SetPoint("BOTTOMLEFT", KCFrame, "TOPLEFT")
	KCTitle:SetJustifyH("LEFT")
	KCTitle:SetText(pinkClr .. "Kill Counter")
	KCTitle:SetFont(KillCounterFont, fontSize*1.5, fontFlags)
	
	KCSessionTime:SetPoint("BOTTOMRIGHT", KCFrame, "TOPRIGHT")
	KCSessionTime:SetJustifyH("LEFT")
	KCSessionTime:SetText("00:00")
	KCSessionTime:SetFont(KillCounterFont, fontSize*1.5, fontFlags)
	
	KCPostButton:SetPoint("TOPRIGHT", KCFrame, "BOTTOMRIGHT")
	KCPostButton:SetText("Post")
	KCPostButton:SetWidth(40)
	KCPostButton:SetHeight(20)
	KCPostButton:RegisterForClicks("LeftButtonUp")
	
	KCResetButton:SetPoint("TOPRIGHT", KCPostButton, "TOPLEFT")
	KCResetButton:SetText("Reset")
	KCResetButton:SetWidth(40)
	KCResetButton:SetHeight(20)
	KCResetButton:RegisterForClicks("LeftButtonUp")
	
	KCLockButton:SetPoint("TOPRIGHT", KCResetButton, "TOPLEFT")
	KCLockButton:SetText("Lock")
	KCLockButton:SetWidth(40)
	KCLockButton:SetHeight(20)
	KCLockButton:RegisterForClicks("LeftButtonUp")
	
	KCTrackModeButton:SetPoint("TOPRIGHT", KCLockButton, "TOPLEFT")
	KCTrackModeButton:SetText(pinkClr .. "Personal")
	KCTrackModeButton:SetWidth(60)
	KCTrackModeButton:SetHeight(20)
	KCTrackModeButton:RegisterForClicks("LeftButtonUp")
end

updateFontSize = function()
	KCNames:SetFont(KillCounterFont, fontSize, fontFlags)
	KCCounts:SetFont(KillCounterFont, fontSize, fontFlags)
	KCTitle:SetFont(KillCounterFont, fontSize*1.5, fontFlags)
	KCSessionTime:SetFont(KillCounterFont, fontSize*1.5, fontFlags)
end

local RegisterEvents = function()
	KCFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	KCChatFrame:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	KCFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
end

local SendToTable = function(name)
	if(killLog[name] ~= nil) then
		killLog[name] = killLog[name] + 1
	else
		killLog[name] = 1
	end
end

local GetCombatLogInfo = function()
	local aaa, eventType, bbb, sourceGUID, sourceName, ccc, ddd, destGUID, destName, eee, fff, spellID = CombatLogGetCurrentEventInfo()
		if(KillCounterVariables.trackGlobalKills) then
			if(eventType == "UNIT_DIED") then
				SendToTable(destName)
			end
		elseif(eventType == "PARTY_KILL" and sourceName == playerName) then
			SendToTable(destName)
		end
end

function getKeysSortedByValue(tbl, sortFunction)
  local keys = {}
  for key in pairs(tbl) do
    table.insert(keys, key)
  end

  table.sort(keys, function(a, b)
    return sortFunction(tbl[b], tbl[a])
  end)

  return keys
end

local FormatData = function()
	names = ""
	counts = ""
	total = 0
	
	local sortedKeys = getKeysSortedByValue(killLog, function(a, b) return a < b end)
	
	for _, key in ipairs(sortedKeys) do
		names = names .. key .. "\n"
		counts = counts .. killLog[key] .. "\n"
		total = total + killLog[key]
	end
	
	names = names .. "Total"
	counts = counts .. total
end

local secondsFormat = function(t)
	local days = floor(t/86400)
	local hours = floor(mod(t, 86400)/3600)
	local minutes = floor(mod(t,3600)/60)
	local seconds = floor(mod(t,60))
	if(t>3599) then 
		return format("%01d:%02d:%02d",hours,minutes,seconds)
	else
		return format("%02d:%02d",minutes,seconds)
	end
end

local SizeWindow = function()
	KCFrame:SetSize(math.max((KCNames:GetStringWidth() + KCCounts:GetStringWidth()), (KCTitle:GetStringWidth()*1.75)), math.max(KCNames:GetStringHeight(), 50))
end

local Display = function()
	FormatData()
	KCNames:SetText(names)
	KCCounts:SetText(counts)
	KCSessionTime:SetText(secondsFormat(time()-tStart))
	SizeWindow()
end

local PrintTableToLines = function(dest)
	local sortedKeys = getKeysSortedByValue(killLog, function(a, b) return a < b end)
	
	SendChatMessage("::KillCount:: KillLog: ", dest, "COMMON", nil)
	SendChatMessage("Session Time: " .. secondsFormat(time()-tStart), dest, "COMMON", nil)
	for _, key in ipairs(sortedKeys) do
		SendChatMessage(string.format("%-30s %s", key .. ":", killLog[key]),dest,"COMMON",nil)
	end
	SendChatMessage("Total Kills:      " .. total, dest, "COMMON", nil)
end

local Initialize = function()
	CreateFrames()
	BackdropDefault()
	CreatePostMenu()
	SetDefaults()
	--LoadTextures()
	RegisterEvents()
	Display()
end

SendToChat = function(dest, dataType)
	if(dataType == "TOTAL") then
		SendChatMessage("KillCount: Total Kills: " .. total, dest, "COMMON", nil)
		SendChatMessage("Session Time: " .. secondsFormat(time()-tStart), dest, "COMMON", nil)
	elseif (dataType == "ALL") then
		PrintTableToLines(dest)
	end
end

Initialize()

KCPostMenu.initialize = function(self, level) 
	if not level then return end
	local info = self.info
	wipe(info)
	if level == 1 then
		info.isTitle = 1
		info.text = "Report:"
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)
		
		info.keepShownOnClick = 1
		info.disabled     = nil
		info.isTitle      = nil
		info.notCheckable = 1	
		
		info.text = "   Total kills:"
		info.func = self.UncheckHack
		info.hasArrow = 1
		info.value = "submenu1"
		UIDropDownMenu_AddButton(info, level)
		
		info.text = "   All Data:"
		info.value = "submenu2"
		-- info.func = function()
			-- print("ALL DATA")
		-- end
		UIDropDownMenu_AddButton(info, level)
		
		-- Close menu item
		info.text         = CLOSE
		info.hasArrow = nil
		info.value = nil
		info.notCheckable = 1
		info.func         = function()
			CloseDropDownMenus()
		end
		UIDropDownMenu_AddButton(info, level)
		
	elseif level == 2 then
		info.notCheckable = 1	
		if UIDROPDOWNMENU_MENU_VALUE == "submenu1" then
			info.text = "Party"
			info.func = function()
				SendToChat("PARTY","TOTAL")
				CloseDropDownMenus()
			end
			UIDropDownMenu_AddButton(info, level)
			
			info.text = "Raid"
			info.func = function()
				SendToChat("RAID","TOTAL")
				CloseDropDownMenus()
			end
			UIDropDownMenu_AddButton(info, level)
			
			info.text = "Whisper"
			info.disabled = true
			UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu2" then
			info.text = "Party"
			info.func = function()
				SendToChat("PARTY","ALL")
				CloseDropDownMenus()
			end
			UIDropDownMenu_AddButton(info, level)
			
			info.text = "Raid"
			info.func = function()
				SendToChat("RAID","ALL")
				CloseDropDownMenus()
			end
			UIDropDownMenu_AddButton(info, level)
			
			info.text = "Whisper"
			info.disabled = true
			UIDropDownMenu_AddButton(info, level)
		end
	end
end

function KCFrame:OnUpdate(arg1)
	timeSinceUpdate = timeSinceUpdate + arg1
	if(updateInterval < timeSinceUpdate) then
		Display()
		
		timeSinceUpdate = 0
	end
	
end

KCFrame:SetScript("OnEvent",
	function(self, event, ...)
		local arg1 = ...
		if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
			GetCombatLogInfo()
		end
		if(event == "PLAYER_ENTERING_WORLD") then
			if(KillCounterVariables.trackGlobalKills) then
				KCTrackModeButton:SetText(pinkClr .. "Global")
			else
				KCTrackModeButton:SetText(pinkClr .. "Personal")
			end
		end
			
end)

KCChatFrame:SetScript("OnEvent",
	function(self, event, ...)
	local chatMessage, playerName, arg3, channelName, arg5, arg6, arg7, arg8, arg9 = ...
		if(chatMessage == "The living are here!") then
			PlaySoundFile("Interface\\AddOns\\KillCounter\\Sounds\\airhorn.ogg", "Master")
		end

end)

KCFrame:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" and not self.isMoving and KCFrame:IsMovable() then
		_, _, _, xpos1, ypos1 = KCFrame:GetPoint(1)
		self:StartMoving();
		_, _, _, xpos2, ypos2 = KCFrame:GetPoint(1)
		self.isMoving = true;
	end
end)

KCFrame:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" and self.isMoving then
		_, _, _, xpos3, ypos3 = KCFrame:GetPoint(1)
		self:StopMovingOrSizing()
		self.isMoving = false;
	end
end)

KCFrame:SetScript('OnEnter', function() 
	KCFrame:SetBackdropColor(1,1,1,1)
end)

KCFrame:SetScript('OnLeave', function() 
	KCFrame:SetBackdropColor(1,1,1,0.3)
end)

KCPostButton:SetScript('OnMouseUp', function(self, button)
	ToggleDropDownMenu(1, nil, KCPostMenu, self:GetName(), 0, 0)
end)

KCResetButton:SetScript('OnMouseUp', function(self, button)
	killLog = {}
	Display()
	tStart = time()
end)

KCTrackModeButton:SetScript('OnMouseUp', function(self, button)
	if(KillCounterVariables.trackGlobalKills) then
		KillCounterVariables.trackGlobalKills = false
		KCTrackModeButton:SetText(pinkClr .. "Personal")
	else
		KillCounterVariables.trackGlobalKills = true
		KCTrackModeButton:SetText(pinkClr .. "Global")
	end
end)

KCLockButton:SetScript('OnMouseUp', function(self, button)
	if(KCFrame:IsMovable()) then
		KCFrame:SetMovable(false)
		KCLockButton:SetText("Unlock")
	else
		KCFrame:SetMovable(true)
		KCLockButton:SetText("lock")
	end
end)

KCFrame:SetScript("OnUpdate", KCFrame.OnUpdate)









