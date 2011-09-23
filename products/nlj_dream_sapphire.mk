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

# Extra DS overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/nlj/overlay/dream_sapphire

# Disable compcache, enable swap, enable data on sd-ext
PRODUCT_PROPERTY_OVERRIDES += \
    ro.compcache.default=0 \
    ro.swap.default=0 \
    ro.vold.sdextonboot=1 \
    ro.vold.data2sdext=1 \
    ro.modversion=NameLessFroyo-$(shell date +%Y%m%d)

# Use the audio profile hack
WITH_DS_HTCACOUSTIC_HACK := true

#
# Copy DS specific prebuilt files
#
PRODUCT_COPY_FILES +=  \
    vendor/nlj/prebuilt/dream_sapphire/etc/AudioPara_dream.csv:system/etc/AudioPara_dream.csv \
    vendor/nlj/prebuilt/dream_sapphire/etc/AudioPara_sapphire.csv:system/etc/AudioPara_sapphire.csv \
    vendor/nlj/prebuilt/dream_sapphire/etc/init.d/02audio_profile:system/etc/init.d/02audio_profile \
	vendor/nlj/prebuilt/common/etc/vold.fstab:system/etc/vold.fstab

ifdef PL_GPS_CONF
	PRODUCT_COPY_FILES += vendor/nlj/prebuilt/common/etc/gps.conf_pl:system/etc/gps.conf
endif
