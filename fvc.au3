#include <GUIConstants.au3>
#include <ScreenCapture.au3>
#include <WinAPIHObj.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)

Global $P1TL[2] = [0, 0]
Global $P1BR[2] = [0, 0]
Global $P2TL[2] = [0, 0]
Global $P2BR[2] = [0, 0]

Global $PgCntr = 1

Global $FRSTPAGE = True
Global $SCNDPAGE = True

Const $FilePath = @ScriptDir & "\capture\" ;save folder


#Region ### START Koda GUI section ### Form=
$MGui = GUICreate("Page capture", 330, 256, 50, 50)
GUISetOnEvent($GUI_EVENT_CLOSE, "MGuiClose")

$LP1TL = GUICtrlCreateLabel("P1 TL  X", 10, 80, 48, 17)
$LP1BR = GUICtrlCreateLabel("P1 BR  X", 10, 112, 56, 17)
$LP2TL = GUICtrlCreateLabel("P2 TL  X", 10, 184, 48, 17)
$LP2BR = GUICtrlCreateLabel("P2 BR  X", 10, 216, 56, 17)

$LMouse = GUICtrlCreateLabel("Mouse:", 10, 16, 100, 17)

$IP1TLX = GUICtrlCreateInput("0", 64, 80, 107, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP1TLXChange")
$IP1TLXUD = GUICtrlCreateUpdown($IP1TLX)
GUICtrlSetOnEvent(-1, "IP1TLXUDChange")
$IP1TLY = GUICtrlCreateInput("0", 200, 80, 107, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP1TLYChange")
$IP1TLYUD = GUICtrlCreateUpdown($IP1TLY)
GUICtrlSetOnEvent(-1, "IP1TLYUDChange")
$IP1BRX = GUICtrlCreateInput("0", 64, 112, 107, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP1BRXChange")
$IP1BRXUD = GUICtrlCreateUpdown($IP1BRX)
GUICtrlSetOnEvent(-1, "IP1BRXUDChange")
$IP1BRY = GUICtrlCreateInput("0", 200, 112, 107, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP1BRYChange")
$IP1BRYUD = GUICtrlCreateUpdown($IP1BRY)
GUICtrlSetOnEvent(-1, "IP1BRYUDChange")
$IP2TLX = GUICtrlCreateInput("0", 64, 184, 108, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP2TLXChange")
$IP2TLXUD = GUICtrlCreateUpdown($IP2TLX)
GUICtrlSetOnEvent(-1, "IP2TLXUDChange")
$IP2TLY = GUICtrlCreateInput("0", 200, 184, 107, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP2TLYChange")
$IP2TLYUD = GUICtrlCreateUpdown($IP2TLY)
GUICtrlSetOnEvent(-1, "IP2TLYUDChange")
$IP2BRX = GUICtrlCreateInput("0", 64, 216, 107, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP2BRXChange")
$IP2BRXUD = GUICtrlCreateUpdown($IP2BRX)
GUICtrlSetOnEvent(-1, "IP2BRXUDChange")
$IP2BRY = GUICtrlCreateInput("0", 200, 216, 107, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP2BRYChange")
$IP2BRYUD = GUICtrlCreateUpdown($IP2BRY)
GUICtrlSetOnEvent(-1, "IP2BRYUDChange")

$LY1 = GUICtrlCreateLabel("Y", 184, 80, 11, 17)
$LY2 = GUICtrlCreateLabel("Y", 184, 112, 11, 17)
$LY3 = GUICtrlCreateLabel("Y", 184, 184, 11, 17)
$LY4 = GUICtrlCreateLabel("Y", 184, 216, 11, 17)

$IPGCNT = GUICtrlCreateInput($PgCntr, 208, 16, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
$IPGCNTUD = GUICtrlCreateUpdown($IPGCNT)
GUICtrlSetOnEvent(-1, "IPGCNTUDChange")

$LPGCNT = GUICtrlCreateLabel("Pg Count Start", 128, 16, 73, 17)
$CBFRSTPAGE = GUICtrlCreateCheckbox("Capture 1st page?", 16, 48, 113, 17)
GUICtrlSetState($CBFRSTPAGE, $FRSTPAGE)
GUICtrlSetOnEvent(-1, "CBFRSTPAGEChange")
$CBSCNDPAGE = GUICtrlCreateCheckbox("Capture 2nd page?", 16, 152, 113, 17)
GUICtrlSetState($CBSCNDPAGE, $SCNDPAGE)
GUICtrlSetOnEvent(-1, "CBSCNDPAGEChange")

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



HotKeySet("{ESC}", "Quit")

HotKeySet("+!{Q}", "P1TL_Set") ;page 1 top left
HotKeySet("+!{A}", "P1BR_Set") ;page 1 bottom right

HotKeySet("+!{W}", "P2TL_Set") ;page 2 top left
HotKeySet("+!{S}", "P2BR_Set") ;page 2 bottom right

HotKeySet("+!{Z}", "Draw_P1Box")
HotKeySet("+!{X}", "Draw_P2Box")

HotKeySet("+!{C}", "Capture")
HotKeySet("+!{E}", "Hide_Mag") ;hide cursor magnifier

;Magnifying a 20x20 area of the screen
Global $GUI_Pixel[400]
Global $GUI = GUICreate("Zoom x2 Au3", 80, 80, 1, 1, $WS_POPUP + $WS_BORDER, $WS_EX_TOPMOST)


GUISetState(@SW_SHOW, $GUI)
Global $Mag_Show = 1

Global $hDC = _WinAPI_GetWindowDC(0) ; DC of entire screen (desktop)
Global $tRect1 = DllStructCreate($tagRECT)
Global $tRect2 = DllStructCreate($tagRECT)


Global $LastPos[2] = [0, 0]

$MousePos = MouseGetPos()

_ScreenCapture_SetBMPFormat(0)
_GDIPlus_Startup()


$hGraphic = _GDIPlus_GraphicsCreateFromHWND($GUI)
_GDIPlus_GraphicsSetInterpolationMode($hGraphic, 4)
_GDIPlus_GraphicsSetSmoothingMode($hGraphic, 0)

_GDIPlus_GraphicsScaleTransform($hGraphic, 4, 4)


If FileExists($FilePath) = False Then
	DirCreate($FilePath)
EndIf

While 1

	$MousePos = MouseGetPos()

	If ($Mag_Show = 1) Then
		$hBitmap = _ScreenCapture_Capture("", $MousePos[0] - 10, $MousePos[1] - 10, $MousePos[0] + 10, $MousePos[1] + 10, 1)
		$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
		_GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 0, 0)
		_GDIPlus_ImageDispose($hImage)
		_WinAPI_DeleteObject($hBitmap)
	EndIf

	If ($LastPos[0] <> $MousePos[0] Or $LastPos[1] <> $MousePos[1]) Then
		WinMove("Zoom x2 Au3", "", $MousePos[0] + 80, $MousePos[1])
		$LastPos[0] = $MousePos[0]
		$LastPos[1] = $MousePos[1]
	EndIf


	GUICtrlSetData($LMouse, "Mouse: " & $MousePos[0] & ", " & $MousePos[1])
	Sleep(1)


	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE

			Quit()
			;Exit

	EndSwitch
WEnd

Func Quit()

	_GDIPlus_Shutdown()

	_WinAPI_ReleaseDC(0, $hDC)
	Exit
EndFunc   ;==>Quit

Func Capture()
	If $FRSTPAGE = True Then
		_ScreenCapture_Capture($FilePath & $PgCntr & ".bmp", $P1TL[0], $P1TL[1], $P1BR[0], $P1BR[1], False) ;cap left page
		$PgCntr = $PgCntr + 1
	EndIf

	If $SCNDPAGE = True Then
		_ScreenCapture_Capture($FilePath & $PgCntr & ".bmp", $P2TL[0], $P2TL[1], $P2BR[0], $P2BR[1], False) ;cap right page
		$PgCntr = $PgCntr + 1
	EndIf

	GUICtrlSetData($IPGCNT, $PgCntr)
	Beep(1000, 100)
EndFunc   ;==>Capture

Func Hide_Mag()
	If $Mag_Show = True Then
		GUISetState(@SW_HIDE, $GUI)
		$Mag_Show = False
	Else
		GUISetState(@SW_SHOW, $GUI)
		$Mag_Show = True
	EndIf
EndFunc   ;==>Hide_Mag


Func P1TL_Set()
	$P1TL = MouseGetPos()
	GUICtrlSetData($IP1TLX, $P1TL[0])
	GUICtrlSetData($IP1TLY, $P1TL[1])
EndFunc   ;==>P1TL_Set

Func P1BR_Set()
	$P1BR = MouseGetPos()
	GUICtrlSetData($IP1BRX, $P1BR[0])
	GUICtrlSetData($IP1BRY, $P1BR[1])
EndFunc   ;==>P1BR_Set
Func P2TL_Set()
	$P2TL = MouseGetPos()
	GUICtrlSetData($IP2TLX, $P2TL[0])
	GUICtrlSetData($IP2TLY, $P2TL[1])
EndFunc   ;==>P2TL_Set

Func P2BR_Set()
	$P2BR = MouseGetPos()
	GUICtrlSetData($IP2BRX, $P2BR[0])
	GUICtrlSetData($IP2BRY, $P2BR[1])
EndFunc   ;==>P2BR_Set



Func Draw_P1Box()

	Local $startX = $P1TL[0] - 1
	Local $startY = $P1TL[1] - 1
	Local $endX = $P1BR[0] + 1
	Local $endY = $P1BR[1] + 1

	DllStructSetData($tRect1, 1, $startX)
	DllStructSetData($tRect1, 2, $startY)
	DllStructSetData($tRect1, 3, $endX)
	DllStructSetData($tRect1, 4, $endY)
	Local $hBrush1 = _WinAPI_CreateSolidBrush(0xFFFF00)

	_WinAPI_FrameRect($hDC, DllStructGetPtr($tRect1), $hBrush1)
	_WinAPI_DeleteObject($hBrush1)

EndFunc   ;==>Draw_P1Box

Func Draw_P2Box()
	Local $startX = $P2TL[0] - 1
	Local $startY = $P2TL[1] - 1
	Local $endX = $P2BR[0] + 1
	Local $endY = $P2BR[1] + 1

	DllStructSetData($tRect2, 1, $startX)
	DllStructSetData($tRect2, 2, $startY)
	DllStructSetData($tRect2, 3, $endX)
	DllStructSetData($tRect2, 4, $endY)
	Local $hBrush2 = _WinAPI_CreateSolidBrush(0xFF00FF)

	_WinAPI_FrameRect($hDC, DllStructGetPtr($tRect2), $hBrush2)
	_WinAPI_DeleteObject($hBrush2)

EndFunc   ;==>Draw_P2Box


Func IP1TLXUDChange()
	GUICtrlSetData($IP1TLX, StringReplace(GUICtrlRead($IP1TLX), ",", ""))
	$P1TL[0] = Number(GUICtrlRead($IP1TLX))
EndFunc   ;==>IP1TLXUDChange
Func IP1TLYUDChange()
	GUICtrlSetData($IP1TLY, StringReplace(GUICtrlRead($IP1TLY), ",", ""))
	$P1TL[1] = Number(GUICtrlRead($IP1TLY))
EndFunc   ;==>IP1TLYUDChange
Func IP1BRXUDChange()
	GUICtrlSetData($IP1BRX, StringReplace(GUICtrlRead($IP1BRX), ",", ""))
	$P1BR[0] = Number(GUICtrlRead($IP1BRX))
EndFunc   ;==>IP1BRXUDChange
Func IP1BRYUDChange()
	GUICtrlSetData($IP1BRY, StringReplace(GUICtrlRead($IP1BRY), ",", ""))
	$P1BR[1] = Number(GUICtrlRead($IP1BRY))
EndFunc   ;==>IP1BRYUDChange



Func IP2TLXUDChange()
	GUICtrlSetData($IP2TLX, StringReplace(GUICtrlRead($IP2TLX), ",", ""))
	$P2TL[0] = Number(GUICtrlRead($IP2TLX))
EndFunc   ;==>IP2TLXUDChange
Func IP2TLYUDChange()
	GUICtrlSetData($IP2TLY, StringReplace(GUICtrlRead($IP2TLY), ",", ""))
	$P2TL[1] = Number(GUICtrlRead($IP2TLY))
EndFunc   ;==>IP2TLYUDChange
Func IP2BRXUDChange()
	GUICtrlSetData($IP2BRX, StringReplace(GUICtrlRead($IP2BRX), ",", ""))
	$P2BR[0] = Number(GUICtrlRead($IP2BRX))
EndFunc   ;==>IP2BRXUDChange
Func IP2BRYUDChange()
	GUICtrlSetData($IP2BRY, StringReplace(GUICtrlRead($IP2BRY), ",", ""))
	$P2BR[1] = Number(GUICtrlRead($IP2BRY))
EndFunc   ;==>IP2BRYUDChange





Func IP1TLXChange()
	GUICtrlSetData($IP1TLX, StringReplace(GUICtrlRead($IP1TLX), ",", ""))
	$P1TL[0] = Number(GUICtrlRead($IP1TLX))
EndFunc   ;==>IP1TLXChange
Func IP1TLYChange()
	GUICtrlSetData($IP1TLY, StringReplace(GUICtrlRead($IP1TLY), ",", ""))
	$P1TL[1] = Number(GUICtrlRead($IP1TLY))
EndFunc   ;==>IP1TLYChange
Func IP1BRXChange()
	GUICtrlSetData($IP1BRX, StringReplace(GUICtrlRead($IP1BRX), ",", ""))
	$P1BR[0] = Number(GUICtrlRead($IP1BRX))
EndFunc   ;==>IP1BRXChange
Func IP1BRYChange()
	GUICtrlSetData($IP1BRY, StringReplace(GUICtrlRead($IP1BRY), ",", ""))
	$P1BR[1] = Number(GUICtrlRead($IP1BRY))
EndFunc   ;==>IP1BRYChange


Func IP2TLXChange()
	GUICtrlSetData($IP2TLX, StringReplace(GUICtrlRead($IP2TLX), ",", ""))
	$P2TL[0] = Number(GUICtrlRead($IP2TLX))
EndFunc   ;==>IP2TLXChange
Func IP2TLYChange()
	GUICtrlSetData($IP2TLY, StringReplace(GUICtrlRead($IP2TLY), ",", ""))
	$P2TL[1] = Number(GUICtrlRead($IP2TLY))
EndFunc   ;==>IP2TLYChange
Func IP2BRXChange()
	GUICtrlSetData($IP2BRX, StringReplace(GUICtrlRead($IP2BRX), ",", ""))
	$P2BR[0] = Number(GUICtrlRead($IP2BRX))
EndFunc   ;==>IP2BRXChange
Func IP2BRYChange()
	GUICtrlSetData($IP2BRY, StringReplace(GUICtrlRead($IP2BRY), ",", ""))
	$P2BR[1] = Number(GUICtrlRead($IP2BRY))
EndFunc   ;==>IP2BRYChange

Func IPGCNTUDChange()
	GUICtrlSetData($IPGCNT, StringReplace(GUICtrlRead($IPGCNT), ",", ""))
	$PgCntr = GUICtrlRead($IPGCNT)
EndFunc   ;==>IPGCNTUDChange


Func CBSCNDPAGEChange()
	If $SCNDPAGE = True Then
		$SCNDPAGE = False
	Else
		$SCNDPAGE = True
	EndIf

EndFunc   ;==>CBSCNDPAGEChange

Func CBFRSTPAGEChange()
	If $FRSTPAGE = True Then
		$FRSTPAGE = False
	Else
		$FRSTPAGE = True
	EndIf

EndFunc   ;==>CBFRSTPAGEChange

Func MGuiClose()
	Quit()
EndFunc   ;==>MGuiClose
