PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/nlj_dream_sapphire.mk

squish-ota: otapackage
	./vendor/nlj/tools/squisher

