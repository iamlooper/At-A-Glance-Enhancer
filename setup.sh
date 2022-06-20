#!/sbin/sh

###########################
# MMT Reborn Logic
###########################

############
# Config Vars
############

# Set this to true if you want to skip mount for your module
SKIPMOUNT="false"
# Set this to true if you want to clean old files in module before injecting new module
CLEANSERVICE="false"
# Set this to true if you want to load vskel after module info print. If you want to manually load it, consider using load_vksel function
AUTOVKSEL="false"
# Set this to true if you want store debug logs of installation
DEBUG="true"

############
# Replace List
############

# List all directories you want to directly replace in the system
# Construct your list in the following example format
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"
# Construct your own list here
REPLACE="

"

############
# Permissions
############

# Set permissions
set_permissions() {
  set_perm_recursive "$MODPATH" 0 0 0777 0755
  set_perm_recursive "$MODPATH/system/bin" 0 0 0777 0755
  set_perm_recursive "$MODPATH/system/product/priv-app" 0 0 0777 0755
  set_perm_recursive "$MODPATH/system/product/overlay" 0 0 0777 0755
}

############
# Info Print
############

# Set what you want to be displayed on header of installation process
info_print() {
  ui_print ""
  ui_print "********************************************"
  ui_print "          At A Glance Enhancer"
  ui_print "        By iamlooper @ telegram"
  ui_print "********************************************"
  
  sleep 2
}

############
# Main
############

# Change the logic to whatever you want
init_main() {
  gms="/data/user/0/com.google.android.gms/databases/phenotype.db"

  ui_print ""
  ui_print "[*] Enhancing At A Glance... "
    
  # Flags by Kingsman44 @ github
  sqlite3 "$gms" "DELETE FROM FlagOverrides WHERE packageName='com.google.android.platform.device_personalization_services'"
  db_editor "com.google.android.platform.device_personalization_services" "boolVal" "1" "Echo__smartspace_enable_battery_notification_parser" "Echo__smartspace_enable_doorbell" "Echo__smartspace_enable_earthquake_alert_predictor" "Echo__smartspace_enable_echo_settings" "Echo__smartspace_enable_light_predictor" "Echo__smartspace_enable_paired_device_predictor" "Echo__smartspace_enable_safety_check_predictor" "Echo__smartspace_enable_echo_unified_settings" "Echo__smartspace_enable_dark_launch_outlook_events" "Echo__smartspace_enable_step_predictor" "Echo__smartspace_enable_nap" "Echo__smartspace_enable_paired_device_connections" "Echo__smartspace_dedupe_fast_pair_notification" "Echo__smartspace_enable_nudge" "Echo__smartspace_enable_package_delivery" "Echo__smartspace_enable_outlook_events" "Echo__smartspace_gaia_twiddler" "Echo__smartspace_enable_eta_lyft" "Echo__smartspace_enable_sensitive_notification_twiddler"
  db_editor "com.google.android.platform.launcher" "boolVal" "ENABLE_SMARTSPACE_ENHANCED"
  
  sleep 1

  ui_print ""
  ui_print "[*] Installing Android System Intelligence App... "

  touch "$MODPATH/system/product/priv-app/DevicePersonalizationPrebuiltPixel2021/.replace"
  touch "$MODPATH/system/product/priv-app/DeviceIntelligenceNetworkPrebuilt/.replace"

  [[ -z "$(dumpsys package com.google.android.as | grep versionName | grep pixel6)" ]] && rm -rf /data/app/*/*com.google.android.as*

  cp -f "$MODPATH/system/product/priv-app/DevicePersonalizationPrebuiltPixel2021/DevicePersonalizationPrebuiltPixel2021.apk" "/data/local/tmp"
  chmod 0777 "/data/local/tmp/DevicePersonalizationPrebuiltPixel2021.apk"
  pm install "/data/local/tmp/DevicePersonalizationPrebuiltPixel2021.apk" &>/dev/null

  sleep 0.5

  ui_print ""
  ui_print "[*] Clearing system cache and disabling enabling Google app to properly make it work..."

  rm -rf "/data/system/package_cache"
  pm disable --user 0 "com.google.android.googlequicksearchbox" &>/dev/null
  pm enable --user 0 "com.google.android.googlequicksearchbox" &>/dev/null

  sleep 0.5

  ui_print ""
  ui_print "[*] Done!"

  sleep 0.5

  ui_print " --- Notes --- "
  ui_print ""
  ui_print "[*] Reboot is required"
  ui_print ""
  ui_print "[*] Report issues to @loopchats on Telegram"
  ui_print ""
  ui_print "[*] Join @loopprojects on Telegram to get more updates"
  ui_print ""
  ui_print "[*] You can find us at @iamlooper & @saitama_96 on Telegram for direct support"

  sleep 2
}