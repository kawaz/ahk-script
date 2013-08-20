;Ctr+Alt+@ でAHKスクリプトをリロード
^!@::Reload

;Win+Q でアプリ終了(F4が遠いから)
#q::!F4

;[半角/全角]でIMEオフ(ONにしてるのかOFFにしてるのか分からなくなるから単体押しは全てOFF、ONはAlt+半角全角とかで行う)
vkF4sc029::IME_OFF()
vkF3sc029::IME_OFF()

;EscでIMEオフしつつESC(vimが快適になる)
$Esc::SendAfterImeOff("{Esc}")

;Shift+F1辺りでシングルクオート入力(ダブルクオートと同じ感覚でシングルクオート打ちたいのに遠いから)
+F1::'
+F2::'
;F1もどうせヘルプ誤爆がウザいからシングルクオートにしてしまう
F1::'

; ホイールにキー割り当てを設定すると光速に起動されるので上限を上げる
#MaxHotkeysPerInterval 350 ; default=70
#HotkeyInterval 2000 ; default=2000
