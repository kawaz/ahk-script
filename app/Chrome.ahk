; ==================
; Chrome 用の設定
; ==================

; == メモ ==
; Chromeで思い出したけどChromeでPostMessage使うと便利だよね。 
; ページエンコーディング変えたり、タブを移動を左右に移動させたりできる。 
; http://src.chromium.org/viewvc/chrome/trunk/src/chrome/app/chrome_command_ids.h?view=markup 
; Shift+PageUp/PageDownでタブを左右に移動 
; +PgUp::PostMessage, 0x111, 34033, 0,, A 
; +PgDn::PostMessage, 0x111, 34032, 0,, A 

;#ifWinActive ahk_class Chrome_WidgetWin_1
#ifWinActive ahk_exe chrome.exe ; ahk_classよりこっちのが便利

; 検索時(オムニバー)はデフォルトでIMEオフにする
$!d::SendWithImeOff("!d")
; 検索時(ページ内検索)はデフォルトでIMEオフにする
$^f::SendWithImeOff("^f")
; 検索時(ページ内検索)はデフォルトでIMEオフにする
$^g::SendWithImeOff("^g")
; Vichromeの/検索でデフォルトIMEオフにする(ただしテキスト入力中はIME操作しない)
;$/::
;  ControlGetFocus, Focus, A
;  if(Focus == "Chrome_RenderWidgetHostHWND1")
;    SendWithImeOff("/")
;  else
;    Send, /
;return


; マウスホイールでタブ切り替え(←)
~WheelUp::
  MouseGetPos, x, y
  if(y < 80) {
    send, ^{PgUp}
  }
return
; マウスホイールでタブ切り替え(→)
~WheelDown::
  MouseGetPos, x, y
  if(y < 80) {
    send, ^{PgDn}
  }
return

; TODO 最後のタブはCtr+wで閉じない
;$^w::
;  Send, ^w
;  ;WinGetText, t1, A
;  ;Send, ^{PgDn}
;  ;WinGetText, t2, A
;  ;Send, ^{PgUp}
;  ;WinGetText, alltitle, A
;  ;if t1<>%t2%
;  ;{
;  ;  Send, ^w
;  ;}
;return

#ifWinActive

