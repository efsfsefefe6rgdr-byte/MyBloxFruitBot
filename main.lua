-- ตั้งค่าเบื้องต้น (แก้ชื่อตัวหลักตรงนี้ได้เลย หรือไปแก้ในหน้าต่าง GUI ก็ได้)
getgenv().MainConfig = {
    MainAccountName = "Rimuru_Dkoz6i", 
    AutoRandom = true,
    AutoDrop = true,
    AutoLeave = true
}
----------------------------------------------------------------
-- เริ่มโหลด Library สร้างหน้าต่าง (ไม่ต้องแก้ข้างล่างนี้)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonh02/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Chicken Farm Bot 1.0", HidePremium = false, SaveConfig = true, ConfigFolder = "FruitBotConfig"})

-- หน้าหลัก (General)
local Tab = Window:MakeTab({
	Name = "หน้าหลัก",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- ส่วนแสดงสถานะ
Tab:AddLabel("สถานะ: กำลังทำงาน...")

-- ช่องใส่ชื่อตัวหลัก
Tab:AddTextbox({
	Name = "Rimuru_Dkoz6i",
	Default = getgenv().MainConfig.MainAccountName,
	TextDisappear = false,
	Callback = function(Value)
		getgenv().MainConfig.MainAccountName = Value
	end	  
})

-- ปุ่มเปิดปิด Auto Random
Tab:AddToggle({
	Name = "Auto Random Fruit (สุ่มผล)",
	Default = getgenv().MainConfig.AutoRandom,
	Callback = function(Value)
		getgenv().MainConfig.AutoRandom = Value
	end    
})

-- ปุ่มเปิดปิด Auto Drop
Tab:AddToggle({
	Name = "Auto Teleport & Drop (ส่งผลให้ตัวหลัก)",
	Default = getgenv().MainConfig.AutoDrop,
	Callback = function(Value)
		getgenv().MainConfig.AutoDrop = Value
	end    
})

----------------------------------------------------------------
-- ฟังก์ชันการทำงาน (Logic)

-- ฟังก์ชันสุ่มผล
function AttemptRandom()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy")
end

-- ฟังก์ชันหาไอเทมผลปีศาจในตัว
function GetFruit()
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
            return v
        end
    end
    for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then
            return v
        end
    end
    return nil
end

-- ระบบวนลูปทำงาน
spawn(function()
    while wait(1) do
        -- 1. ถ้าเปิด Auto Random ให้ลองสุ่ม
        if getgenv().MainConfig.AutoRandom then
            pcall(function()
                AttemptRandom()
            end)
        end
        
        -- 2. ถ้าเปิด Auto Drop และมีผลในตัว ให้ไปหาตัวหลัก
        if getgenv().MainConfig.AutoDrop then
            local fruit = GetFruit()
            if fruit then
                local mainPlr = game.Players:FindFirstChild(getgenv().MainConfig.MainAccountName)
                if mainPlr and mainPlr.Character and mainPlr.Character:FindFirstChild("HumanoidRootPart") then
                    -- วาร์ปไปหา
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mainPlr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                    wait(0.5)
                    -- ถือผล
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(fruit)
                    wait(0.5)
                    -- โยนผล
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Backspace", false, game)
                    
                    -- ถ้าตั้งค่าให้ปิดเกมเมื่อเสร็จงาน
                    if getgenv().MainConfig.AutoLeave then
                        wait(2)
                        game:Shutdown() -- ปิดเกม
                    end
                end
            end
        end
    end
end)

OrionLib:Init()