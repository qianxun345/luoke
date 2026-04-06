#MaxThreadsPerHotkey 2
global isRunning := false

; 绑定游戏窗口（如有需要取消注释替换进程名）
; #IfWinActive ahk_exe NRC-Win64-Shipping.exe

PgDn::
isRunning := !isRunning ; 按下 PgDn 切换开启/关闭状态

if (isRunning) {
    ToolTip, Auto Clicker Started (Press PgDn to Stop)
    SetTimer, RemoveToolTip, -2000 ; 提示文字2秒后消失
} else {
    ToolTip, Auto Clicker Stopped
    SetTimer, RemoveToolTip, -2000
    return ; 停止时打断后面的动作
}

; 循环执行动作
while (isRunning) {
    
    if (!isRunning) 
        break
    
    ; 模拟鼠标左键点击，增加按下时间防止漏检
    Click, Down
    Random, randSleep, 30, 60
    Sleep, %randSleep% ; 增加按键随机停留 30 - 60ms
    Click, Up

    ; 等待 0.8 - 1.2 秒 (800ms - 1200ms)
    ; SafeSleep 会分割睡眠时间，以便在等待期间按下PgDn能迅速中断
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

; 清理屏幕提示的子程序
RemoveToolTip:
ToolTip 
return

; #IfWinActive ; 结束游戏窗口绑定
