qsettings=$(settings get secure sysui_qs_tiles)
if [[ $qsettings != *ScreenSharing* ]]; then
    settings put secure sysui_qs_tiles "$qsettings,custom(com.samsung.android.smartmirroring/.tile.ScreenSharingTile)"
else
    sleep 1
fi

