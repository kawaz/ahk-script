; ==================
; Chrome 用の設定
; ==================
#ifWinActive ahk_class Chrome_WidgetWin_1

; 検索時(オムニバー)はデフォルトでIMEオフにする
$!d::SendWithImeOff("!d")
; 検索時(ページ内検索)はデフォルトでIMEオフにする
$^f::SendWithImeOff("^f")
; 検索時(ページ内検索)はデフォルトでIMEオフにする
$^g::SendWithImeOff("^g")
; 検索時(Vichrome)はデフォルトでIMEオフにする
$/::SendWithImeOff("/")

#ifWinActive
