#MaxThreadsPerHotkey 2
global isRunning := false
global targetPointX := -1
global targetPointY := -1

; 绑定游戏窗口，只有在这个游戏里按 PgUp 才有效
#IfWinActive ahk_exe NRC-Win64-Shipping.exe

PgDn::
CoordMode, Mouse, Client
MouseGetPos, targetPointX, targetPointY
ToolTip, Recorded Target Point: %targetPointX%`, %targetPointY%
SetTimer, RemoveToolTip, -2000
return

PgUp::
if (targetPointX = -1) {
    MsgBox, 请先按下 PgDn 记录传送点的位置！
    return
}
isRunning := !isRunning ; 按下 PgUp 切换开启/关闭状态

if (isRunning) {
    hasClickedClient := false ; 每次按 PgUp 启动时重置标记
    ToolTip, Script Started (Press PgUp to Stop)
    SetTimer, RemoveToolTip, -2000 ; 提示文字2秒后消失
} else {
    ToolTip, Script Stopped
    SetTimer, RemoveToolTip, -2000
    return ; 停止时打断后面的动作
}

; 循环执行动作
while (isRunning) {
    
    ; 1. 按m键
    if (!isRunning) 
        break
    ToolTip, Action: Pressing M Key
    Send, {m down}
    RandomSleep(80, 120)
    Send, {m up}
    if (!SafeSleep(1300, 1500)) 
        break

    ; 2. 鼠标点击client（115-125,386-390） (仅执行一次)
    if (!hasClickedClient) {
        if (!isRunning) 
            break
        ToolTip, Action: Clicking Client (115-125`, 386-390)
        Random, randX1, 115, 125
        Random, randY1, 386, 390
        X1 := randX1 + 9
        Y1 := randY1 + 38
        Click, %X1%, %Y1%
        if (!SafeSleep(300, 500)) 
            break
        hasClickedClient := true ; 执行完成后将其打上标记，后续循环不再进入
    }

    ; 3. 直接点击 PgDn 记录的传送点，然后等待 10s 代替 image2
    if (!isRunning) 
        break
    CoordMode, Mouse, Client

    ; 执行记录点的点击
    ToolTip, Action: Clicking Recorded Point
    Click, %targetPointX%, %targetPointY%
    if (!SafeSleep(300, 500)) 
        break
    
    ; 然后点击右下角区域 client(1070-1478, 833-864)
    if (!isRunning) 
        break
    ToolTip, Action: Clicking Client (1070-1478`, 833-864)
    Random, randX2, 1070, 1478
    Random, randY2, 833, 864
    Click, %randX2%, %randY2%
    if (!SafeSleep(300, 500)) 
        break

    ; 4. 不再识别 image2，直接等待 10s 后开始后续操作
    ToolTip, Action: Waiting for 10s...
    if (!SafeSleep(10000, 10000))
        break

    if (!isRunning)
        break

    ; 5. 借用luoke_home.ahk中的“依次遍历数字 2 到 6”流程
    Loop, Parse, % "13456" 
    {
        if (!isRunning) 
            break
        
        ToolTip, Action: Pressing Key %A_LoopField%
        Send, {%A_LoopField% down}
        RandomSleep(80, 120)
        Send, {%A_LoopField% up}

        if (!SafeSleep(1000, 1200))
            break
        
        ToolTip, Action: Left Calling (Key %A_LoopField%)
        Click, down
        RandomSleep(80, 120)
        Click, up

        if (!SafeSleep(1000, 1200))
            break
    }

        ; (2) 数字2键
    ToolTip, Action: Pressing 2 Key
    Send, {2 down}
    RandomSleep(180, 240)
    Send, {2 up}
    if (!SafeSleep(3800, 4200)) 
        break

    ; 6. 执行luoke_pgdn.ahk中的1-5步，循环8-12次
    Random, loopCount, 8, 12
    ToolTip, Action: Loop Action %loopCount% times
    Loop, %loopCount% {
        if (!isRunning) 
            break

        ; (1) Tab键
        ToolTip, Action: Pressing Tab Key
        Send, {Tab down}
        RandomSleep(80, 120)
        Send, {Tab up}
        if (!SafeSleep(900, 1100)) 
            break

        ; (2) 数字2键
        ToolTip, Action: Pressing 2 Key
        Send, {2 down}
        RandomSleep(180, 240)
        Send, {2 up}
        if (!SafeSleep(3800, 4200)) 
            break

        ; (3) Esc键
        ToolTip, Action: Pressing Esc Key
        Send, {Esc down}
        RandomSleep(80, 120)
        Send, {Esc up}
        if (!SafeSleep(450, 550)) 
            break

        ; (4) R键
        ToolTip, Action: Pressing R Key
        Send, {r down}
        RandomSleep(80, 120)
        Send, {r up}
        if (!SafeSleep(9500, 10500)) 
            break

        ; (5) X键
        ToolTip, Action: Pressing X Key
        Send, {x down}
        RandomSleep(80, 120)
        Send, {x up}
        if (!SafeSleep(40, 60)) 
            break
    }
    if (!SafeSleep(800, 1200)) 
            break
}
return

; ============================
; 增强：安全无延迟等待函数 (带随机延迟)
; ============================
; 将长时间的Sleep切碎为一个个50ms，每次循环都检查是否被中断。
; 使用 Random 增加随机时间波动，模拟真人。
SafeSleep(minTime, maxTime) {
    global isRunning
    Random, targetTime, %minTime%, %maxTime%
    ticks := targetTime / 50
    Loop, %ticks% 
    {
        if (!isRunning)
            return false ; 被中断了，返回false
        Sleep, 50
    }
    return true ; 正常走完，返回true
}

; ============================
; 随机延迟函数（用于按键按压时长）
; ============================
RandomSleep(min, max) {
    Random, randTime, %min%, %max%
    Sleep, %randTime%
}

; 清理屏幕提示的子程序
RemoveToolTip:
ToolTip 
return

#IfWinActive ; 结束游戏窗口绑定