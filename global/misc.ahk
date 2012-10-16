;Ctr+Alt+@ でAHKスクリプトをリロード
^!@::Reload

;Win+Q でアプリ終了(F4が遠いから)
#q::!F4

;[半角/全角]でIMEオフ(ONにしてるのかOFFにしてるのか分からなくなるから単体押しは全てOFF、ONはAlt+半角全角とかで行う)
vkF4sc029::IME_OFF()
vkF3sc029::IME_OFF()

;EscでIMEオフしつつESC(vimが快適になる)
$Esc::SendAfterImeOff("{Esc}")

;Shift+F1 でシングルクオート入力(ダブルクオートと同じ感覚でシングルクオート打ちたいのに遠いから)
+F1::'

; =============================
; MigemizeExplorerのヒント
;#ifWinActive ahk_exe explorer.exe
;GroupAdd, explorer, ahk_class CabinetWClass
;GroupAdd, explorer, ahk_class ExploreWClass
;$/::
;ControlGet, hwnd, hwnd, , DirectUIHWND3, ahk_group explorer
;Acc := Acc_ObjectFromWindow(hwnd)
;For Each, child in Acc_Children(Acc) {
;   n := child.accName(0)
;   MsgBox n
;   if n in %SelectList% ; if the item name is in the "SelectList"
;      child.accSelect(9,0) ; NONE=0, TAKEFOCUS=1, TAKESELECTION=2, EXTENDSELECTION=4, ADDSELECTION=8, REMOVESELECTION=16
;}
;return
;#ifWinActive

; ホイールにキー割り当てを設定すると光速に起動されるので上限を上げる
#MaxHotkeysPerInterval 350 ; default=70
#HotkeyInterval 2000 ; default=2000
