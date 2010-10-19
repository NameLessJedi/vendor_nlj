# Inherit AOSP device configuration for dream_sapphire.
$(call inherit-product, device/htc/dream_sapphire/full_dream_sapphire.mk)

# Inherit some common cyanogenmod & nlj stuff
$(call inherit-product, vendor/nlj/products/common.mk)

# Include GSM-only stuff
$(call inherit-product, vendor/nlj/products/gsm.mk)

#
# Setup device specific product configuration.
#
PRODUCT_NAME := nlj_dream_sapphire
PRODUCT_BRAND := google
PRODUCT_DEVICE := dream_sapphire
PRODUCT_MODEL := Dream/Sapphire
PRODUCT_MANUFACTURER := HTC
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_ID=FRG83 BUILD_DISPLAY_ID=FRG83 BUILD_FINGERPRINT=tmobile/opal/sapphire/sapphire:2.2.1/FRG83/60505:user/release-keys PRIVATE_BUILD_DESC="opal-user 2.2.1 FRG83 60505 release-keys"

# http://github.com/CyanogenMod/android_vendor_cyanogen/commit/b05629c1413dbaee5519bf5729ccdc7cd75bf464
# "Prelink map is no longer required with new proprietaries for DS."
# PRODUCT_SPECIFIC_DEFINES += TARGET_PRELINKER_MAP=$(TOP)/vendor/nlj/prelink-linux-arm-ds.map

# Build kernel
ifdef PERSHOOT_KERNEL
    PRODUCT_SPECIFIC_DEFINES += TARGET_PREBUILT_KERNEL=
    PRODUCT_SPECIFIC_DEFINES += TARGET_KERNEL_DIR=kernel-pershoot
    PRODUCT_SPECIFIC_DEFINES += TARGET_KERNEL_CONFIG=$(TOP)/kernel-pershoot/config-froyo-xtra
else
    PRODUCT_SPECIFIC_DEFINES += TARGET_PREBUILT_KERNEL=
    PRODUCT_SPECIFIC_DEFINES += TARGET_KERNEL_DIR=kernel-msm
    PRODUCT_SPECIFIC_DEFINES += TARGET_KERNEL_CONFIG=$(TOP)/vendor/nlj/nlj_msm_defconfig
endif

# Extra DS overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/nlj/overlay/dream_sapphire

# Disable compcache, enable swap, setup modversion
PRODUCT_PROPERTY_OVERRIDES += \
    ro.compcache.default=0 \
    ro.swap.default=1 \
    ro.modversion=NLJ-$(shell date +%Y.%m.%d)

# Use the audio profile hack
WITH_DS_HTCACOUSTIC_HACK := true

#
# Copy DS specific prebuilt files
#
PRODUCT_COPY_FILES +=  \
    vendor/nlj/prebuilt/mdpi/media/bootanimation.zip:system/media/bootanimation.zip \
    vendor/nlj/prebuilt/dream_sapphire/etc/AudioPara_dream.csv:system/etc/AudioPara_dream.csv \
    vendor/nlj/prebuilt/dream_sapphire/etc/AudioPara_sapphire.csv:system/etc/AudioPara_sapphire.csv \
    vendor/nlj/prebuilt/dream_sapphire/etc/init.d/02audio_profile:system/etc/init.d/02audio_profile \
    vendor/nlj/prebuilt/common/bin/ApkManager.sh:system/bin/ApkManager.sh \
    vendor/nlj/prebuilt/common/etc/init.d/05mountsd:system/etc/init.d/05mountsd \
    vendor/nlj/prebuilt/common/etc/init.d/06bindcache:system/etc/init.d/06bindcache \
    vendor/nlj/prebuilt/common/etc/init.d/08swap:system/etc/init.d/08swap \
    vendor/nlj/prebuilt/common/etc/init.d/10apps2sd:system/etc/init.d/10apps2sd

PRODUCT_LOCALES := en_US pl_PL

PRODUCT_PACKAGES += Gallery

PACKAGES.Gallery.OVERRIDES := Gallery3D

