#MaxThreadsPerHotkey 2
global isRunning := false

; 绑定游戏窗口，只有在这个游戏里按 PgUp 才有效
#IfWinActive ahk_exe NRC-Win64-Shipping.exe

; 获取窗口客户区大小的函数
GetClientSize(ByRef w, ByRef h) {
    WinGet, hwnd, ID, A
    VarSetCapacity(rect, 16)
    DllCall("GetClientRect", "ptr", hwnd, "ptr", &rect)
    w := NumGet(rect, 8, "int")
    h := NumGet(rect, 12, "int")
}

PgUp::
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
    GetClientSize(w, h)
    
    ; 1. 按m键
    if (!isRunning) 
        break
    ToolTip, Action: Pressing M Key
    Send, {m down}
    RandomSleep(80, 120)
    Send, {m up}
    if (!SafeSleep(1300, 1500)) 
        break

; 3. 直接点击屏幕正中央，上下左右随机偏移5像素，然后等待 10s 代替 image2
    if (!isRunning)
        break
    CoordMode, Mouse, Client

    ; 执行记录点的点击
    ToolTip, Action: Clicking Screen Center
    Random, offsetX, -5, 5
    Random, offsetY, -5, 5
    targetX := Round(w / 2) + offsetX
    targetY := Round(h / 2) + offsetY
    Click, %targetX%, %targetY%
    if (!SafeSleep(500, 700)) 
        break
    
    ; 然后点击右下角区域 client(1070-1478, 833-864) 转换自1600x900
    if (!isRunning) 
        break
    ToolTip, Action: Clicking Client (66.8`% to 92.3`%`, 92.5`% to 96`%)
    Random, randPctX2, 0.66875, 0.92375
    Random, randPctY2, 0.9255, 0.9600
    X2 := Round(randPctX2 * w)
    Y2 := Round(randPctY2 * h)
    Click, %X2%, %Y2%

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

    ; 6. 执行鞠躬动作，循环8-12次
    Random, loopCount, 8, 12
    ToolTip, Action: Loop Action %loopCount% times
    Loop, %loopCount% {
        if (!isRunning) 
            break

        ; --- 反检测：1. 模拟玩家发呆/看手机 (约 3% 概率延迟 10-20秒) ---
        Random, afkChance, 1, 100
        if (afkChance <= 3) {
            ToolTip, Action: Simulating Human Distraction...
            if (!SafeSleep(10000, 20000))
                break
        }
        
        ; --- 反检测：2. 独立的随机鼠标游离抖动 (约 8% 概率) ---
        Random, jitterChance, 1, 100
        if (jitterChance <= 8) {
            RandomMouseJitter()
        }

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

        ; (4) R键 (反检测：概率性多按1~2次)
        ToolTip, Action: Pressing R Key
        Random, randR, 1, 100
        rPresses := (randR <= 15) ? 2 : ((randR <= 20) ? 3 : 1) ; 15%按2次，5%按3次
        Loop, %rPresses% {
            Send, {r down}
            RandomSleep(80, 120)
            Send, {r up}
            if (A_Index < rPresses)
                RandomSleep(150, 300)
        }
        if (!SafeSleep(9500, 10500)) 
            break

        ; (5) X键 (反检测：概率性多按1~2次)
        ToolTip, Action: Pressing X Key
        Random, randX, 1, 100
        xPresses := (randX <= 15) ? 2 : ((randX <= 20) ? 3 : 1) ; 15%按2次，5%按3次
        Loop, %xPresses% {
            Send, {x down}
            RandomSleep(80, 120)
            Send, {x up}
            if (A_Index < xPresses)
                RandomSleep(150, 300)
        }
        if (!SafeSleep(40, 60)) 
            break
    }
    
    ; --- 反检测：大循环结束后的随机喘息时间 (约 5% 概率停顿 5-10秒) ---
    Random, restChance, 1, 100
    if (restChance <= 5) {
        ToolTip, Action: Taking a short break...
        if (!SafeSleep(5000, 10000))
            break
    } else {
        ; 正常情况下的短停顿
        if (!SafeSleep(800, 1200)) 
            break
    }
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

; ============================
; 反检测：微小鼠标游荡/抖动
; ============================
; 模拟人手处于放松状态时不经意地触碰鼠标导致的光标滑动
RandomMouseJitter() {
    MouseGetPos, curX, curY
    Random, jX, -20, 20
    Random, jY, -20, 20
    ; Speed参数 2~5 模仿较为自然的滑动速度
    Random, speed, 2, 5
    MouseMove, curX + jX, curY + jY, %speed%
}

; 清理屏幕提示的子程序
RemoveToolTip:
ToolTip 
return

#IfWinActive ; 结束游戏窗口绑定