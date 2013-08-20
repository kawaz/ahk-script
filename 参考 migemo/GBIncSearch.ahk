#NoEnv

;*** 設定読み込み ***
SplitPath, A_LineFile, , GBLineDir
IniFile := GBLineDir . "\GBIncSearch.ini"
IfNotExist, %IniFile%
	FileAppend, 
(
[General]
Bookmark   = .\GoogleBookmarks.html
Browser    =
Persistent = 1
StartShow  = 0
GBWidth    = 400
GBRow      = 10

[Key]
GBHotkey   = sc03A
GBUp       = !i
GBDown     = !k

[Migemo]
MigemoMode = 0
MigemoDll  = .\migemo.dll
MigemoDict = .\dict\migemo-dict
MigemoLen  = 3

;項目の詳細：http://retla.g.hatena.ne.jp/retla/20100810/gbincsearch#config
), %IniFile%
; Bookmark
IniRead, GBTemp, %IniFile%, General, Bookmark
Bookmark := (InStr(GBTemp, ":\")) ? GBTemp : GBLineDir . "\" . GBTemp
; Browser
IniRead, GBTemp, %IniFile%, General, Browser, 
Browser := (GBTemp != Error) ? GBTemp : 
; Persistent
IniRead, GBTemp, %IniFile%, General, Persistent
Persistent := (GBTemp = 0 || GBTemp = 1) ? GBTemp : 1
; StartShow
IniRead, GBTemp, %IniFile%, General, StartShow
StartShow := (GBTemp = 0 || GBTemp = 1) ? GBTemp : 0
; Width
IniRead, GBTemp, %IniFile%, General, GBWidth
GBWidth := (GBTemp > 0) ? GBTemp : 400
; Row
IniRead, GBTemp, %IniFile%, General, GBRow
GBRow := (GBTemp > 0) ? GBTemp : 15
; GBHotkey
IniRead, GBTemp, %IniFile%, Key, GBHotkey
GBHotkey := (GBTemp != "Error") ? GBTemp : sc03A
; GBUp
IniRead, GBTemp, %IniFile%, Key, GBUp
GBUp := (GBTemp != "Error") ? GBTemp : 
; GBDown
IniRead, GBTemp, %IniFile%, Key, GBDown, 
GBDown := (GBTemp != "Error") ? GBTemp : 
; MigemoMode
IniRead, GBTemp, %IniFile%, migemo, MigemoMode
MigemoMode := (GBTemp = 0 || GBTemp = 1) ? GBTemp : 0
; MigemoDll
IniRead, GBTemp, %IniFile%, migemo, MigemoDll
MigemoDll := (InStr(GBTemp, ":\")) ? GBTemp : GBLineDir . "\" . GBTemp
; MigemoDict
IniRead, GBTemp, %IniFile%, migemo, MigemoDict
MigemoDict := (InStr(GBTemp, ":\")) ? GBTemp : GBLineDir . "\" . GBTemp
; MigemoLen
IniRead, GBTemp, %IniFile%, migemo, MigemoLen
MigemoLen := (GBTemp > 1) ? GBTemp : 2
; 変数メモリ解放
GBLineDir =
IniFile   =
GBTemp    =

;*** 指定ファイルがない場合の処理 ***
IfNotExist, %Bookmark%
{
	MsgBox, GoogleBookmarks.htmlの取得失敗。`nGBIncSearchを終了します。
	If (A_IsCompiled = 1 || A_LineFile = A_ScriptFullPath)
		ExitApp
	Else
		GoTo, GBIncSearchEnd
}
If (MigemoMode = 1 && !(FileExist(MigemoDict) && FileExist(MigemoDll)))
{
	IfExist, %MigemoDict%
		MigemoCaution = migemo.dll
	Else IfExist, %MigemoDll%
		MigemoCaution = Migemo辞書
	Else
		MigemoCaution = migemo.dllとMigemo辞書
	MsgBox, %MigemoCaution%が見つかりません。`nMigemo検索はOFFになります。
	MigemoMode = 0
	MigemoCaution :=
}

;*** GUI作成 ***
GBGui := NewGui()
ButtonWidth := (GBWidth - 15) / 2
Gui, Margin, 1, 1
Gui, %GBGui%:Add, Edit, vGBEdit gInc w%GBWidth%
Gui, %GBGui%:Add, ListView, r%GBRow% w%GBWidth% Grid Count500 -Multi AltSubmit vGBList, 追加日時　　|タイトル　　　　　　　　　　　　　　　　　　　　　　　|タグ　　　　　　　　|コメント　　　　　　|URL
Gui, %GBGui%:Add, Text, r2 w%GBWidth% vGBText
Gui, %GBGui%:Add, Button, xm+5 w%ButtonWidth% Default gButtonOpen, Open
Gui, %GBGui%:Add, Button, x+5 w%ButtonWidth% gButtonCancel, Cancel
Gui, %GBGui%:Add, StatusBar
Gui, %GBGui%:Default
SB_SetParts(60)
If (StartShow = 0 || StartShow = "")
	Gui, %GBGui%:Show, Hide, GBIncSearch
Else
	Gui, %GBGui%:Show, , GBIncSearch
Hotkey, IfWinActive, GBIncSearch ahk_class AutoHotkeyGUI
If (GBUp)
	HotKey, %GBUp%, Up
If (GBDown)
	HotKey, %GBDown%, Down
Hotkey, IfWinActive
Hotkey, %GBHotkey%, GBHotkey

;*** 初期読み込み ***
Read:
	Critical
	Gui, %GBGui%:Default
	LV_Delete()
	SB_SetText("Loading...", 1)
	FileEncoding UTF-8
	Migemo   := (MigemoMode = 1) ? Migemo_Open(MigemoDict, MigemoDll) :
	RegStr1  := "^<DT><H3 ADD_DATE="".*?"">(.*)</H3>$"
	RegStr2  := "<A HREF=""(.*?)"" ADD_DATE=""(.*?)"">(.*?)</A>$"
	RegStr3  := "^<DD>(.*)$"
	Tag      :=
	URL      :=
	Date     :=
	Title    :=
	Comment  :=
	Item     := Object()
	ListNum  := 0
	Loop, Read, %Bookmark%
	{
		StringReplace, LoopReadLine, A_LoopReadLine, `|, ｜	; 文字列にパイプが含まれていたら全角に置換（リスト項目の区切り文字だから）
		RegExMatch(LoopReadLine, RegStr1, MatchStr)
		If (MatchStr != "")
		{
			Tag := MatchStr1
			Continue
		}
		RegExMatch(LoopReadLine, RegStr2, MatchStr)
		If (MatchStr != "")
		{
			URL     := MatchStr1
			Date    := 19700101000000														; UTC基準時
			AddDate := MatchStr2 / 1000000 + 32400											; 時差修正
			EnvAdd, Date, AddDate, Seconds													; UTCから日付取得
			Date    := RegExReplace(Date, "(....)(..)(..)(..)(..)(..)","$1/$2/$3 $4:$5:$6")	; 日付フォーマットに修正
			Title   := MatchStr3
			If (URL != "" && Title = "")
			{
				Title := "No Title"
			}
			Dup   := 0
			Loop, %ListNum%
			{
				If (Item["URL", A_Index] = URL && Item["Title", A_Index] = Title)
				{
					Dup := 1
					Item["Tag", A_Index] := Item["Tag", A_Index] . "[" . Tag . "] "
					LV_Modify(A_Index, "Col3", Item["Tag", A_Index])
					Break
				}
			}
			If (Dup = 0)
			{
				ListNum += 1
				Item["Tag", ListNum]   := "[" . Tag . "] "
				Item["URL", ListNum]   := URL
				Item["Date", ListNum]  := Date
				Item["Title", ListNum] := Title
				LV_Add("", Item["Date", ListNum], Item["Title", ListNum], Item["Tag", ListNum], Item["Comment", ListNum], Item["URL", ListNum])
			}
			Continue
		}
		RegExMatch(LoopReadLine, RegStr3, MatchStr)
		If (MatchStr != "" && Dup = 0)
		{
			Comment := MatchStr1
			Item["Comment", ListNum] := Comment
			LV_Modify(ListNum, "Col4", Item["Comment", ListNum])
			Continue
		}
	}
	IncNum := ListNum	; 未検索状態の項目数＝初期状態の項目数にする
	LV_ModifyCol(1, "SortDesc")

	LV_Modify(1, "Select")
	GoSub, ChangeSel
	SB_SetText("全" . ListNum . "件", 1)
	Critical, Off
	If A_ThisLabel = Read
		Return
	Else
		GoTo, GBIncSearchEnd

;*** インクリメンタルサーチ ***
Inc:
	Critical
	IncNum := 0
	GuiControlGet, Search, %GBGui%:, GBEdit
	StringReplace, Search, Search, `|, ｜	; 半角パイプを全角に変換
	Transform, Search, HTML, %Search%		; 一部文字を実体参照に変換
	LV_Delete()
	Loop, %ListNum%
	{
		Target := Item["Title", A_Index] . A_Space . Item["URL", A_Index] . A_Space . Item["Tag", A_Index] . A_Space . Item["Comment", A_Index]
		Match  := 1
		Loop, Parse, Search, %A_Space%
		{
			If (!InStr(Target, A_LoopField) && (MigemoMode != 1 || StrLen(A_LoopField) < MigemoLen || !RegExMatch(Target, Migemo.Query(A_LoopField))))
			{
				Match := 0
				Break
			}
		}
		If (Match = 1)
		{
			LV_Add("", Item["Date", A_Index], Item["Title", A_Index], Item["Tag", A_Index], Item["Comment", A_Index], Item["URL", A_Index])
			IncNum += 1
			Result%IncNum% := A_Index
		}
	}
	LV_ModifyCol(1, "SortDesc")
	LV_Modify(1, "Select")
	GoSub, ChangeSel
	SB_SetText(IncNum . "/" . ListNum, 1)
	If (IncNum = 0)
		SB_SetText("該当無し", 2)
	Critical, Off
Return

;*** 項目選択時の処理 ***
ChangeSel:
	Gui, %GBGui%:Default
	SelNum := LV_GetNext("")
	If Act = Up
		SelNum -= 1
	Else If Act = Down
		SelNum += 1
	If SelNum < 1
		SelNum += IncNum
	Else If SelNum > %IncNum%
		SelNum -= IncNum
	Act :=
	LV_Modify(SelNum, "Select Vis")
	LV_GetText(SelTag, SelNum, 3)
	LV_GetText(SelComment, SelNum, 4)
	LV_GetText(SelURL, SelNum, 5)
	GuiControl, %GBGui%:, GBText, % " タグ:     " . SelTag . "`n コメント: " . SelComment
	SB_SetText(SelURL, 2)
Return

;*** キー操作 ***
; アクティブ時
#IfWinActive, GBIncSearch ahk_class AutoHotkeyGUI
F5::
	GuiControl, %GBGui%:, GBEdit, 
	sleep,50
	GoTo, Read
^F5::
	Run, https://www.google.com/bookmarks/bookmarks.html
	GoTo, GuiClose
Return
Up::
	Act = Up
	GoTo, ChangeSel
Down::
	Act = Down
	GoTo, ChangeSel
~LButton::
	Sleep, 100
	GoSub, ChangeSel
	If A_TickCount < %KeyDouble%
	{
		KeyDouble = 0
		GoTo, ButtonOpen
	}
	Else
	{
		KeyDouble := A_TickCount + 200
	}
Return
Alt::Return	; Altを押すと存在しないメニューバーにフォーカスが移る？ので無効化
; グローバル
#IfWinActive
GBHotkey:
	IfWinActive, GBIncSearch ahk_class AutoHotkeyGUI
	{
		GoTo, Quit
	}
	Else
	{
		GuiControl, %GBGui%:Focus, GBEdit
		Gui, %GBGui%:Show
	}
Return


;*** Migemo.ahk ***
; 以下より拝借：http://hibari.2ch.net/test/read.cgi/software/1280482227/118,148
Migemo_Open(dict, dll="migemo.dll") {
	static base := Object("__Delete", "Migemo_ObjDelete", "Query", "Migemo_ObjQuery", "hModule", 0)
	If (!base.hModule) {
		If (hModule := DllCall("LoadLibrary", "Str", dll, "Ptr")) {
			base.hModule    := hModule
			base.func_close := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "migemo_close", "Ptr")
			base.func_query := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "migemo_query", "Ptr")
		} else {
			MsgBox, 65, Warning, Failed to initialize Migemo.dll`nContinue?
			IfMsgBox, Cancel
				Exit
		}
	}
	Return Object("base", base, "hMigemo", DllCall("migemo.dll\migemo_open", "AStr", dict, "Ptr"))
}
Migemo_ObjDelete(self) {
	If DllCall(self.base.func_close, "Ptr", self.hMigemo)
		self.Remove("hMigemo") := 0
}
Migemo_ObjQuery(self, word) {
	Return DllCall(self.base.func_query, "Ptr", self.hMigemo, "AStr", word, "AStr")
}


;*** Gui番号の生成関数（旧「流行らせるページ」の関数） ***
NewGui(){
    Process,Exist
    mypid:=ErrorLevel
    DetectHiddenWindows,On
    WinGet,h,list,ahk_pid %mypid% ahk_class AutoHotkeyGUI
    DetectHiddenWindows,Off
    Loop,99{
        found=0
        Gui,%A_Index%:+LastFound
        WinGet,hwnd,id
        Loop,%h%{
            if(h%A_Index%=hwnd){
                found=1
                break
            }
        }
        if(found=0){
            return A_Index
        }
    }
    return 0
}


;*** OpenボタンでURLを開く（そのまま終了処理へ） ***
ButtonOpen:
	If (Browser != "")
		Run, % Browser . A_Space . SelURL
	Else
		Run, % SelURL

;*** 終了処理 ***
Quit:
ButtonCancel:
GuiClose:
GuiEscape:
	If (Persistent = 0 && (A_IsCompiled = 1 || A_LineFile = A_ScriptFullPath))
		ExitApp						; 単独非常駐実行の場合はスクリプト終了
	Else
		Gui, %GBGui%:Show, Hide		; 組み込み・常駐で使っている場合はGUIを非表示化
	GuiControl, %GBGui%:, GBEdit, 
Return

GBIncSearchEnd:
