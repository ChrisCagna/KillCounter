KillCounterVarrables = {

}




-- Set to false to use file-scoped variables or true to use the new addon-scoped variables
-- local useAddonScope = true
-- local addonName, MenuClass

local KillCounterFont = "Interface\\AddOns\\KillCounter\\Fonts\\Chela.ttf"
local fontSize = 15
local fontFlags = "OUTLINE"
local redClr = "|cffE72CA0"

local xpos1 = 0
local ypos1 = 0
local xpos2 = 0
local ypos2 = 0
local xpos3 = 0
local ypos3 = 0

local names = "Go Git Sumtin"
local counts = ""
local namesAndCounts = ""
local total = 0

killLog = { }

SLASH_KILLCOUNTER1 = "/kc"

local function handler(msg, editBox)
	if(msg == "test") then
	
	
		print(DEFAULT_CHAT_FRAME.editBox:GetText())
		
		--print("Kill Counter Working")
		--SendChatMessage(total, "PARTY", "COMMON", nil)
		--SendToChat()
		--killLog = { }
		
		
	end
	
	
end

SlashCmdList["KILLCOUNTER"] = handler;

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

-- LoadTextures = function()
	-- local width = 10
	-- local height = 10
	-- local reportButtonTexture = KCFrame:CreateTexture("$parentGlow", "OVERLAY")
	-- KCFrame:SetAlpha(1)
	-- reportButtonTexture:SetTexture("Interface\\AddOns\\KillCounter\\report_button.blp")
	-- reportButtonTexture:SetPoint("TOPRIGHT")	
	-- reportButtonTexture:SetSize(width,height)
-- end

local CreateFrames = function()
	KCFrame=CreateFrame("Frame","KCFrame",UIParent)
	KCNames=KCFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
	KCCounts=KCFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
	KCTitle=KCFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
	KCSessionTime=KCFrame:CreateFontString(nil,"OVERLAY","GameFontNormal")
	KCPostButton = CreateFrame("Button","KCPostButton",KCFrame,"UIPanelButtonGrayTemplate")
	
	
end


local 	KCPostMenu = CreateFrame("Frame", "KC_PostMenu")
		KCPostMenu.displayMode = "MENU"
		KCPostMenu.info = {}
		KCPostMenu.HideMenu = function()
			if UIDROPDOWNMENU_OPEN_MENU == KCPostMenu then
				CloseDropDownMenus()
			end
		end
		
		KCPostMenu.HideMenu = function()
			if UIDROPDOWNMENU_OPEN_MENU == KCPostMenu then
				CloseDropDownMenus()
			end
		end


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
		info.func         = self.HideMenu()

		UIDropDownMenu_AddButton(info, level)
		
	elseif level == 2 then
		info.notCheckable = 1	
		if UIDROPDOWNMENU_MENU_VALUE == "submenu1" then
			info.text = "Party"
			info.func = function()
				SendToChat("PARTY","TOTAL")
			end
			UIDropDownMenu_AddButton(info, level)
			
			info.text = "Raid"
			info.func = function()
				SendToChat("RAID","TOTAL")
			end
			UIDropDownMenu_AddButton(info, level)
			
			info.text = "Whisper"
			UIDropDownMenu_AddButton(info, level)
			
		elseif UIDROPDOWNMENU_MENU_VALUE == "submenu2" then
			info.text = "Party"
			info.func = function()
				SendToChat("PARTY","ALL")
			end
			UIDropDownMenu_AddButton(info, level)
			
			info.text = "Raid"
			info.func = function()
				SendToChat("RAID","ALL")
			end
			UIDropDownMenu_AddButton(info, level)
			
			info.text = "Whisper"
			UIDropDownMenu_AddButton(info, level)
		end
	end
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
	KCTitle:SetText(redClr .. "Kill Counter 1.0")
	KCTitle:SetFont(KillCounterFont, fontSize*1.5, fontFlags)
	
	KCPostButton:SetPoint("TOPRIGHT", KCFrame, "BOTTOMRIGHT")
	KCPostButton:SetText("Post")
	KCPostButton:SetWidth(50)
	KCPostButton:SetHeight(20)
	KCPostButton:RegisterForClicks("LeftButtonUp")
end

local RegisterEvents = function()
	KCFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local SendToTable = function(name)
	if(killLog[name] ~= nil) then
		killLog[name] = killLog[name] + 1
	else
		killLog[name] = 1
	end
end

local GetCombatLogInfo = function()
	local _, eventType, _, sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellID = CombatLogGetCurrentEventInfo()
		if(eventType == "UNIT_DIED") then
			print(destName)
			SendToTable(destName)
		end
end

local FormatData = function()
	names = ""
	counts = ""
	total = 0
	
	for key,value in pairs(killLog) do
		names = names .. key .. "\n"
		counts = counts .. value .. "\n"
		total = total + value
	end
	
	names = names .. "Total"
	counts = counts .. total
end

local FormatAllData = function()
		namesAndCounts = ""
	for key,value in pairs(killLog) do
		namesAndCounts = namesAndCounts .. key .. ":  " .. value .. "\n"
	end
end

local SizeWindow = function()
	KCFrame:SetSize(math.max((KCNames:GetStringWidth() + KCCounts:GetStringWidth()), 200),KCNames:GetStringHeight())
end

local Display = function()
	FormatData()
	KCNames:SetText(names)
	KCCounts:SetText(counts)
	SizeWindow()
end

local PrintStringToLines = function(dest)
	SendChatMessage("KillCount: Kill Log: ", dest, "COMMON", nil)
	for str in string.gmatch(namesAndCounts, "([^".. "\n" .."]+)") do
		SendChatMessage(str, dest, "COMMON", nil)
	end
	SendChatMessage("Total Kills: " .. total, dest, "COMMON", nil)
end

local Initialize = function()
	CreateFrames()
	BackdropDefault()
	SetDefaults()
	--LoadTextures()
	RegisterEvents()
	Display()
end

SendToChat = function(dest, dataType)
	if(dataType == "TOTAL") then
		SendChatMessage("KillCount: Total Kills: " .. total, dest, "COMMON", nil)
	elseif (dataType == "ALL") then
		FormatAllData()
		PrintStringToLines(dest)
	end
end

Initialize()

KCFrame:SetScript("OnEvent",
	function(self, event, ...)
	if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
		GetCombatLogInfo()
		Display()
	end
end)

KCFrame:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" and not self.isMoving then
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











