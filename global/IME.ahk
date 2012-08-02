;-----------------------------------------------------------
; IMEの状態をセット
;   SetSts          1:ON / 0:OFF
;   WinTitle="A"    対象Window
;   戻り値          0:成功 / 0以外:失敗
;-----------------------------------------------------------
IME_SET(SetSts, WinTitle="A")  {
  VarSetCapacity(stGTI, 48, 0)
  NumPut(48, stGTI,  0, "UInt")   ;  DWORD   cbSize;
  hwndFocus := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI) ? NumGet(stGTI,12,"UInt") : WinExist(WinTitle)
  return DllCall("SendMessage"
    , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwndFocus)
    , UInt, 0x0283  ;Message : WM_IME_CONTROL
    ,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
    ,  Int, SetSts) ;lParam  : 0 or 1
}

;[半角/全角]でIMEオフ
vkF4sc029::IME_SET(0)
vkF3sc029::IME_SET(0)

;EscでIMEオフしつつESC
$Esc::
  IME_SET(0)
  Send, {Esc}
return
