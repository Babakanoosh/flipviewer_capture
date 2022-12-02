

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
#Region ### START Koda GUI section ### Form=
$MGui = GUICreate("Page capture", 319, 300, 270, 150)
GUISetOnEvent($GUI_EVENT_CLOSE, "MGuiClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "MGuiMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "MGuiMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "MGuiRestore")
$LP1TL = GUICtrlCreateLabel("P1 TL  X", 10, 80, 48, 17)
GUICtrlSetOnEvent(-1, "LP1TLClick")
$LP1BR = GUICtrlCreateLabel("P1 BR  Y", 8, 112, 56, 17)
GUICtrlSetOnEvent(-1, "LP1BRClick")
$LP2TL = GUICtrlCreateLabel("P2 TL  X", 10, 144, 48, 17)
GUICtrlSetOnEvent(-1, "LP2TLClick")
$LP2BR = GUICtrlCreateLabel("P2 BR  Y", 8, 176, 56, 17)
GUICtrlSetOnEvent(-1, "LP2BRClick")
$LMouse = GUICtrlCreateLabel("Mouse:", 16, 24, 100, 17)
GUICtrlSetOnEvent(-1, "LMouseClick")
$IP1TLX = GUICtrlCreateInput("0", 64, 80, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP1TLXChange")
$IP1TLXUD = GUICtrlCreateUpdown($IP1TLX)
GUICtrlSetOnEvent(-1, "IP1TLXUDChange")
$IP1TLY = GUICtrlCreateInput("0", 176, 80, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP1TLYChange")
$IP1TLYUD = GUICtrlCreateUpdown($IP1TLY)
GUICtrlSetOnEvent(-1, "IP1TLYUDChange")
$IP1BRX = GUICtrlCreateInput("0", 64, 112, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP1BRXChange")
$IP1BRXUD = GUICtrlCreateUpdown($IP1BRX)
GUICtrlSetOnEvent(-1, "IP1BRXUDChange")
$IP1BRY = GUICtrlCreateInput("0", 176, 112, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP1BRYChange")
$IP1BRYUD = GUICtrlCreateUpdown($IP1BRY)
GUICtrlSetOnEvent(-1, "IP1BRYUDChange")
$IP2TLX = GUICtrlCreateInput("0", 64, 144, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP2TLXChange")
$IP2TLXUD = GUICtrlCreateUpdown($IP2TLX)
GUICtrlSetOnEvent(-1, "IP2TLXUDChange")
$IP2TLY = GUICtrlCreateInput("0", 176, 144, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP2TLYChange")
$IP2TLYUD = GUICtrlCreateUpdown($IP2TLY)
GUICtrlSetOnEvent(-1, "IP2TLYUDChange")
$IP2BRX = GUICtrlCreateInput("0", 64, 176, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP2BRXChange")
$IP2BRXUD = GUICtrlCreateUpdown($IP2BRX)
GUICtrlSetOnEvent(-1, "IP2BRXUDChange")
$IP2BRY = GUICtrlCreateInput("0", 176, 176, 90, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
GUICtrlSetOnEvent(-1, "IP2BRYChange")
$IP2BRYUD = GUICtrlCreateUpdown($IP2BRY)
GUICtrlSetOnEvent(-1, "IP2BRYUDChange")
$LY1 = GUICtrlCreateLabel("Y", 160, 80, 11, 17)
GUICtrlSetOnEvent(-1, "LY1Click")
$LY2 = GUICtrlCreateLabel("Y", 160, 112, 11, 17)
GUICtrlSetOnEvent(-1, "LY2Click")
$LY3 = GUICtrlCreateLabel("Y", 160, 144, 11, 17)
GUICtrlSetOnEvent(-1, "LY3Click")
$LY4 = GUICtrlCreateLabel("Y", 160, 176, 11, 17)
$IPGCNT = GUICtrlCreateInput("0", 208, 24, 73, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
$IPGCNTUD = GUICtrlCreateUpdown($IPGCNT)
GUICtrlSetOnEvent(-1, "IPGCNTUDChange")
$LPGCNT = GUICtrlCreateLabel("Pg Count Start", 128, 24, 73, 17)
GUICtrlSetOnEvent(-1, "LY4Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



Global $P1TL[2] = [0,0]
Global $P1BR[2] = [0,0]

Global $P2TL[2] = [0,0]
Global $P2BR[2] = [0,0]

Global $PgCntr = -1

HotKeySet("{ESC}", "Quit")

HotKeySet("+!{Q}", "P1TL_Set")
HotKeySet("+!{A}", "P1BR_Set")

HotKeySet("+!{W}", "P2TL_Set")
HotKeySet("+!{S}", "P2BR_Set")

HotKeySet("+!{Z}", "Draw_P1Box")
HotKeySet("+!{X}", "Draw_P2Box")

HotKeySet("+!{C}", "Capture")
HotKeySet("+!{E}", "Hide_Mag")

;Magnifying a 20x20 area of the screen
Global $GUI_Pixel[400]
Global $GUI = GUICreate("Zoom x2 Au3",80,80,1,1,$WS_POPUP+$WS_BORDER,$WS_EX_TOPMOST)


GUISetState(@SW_SHOW, $GUI)
Global $Mag_Show = 1

Global $hDC = _WinAPI_GetWindowDC(0) ; DC of entire screen (desktop)
Global $tRect1 = DllStructCreate($tagRECT)
Global $tRect2 = DllStructCreate($tagRECT)


Global $LastPos[2] = [0,0]

$MousePos = MouseGetPos()

_ScreenCapture_SetBMPFormat(0)
_GDIPlus_Startup()


$hGraphic = _GDIPlus_GraphicsCreateFromHWND($GUI)
_GDIPlus_GraphicsSetInterpolationMode ( $hGraphic, 4)
_GDIPlus_GraphicsSetSmoothingMode ( $hGraphic, 0 )

_GDIPlus_GraphicsScaleTransform ( $hGraphic, 4, 4 )
While 1

	$MousePos = MouseGetPos()

	If($Mag_Show = 1) Then
	   $hBitmap = _ScreenCapture_Capture("" , $MousePos[0]-10, $MousePos[1]-10, $MousePos[0]+10, $MousePos[1]+10, 1)
	   $hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
	   _GDIPlus_GraphicsDrawImage( $hGraphic, $hImage, 0, 0)
	   _GDIPlus_ImageDispose($hImage)
	   _WinAPI_DeleteObject($hBitmap)
	EndIf

   If ($LastPos[0] <> $MousePos[0] Or $LastPos[1] <> $MousePos[1]) Then
       WinMove("Zoom x2 Au3","",$MousePos[0]+80,$MousePos[1])
        $LastPos[0] = $MousePos[0]
        $LastPos[1] = $MousePos[1]
    EndIf




;Sleeping 1-10 ms takes 70-60% (respectively) CPU usage on my machine

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
EndFunc

Func Capture()

	$PgCntr = $PgCntr+1
	_ScreenCapture_Capture(@ScriptDir & "\cap\" & $PgCntr & ".bmp", $P1TL[0], $P1TL[1], $P1BR[0], $P1BR[1]) ;cap left page


	$PgCntr = $PgCntr+1
	_ScreenCapture_Capture(@ScriptDir & "\cap\" & $PgCntr & ".bmp", $P2TL[0], $P2TL[1], $P2BR[0], $P2BR[1]) ;cap right page


	GUICtrlSetData($IPGCNT, $PgCntr)
	Beep(1000, 100)
EndFunc

Func Hide_Mag()
	GUISetState(@SW_HIDE, $GUI)
	$Mag_Show = 0
EndFunc


Func P1TL_Set()
	$P1TL = MouseGetPos()
	GUICtrlSetData($IP1TLX, $P1TL[0])
	GUICtrlSetData($IP1TLY, $P1TL[1])
EndFunc

Func P1BR_Set()
	$P1BR = MouseGetPos()
	GUICtrlSetData($IP1BRX, $P1BR[0])
	GUICtrlSetData($IP1BRY, $P1BR[1])
EndFunc
Func P2TL_Set()
	$P2TL = MouseGetPos()
	GUICtrlSetData($IP2TLX, $P2TL[0])
	GUICtrlSetData($IP2TLY, $P2TL[1])
EndFunc

Func P2BR_Set()
	$P2BR = MouseGetPos()
	GUICtrlSetData($IP2BRX, $P2BR[0])
	GUICtrlSetData($IP2BRY, $P2BR[1])
EndFunc



Func Draw_P1Box()

    Local $startX = $P1TL[0]-1
    Local $startY = $P1TL[1]-1
    Local $endX = $P1BR[0]+1
    Local $endY = $P1BR[1]+1

	DllStructSetData($tRect1, 1, $startX)
    DllStructSetData($tRect1, 2, $startY)
    DllStructSetData($tRect1, 3, $endX)
    DllStructSetData($tRect1, 4, $endY)
    Local $hBrush1 = _WinAPI_CreateSolidBrush(0x00ff0d)

	_WinAPI_FrameRect($hDC, DllStructGetPtr($tRect1), $hBrush1)
	_WinAPI_DeleteObject($hBrush1)

EndFunc

Func Draw_P2Box()
	Local $startX = $P2TL[0]-1
    Local $startY = $P2TL[1]-1
    Local $endX = $P2BR[0]+1
    Local $endY = $P2BR[1]+1

	DllStructSetData($tRect2, 1, $startX)
    DllStructSetData($tRect2, 2, $startY)
    DllStructSetData($tRect2, 3, $endX)
    DllStructSetData($tRect2, 4, $endY)
    Local $hBrush2 = _WinAPI_CreateSolidBrush(0x00af0d)

	_WinAPI_FrameRect($hDC, DllStructGetPtr($tRect2), $hBrush2)
	_WinAPI_DeleteObject($hBrush2)

EndFunc


Func IP1BRXChange()

EndFunc
Func IP1BRYChange()

EndFunc
Func IP1TLXChange()

EndFunc
Func IP1TLYChange()

EndFunc
Func IP2BRXChange()

EndFunc
Func IP2BRYChange()

EndFunc
Func IP2TLXChange()

EndFunc
Func IP2TLYChange()


EndFunc


;Global $P1TL[2] = [0,0]
;Global $P1BR[2] = [0,0]

;Global $P2TL[2] = [0,0]
;Global $P2BR[2] = [0,0]

Func IP1TLXUDChange()
$P1TL[0] = GUICtrlRead($IP1TLX)
EndFunc
Func IP1TLYUDChange()
$P1TL[1] = GUICtrlRead($IP1TLY)
EndFunc


Func IP1BRXUDChange()
$P1BR[0] = GUICtrlRead($IP1BRX)
EndFunc
Func IP1BRYUDChange()
$P1BR[1] = GUICtrlRead($IP1BRY)
EndFunc



Func IP2TLXUDChange()
$P2TL[0] = GUICtrlRead($IP2TLX)
EndFunc
Func IP2TLYUDChange()
$P2TL[1] = GUICtrlRead($IP2TLY)
EndFunc

Func IP2BRXUDChange()
$P2BR[0] = GUICtrlRead($IP2BRX)
EndFunc
Func IP2BRYUDChange()
$P2BR[1] = GUICtrlRead($IP2BRY)
EndFunc



Func IPGCNTUDChange()
	$PgCntr = GUICtrlRead($IPGCNT)

EndFunc





Func LMouseClick()

EndFunc

Func LP1BRClick()

EndFunc
Func LP1TLClick()

EndFunc
Func LP2BRClick()

EndFunc
Func LP2TLClick()

EndFunc

Func LY1Click()

EndFunc
Func LY2Click()

EndFunc
Func LY3Click()

EndFunc
Func LY4Click()

EndFunc


Func MGuiClose()
	Quit()
EndFunc


Func MGuiMaximize()

EndFunc
Func MGuiMinimize()

EndFunc
Func MGuiRestore()

EndFunc
