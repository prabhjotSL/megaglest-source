;--------------------------------
; General Attributes

!define APNAME Mega-Glest
!define APVER 3.3.5
!define APVER_UPDATE 3.3.5.1-alpha1

Name "${APNAME} ${APVER_UPDATE}"
SetCompressor /FINAL /SOLID lzma
SetCompressorDictSize 64
OutFile "${APNAME}-Updater-${APVER_UPDATE}_i386_win32.exe"
Icon "..\megaglest.ico"
UninstallIcon "..\megaglest.ico"
!define MUI_ICON "..\megaglest.ico"
!define MUI_UNICON "..\megaglest.ico"
InstallDir "$PROGRAMFILES\${APNAME}_${APVER}"
ShowInstDetails show
BGGradient 0xDF9437 0xffffff

; Request application privileges for Windows Vista
RequestExecutionLevel none

PageEx license
       LicenseText "Megaglest License"
       LicenseData "..\..\..\data\glest_game\docs\license.txt"
PageExEnd

PageEx license
       LicenseText "Megaglest README"
       LicenseData "..\..\..\data\glest_game\docs\readme.txt"
PageExEnd

;--------------------------------
; Images not included!
; Use your own animated GIFs please
;--------------------------------

;--------------------------------
;Interface Settings

!include "MUI.nsh"
!define MUI_CUSTOMFUNCTION_GUIINIT MUIGUIInit
!insertmacro MUI_PAGE_WELCOME
#!insertmacro MUI_PAGE_DIRECTORY
#!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\${APNAME}_${APVER}" "Install_Dir"

; Pages

Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

Function MUIGUIInit

  SetOutPath '$PLUGINSDIR'
  File megaglestinstallscreen.jpg
  
  FindWindow $0 '_Nb'
  EBanner::show /NOUNLOAD /FIT=BOTH /HWND=$0 "$PLUGINSDIR\megaglestinstallscreen.jpg"

#  FindWindow $0 "#32770" "" $HWNDPARENT
#  GetDlgItem $0 $0 1006
#  SetCtlColors $0 0xDF9437 0xDF9437

   ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APNAME}_${APVER}" "UninstallString"
   StrCmp $R0 "" 0 foundInst
   
   IfFileExists $INSTDIR\glest_game.exe foundInst
   
   IfFileExists $EXEDIR\glest_game.exe foundInst notFoundInst

foundInst:

MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
  "${APNAME} v${APVER} installation found. $\n$\nClick `OK` to update \
  the previous installation or `Cancel` to exit." \
  IDOK uninstInit

  # change install folder to a version specific name to aovid over-writing
  # old one
  ;StrCpy $INSTDIR "$PROGRAMFILES\${APNAME}_${APVER}"
  Quit
  goto doneInit

notFoundInst:

MessageBox MB_OK|MB_ICONSTOP \
  "${APNAME} v${APVER} installation NOT found. $\n$\nCannot upgrade \
  this installation since the main installer was not previously used." \
  IDOK
  Quit
  goto doneInit

;Run the uninstaller
uninstInit:
  ClearErrors
  ;ExecWait '$R0 _?=$INSTDIR' ;Do not copy the uninstaller to a temp file
  ;Exec $INSTDIR\uninst.exe ; instead of the ExecWait line
    
doneInit:

FunctionEnd


Function .onGUIEnd

  EBanner::stop

FunctionEnd

Function .onInstSuccess

    MessageBox MB_YESNO "${APNAME} v${APVER} installed successfully, \
    click Yes to launch the game$\nor 'No' to exit." IDNO noLaunch

    SetOutPath $INSTDIR
    Exec 'glest_game.exe'

noLaunch:

FunctionEnd

; The stuff to install
Section "${APNAME} (required)"

  SectionIn RO

  #MUI_PAGE_INSTFILES
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  ; Put file there
  File "..\..\..\data\glest_game\glest_game.exe"
  File "..\..\..\data\glest_game\glest_editor.exe"
  File "..\..\..\data\glest_game\glest_configurator.exe"
  File "..\..\..\data\glest_game\g3d_viewer.exe"
  File /r /x .svn /x mydata "..\..\..\data\glest_game\data\*.lng"

  AccessControl::GrantOnFile "$INSTDIR" "(BU)" "FullAccess"

SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

SectionEnd

;--------------------------------

; Uninstaller

Section "Uninstall"

SectionEnd

