; ===== メモ =====
; # = Win , ! = Alt , ^ = Ctrl , + = Shift
; 左Ctrl = LCtrl , ひらがなカタカナ = vkF2sc070
; 変換 = vk1Csc079 , 無変換 = vk1Dsc07B
; 半角 = vkF4sc029 , 全角 = vkF3sc029
;
; AutoHotkey スレッド part14
; http://anago.2ch.net/test/read.cgi/software/1333372506/

#include global/functions.ahk
#include global/misc.ahk
#include app/Notepad++.ahk
#include app/Hidemaru.ahk
#include app/Chrome.ahk

; TIPS
;
; トレイアイコンを帰るにはスクリプト内で Menu, Tray, Icon, icon.ico する。
; EXEへのコンパイル時に指定するアイコンはエクスプローラで表示されるものなのでトレイアイコンとは別なので注意。
; http://anago.2ch.net/test/read.cgi/software/1333372506/397-403