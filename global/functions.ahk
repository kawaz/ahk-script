; アクティブWindowsのタイトルによって送信するキーを変更する
SendIfTitleMatch(titleRegExp, matchKey, notMatchKey) {
	WinGetTitle title, A
	if(RegExMatch(title, titleRegExp)) {
		Send, %matchKey%
	} else {
		Send, %notMatchKey%
	}
}
