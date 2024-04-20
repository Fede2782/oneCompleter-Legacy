# oneCompleter

![Version](https://img.shields.io/github/v/release/Fede2782/oneCompleter?style=flat"/>)
![Size](https://img.shields.io/github/repo-size/Fede2782/oneCompleter?style=flat"/>)
![Commit](https://img.shields.io/github/last-commit/Fede2782/oneCompleter/master?style=flat-square"/>)

Add missing One UI features to different devices and much more...

You can flash this Magisk module at your own risk. I am not responsible for lost warranty, bootloops, lost data, or any other damage to your device.

## Requirements:
- One UI 5.1 or One UI 5.1.1 device with One UI (One UI Core not supported)
- Latest Magisk with Zygisk enabled
- Clean system (stock ROM, no modifications to stock ROM with Magisk/KernelSU or other methods)
- 1GB of free storage
- Internet Connection

## Credits
These amazing features were created by Samsung. None of this would have been possible if Samsung hadn't created these features.

Pixelify for the Zygisk spoofing implementation. BlackMesa123 for floating feature script.

## 💡Little tip

This module installs some big apps and libs. I suggest you use Galaxy App Booster (Samsung official app of Good Guardians suite) after every big module update, so the tablet will not slow down. A "wipe cache" or "Repair apps" in Recovery may be useful in some cases. Moreover, make sure all apps are up-to-date before/after installing this module (Play Store and Galaxy Store).

## Features Now:
- ✅️ Object/Shadow/Reflection eraser
- ✅️ Image Clipper (thanks to ShaDisNX255/NcX-S21FE/)*¹
- ✅️ Smart Suggestions Widget (thanks to BlackMesa123)
- ✅️ Camera Privacy toggle 
- ✅️ Google Discover feed 
- ✅️ Samsung Tag Service 
- ✅️ Camera fun mode
- ✅️ Styles feature in Photo Editor 
- ✅️ Two-line boot animation*²
- ✅️ Tablet as Second screen
- ✅️ High End animations in stock launcher
- ✅️ Highlight video maker
- ✅️ Extra Dim
- ✅️ Samsung Health available in Galaxy Store for tablets*³
- ✅️ Wireless DeX*⁴

*¹ Available only on Exynos 9611 devices. *² Available only on Tab S6 Lite 2020. *³ You still need a module to patch Samsung Health like [BlackMesa123's KnoxPatch](https://github.com/BlackMesa123/KnoxPatch/). Moreover, make sure Galaxy Store is not in Magisk/KernelSU denylist. *⁴ Requires a proper kernel support. 

## Configuration
You can configure the first installation by editing the config.sh file inside the module. 

## ⚠️ Uninstall/Disable and OS updates
Never disable this module because it may create big issues in the system. In this case, install again the module. If you have booted in Safe Mode you should reinstall it too. Never update One UI/Android version (One UI 5 -> 5.1, Android 12 -> 13) with the module installed, uninstall the module before doing the update and then install it again. 

## Other Info
Feel free to contribute if you have some ideas or ways to enable or add these features.

Big files are stored here to reduce zip file size: https://gitlab.com/Fede2782/onecompleter-files/

If you want to test new builds immediately you can download artifacts from Github actions.
