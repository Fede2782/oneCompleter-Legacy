MAXAPI=33
MINAPI=33

SKIPUNZIP=1

if [[ "$(getprop ro.build.PDA)" == "P615XXS5FWD2" ]]; then
    echo "Supported software version: P615XXS5FWD2"
else
    ui_print "Unsupported device or version: '$(getprop ro.build.PDA)'"
    ui_print "P615XXS5FWD2 requires for this module's version"
    abort
fi

ui_print "- Extracting module files..."
unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH

ui_print "- Now clearing package cache to make everything working..."
rm -rf /data/system/package_cache/*

ui_print "- Setting permissions..."
set_perm_recursive "$MODPATH" 0 0 0777 0755

rm -rf $MODPATH/.github
