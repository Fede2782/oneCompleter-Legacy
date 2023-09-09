qsettings=$(settings get secure sysui_qs_tiles)
if [[ $qsettings != *ScreenSharing* ]]; then
    settings put secure sysui_qs_tiles "$qsettings,custom(com.samsung.android.smartmirroring/.tile.ScreenSharingTile)"
else
    sleep 1
fi
watch -n 60 pm enable com.samsung.android.smartsuggestions/com.samsung.android.smartsuggestions.widget.appwidget.SmartSuggestionsWidgetProvider
