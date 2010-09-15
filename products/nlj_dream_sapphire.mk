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
PRODUCT_BUILD_PROP_OVERRIDES += BUILD_ID=FRF91 BUILD_DISPLAY_ID=FRF91 BUILD_FINGERPRINT=google/passion/passion/mahimahi:2.2/FRF91/43546:user/release-keys PRIVATE_BUILD_DESC="passion-user 2.2 FRF91 43546 release-keys"

PRODUCT_SPECIFIC_DEFINES += TARGET_PRELINKER_MAP=$(TOP)/vendor/cyanogen/prelink-linux-arm-ds.map

# Build kernel
PRODUCT_SPECIFIC_DEFINES += TARGET_PREBUILT_KERNEL=
PRODUCT_SPECIFIC_DEFINES += TARGET_KERNEL_DIR=kernel-msm
PRODUCT_SPECIFIC_DEFINES += TARGET_KERNEL_CONFIG=nlj_msm_defconfig

# Extra DS overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/nlj/overlay/dream_sapphire

# Disable Compcache by default on D/S
PRODUCT_PROPERTY_OVERRIDES += \
    ro.compcache.default=0

PRODUCT_PROPERTY_OVERRIDES += \
    ro.modversion=CyanogenMod-6-$(shell date +%m%d%Y)-NLJ

# Use the audio profile hack
WITH_DS_HTCACOUSTIC_HACK := true

#
# Copy DS specific prebuilt files
#
PRODUCT_COPY_FILES +=  \
    vendor/cyanogen/prebuilt/mdpi/media/bootanimation.zip:system/media/bootanimation.zip \
    vendor/cyanogen/prebuilt/dream_sapphire/etc/AudioPara_dream.csv:system/etc/AudioPara_dream.csv \
    vendor/cyanogen/prebuilt/dream_sapphire/etc/AudioPara_sapphire.csv:system/etc/AudioPara_sapphire.csv \
    vendor/cyanogen/prebuilt/dream_sapphire/etc/init.d/02audio_profile:system/etc/init.d/02audio_profile \
    vendor/nlj/prebuilt/common/bin/ApkManager.sh:system/bin/ApkManager.sh \
    vendor/nlj/prebuilt/common/etc/init.d/05mountsd:system/etc/init.d/05mountsd \
    vendor/nlj/prebuilt/common/etc/init.d/06bindcache:system/etc/init.d/06bindcache \
    vendor/nlj/prebuilt/common/etc/init.d/08swap:system/etc/init.d/08swap \
    vendor/nlj/prebuilt/common/etc/init.d/10apps2sd:system/etc/init.d/10apps2sd

PRODUCT_LOCALES := en_US pl_PL

PRODUCT_PACKAGES += Gallery

PACKAGES.Gallery.OVERRIDES := Gallery3D

