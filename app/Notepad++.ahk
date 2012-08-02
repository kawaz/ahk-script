; ==================
; Notepad++ 用の設定
; ==================
#ifWinActive ahk_class Notepad++

; Notepad++でタブが無ければCtr+Wで終了する。
$^w::SendIfTitleMatch("[\*\\]", "^w", "!{F4}")

; Ctr+PgUp/PgDn で即タブ移動する
; あとデフォルトのタブ移動の挙動は分かりにくいので以下の設定をしておく！
; http://bit.ly/MyjVxZ
^PgUp::Send, +^{Tab}{Esc}
^PgDn::Send, ^{Tab}{Esc}

#ifWinActive
