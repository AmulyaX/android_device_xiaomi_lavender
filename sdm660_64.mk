TARGET_USES_AOSP := true

DEVICE_PACKAGE_OVERLAYS := device/qcom/sdm660_64/overlay

# Default vendor configuration.
ifeq ($(ENABLE_VENDOR_IMAGE),)
ENABLE_VENDOR_IMAGE := true
endif

# Default A/B configuration.
ENABLE_AB ?= true

# Disable QTIC until it's brought up in split system/vendor
# configuration to avoid compilation breakage.
ifeq ($(ENABLE_VENDOR_IMAGE), true)
#TARGET_USES_QTIC := false
endif

TARGET_USES_AOSP_FOR_AUDIO := false
TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
TARGET_DISABLE_DASH := true

TARGET_KERNEL_VERSION := 4.4
BOARD_FRP_PARTITION_NAME := frp
TARGET_USES_NQ_NFC := true

# enable the SVA in UI area
TARGET_USE_UI_SVA := true

TARGET_USES_MKE2FS := true
#QTIC flag
-include $(QCPATH)/common/config/qtic-config.mk

# Add soft home, back and multitask keys
PRODUCT_PROPERTY_OVERRIDES += \
    qemu.hw.mainkeys=0

# Video codec configuration files
ifeq ($(TARGET_ENABLE_QC_AV_ENHANCEMENTS), true)
PRODUCT_COPY_FILES += \
    device/qcom/sdm660_64/media_profiles.xml:system/etc/media_profiles.xml \
    device/qcom/sdm660_64/media_profiles_sdm660_v1.xml:system/etc/media_profiles_sdm660_v1.xml \
    device/qcom/sdm660_64/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml \
    device/qcom/sdm660_64/media_profiles_sdm660_v1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_sdm660_v1.xml \
    device/qcom/sdm660_64/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    device/qcom/sdm660_64/media_codecs_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor.xml \
    device/qcom/sdm660_64/media_codecs_sdm660_v1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_sdm660_v1.xml \
    device/qcom/sdm660_64/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    device/qcom/sdm660_64/media_codecs_performance_sdm660_v1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance_sdm660_v1.xml \
    device/qcom/sdm660_64/media_codecs_vendor_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_vendor_audio.xml
endif #TARGET_ENABLE_QC_AV_ENHANCEMENTS

# video seccomp policy files
PRODUCT_COPY_FILES += \
    device/qcom/sdm660_64/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/sdm660_64/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy


PRODUCT_PROPERTY_OVERRIDES += \
    vendor.video.disable.ubwc=1

ifneq ($(TARGET_DISABLE_DASH), true)
    PRODUCT_BOOT_JARS += qcmediaplayer
endif

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-service \
    android.hardware.power@1.0-impl

# Override heap growth limit due to high display density on device
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=256m
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)
$(call inherit-product, device/qcom/common/common64.mk)

PRODUCT_NAME := sdm660_64
PRODUCT_DEVICE := sdm660_64
PRODUCT_BRAND := qti
PRODUCT_MODEL := sdm660 for arm64

# default is nosdcard, S/W button enabled in resource
PRODUCT_CHARACTERISTICS := nosdcard

# When can normal compile this module,  need module owner enable below commands
# font rendering engine feature switch
#-include $(QCPATH)/common/config/rendering-engine.mk
#ifneq (,$(strip $(wildcard $(PRODUCT_RENDERING_ENGINE_REVLIB))))
#    MULTI_LANG_ENGINE := REVERIE
#    MULTI_LANG_ZAWGYI := REVERIE
#endif

# Enable features in video HAL that can compile only on this platform
TARGET_USES_MEDIA_EXTENSIONS := true

# WLAN chipset
WLAN_CHIPSET := qca_cld3

#
# system prop for opengles version
#
# 196610 is decimal for 0x30002 to report major/minor versions as 3/2
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196610

#Android EGL implementation
PRODUCT_PACKAGES += libGLES_android
PRODUCT_BOOT_JARS += tcmiface
PRODUCT_BOOT_JARS += telephony-ext

PRODUCT_PACKAGES += telephony-ext

ifneq ($(strip $(QCPATH)),)
PRODUCT_BOOT_JARS += WfdCommon
endif

# system prop for Bluetooth SOC type
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.qcom.bluetooth.soc=cherokee

DEVICE_MANIFEST_FILE := device/qcom/sdm660_64/manifest.xml
DEVICE_MATRIX_FILE   := device/qcom/common/compatibility_matrix.xml
DEVICE_FRAMEWORK_MANIFEST_FILE := device/qcom/sdm660_64/framework_manifest.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := device/qcom/common/vendor_framework_compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    device/qcom/sdm660_64/vendor_framework_compatibility_matrix.xml

# Audio configuration file
-include $(TOPDIR)hardware/qcom/audio/configs/sdm660/sdm660.mk

PRODUCT_PACKAGES += android.hardware.media.omx@1.0-impl

# Sensor HAL conf file
PRODUCT_COPY_FILES += \
    device/qcom/sdm660_64/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf
# Exclude TOF sensor from InputManager
PRODUCT_COPY_FILES += \
    device/qcom/sdm660_64/excluded-input-devices.xml:system/etc/excluded-input-devices.xml

# WLAN host driver
ifneq ($(WLAN_CHIPSET),)
PRODUCT_PACKAGES += $(WLAN_CHIPSET)_wlan.ko
endif

# WLAN driver configuration file
PRODUCT_COPY_FILES += \
    device/qcom/sdm660_64/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini

PRODUCT_PACKAGES += \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf

#ANT+ stack
PRODUCT_PACKAGES += \
    AntHalService \
    libantradio \
    antradio_app \
    libvolumelistener

#Display/Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.configstore@1.0-service \
    android.hardware.broadcastradio@1.0-impl

PRODUCT_PACKAGES += \
    vendor.display.color@1.0-service \
    vendor.display.color@1.0-impl

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service \

# Camera configuration file. Shared by passthrough/binderized camera HAL
PRODUCT_PACKAGES += camera.device@3.2-impl
PRODUCT_PACKAGES += camera.device@1.0-impl
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-impl
# Enable binderized camera HAL
PRODUCT_PACKAGES += android.hardware.camera.provider@2.4-service

PRODUCT_PACKAGES += \
	android.hardware.usb@1.0-service

# Sensor features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml

#Facing, CMC and Gesture
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.sensors.facing=false \
    ro.vendor.sensors.cmc=false \
    ro.vendor.sdk.sensors.gestures=false

# FBE support
PRODUCT_COPY_FILES += \
    device/qcom/sdm660_64/init.qti.qseecomd.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.qti.qseecomd.sh
# VB xml
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:system/etc/permissions/android.software.verified_boot.xml

# MIDI feature
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.software.midi.xml:system/etc/permissions/android.software.midi.xml

# MSM IRQ Balancer configuration file for SDM660
PRODUCT_COPY_FILES += device/qcom/sdm660_64/msm_irqbalance.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance.conf

# MSM IRQ Balancer configuration file for SDM630
PRODUCT_COPY_FILES += device/qcom/sdm660_64/msm_irqbalance_sdm630.conf:$(TARGET_COPY_OUT_VENDOR)/etc/msm_irqbalance_sdm630.conf

# dm-verity configuration
PRODUCT_SUPPORTS_VERITY := true
PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/bootdevice/by-name/system
ifeq ($(ENABLE_VENDOR_IMAGE), true)
PRODUCT_VENDOR_VERITY_PARTITION := /dev/block/bootdevice/by-name/vendor
endif

PRODUCT_FULL_TREBLE_OVERRIDE := true

PRODUCT_VENDOR_MOVE_ENABLED := true

#for android_filesystem_config.h
PRODUCT_PACKAGES += \
    fs_config_files

# Add the overlay path
#PRODUCT_PACKAGE_OVERLAYS := $(QCPATH)/qrdplus/Extension/res \
#       $(QCPATH)/qrdplus/globalization/multi-language/res-overlay \
#      $(PRODUCT_PACKAGE_OVERLAYS)

#for wlan
PRODUCT_PACKAGES += \
        wificond \
        wifilogd

ifeq ($(ENABLE_AB), true)
#A/B related packages
PRODUCT_PACKAGES += update_engine \
                    update_engine_client \
                    update_verifier \
                    bootctrl.sdm660 \
                    brillo_update_payload \
                    android.hardware.boot@1.0-impl \
                    android.hardware.boot@1.0-service

#Boot control HAL test app
PRODUCT_PACKAGES_DEBUG += bootctl
endif

#Healthd packages
PRODUCT_PACKAGES += android.hardware.health@2.0-impl \
                    android.hardware.health@2.0-service \
                    libhealthd.msm

#FEATURE_OPENGLES_EXTENSION_PACK support string config file
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml

TARGET_SUPPORT_SOTER := true

#Enable QTI KEYMASTER and GATEKEEPER HIDLs
ifeq ($(ENABLE_VENDOR_IMAGE), true)
KMGK_USE_QTI_SERVICE := true
endif

#Enable KEYMASTER 4.0
ENABLE_KM_4_0 := true

#Enable AOSP KEYMASTER and GATEKEEPER HIDLs
ifneq ($(KMGK_USE_QTI_SERVICE), true)
PRODUCT_PACKAGES += android.hardware.gatekeeper@1.0-impl \
                    android.hardware.gatekeeper@1.0-service \
                    android.hardware.keymaster@3.0-impl \
                    android.hardware.keymaster@3.0-service
endif

PRODUCT_PROPERTY_OVERRIDES += rild.libpath=/system/vendor/lib64/libril-qc-qmi-1.so

# Kernel modules install path
# Change to dlkm when dlkm feature is fully enabled
KERNEL_MODULES_INSTALL := dlkm
KERNEL_MODULES_OUT := out/target/product/$(PRODUCT_NAME)/$(KERNEL_MODULES_INSTALL)/lib/modules

PRODUCT_PACKAGES += android.hardware.thermal@1.0-impl \
                    android.hardware.thermal@1.0-service

SDM660_DISABLE_MODULE := true

#Property for setting the max timeout of autosuspend
PRODUCT_PROPERTY_OVERRIDES += sys.autosuspend.timeout=500000

PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE:=true

# Enable vndk-sp Libraries
PRODUCT_PACKAGES += vndk_package

TARGET_MOUNT_POINTS_SYMLINKS := false

$(call inherit-product, build/make/target/product/product_launched_with_p.mk)

# Enable STA + SAP Concurrency.
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
