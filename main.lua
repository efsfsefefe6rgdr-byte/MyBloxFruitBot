-- เปลี่ยน Library เป็นตัวสำรองที่เสถียรกว่า
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonh02/Orion/main/source')))()

getgenv().MainConfig = {
    MainAccountName = "Rimuru_Dkoz6i", -- **แก้ชื่อไอดีหลักตรงนี้**
    AutoRandom = true,
    AutoDrop = true,
    AutoLeave = true
}

local Window = OrionLib:MakeWindow({Name = "Chicken Farm Bot 1.0", HidePremium = false, SaveConfig = true, ConfigFolder = "FruitBotConfig"})

local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddLabel("Status: Bot is Running...")

Tab:AddTextbox({
	Name = "Rimuru_Dkoz6i",
	Default = getgenv().MainConfig.MainAccountName,
	TextDisappear = false,
	Callback = function(Value)
		getgenv().MainConfig.MainAccountName = Value
	end	  
})

-- ฟังก์ชันสุ่มผล
function AttemptRandom()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
end

-- ฟังก์ชันหาผลไม้
function GetFruit()
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then return v end
    end
    for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then return v end
    end
    return nil
end

-- ลูปหลัก
spawn(function()
    while wait(2) do
        if getgenv().MainConfig.AutoRandom then
            pcall(function() AttemptRandom() end)
        end
        
        if getgenv().MainConfig.AutoDrop then
            local fruit = GetFruit()
            if fruit then
                local mainPlr = game.Players:FindFirstChild(getgenv().MainConfig.MainAccountName)
                if mainPlr and mainPlr.Character and mainPlr.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mainPlr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    wait(0.5)
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(fruit)
                    wait(0.5)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Backspace", false, game)
                    if getgenv().MainConfig.AutoLeave then
                        wait(2)
                        game:Shutdown() 
                    end
                end
            end
        end
    end
end)

OrionLib:Init()