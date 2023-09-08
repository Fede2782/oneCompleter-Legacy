qsettings=$(settings get secure sysui_qs_tiles)
settings put secure sysui_qs_tiles "$qsettings,custom(com.samsung.android.smartmirroring/.tile.ScreenSharingTile)"
