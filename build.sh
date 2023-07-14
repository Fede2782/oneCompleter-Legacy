#/bin/bash
rm *.zip
version="$(grep '^version=' module.prop  | cut -d= -f2)"
zip -r9 "oneCompleter-$version.zip" . -x build.sh update.json
zip --delete "oneCompleter-$version.zip" ".git/*" || true
zip --delete "oneCompleter-$version.zip" ".github/*" || true
zip --delete "oneCompleter-$version.zip" "img/*" || true

if [[ "$1" == "offline" ]]; then
    echo "Preparing offline installer..."
    download_offline
    zip -r9 "oneCompleter-$version-offline.zip" . -x build.sh update.json
    zip --delete "oneCompleter-$version-offline.zip" ".git/*" || true
    zip --delete "oneCompleter-$version-offline.zip" ".github/*" || true
    zip --delete "oneCompleter-$version-offline.zip" "img/*" || true
else
    echo "Completed"
fi
