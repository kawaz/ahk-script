;[半角/全角]でIMEオフ
vkF4sc029::IME_OFF()
vkF3sc029::IME_OFF()

;EscでIMEオフしつつESC
$Esc::
  IME_OFF()
  Send, {Esc}
return
