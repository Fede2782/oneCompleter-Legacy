#/bin/bash
rm *.zip
version="$(grep '^version=' module.prop  | cut -d= -f2)"
zip -r9 "oneCompleter-$version.zip" . -x build.sh update.json
zip --delete "oneCompleter-$version.zip" ".git/*" || true


