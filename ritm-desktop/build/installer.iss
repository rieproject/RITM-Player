; =============================================================================
; RITM Player - Inno Setup script (DRAFT, belum diuji)
;
; Cara pakai:
;   1. Build folder aplikasi:   npx electron-builder --win --x64 --dir
;      -> hasilnya di release\win-unpacked\ (sudah termasuk resources\native
;         dan resources\thumb\ritm_thumb.dll dari extraResources).
;   2. Compile installer:       "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" build\installer.iss
;      -> keluaran: release\RITM-Player-Setup-1.0.0-inno.exe
;   Atau cukup jalankan run.bat lalu pilih 8 (langkah 1 dan 2 otomatis).
;
; Catatan escape: di Inno Setup, karakter "{" dalam string adalah awal konstanta,
; jadi GUID dan path yang memakai "{" harus ditulis "{{".
; =============================================================================

#define MyAppName "RITM Player"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "RieProject.id"
#define MyAppExeName "RITM Player.exe"
#define SourceDir "..\release\win-unpacked"

; Sama dengan thumbnail CLSID dan handler di build\installer.nsh.
#define ThumbCLSID "{{7C3A9E21-5B4D-4F8A-9E0C-2D1B6A8F4C37}"
#define ThumbHandler "{{E357FCCD-A995-4576-B01F-234630154E96}"

[Setup]
; AppId harus unik dan tetap sama di semua versi. GUID ini dibuat khusus untuk
; draft ini; ganti jika ingin memakai ID lain.
AppId={{5E1C7A2D-8B4F-4C9A-9D31-6F0E2B7A4C58}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppCopyright=(c) RieProject.id
AppPublisherURL=https://rieproject.id
AppSupportURL=https://rieproject.id
; Metadata versi di properti file Setup.exe. Installer tanpa info publisher/versi
; lebih sering ditandai mencurigakan oleh antivirus dan SmartScreen.
VersionInfoVersion=1.0.0.0
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppName} Installer
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}
VersionInfoCopyright=(c) RieProject.id
VersionInfoOriginalFileName=RITM-Player-Setup-{#MyAppVersion}-inno.exe
; Install per-machine ke Program Files (butuh izin admin / UAC).
; Setara dengan perMachine: true di electron-builder.
PrivilegesRequired=admin
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
AllowNoIcons=yes
DefaultDirName={autopf}\{#MyAppName}
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=..\release
OutputBaseFilename=RITM-Player-Setup-{#MyAppVersion}-inno
SetupIconFile=icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
; Signing hanya aktif bila ISCC dipanggil dengan /DSIGN dan /Sritmsign=... (lihat run.bat opsi 8, build\sign.bat).
#ifdef SIGN
SignTool=ritmsign
SignedUninstaller=yes
#endif

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Buat ikon di desktop"; GroupDescription: "Ikon tambahan:"; Flags: unchecked

[Files]
; Seluruh isi folder aplikasi (termasuk resources\native, resources\thumb, dan app.asar).
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Ikon file .ritm (sama dengan build\file-icon.ico yang dipakai NSIS).
Source: "file-icon.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Registry]
; ---- Asosiasi file .ritm (HKLM, per-machine) ----
; Nilai default ekstensi menunjuk ke ProgID milik RITM.
Root: HKLM; Subkey: "Software\Classes\.ritm"; ValueType: string; ValueName: ""; ValueData: "RITM.Release"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "Software\Classes\.ritm"; ValueType: string; ValueName: "Content Type"; ValueData: "application/vnd.ritm+zip"; Flags: uninsdeletevalue

; ProgID: ikon, perintah buka.
Root: HKLM; Subkey: "Software\Classes\RITM.Release"; ValueType: string; ValueName: ""; ValueData: "RITM Release"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Classes\RITM.Release\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\file-icon.ico,0"
Root: HKLM; Subkey: "Software\Classes\RITM.Release\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""

; ---- Thumbnail provider (shell extension ritm_thumb.dll) ----
; Sama dengan installer.nsh: CLSID + InprocServer32 + handler di bawah .ritm\ShellEx.
Root: HKLM; Subkey: "Software\Classes\CLSID\{#ThumbCLSID}"; ValueType: string; ValueName: ""; ValueData: "RITM Thumbnail Provider"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Classes\CLSID\{#ThumbCLSID}\InprocServer32"; ValueType: string; ValueName: ""; ValueData: "{app}\resources\thumb\ritm_thumb.dll"
Root: HKLM; Subkey: "Software\Classes\CLSID\{#ThumbCLSID}\InprocServer32"; ValueType: string; ValueName: "ThreadingModel"; ValueData: "Apartment"
Root: HKLM; Subkey: "Software\Classes\.ritm\ShellEx\{#ThumbHandler}"; ValueType: string; ValueName: ""; ValueData: "{#ThumbCLSID}"; Flags: uninsdeletekey

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Jalankan {#MyAppName}"; Flags: nowait postinstall skipifsilent

; Tidak ada skrip [Code]. Pemanggilan DLL eksternal (SHChangeNotify) di Pascal Script
; sering dianggap pola dropper oleh antivirus, dan tidak diperlukan agar install berfungsi.
; Asosiasi .ritm tetap terdaftar lewat [Registry]; Explorer memperbaruinya saat berikutnya dibuka.
