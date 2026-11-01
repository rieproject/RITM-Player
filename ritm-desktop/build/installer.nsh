; Pendaftaran thumbnail provider untuk file .ritm (lihat native/thumb/ritm_thumb.cpp).
; Installer per-user (perMachine: false), jadi semuanya ditulis ke HKCU\Software\Classes
; dengan tampilan registry 64-bit agar Explorer 64-bit membacanya.
; CLSID : {7C3A9E21-5B4D-4F8A-9E0C-2D1B6A8F4C37}
; Handler thumbnail : {E357FCCD-A995-4576-B01F-234630154E96}

!define RITM_THUMB_CLSID "{7C3A9E21-5B4D-4F8A-9E0C-2D1B6A8F4C37}"
!define RITM_THUMB_SHELLEX "{E357FCCD-A995-4576-B01F-234630154E96}"

!macro customInstall
  SetRegView 64
  WriteRegStr HKCU "Software\Classes\CLSID\${RITM_THUMB_CLSID}" "" "RITM Thumbnail Provider"
  WriteRegStr HKCU "Software\Classes\CLSID\${RITM_THUMB_CLSID}\InprocServer32" "" "$INSTDIR\resources\thumb\ritm_thumb.dll"
  WriteRegStr HKCU "Software\Classes\CLSID\${RITM_THUMB_CLSID}\InprocServer32" "ThreadingModel" "Apartment"
  WriteRegStr HKCU "Software\Classes\.ritm\ShellEx\${RITM_THUMB_SHELLEX}" "" "${RITM_THUMB_CLSID}"
  ; Beritahu Explorer bahwa asosiasi file berubah (tanpa perlu restart).
  System::Call 'shell32::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)'
!macroend

!macro customUnInstall
  SetRegView 64
  DeleteRegKey HKCU "Software\Classes\CLSID\${RITM_THUMB_CLSID}"
  DeleteRegKey HKCU "Software\Classes\.ritm\ShellEx\${RITM_THUMB_SHELLEX}"
  System::Call 'shell32::SHChangeNotify(i 0x08000000, i 0, i 0, i 0)'
!macroend
