PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/nlj_dream_sapphire.mk

squish-ota: otapackage
	echo "SquishIt :)"
	./vendor/nlj/tools/squisher

