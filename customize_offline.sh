MAXAPI=33
MINAPI=33

SKIPUNZIP=1

if [[ "$(getprop ro.build.PDA)" == "P615XXS5FWD2" || "$(getprop ro.build.PDA)" == "P610XXS3FWD2" ]]; then
    ui_print "Supported software version: $(getprop ro.build.PDA)"
else
    ui_print "Unsupported device or version: $(getprop ro.build.PDA)"
    ui_print "P615XXS5FWD2 or P610XXS3FWD2 required for this module's version"
    abort
fi

ui_print "- Extracting module files..."
unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH

if [[ "$(getprop ro.build.PDA)" == "P610XXS3FWD2" ]]; then
    ui_print "- Found P610 model"
    ui_print "- Applying patch...."
    mv $MODPATH/system/etc/floating_feature_p610.xml $MODPATH/system/etc/floating_feature.xml
    mv $MODPATH/system/vendor/etc/floating_feature_p610.xml $MODPATH/system/vendor/etc/floating_feature.xml
else
    ui_print "- Found P615 model"
    ui_print "- Cleaning unused files..."
    rm $MODPATH/system/etc/floating_feature_p610.xml
    rm $MODPATH/system/vendor/etc/floating_feature_p610.xml
fi

ui_print "- Now clearing temp files and system cache to make everything working..."
rm -rf /data/system/package_cache/*

ui_print "- Setting permissions..."
set_perm_recursive "$MODPATH" 0 0 0777 0755
