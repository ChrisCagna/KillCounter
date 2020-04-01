KillCounterVarrables = {

}


local xpos1 = 0
local ypos1 = 0
local xpos2 = 0
local ypos2 = 0
local xpos3 = 0
local ypos3 = 0

local names = ""
local counts = ""
local total = 0

killLog = { }

SLASH_KILLCOUNTER1 = "/kc"

local function handler(msg, editBox)
	if(msg == "test") then
	
		print("Kill Counter Working")
		--SendChatMessage(total, "PARTY", "COMMON", nil)
		SendToChat()
		
	end
end

SlashCmdList["KILLCOUNTER"] = handler;

BackdropDefault = function()

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
	KCPostButton = CreateFrame("Button","KCPostButton",KCFrame,"UIPanelButtonGrayTemplate")

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
	
	KCNames:SetPoint("TOPLEFT")
	KCNames:SetJustifyH("LEFT")
	KCNames:SetText("Name1\nName2")
	
	KCCounts:SetPoint("TOPRIGHT")
	KCCounts:SetJustifyH("RIGHT")
	KCCounts:SetText("##")
	
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

local SizeWindow = function()
	KCFrame:SetSize((KCNames:GetStringWidth() + KCCounts:GetStringWidth())*1.5,KCNames:GetStringHeight())
end

local Display = function()
	FormatData()
	KCNames:SetText(names)
	KCCounts:SetText(counts)
	SizeWindow()
end

local Initialize = function()
	CreateFrames()
	BackdropDefault()
	SetDefaults()
	RegisterEvents()
	Display()
end

local SendToChat = function()
	SendChatMessage("KillCount: Total Kills: " .. total, "PARTY", "COMMON", nil)
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
	KCFrame:SetBackdrop(backdrop)
end)

KCFrame:SetScript('OnLeave', function() 
	KCFrame:SetBackdropColor(1,1,1,0)
end)

KCPostButton:SetScript('OnMouseUp', function(self, button)
	SendToChat()
end)









