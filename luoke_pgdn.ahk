#MaxThreadsPerHotkey 2
global isRunning := false

; 绑定游戏窗口，只有在这个游戏里按 PgDn 才有效
#IfWinActive ahk_exe NRC-Win64-Shipping.exe

PgDn::
isRunning := !isRunning ; 按下 PgDn 切换开启/关闭状态

if (isRunning) {
    ToolTip, ▶ Script Started (Press PgDn to Stop)
    SetTimer, RemoveToolTip, -2000 ; 提示文字2秒后消失
} else {
    ToolTip, ⏹ Script Stopped
    SetTimer, RemoveToolTip, -2000
    return ; 停止时打断后面的动作
}

; 循环执行动作
while (isRunning) {
    
    ; 1. Tab键
    if (!isRunning) 
        break
    Send, {Tab down}
    RandomSleep(80, 120)
    Send, {Tab up}
    if (!SafeSleep(900, 1100)) 
        break

    ; 2. 数字2键
    if (!isRunning) 
        break
    Send, {2 down}
    RandomSleep(180, 240)
    Send, {2 up}
    if (!SafeSleep(3800, 4200)) 
        break

    ; 3. Esc键
    if (!isRunning) 
        break
    Send, {Esc down}
    RandomSleep(80, 120)
    Send, {Esc up}
    if (!SafeSleep(450, 550)) 
        break

    ; 4. R键
    if (!isRunning) 
        break
    Send, {r down}
    RandomSleep(80, 120)
    Send, {r up}
    if (!SafeSleep(9500, 10500)) 
        break

    ; 5. X键
    if (!isRunning) 
        break
    Send, {x down}
    RandomSleep(80, 120)
    Send, {x up}
    if (!SafeSleep(40, 60)) 
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