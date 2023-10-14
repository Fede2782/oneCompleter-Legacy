#/bin/bash
rm *.zip
version="$(grep '^version=' module.prop  | cut -d= -f2)"
zip -r9 "oneCompleter-$version-online.zip" . -x build.sh update.json README.md CHANGELOG.md LICENSE ".git/*" ".github/*" "img/*"
#zip --delete "oneCompleter-$version-online.zip" ".git/*" || true
#zip --delete "oneCompleter-$version-online.zip" ".github/*" || true
#zip --delete "oneCompleter-$version-online.zip" "img/*" || true

MODPATH=$(pwd)

function download_offline {
  mkdir $MODPATH/tmp/
  mkdir $MODPATH/system/priv-app/

  wget -O $MODPATH/tmp/AREmojiEditor.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/AREmojiEditor.tar.gz"
  mkdir $MODPATH/system/priv-app/AREmojiEditor/
  tar -xvf $MODPATH/tmp/AREmojiEditor.tar.gz -C $MODPATH/system/priv-app/AREmojiEditor/

  wget -O $MODPATH/tmp/AvatarEmojiSticker.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/AvatarEmojiSticker.tar.gz"
  mkdir $MODPATH/system/priv-app/AvatarEmojiSticker/
  tar -xvf $MODPATH/tmp/AvatarEmojiSticker.tar.gz -C $MODPATH/system/priv-app/AvatarEmojiSticker/

  wget -O $MODPATH/tmp/HashTagService.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/HashTagService.tar.gz"
  mkdir $MODPATH/system/priv-app/HashTagService/
  tar -xvf $MODPATH/tmp/HashTagService.tar.gz -C $MODPATH/system/priv-app/HashTagService/

  wget -O $MODPATH/tmp/AREmoji.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/AREmoji.tar.gz"
  mkdir $MODPATH/system/priv-app/AREmoji/
  tar -xvf $MODPATH/tmp/AREmoji.tar.gz -C $MODPATH/system/priv-app/AREmoji/

  wget -O $MODPATH/tmp/FunModeSDK.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/FunModeSDK.tar.gz"
  mkdir $MODPATH/system/app/FunModeSDK/
  tar -xvf $MODPATH/tmp/FunModeSDK.tar.gz -C $MODPATH/system/app/FunModeSDK/

  wget -O $MODPATH/tmp/SamsungWeather.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/SamsungWeather.tar.gz"
  tar -xvf $MODPATH/tmp/SamsungWeather.tar.gz -C $MODPATH/system/app/SamsungWeather/

  wget -O $MODPATH/tmp/EditorFiles.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/EditorFiles.tar.gz"
  tar -xvf $MODPATH/tmp/EditorFiles.tar.gz -C $MODPATH/system/etc/

  wget -O $MODPATH/tmp/FunModeSDK.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/FunModeSDK.tar.gz"
  mkdir $MODPATH/system/app/FunModeSDK/
  tar -xvf $MODPATH/tmp/FunModeSDK.tar.gz -C $MODPATH/system/app/FunModeSDK/

  wget -O $MODPATH/tmp/PhotoEditor_Full.tar.gz "https://gitlab.com/Fede2782/onecompleter-files/-/raw/main/PhotoEditor_Full.tar.gz"
  mkdir $MODPATH/system/priv-app/PhotoEditor_Full
  tar -xvf $MODPATH/tmp/PhotoEditor_Full.tar.gz -C $MODPATH/system/priv-app/PhotoEditor_Full/

}

if [[ "$1" == "offline" ]]; then
    echo "Preparing offline installer..."
    mv customize_offline.sh customize.sh
    download_offline
    rm -rf tmp
    zip -r9 "oneCompleter-$version-offline.zip" . -x build.sh update.json "oneCompleter-$version-online.zip" customize_offline.sh
    zip --delete "oneCompleter-$version-offline.zip" ".git/*" || true
    zip --delete "oneCompleter-$version-offline.zip" ".github/*" || true
    zip --delete "oneCompleter-$version-offline.zip" "img/*" || true
else
    echo "Completed"
fi
