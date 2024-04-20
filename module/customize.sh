MAXAPI=33
MINAPI=33

SKIPUNZIP=1

if [[ "$(getprop ro.system.product.cpu.abilist64)" == *"arm64-v8a"* ]]; then
    ui_print "- Supported architecture: $(getprop ro.system.product.cpu.abilist64)"
else
    ui_print "Unsupported architecture: $(getprop ro.system.product.cpu.abilist)"
    ui_print "64-bit Android required for this module."
    abort
fi

if [[ "$(getprop ro.build.version.oneui)" == "50101" || "$(getprop ro.build.version.oneui)" == "50100" ]]; then
    ui_print "- Supported One UI version"
else
    ui_print "Unsupported One UI version: $(getprop ro.build.version.oneui)"
    ui_print "One UI 5.1 (50100) or OneUI 5.1.1 (50101) required for this module's version"
    abort
fi

if grep -q "sep_lite" "/system/etc/floating_feature.xml"; then
    ui_print "One UI Core devices are not supported"
    abort
else
    if [[ ! -e "/system/lib64/libBeauty_v4.camera.samsung.so" ]]; then
        ui_print "One UI Core devices are not supported"
        abort
    fi
    ui_print "- Supported One UI edition"
fi

if [[ "$(getprop ro.build.PDA)" == "P615XXS7FXA1" || "$(getprop ro.build.PDA)" == "P610XXS4FXA1" ]]; then
    ui_print "Installing on Tab S6 Lite: $(getprop ro.build.PDA)"
    2020_EDITION=true
else
    rm -rf $MODPATH/system/media
fi

SET_CONFIG()
{
    local CONFIG="$1"
    local VALUE="$2"
    local FILE="$MODPATH/system/etc/floating_feature.xml"

    [ -e "$FILE" ] || cp "/system/etc/floating_feature.xml" "$FILE"
    
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
            if ! grep -q "Added by oneCompleter" "$FILE"; then
                echo "    <!-- Added by oneCompleter -->" >> "$FILE"
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

ui_print "- Extracting module files..."
unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH >> /dev/null
mkdir $MODPATH/zygisk
mv $MODPATH/lib/zygisk/* $MODPATH/zygisk/
rm -rf $MODPATH/lib

ui_print "- Loading configuration..."
source $MODPATH/config.sh
if [ -e /sdcard/onecompleter/config.sh ]; then
    source /sdcard/onecompleter/config.sh
    ui_print "- Loading configuration in /sdcard/onecompleter/config.sh"
elif [ -e /sdcard/onecompleter/config.sh ]; then
    source /data/adb/modules/onecompleter/config.sh
    ui_print "- Loading previous configuration"
    ui_print "- If you have not customized anything before the default one will be used"
else
    ui_print "- Using default configuration"
fi

ui_print "- Creating temp directory..."
mkdir $MODPATH/tmp

ui_print "- Installing large apps..."
mkdir $MODPATH/system/app/
mkdir $MODPATH/system/priv-app/

if [[ $FUN_MODE == "1" ]]; then
	ui_print "- Installing Camera Kit by Snapchat (for fun mode)..."
	wget -O $MODPATH/tmp/FunModeSDK.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/FunModeSDK.tar.gz"
	mkdir $MODPATH/system/app/FunModeSDK/
	tar -xvf $MODPATH/tmp/FunModeSDK.tar.gz -C $MODPATH/system/app/FunModeSDK/
    mkdir $MODPATH/system/cameradata
    cp /system/cameradata/camera-feature.xml "$MODPATH/system/cameradata/camera-feature.xml"
    if grep -q 'SHOOTING_MODE_FUN' input_file.xml; then
        ui_print "- - Fun Mode configuration in camera-feature.xml already present."
        ui_print "- - This means you do not need this feature enabled by oneCompleter or your setup is broken or modifed by other modules."
    else
        sed -i '/<resources>/a \    <local name="SHOOTING_MODE_FUN" back="FUN" front="FUN" enable="false" more="false" order="4" />' "$MODPATH/system/cameradata/camera-feature.xml"
    fi
else
    ui_print "- Skipping Fun Mode installation"
fi

if [[ $AI_ERASERS == "1" ]]; then
	ui_print "- Installing AI models for Styles and Erasers in Photo Editor..."
	wget -O $MODPATH/tmp/EditorFiles.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/EditorFiles.tar.gz"
	tar -xvf $MODPATH/tmp/EditorFiles.tar.gz -C $MODPATH/system/etc/
    if [[ $PHOTO_EDITOR == "0" ]]; then
        ui_print "- - Full Photo Editor installation has been disabled"
        ui_print "- - You may not be able to use Styles and Erasers feature..."
    fi
else
    ui_print "- Skipping AI models for Styles and Erasers in Photo Editor installation"
fi

if [[ $AI_TAGGER == "1" ]] && [[ ! -e /system/priv-app/HashTagService/oat/arm64/HashTagService.odex ]]; then
	ui_print "- Installing HashTag Service..."
	wget -O $MODPATH/tmp/HashTagService.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/HashTagService.tar.gz"
	mkdir $MODPATH/system/priv-app/HashTagService
	tar -xvf $MODPATH/tmp/HashTagService.tar.gz -C $MODPATH/system/priv-app/HashTagService/
else
    ui_print "- Skipping HashTag installation"
fi

if [[ $PHOTO_EDITOR == "1" ]]; then
	ui_print "- Installing Full Photo Editor..."
	wget -O $MODPATH/tmp/PhotoEditor_Full.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/PhotoEditor_Full.tar.gz"
	mkdir $MODPATH/system/priv-app/PhotoEditor_Full
	tar -xvf $MODPATH/tmp/PhotoEditor_Full.tar.gz -C $MODPATH/system/priv-app/PhotoEditor_Full/
    if [[ $AI_ERASERS == "0" ]]; then
        ui_print "- - AI models for Styles and Erasers installation has been disabled"
        ui_print "- - You may not be able to use Styles and Erasers feature..."
    fi
else
    ui_print "- Skipping Full Photo Editor installation"
fi

if [[ $IMAGE_CLIPPER == "1" ]] && [[ $(getprop ro.hardware) == "exynos9611" ]]; then
	ui_print "- Enabling Image Clipper in Gallery"
else
	ui_print "- Skipping Image Clipper installation"
	rm -rf $MODPATH/system/lib64
	rm -rf $MODPATH/system/lib
	rm -rf $MODPATH/system/etc/public.libraries-arcsoft.txt
fi

if [[ $WIRELESS_DEX == "1" ]]; then
    ui_print "- Enabling Wireless DeX"
    ui_print "- - This feature requires a kernel with DeX input driver"
    SET_CONFIG "SEC_FLOATING_FEATURE_COMMON_CONFIG_DEX_MODE" "standalone,wireless"
fi

ui_print "- Configuring Floating Feature..."

READ_AND_APPLY_CONFIGS

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
ui_print "- If you remove it you may have to install again the module, you do not need to uninstall it first"
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
