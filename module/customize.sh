MAXAPI=33
MINAPI=33

SKIPUNZIP=1

#if [[ "$(getprop ro.build.PDA)" == "P615XXS7FXA1" || "$(getprop ro.build.PDA)" == "P610XXS4FXA1" ]]; then
#    ui_print "Supported software version: $(getprop ro.build.PDA)"
#else
#    ui_print "Unsupported device or version: $(getprop ro.build.PDA)"
#    ui_print "P615XXU7FWH7 or P610XXU4FH7 required for this module's version"
#    abort
#fi

ui_print "- Extracting module files..."
unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH
mkdir $MODPATH/zygisk
mv $MODPATH/lib/zygisk/* $MODPATH/zygisk/
rm -rf $MODPATH/lib

ui_print "- Creating temp directory..."
mkdir $MODPATH/tmp

ui_print "- Installing large apps..."

#REMOTE vers
#SmartSuggestions 5.2.00.66

mkdir $MODPATH/system/app/
mkdir $MODPATH/system/priv-app/

ui_print "- Installing Camera Kit by Snapchat (for fun mode)..."
wget -O $MODPATH/tmp/FunModeSDK.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/FunModeSDK.tar.gz"
mkdir $MODPATH/system/app/FunModeSDK/
tar -xvf $MODPATH/tmp/FunModeSDK.tar.gz -C $MODPATH/system/app/FunModeSDK/

ui_print "- Installing AI models for Styles and Erasers in Photo Editor..."
wget -O $MODPATH/tmp/EditorFiles.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/EditorFiles.tar.gz"
tar -xvf $MODPATH/tmp/EditorFiles.tar.gz -C $MODPATH/system/etc/

ui_print "- Installing HashTag Service..."
wget -O $MODPATH/tmp/HashTagService.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/HashTagService.tar.gz"
mkdir $MODPATH/system/priv-app/HashTagService
tar -xvf $MODPATH/tmp/HashTagService.tar.gz -C $MODPATH/system/priv-app/HashTagService/

ui_print "- Installing Full Photo Editor..."
wget -O $MODPATH/tmp/PhotoEditor_Full.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/PhotoEditor_Full.tar.gz"
mkdir $MODPATH/system/priv-app/PhotoEditor_Full
tar -xvf $MODPATH/tmp/PhotoEditor_Full.tar.gz -C $MODPATH/system/priv-app/PhotoEditor_Full/

#if [[ "$(getprop ro.build.PDA)" == "P610XXS3FWD2" ]]; then
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

ui_print "- Configuring Floating Feature..."
SET_CONFIG()
{
    local CONFIG="$1"
    local VALUE="$2"
    local FILE="$MODPATH/system/etc/floating_feature.xml"

    [ -e "$FILE" ] || cp "/system/etc/floating_feature.xml "$FILE"
    
    if [[ "$2" == "-d" ]] || [[ "$2" == "--delete" ]]; then
        CONFIG="$(echo -n "$CONFIG" | sed 's/=//g')"
        if grep -Fq "$CONFIG" "$FILE"; then
            ui_print "Deleting \"$CONFIG\" config in /system/system/etc/floating_feature.xml"
            sed -i "/$CONFIG/d" "$FILE"
        fi
    else
        if grep -Fq "<$CONFIG>" "$FILE"; then
            ui_print "Replacing \"$CONFIG\" config with \"$VALUE\" in /system/system/etc/floating_feature.xml"
            sed -i "$(sed -n "/<${CONFIG}>/=" "$FILE") c\ \ \ \ <${CONFIG}>${VALUE}</${CONFIG}>" "$FILE"
        else
            ui_print "Adding \"$CONFIG\" config with \"$VALUE\" in /system/system/etc/floating_feature.xml"
            sed -i "/<\/SecFloatingFeatureSet>/d" "$FILE"
            if ! grep -q "Added by unica" "$FILE"; then
                echo "    <!-- Added by unica/patches/floating_feature/customize.sh -->" >> "$FILE"
            fi
            echo "    <${CONFIG}>${VALUE}</${CONFIG}>" >> "$FILE"
            echo "</SecFloatingFeatureSet>" >> "$FILE"
        fi
    fi
}

READ_AND_APPLY_CONFIGS()
{
    local CONFIG_FILE="$MODPATH/sff.sh"

    if [ -f "$CONFIG_FILE" ]; then
        while read -r i; do
            [[ "$i" = "#"* ]] && continue
            [[ -z "$i" ]] && continue

            if [[ "$i" == *"delete" ]] || [[ -z "$(echo -n "$i" | cut -d "=" -f 2)" ]]; then
                SET_CONFIG "$(echo -n "$i" | cut -d " " -f 1)" --delete
            elif echo -n "$i" | grep -q "="; then
                SET_CONFIG "$(echo -n "$i" | cut -d "=" -f 1)" "$(echo -n "$i" | cut -d "=" -f2-)"
            else
                echo "Malformed string in $MODPATH/sff.sh: \"$i\""
                return 1
            fi
        done < "$CONFIG_FILE"
    fi
}

rm $MODPATH/sff.sh

ui_print "- Finishing the last things..."
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

REMOVE="
/system/priv-app/PhotoEditor_Mid
/system/app/SamsungWeather/SamsungWeather.apk.prof
"

ui_print "- Now clearing temp files and system cache to make everything working..."
rm -rf /data/system/package_cache/*
rm -rf $MODPATH/tmp

ui_print "- Setting permissions..."
set_perm_recursive "$MODPATH" 0 0 0777 0755

ui_print "- You'll see SecondScreen toggle after reboot in QuickSettings"
ui_print ""
ui_print "- Done!"
ui_print ""
