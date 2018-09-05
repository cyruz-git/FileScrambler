; ----------------------------------------------------------------------------------------------------------------------
; Name .........: FileScrambler
; Description ..: Camouflaging tool that helps hiding files and directories scrambling names and swapping header bytes.
; AHK Version ..: AHK_L 1.1.26.1 x32/64 ANSI/Unicode
; Author .......: (C) 2018 by Ciro Principe
; Changelog ....: Sep 01, 2018 - v0.1   - First version.
; ..............: Sep 05, 2018 - v0.1.1 - Replaced FileAppend with a file object for logging.
; License ......: GNU Lesser General Public License
; ..............: This program is free software: you can redistribute it and/or modify it under the terms of the GNU
; ..............: Lesser General Public License as published by the Free Software Foundation, either version 3 of the
; ..............: License, or (at your option) any later version.
; ..............: This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even
; ..............: the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser 
; ..............: General Public License for more details.
; ..............: You should have received a copy of the GNU Lesser General Public License along with this program. If 
; ..............: not, see <http://www.gnu.org/licenses/>.
; ----------------------------------------------------------------------------------------------------------------------

; ===[ COMPILER DIRECTIVES ]============================================================================================
;@Ahk2Exe-SetName FileScrambler
;@Ahk2Exe-SetDescription File camouflaging tool
;@Ahk2Exe-SetVersion 0.1
;@Ahk2Exe-SetCopyright Ciro Principe - http://ciroprincipe.info
;@Ahk2Exe-SetOrigFilename FileScrambler.exe
; ======================================================================================================================

#SingleInstance force
#Persistent
#NoTrayIcon
#NoEnv

; ===[ CONSTANTS ]======================================================================================================
  Global SCRIPTNAME, SCRIPTVER, SCRIPTLOGENA, SCRIPTLOGFILE, ADDSYSFILES, BYTESTOSWAP, CHARTABLE, SUBSTABLE
  SCRIPTNAME    := "FileScrambler"
  SCRIPTVER     := "0.1"
  SCRIPTABOUT   := "V" SCRIPTVER " - (C)2018 CIRO PRINCIPE"
  SCRIPTRESDIR  := A_Temp "\AHK_FS_TEMP\"
  SCRIPTLOGENA  := 1
  SCRIPTLOGFILE := A_ScriptDir "\FileScrambler-Debug_" A_Now ".log"
  ADDSYSFILES   := 0
  BYTESTOSWAP   := 16
  CHARTABLE     := "1t 2B 3e 4L 5v 6F 7k 8H 9d 0i aN bx cV d9 e3 fP gy hK i0 jX k7 lC mw nT ou pI qD rZ sU t1 uo "
                .  "v5 wm xb yg zS AO B2 Cl Dq ER F6 GW H8 Ip JY Kh L4 MQ Na OA Pf QM RE Sz Tn Us Vc WG Xj YJ Zr"
; ======================================================================================================================

; ===[ RESOURCES ]======================================================================================================
  hImg01 = 89504E470D0A1A0A0000000D494844520000000100000001010300000025DB56CA00000003504C54450072C6C874412B0000000A4944415408D76360000000020001E221BC330000000049454E44AE426082
  hImg02 = 89504E470D0A1A0A0000000D494844520000001000000010080200000090916836000000017352474200AECE1CE90000000467414D410000B18F0BFC6105000000097048597300000EC300000EC301C76FA8640000001974455874536F667477617265007061696E742E6E657420342E302E3231F12069950000006049444154384F958B5B1280200CC4383387E45A3E869A3211453BF9C8EE4229B5FDC37989F3126C1B4E0D6F4E306D4424C034109100D3A09860FD45BF7B4CB0C9367CCB12F3F0D4631A88488069202201E6E16A8E1BCBFCF015E725CEEFD4B60367139CEDF863EFB70000000049454E44AE426082
  hImg03 = 0000010001003030000001000800A80E00001600000028000000300000006000000001000800000000000000000000000000000000000000000000000000C6720000FFFFFF00000E500000147000001A90000020B0000026CF00002CF000113DFF003157FF005171FF00718BFF0091A5FF00B1BFFF00D1DAFF00FFFFFF0000000000001A2F00002D5000003F7000005190000063B0000076CF000088F0001198FF0031A6FF0051B3FF0071C1FF0091CFFF00B1DDFF00D1EBFF00FFFFFF0000000000002C2F00004B5000006870000086900000A5B00000C3CF0000E1F00011EFFF0031F1FF0051F3FF0071F5FF0091F7FF00B1F9FF00D1FBFF00FFFFFF0000000000002F21000050370000704C000090630000B0790000CF8F0000F0A60011FFB40031FFBE0051FFC80071FFD30091FFDC00B1FFE500D1FFF000FFFFFF0000000000002F0E00005018000070220000902C0000B0360000CF400000F04A0011FF5B0031FF710051FF870071FF9D0091FFB200B1FFC900D1FFDF00FFFFFF0000000000022F00000450000006700000089000000AB000000BCF00000EF0000020FF12003DFF31005BFF510079FF710098FF9100B5FFB100D4FFD100FFFFFF0000000000142F000022500000307000003D9000004CB0000059CF000067F0000078FF11008AFF31009CFF5100AEFF7100C0FF9100D2FFB100E4FFD100FFFFFF0000000000262F0000405000005A700000749000008EB00000A9CF0000C2F00000D1FF1100D8FF3100DEFF5100E3FF7100E9FF9100EFFFB100F6FFD100FFFFFF00000000002F26000050410000705B000090740000B08E0000CFA90000F0C30000FFD21100FFD83100FFDD5100FFE47100FFEA9100FFF0B100FFF6D100FFFFFF00000000002F1400005022000070300000903E0000B04D0000CF5B0000F0690000FF791100FF8A3100FF9D5100FFAF7100FFC19100FFD2B100FFE5D100FFFFFF00000000002F030000500400007006000090090000B00A0000CF0C0000F00E0000FF201200FF3E3100FF5C5100FF7A7100FF979100FFB6B100FFD4D100FFFFFF00000000002F000E00500017007000210090002B00B0003600CF004000F0004900FF115A00FF317000FF518600FF719C00FF91B200FFB1C800FFD1DF00FFFFFF00000000002F0020005000360070004C0090006200B0007800CF008E00F000A400FF11B300FF31BE00FF51C700FF71D100FF91DC00FFB1E500FFD1F000FFFFFF00000000002C002F004B0050006900700087009000A500B000C400CF00E100F000F011FF00F231FF00F451FF00F671FF00F791FF00F9B1FF00FBD1FF00FFFFFF00000000001B002F002D0050003F007000520090006300B0007600CF008800F0009911FF00A631FF00B451FF00C271FF00CF91FF00DCB1FF00EBD1FF00FFFFFF000000000008002F000E005000150070001B0090002100B0002600CF002C00F0003E11FF005831FF007151FF008C71FF00A691FF00BFB1FF00DAD1FF00FFFFFF00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010101010101010100000000000000000000000000000101010101010101000000000000000000000000000000000000010101010101010100000000000000000000000001010101010101010101010101000000000000000000000000000000010101010101010100000000000000000000010101010101010101010101010101010000000000000000000000000000010101010101010100000000000000000001010101010101010101010101010101010100000000000000000000000000010101010101010100000000000000000001010101010101010101010101010101010100000000000000000000000000010101010101010100000000000000000101010101010101010101010101010101010101000000000000000000000000010101010101010100000000000000000101010101010101000000010101010101010101000000000000000000000000010101010101010100000000000000000101010101010101000000000101010101010101000000000000000000000000010101010101010100000000000000000101010101010101000000000101010101010101000000000000000000000000010101010101010100000000000000000101010101010101000000000101010101010101000000000000000000000000010101010101010100000000000000000101010101010101000000000101010101010101000000000000000000000000010101010101010100000000000000000101010101010101000000010101010101010101000000000000000000000000010101010101010100000000000000000000000000000000000001010101010101010101000000000000000000000000010101010101010100000000000000000000000000000000000101010101010101010100000000000000000000000000010101010101010101010101010101000000000000000001010101010101010101010100000000000000000000000000010101010101010101010101010101000000000000000101010101010101010101010100000000000000000000000000010101010101010101010101010101000000000000010101010101010101010101010000000000000000000000000000010101010101010101010101010101000000000101010101010101010101010101000000000000000000000000000000010101010101010101010101010101000000010101010101010101010101010100000000000000000000000000000000010101010101010101010101010101000001010101010101010101010101000000000000000000000000000000000000010101010101010100000000000000000001010101010101010101010100000000000000000000000000000000000000010101010101010100000000000000000101010101010101010101010000000000000000000000000000000000000000010101010101010100000000000000000101010101010101010100000000000000000000000000000000000000000000010101010101010100000000000000000101010101010101010000000000000000000000000000000000000000000000010101010101010100000000000000000101010101010101000000010101010101010100000000000000000000000000010101010101010100000000000000000101010101010101000000010101010101010100000000000000000000000000010101010101010100000000000000000101010101010101000000010101010101010100000000000000000000000000010101010101010101010101010101000101010101010101000000010101010101010100000000000000000000000000010101010101010101010101010101000101010101010101010101010101010101010100000000000000000000000000010101010101010101010101010101000001010101010101010101010101010101010100000000000000000000000000010101010101010101010101010101000001010101010101010101010101010101010000000000000000000000000000010101010101010101010101010101000000010101010101010101010101010101000000000000000000000000000000010101010101010101010101010101000000000101010101010101010101010100000000000000000000000000000000010101010101010101010101010101000000000000010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304000000000000F304
  hImg04 = 89504E470D0A1A0A0000000D494844520000001D000000160103000000069A058F00000006504C5445FFFFFF777777AA63A605000000104944415408D763A008D41F8010C402007053027F368748A10000000049454E44AE426082
  hImg05 = 89504E470D0A1A0A0000000D494844520000001D000000160103000000069A058F00000006504C5445FFFFFF777777AA63A605000000264944415408D7632000141C8044C1032061790048C83700097E063001E68225C04A208AF103006E7606AF93717D220000000049454E44AE426082
; ======================================================================================================================

; ======================================================================================================================
; ===[ MAIN SECTION ]===================================================================================================
; ======================================================================================================================

; Open log file.
If ( SCRIPTLOGENA && !IsObject(SCRIPTLOGFILE := FileOpen(SCRIPTLOGFILE, "w `n")) )
{
    MsgBox,, %SCRIPTNAME%, Error creating log file. Program aborted.
    ExitApp   
}

WriteLog("===[" SCRIPTNAME " version " SCRIPTVER "]=== started.`n", 1)

; Create resources folder.
WriteLog("Creating program resources in <" SCRIPTRESDIR ">.`n", 1)
FileCreateDir, %SCRIPTRESDIR%
SetWorkingDir, %SCRIPTRESDIR%
If ( !FileWriteHex(hImg01, "px_blue.png")
||   !FileWriteHex(hImg02, "icn_menu.png")
||   !FileWriteHex(hImg03, "icn_window.ico")
||   !FileWriteHex(hImg04, "btn_minimize.png")
||   !FileWriteHex(hImg05, "btn_close.png") )
{
    WriteLog("Error writing resources files. Program aborted.`n", 1)
    MsgBox,, %SCRIPTNAME%, Error writing resources. Program aborted.
    ExitApp
}   WriteLog("All resources written to files.`n", 1)

; We create a Dictionary table from the supplied CHARTABLE. Dictionaries allows us to use case sensitive keys.
; *** IMPORTANT *** Using this way numeric keys will be stored as strings. Class has been adjusted accordingly.
SUBSTABLE := new Dictionary
Loop, PARSE, CHARTABLE, %A_Space%
    If ( A_LoopField != "" ) ; Just to avoid any mistype in the CHARTABLE.
        SUBSTABLE[SubStr(A_LoopField, 1, 1)] := SubStr(A_LoopField, 2, 1)

; Set script icon.
Menu, Tray, Icon, icn_window.ico

; Create GUI. This GUI code is from TheDewd: https://autohotkey.com/boards/viewtopic.php?p=34758#p34758.
WriteLog("Create main GUI.`n", 1)
Gui, -Caption -Border -Resize +LastFound +AlwaysOnTop +HWNDhGui1
Gui, Color, FFFFFF
Gui, Add, Picture, vBorderT, px_blue.png
Gui, Add, Picture, vBorderB, px_blue.png
Gui, Add, Picture, vBorderL, px_blue.png
Gui, Add, Picture, vBorderR, px_blue.png
Gui, Add, Picture, vMenuIco gMENUICON, icn_menu.png
Gui, Add, Picture, vBtnMinimize gBTNMINIMIZE, btn_minimize.png
Gui, Add, Picture, vBtnClose gBTNCLOSE, btn_close.png
Gui, Font, s96 cEEEEEE, Segoe UI
Gui, Add, Text, +Center +BackgroundTrans vDropSign, +
Gui, Font, s32 cAAAAAA, Segoe UI
Gui, Add, Text, +Center +BackgroundTrans vDropNum
Gui, Add, Picture, vStatusBar, px_blue.png
Gui, Add, Text, +BackgroundTrans vGuiMove gGUIMOVE
Gui, Font, s9 c444444, Segoe UI
Gui, Add, Text, +Center +BackgroundTrans vGuiTitle, %SCRIPTNAME%
Gui, Font, s8 cFFFFFF
Gui, Add, Text, +BackgroundTrans vSBText Center, DRAG AND DROP HERE
Gui, Font

; Hide file number before showing the GUI.
GuiControl, Hide, DropNum
Gui, Show, w200 h200, FileScrambler

Return

; ======================================================================================================================
; ===[ LABELS ]=========================================================================================================
; ======================================================================================================================

MENUICON:
    GuiControlGet, sOldSBText,, SBText
    GuiControl, Text, SBText, %SCRIPTABOUT%
    SetTimer, MENUICONTIMER, -3000
Return

MENUICONTIMER:
    GuiControl, Text, SBText, %sOldSBText%
Return

BTNMINIMIZE:
    WinMinimize
Return

GUIDROPFILES:
    ; Files dropped, update GUI hiding the drop sign and showing the number text.
    GuiControl, Hide, DropSign
    GuiControl, Show, DropNum
    GuiControl, Text, SBText, CALCULATING...
    ; Create an array of file names.
    WriteLog("Files dropped. Start building list.`n", 1)
    aFileList := { dropped: A_GuiEvent, skipped: "" }
    CreateFileList(aFileList)
    WriteLog( "File list built. Total: " aFileList.Length() "." 
            . ((aFileList.skipped != "") ? " - Skipped:`n" aFileList.skipped : "`n"), 1 )
    GuiControl, Text, SBText, (S)TART OR (C)ANCEL
    ; Makes the window active, to facilitate hotkeys usage.
    WinActivate, ahk_id %hGui1%
    ; Create the hotkeys to start or cancel the job.
    Hotkey, IfWinActive, ahk_id %hGui1%
    Hotkey, s, JOBSTART, On
    Hotkey, c, JOBCANCEL, On
Return

GUIMOVE:
    PostMessage, 0xA1, 2,,, A
Return

GUISIZE:
    If (A_EventInfo == 1) ; Window minimized, do nothing.
        Return
    GuiControl, Move, BorderT, % " x" 0 " y" 0 " w" A_GuiWidth " h" 1
    GuiControl, Move, BorderB, % " x" 0 " y" A_GuiHeight-1 " w" A_GuiWidth " h" 1
    GuiControl, Move, BorderL, % " x" 0 " y" 1 " w" 1 " h" A_GuiHeight-1
    GuiControl, Move, BorderR, % " x" A_GuiWidth-1 " y" 1 " w" 1 " h" A_GuiHeight-1
    GuiControl, Move, MenuIco, % " x" 11 " y" 7 " w" 16 " h" 16
    GuiControl, Move, BtnMinimize, % " x" A_GuiWidth-59 " y" 4 " w" 29 " h" 22
    GuiControl, Move, BtnClose, % " x" A_GuiWidth-30 " y" 4 " w" 29 " h" 22
    GuiControl, Move, DropSign, % " x" 1 " y" 1 " w" A_GuiWidth-2
    GuiControl, Move, DropNum, % " x" 1 " y" 66 " w" A_GuiWidth-2
    GuiControl, Move, StatusBar, % " x" 1 " y" A_GuiHeight-23 " w" A_GuiWidth-1 " h" 22
    GuiControl, Move, GuiMove, % " x" 1 " y" 1 " w" A_GuiWidth-2 " h" 28
    GuiControl, Move, GuiTitle, % " x" 37 " y" 8 " w" A_GuiWidth-96
    GuiControl, Move, SBText, % " x" 8 " y" A_GuiHeight-19 " w" A_GuiWidth-16
    WinSet, Redraw
Return

JOBSTART:
    Hotkey, s, JOBSTART, Off
    Hotkey, c, JOBCANCEL, Off
    WriteLog("Job started.`n", 1)
    nError := ScrambleFiles(aFileList)
    WriteLog("Job completed. Errors: " nError ".`n", 1)
    GuiControl, Text, SBText, COMPLETED!
Return

JOBCANCEL:
    WriteLog("Job canceled.", 1)
    Hotkey, IfWinActive, ahk_id %hGui1%
    Hotkey, s, JOBSTART, Off
    Hotkey, c, JOBCANCEL, Off
    GuiControl, Hide, DropNum
    GuiControl, Show, DropSign
    GuiControl, Text, SBText, DRAG AND DROP HERE
Return

GUIESCAPE:
GUICLOSE:
BTNCLOSE:
    WriteLog("Preparing closure, removing resources.`n", 1)
    FileRemoveDir, %SCRIPTRESDIR%, 1
    If ( ErrorLevel )
         WriteLog("Error removing resources folder: " A_LastError ". Quit program.`n", 1)
    Else WriteLog("Resources folder removed. Quit program.`n", 1)
    If ( SCRIPTLOGENA )
        SCRIPTLOGFILE.Close()
ExitApp

; ======================================================================================================================
; ===[ FUNCTIONS ]======================================================================================================
; ======================================================================================================================

; Create an array containing the ordered list of files/directories to be scrambled.
CreateFileList(ByRef aFileList, bRecurse:=0, sDir:="")
{
    Global DropNum
    If ( bRecurse )
    {   ; Recursing, parsing the directories.
        Loop, %sDir%\*.*, 1
        {
            If ( InStr(A_LoopFileAttrib, "D") )
                CreateFileList(aFileList, 1, A_LoopFileLongPath)
            If ( !InStr(A_LoopFileAttrib, "S") || ADDSYSFILES )
            {
                aFileList.Push(A_LoopFileLongPath)
                GuiControl, Text, DropNum, % aFileList.Length()
            }
            Else aFileList.skipped .= "`t" A_LoopFileLongPath "`n"
        }
    }
    Else
    {   ; First run, parsing the dropped list.
        Loop, PARSE, % aFileList.dropped, `n
        {
            If ( InStr(FileExist(A_LoopField), "D") )
                CreateFileList(aFileList, 1, A_LoopField)
            If ( !InStr(FileExist(A_LoopField), "S") || ADDSYSFILES )
            {
                aFileList.Push(A_LoopField)
                GuiControl, Text, DropNum, % aFileList.Length()
            }
            Else aFileList.skipped .= "`t" A_LoopField "`n"
        }
    }
}

; Scramble the files and the directories in the list.
ScrambleFiles(ByRef aFileList)
{
    Global DropNum, SBText
    nError := 0
    Loop % aFileList.Length()
    {
        ; Split file/dir name and its path.
        sPath := RegExReplace(aFileList[A_Index], "\\[^\\]*$")
        sName := RegExReplace(aFileList[A_Index], "^.*\\")
        ; Scramble file/dir name.
        BufScrambleString(sName, SUBSTABLE)
        
        ; It's a file, we swap bytes and rename it.
        If ( !InStr(FileExist(aFileList[A_Index]), "D") )
        {   ; *** FILES WILL BE MODIFIED ***
            WriteLog("`t##[" A_Index "]## File <" aFileList[A_Index] ">`n`tScrambled name: [" sName "]`n")
            If ( !IsObject(f := FileOpen(aFileList[A_Index], "rw")) )
            {
                nError++, WriteLog("`tError opening the file: " A_LastError ".`n")
                Continue
            }
            f.RawRead(cBuf, BYTESTOSWAP)
            WriteLog("`tOriginal bytes: [" BufToHex(&cBuf, BYTESTOSWAP) "] ")
            BufSwapBytes(cBuf, BYTESTOSWAP)
            WriteLog("Swapped bytes: [" BufToHex(&cBuf, BYTESTOSWAP) "]`n")
            f.Seek(-BYTESTOSWAP, 1)
            f.RawWrite(cBuf, BYTESTOSWAP)
            f.Close()
            FileMove, % aFileList[A_Index], %sPath%\%sName%
            If ( ErrorLevel )
                nError++, WriteLog("`tError renaming the file: " A_LastError ".`n")
            Else WriteLog("`tBytes swapped and file renamed to <" sPath "\" sName ">`n")
        }
        ; It's a directory we only rename it.
        Else
        {   ; *** DIRECTORIES WILL BE MODIFIED ***
            WriteLog("`t##[" A_Index "]## Directory <" aFileList[A_Index] ">`n`tScrambled name: [" sName "]`n")
            FileMoveDir, % aFileList[A_Index], %sPath%\%sName%, R
            If ( ErrorLevel )
                nError++, WriteLog("`tError renaming the directory: " A_LastError ".`n")
            Else WriteLog("`tDirectory renamed to <" sPath "\" sName ">`n")
        }
        
        ; Update GUI.
        GuiControl, Text, DropNum, % aFileList.Length()-A_Index
        GuiControl, Text, SBText, % "SCRAMBLING... " (A_Index * 100) // aFileList.Length() "%"
    }
    Return nError
}

; Return a hexadecimal string from a binary buffer.
BufToHex(nAdrBuf, nSzBuf)
{
    DllCall( "Crypt32.dll\CryptBinaryToString", Ptr,nAdrBuf, UInt,nSzBuf, UInt,0x40000004, Ptr,0, UIntP,nLen )
    VarSetCapacity(cHex, nLen*(A_IsUnicode ? 2 : 1), 0)
    DllCall( "Crypt32.dll\CryptBinaryToString", Ptr,nAdrBuf, UInt,nSzBuf, UInt,0x40000004, Ptr,&cHex, UIntP,nLen )
    Return StrGet(&cHex, nLen, (A_IsUnicode ? "UTF-16" : "CP0")), cHex := ""
}

; Replace string chars one by one following the substitution table.
BufScrambleString(ByRef sBuf, ByRef oSubsTable)
{
    Loop % StrLen(sBuf)
    {
        idx := (A_IsUnicode) ? (A_Index-1)*2 : A_Index-1
        chr := Chr(NumGet(sBuf, idx, (A_IsUnicode) ? "UShort" : "Char"))
        NumPut(Asc(oSubsTable[chr ""]), sBuf, idx, (A_IsUnicode) ? "UShort" : "Char")
    }
}

; Swap bytes for each word in the buffer (2 bytes size). Eg: "1A 06" becomes "06 1A". 
BufSwapBytes(ByRef cBuf, nHowMany)
{
    Loop % nHowMany//2
    {
        idx := (A_Index*2)-2, idxNext := (A_Index*2)-1
        num := NumGet(cBuf, idx, "UChar"), numNext := NumGet(cBuf, idxNext, "UChar")
        NumPut(numNext, cBuf, idx, "UChar"), NumPut(num, cBuf, IdxNext, "UChar")
    }
}

; Write a file from an hexadecimal string.
FileWriteHex(sHex, sFilePath)
{
    If ( !IsObject(f := FileOpen(sFilePath, "w")) )
        Return 0
    Loop, % StrLen(sHex) // 2
        f.WriteUChar("0x" . SubStr(sHex, (2 * A_Index) - 1, 2))
    f.Close()
    Return 1
}

; Write a log file useful for debug.
WriteLog(sRecord, bStamp:=0)
{
    If ( SCRIPTLOGENA )
        SCRIPTLOGFILE.Write((bStamp ? "[" A_YYYY "." A_MM "." A_DD "]" A_Hour ":" A_Min ":" A_Sec " - " : "") sRecord)
}

; Implement a minimal Dictionary COM object used for char substitution.
Class Dictionary
{
    __New(param*)
    {
    	ObjRawSet(this, "__", ComObjCreate("Scripting.Dictionary"))
		Loop % param.Length()//2
			this[param[A_Index*2-1]] := param[A_Index*2]
    }
    __Set(key, value)
    {
        skey := key "" ; Ensures we deal only with strings.
        If ( this.__.Exists(skey) )
             Return this.__.Item(skey) := value
        Else Return this.__.Add(skey, value)
    }
    __Get(key)
    {
        skey := key "" ; Ensures we deal only with strings.
        If ( this.__.Exists(skey) )
             Return this.__.Item(skey)
        Else Return skey
    }
}