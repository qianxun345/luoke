#MaxThreadsPerHotkey 2
global isRunning := false

; 【关键步骤】：将下面的 YourGame.exe 替换为你的游戏进程名
#IfWinActive ahk_exe NRC-Win64-Shipping.exe

Home::
isRunning := !isRunning ; 按下Home键切换状态（开启/关闭）

if (isRunning) {
    ToolTip, ▶ Script Started (Press Home to Stop)
    SetTimer, RemoveToolTip, -2000 ; 提示文字2秒后自动消失
} else {
    ToolTip, ⏹ Script Stopped
    SetTimer, RemoveToolTip, -2000
    return ; 如果切换为停止状态，直接打断并结束
}

; 只要开启，就一直循环执行 2、3、4、5、6 的流程
while (isRunning) {
    ; 依次遍历数字 2 到 6
    Loop, Parse, % "23456" 
    {
        if (!isRunning) ; 如果中途按了Home键停止，立刻跳出循环
            break

        ; 1. 按下数字键
        Send, {%A_LoopField% down}
        RandomSleep(80, 120)
        Send, {%A_LoopField% up}

        ; 2. 等待 1.1 秒左右 (随机 1000~1200 毫秒)
        if (!SafeSleep(1000, 1200))
            break

        ; 3. 鼠标左键点击
        Click, down
        RandomSleep(80, 120)
        Click, up

        ; 4. 等待 1.1 秒左右
        if (!SafeSleep(1000, 1200))
            break
    }
}
return

; ============================
; 增强：安全无延迟等待函数（带随机延迟）
; ============================
SafeSleep(minTime, maxTime) {
    global isRunning
    Random, targetTime, %minTime%, %maxTime%
    ticks := targetTime / 50
    Loop, %ticks% 
    {
        if (!isRunning)
            return false
        Sleep, 50
    }
    return true
}

; ============================
; 随机延迟函数（用于按键按压时长）
; ============================
RandomSleep(min, max) {
    Random, randTime, %min%, %max%
    Sleep, %randTime%
}

; 清除屏幕提示文字的子程序
RemoveToolTip:
ToolTip 
return

#IfWinActive ; 结束游戏窗口绑定