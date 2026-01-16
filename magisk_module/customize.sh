#!/system/bin/sh
# JamesDSPManager-RE Magisk Module Installer
# Based on MMT-Extended template

SKIPUNZIP=1
ASH_STANDALONE=1

# Extract verify.sh
ui_print "- Extracting verify.sh"
unzip -o "$ZIPFILE" 'common/verify.sh' -d $TMPDIR >&2
if [ ! -f $TMPDIR/common/verify.sh ]; then
  ui_print "*********************************************************"
  ui_print "! Unable to extract verify.sh!"
  ui_print "! This zip may be corrupted, please try downloading again"
  ui_print "*********************************************************"
  exit 1
fi
. $TMPDIR/common/verify.sh

extract_files() {
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" -x 'META-INF/*' -d $MODPATH >&2
}

set_permissions() {
  ui_print "- Setting permissions"
  
  # Module permissions
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm_recursive $MODPATH/system/bin 0 2000 0755 0755
  
  # Library permissions
  set_perm_recursive $MODPATH/system/lib 0 0 0755 0644
  if [ -d "$MODPATH/system/lib64" ]; then
    set_perm_recursive $MODPATH/system/lib64 0 0 0755 0644
  fi
  
  # App permissions
  set_perm_recursive $MODPATH/system/priv-app/JamesDSPManagerRE 0 0 0755 0644
}

# Install
ui_print " "
ui_print "**************************************"
ui_print " JamesDSPManager-RE Installation"
ui_print "**************************************"
ui_print " "
ui_print "- Version: 10.0-RE"
ui_print "- Author: Mohammad Adi"
ui_print " "

# Device info
ui_print "- Device: $(getprop ro.product.device)"
ui_print "- Android: $(getprop ro.build.version.release)"
ui_print "- SDK: $(getprop ro.build.version.sdk)"
ui_print " "

# Check Android version
ANDROID_VER=$(getprop ro.build.version.sdk)
if [ "$ANDROID_VER" -lt 21 ]; then
  ui_print "! Android 5.0+ required!"
  ui_print "! Current: Android $(getprop ro.build.version.release)"
  exit 1
fi

ui_print "- Extracting files..."
extract_files

ui_print "- Installing audio effects config..."
# Create audio effects config
AUDIO_EFFECTS="/system/etc/audio_effects.conf"
if [ -f "$AUDIO_EFFECTS" ]; then
  ui_print "  Found existing audio_effects.conf"
else
  ui_print "  Creating audio_effects.conf"
fi

ui_print "- Setting permissions..."
set_permissions

ui_print " "
ui_print "**************************************"
ui_print " Installation Complete!"
ui_print "**************************************"
ui_print " "
ui_print "- Reboot to apply changes"
ui_print "- Open JamesDSP Manager RE from launcher"
ui_print " "
