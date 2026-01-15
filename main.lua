-- ใช้ Library ตัวสำรองเพื่อป้องกัน Error บรรทัดที่ 11
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonh02/Orion/main/source')))()

getgenv().MainConfig = {
    MainAccountName = "ชื่อไอดีหลักของคุณ", -- **กรุณาเปลี่ยนเป็นชื่อไอดีหลักจริงๆ**
    AutoRandom = true,
    AutoDrop = true,
    AutoLeave = true
}

local Window = OrionLib:MakeWindow({Name = "Chicken Bot 1.0", HidePremium = false, SaveConfig = true, ConfigFolder = "FruitBotConfig"})
local Tab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})

Tab:AddLabel("Status: Bot is Running...")

-- ระบบวนลูปทำงานอัตโนมัติ
spawn(function()
    while wait(2) do
        -- สุ่มผลปีศาจ
        if getgenv().MainConfig.AutoRandom then
            pcall(function() 
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Cousin", "Buy") 
            end)
        end
        
        -- ตรวจสอบและวาร์ปไปโยนผล
        if getgenv().MainConfig.AutoDrop then
            local fruit = nil
            for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if v:IsA("Tool") and v.ToolTip == "Blox Fruit" then fruit = v break end
            end
            
            if fruit then
                local mainPlr = game.Players:FindFirstChild(getgenv().MainConfig.MainAccountName)
                if mainPlr and mainPlr.Character then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mainPlr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                    wait(0.5)
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(fruit)
                    wait(0.5)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Backspace", false, game)
                    if getgenv().MainConfig.AutoLeave then wait(2) game:Shutdown() end
                end
            end
        end
    end
end)

OrionLib:Init()