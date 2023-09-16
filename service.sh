qsettings=$(settings get secure sysui_qs_tiles)

pm disable com.samsung.android.smartmirroring/com.samsung.android.smartmirroring.settings.DisableSecondScreenActivity
pm enable com.samsung.android.smartmirroring/com.samsung.android.smartmirroring.player.SecondScreenActivity
pm enable com.samsung.android.smartmirroring/com.samsung.android.smartmirroring.tile.ScreenSharingTile
pm enable com.samsung.android.smartsuggestions/com.samsung.android.smartsuggestions.widget.appwidget.SmartSuggestionsWidgetProvider
pm enable com.samsung.android.smartmirroring/.player.SecondScreenActivity
pm enable com.samsung.android.smartmirroring/.tile.ScreenSharingTile

ui_print "- Adding Second Screen tile in Quick Settings..."
ui_print "- If you remove it you may have to install again the module (you don't need to uninstall it first)"
if [[ $qsettings == *"ScreenSharing"* ]]; then
  echo "The string contains 'ScreenSharing'. No further action needed." >> /dev/null
else
  # Add your additional actions here
  settings put secure sysui_qs_tiles "$qsettings,custom(com.samsung.android.smartmirroring/.tile.ScreenSharingTile)"
fi

#watch -n 45 pm enable com.samsung.android.smartsuggestions/com.samsung.android.smartsuggestions.widget.appwidget.SmartSuggestionsWidgetProvider >> /dev/null
