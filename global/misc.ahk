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

;Shift+F1 でシングルクオート入力(ダブルクオートと同じ感覚でシングルクオート打ちたいのに遠いから)
+F1::'
