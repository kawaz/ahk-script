; アクティブWindowsのタイトルによって送信するキーを変更する
; @param titleRegExp タイトルの正規表現
; @param matchKey マッチした時に送信するキー
; @param notMatchKey マッチしなかった時に送信するキー
SendIfTitleMatch(titleRegExp, matchKey, notMatchKey) {
  WinGetTitle title, A
  if(RegExMatch(title, titleRegExp)) {
    Send, %matchKey%
  } else {
    Send, %notMatchKey%
  }
}

; keyを送信した後IMEをオフにする
; @param key 送信するキー
SendWithImeOff(key) {
  IME_OFF()
  Send, %key%
}

; IMEをオフにした後keyを送信する
; @param key 送信するキー
SendAfterImeOff(key) {
  Send, %key%
  IME_OFF()
}

; IMEの状態をセット
; @param SetSts 1:ON, 0:OFF
; @param WinTitle="A" 対象Window
; @return 0:成功, 0以外:失敗
IME_SET(SetSts, WinTitle="A") {
  VarSetCapacity(stGTI, 48, 0)
  NumPut(48, stGTI,  0, "UInt") ; DWORD cbSize;
  hwndFocus := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI) ? NumGet(stGTI,12,"UInt") : WinExist(WinTitle)
  return DllCall("SendMessage"
    , UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwndFocus)
    , UInt, 0x0283  ;Message : WM_IME_CONTROL
    , Int, 0x006    ;wParam  : IMC_SETOPENSTATUS
    , Int, SetSts)  ;lParam  : 0 or 1
}

; IMEをONする
; @param WinTitle="A" 対象Window
; @return 0:成功, 0以外:失敗
IME_ON(WinTitle="A") {
  return IME_SET(1, WinTitle)
}

; IMEをOFFする
; @param WinTitle="A" 対象Window
; @return 0:成功, 0以外:失敗
IME_OFF(WinTitle="A") {
  return IME_SET(0, WinTitle)
}
