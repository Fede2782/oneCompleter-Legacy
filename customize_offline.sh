MAXAPI=33
MINAPI=33

SKIPUNZIP=1

if [[ "$(getprop ro.build.PDA)" == "P615XXU7FWH7" || "$(getprop ro.build.PDA)" == "P610XXU4FWH7" ]]; then
    ui_print "Supported software version: $(getprop ro.build.PDA)"
else
    ui_print "Unsupported device or version: $(getprop ro.build.PDA)"
    ui_print "P615XXU7FWH7 or P610XXU4FWH7 required for this module's version"
    abort
fi

ui_print "- Extracting module files..."
unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH

#if [[ "$(getprop ro.build.PDA)" == "P610XXS4FWG4" ]]; then
#    ui_print "- Found P610 model"
#    ui_print "- Applying patch...."
#    mv $MODPATH/system/etc/floating_feature_p610.xml $MODPATH/system/etc/floating_feature.xml
#    mv $MODPATH/system/vendor/etc/floating_feature_p610.xml $MODPATH/system/vendor/etc/floating_feature.xml
#else
#    ui_print "- Found P615 model"
#    ui_print "- Cleaning unused files..."
#    rm $MODPATH/system/etc/floating_feature_p610.xml
#    rm $MODPATH/system/vendor/etc/floating_feature_p610.xml
#fi

ui_print "- Force enabling features: SecondScreen and SmartSuggestions..."
chmod +x $MODPATH/service.sh

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

ui_print "- Now clearing temp files and system cache to make everything working..."
rm -rf /data/system/package_cache/*

ui_print "- Setting permissions..."
set_perm_recursive "$MODPATH" 0 0 0777 0755
