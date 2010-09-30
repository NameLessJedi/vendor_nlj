# Generic Cyanogenmod + NLJ product
PRODUCT_NAME := nlj
PRODUCT_BRAND := cyanogen
PRODUCT_DEVICE := generic

PRODUCT_PACKAGES += ADWLauncher

PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.ringtone=DonMessWivIt.ogg

PRODUCT_PROPERTY_OVERRIDES += \
    ro.rommanager.developerid=nlj

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# Used by BusyBox
KERNEL_MODULES_DIR:=/system/lib/modules

# Tiny toolbox
TINY_TOOLBOX:=true

# Enable Windows Media if supported by the board
WITH_WINDOWS_MEDIA:=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=dd-MM-yyyy \
    ro.com.android.dataroaming=false

# CyanogenMod specific product packages
PRODUCT_PACKAGES += \
    CMParts \
    CMPartsHelper \
    CMWallpapers \
    DSPManager \
    FileManager \
    Superuser

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/cyanogen/CHANGELOG.mkdn:system/etc/CHANGELOG-CM.txt

# Common CM overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/nlj/overlay/common

# Bring in some audio files
include frameworks/base/data/sounds/AudioPackage4.mk

PRODUCT_COPY_FILES += \
    vendor/nlj/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/nlj/prebuilt/common/etc/resolv.conf:system/etc/resolv.conf \
    vendor/nlj/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf \
    vendor/nlj/prebuilt/common/etc/terminfo/l/linux:system/etc/terminfo/l/linux \
    vendor/nlj/prebuilt/common/etc/terminfo/u/unknown:system/etc/terminfo/u/unknown \
    vendor/nlj/prebuilt/common/etc/profile:system/etc/profile \
    vendor/nlj/prebuilt/common/etc/init.local.rc:system/etc/init.local.rc \
    vendor/nlj/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/nlj/prebuilt/common/etc/init.d/01sysctl:system/etc/init.d/01sysctl \
    vendor/nlj/prebuilt/common/etc/init.d/03firstboot:system/etc/init.d/03firstboot \
    vendor/nls/prebuilt/common/etc/init.d/04modules:system/etc/init.d/04modules \
    vendor/nlj/prebuilt/common/bin/handle_compcache:system/bin/handle_compcache \
    vendor/nlj/prebuilt/common/bin/compcache:system/bin/compcache \
    vendor/nlj/prebuilt/common/bin/fix_permissions:system/bin/fix_permissions \
    vendor/nlj/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/nlj/prebuilt/common/xbin/htop:system/xbin/htop \
    vendor/nlj/prebuilt/common/xbin/irssi:system/xbin/irssi \
    vendor/nlj/prebuilt/common/xbin/lsof:system/xbin/lsof \
    vendor/nlj/prebuilt/common/xbin/powertop:system/xbin/powertop \
    vendor/nlj/prebuilt/common/xbin/openvpn-up.sh:system/xbin/openvpn-up.sh

# Always run in insecure mode, enables root on user build variants
#ADDITIONAL_DEFAULT_PROPERTIES += ro.secure=0

ifdef CYANOGEN_WITH_GOOGLE
    PRODUCT_COPY_FILES += \
        vendor/cyanogen/proprietary/CarHomeGoogle.apk:./system/app/CarHomeGoogle.apk \
        vendor/cyanogen/proprietary/CarHomeLauncher.apk:./system/app/CarHomeLauncher.apk \
        vendor/cyanogen/proprietary/Facebook.apk:./system/app/Facebook.apk \
        vendor/cyanogen/proprietary/Gmail.apk:./system/app/Gmail.apk \
        vendor/cyanogen/proprietary/GoogleBackupTransport.apk:./system/app/GoogleBackupTransport.apk \
        vendor/cyanogen/proprietary/GoogleCalendarSyncAdapter.apk:./system/app/GoogleCalendarSyncAdapter.apk \
        vendor/cyanogen/proprietary/GoogleContactsSyncAdapter.apk:./system/app/GoogleContactsSyncAdapter.apk \
        vendor/cyanogen/proprietary/GoogleFeedback.apk:./system/app/GoogleFeedback.apk \
        vendor/cyanogen/proprietary/GooglePartnerSetup.apk:./system/app/GooglePartnerSetup.apk \
        vendor/cyanogen/proprietary/GoogleQuickSearchBox.apk:./system/app/GoogleQuickSearchBox.apk \
        vendor/cyanogen/proprietary/GoogleServicesFramework.apk:./system/app/GoogleServicesFramework.apk \
        vendor/cyanogen/proprietary/HtcCopyright.apk:./system/app/HtcCopyright.apk \
        vendor/cyanogen/proprietary/HtcEmailPolicy.apk:./system/app/HtcEmailPolicy.apk \
        vendor/cyanogen/proprietary/HtcSettings.apk:./system/app/HtcSettings.apk \
        vendor/cyanogen/proprietary/LatinImeTutorial.apk:./system/app/LatinImeTutorial.apk \
        vendor/cyanogen/proprietary/Maps.apk:./system/app/Maps.apk \
        vendor/cyanogen/proprietary/MarketUpdater.apk:./system/app/MarketUpdater.apk \
        vendor/cyanogen/proprietary/MediaUploader.apk:./system/app/MediaUploader.apk \
        vendor/cyanogen/proprietary/NetworkLocation.apk:./system/app/NetworkLocation.apk \
        vendor/cyanogen/proprietary/OneTimeInitializer.apk:./system/app/OneTimeInitializer.apk \
        vendor/cyanogen/proprietary/PassionQuickOffice.apk:./system/app/PassionQuickOffice.apk \
        vendor/cyanogen/proprietary/SetupWizard.apk:./system/app/SetupWizard.apk \
        vendor/cyanogen/proprietary/Street.apk:./system/app/Street.apk \
        vendor/cyanogen/proprietary/Talk.apk:./system/app/Talk.apk \
        vendor/cyanogen/proprietary/Twitter.apk:./system/app/Twitter.apk \
        vendor/cyanogen/proprietary/Vending.apk:./system/app/Vending.apk \
        vendor/cyanogen/proprietary/VoiceSearch.apk:./system/app/VoiceSearch.apk \
        vendor/cyanogen/proprietary/YouTube.apk:./system/app/YouTube.apk \
        vendor/cyanogen/proprietary/googlevoice.apk:./system/app/googlevoice.apk \
        vendor/cyanogen/proprietary/kickback.apk:./system/app/kickback.apk \
        vendor/cyanogen/proprietary/soundback.apk:./system/app/soundback.apk \
        vendor/cyanogen/proprietary/talkback.apk:./system/app/talkback.apk \
        vendor/cyanogen/proprietary/com.google.android.maps.xml:./system/etc/permissions/com.google.android.maps.xml \
        vendor/cyanogen/proprietary/features.xml:./system/etc/permissions/features.xml \
        vendor/cyanogen/proprietary/com.google.android.maps.jar:./system/framework/com.google.android.maps.jar \
        vendor/cyanogen/proprietary/libinterstitial.so:./system/lib/libinterstitial.so \
        vendor/cyanogen/proprietary/libspeech.so:./system/lib/libspeech.so
else
    PRODUCT_PACKAGES += \
        Provision \
        GoogleSearch \
        LatinIME
endif
