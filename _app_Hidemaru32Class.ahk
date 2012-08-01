; ==================
; 秀丸 用の設定
; ==================
#ifWinActive ahk_class Hidemaru32Class

; Ctr+PgUp/PgDn でタブ移動する
^PgUp::Send, +^{Tab}
^PgDn::Send, ^{Tab}

; Ctr+Wでタブを閉じる
$^W::Send, !fx

#ifWinActive
