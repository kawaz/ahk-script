;Ctr+@ でアプリのクラスとタイトルを取得する
$^@::
  Send, ^@
  WinGetTitle title, A
  WinGetClass cls, A
  tooltip % "class=" cls ", title=" title
  sleep 3000
  tooltip
return

;Win+Q でアプリ終了(F4が遠いから)
#q::!F4

;[半角/全角]でIMEオフ(ONにしてるのかOFFにしてるのか分からなくなるから単体押しは全てOFF、ONはAlt+半角全角とかで行う)
vkF4sc029::IME_OFF()
vkF3sc029::IME_OFF()

;EscでIMEオフしつつESC(vimが快適になる)
$Esc::SendAfterImeOff("{Esc}")

;Shift+F1 でシングルクオート入力(ダブルクオートと同じ感覚でシングルクオート打ちたいのに遠いから)
+F1::'
