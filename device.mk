#
 # Copyright 2018 The Android Open Source Project
 #
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 #      http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
 #

 # Inherit the fusion-common definitions
 $(call inherit-product, device/xiaomi/sdm660-common/platform.mk)

 # setup dalvik vm configs
 $(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)

 # setup HWUI configs
 $(call inherit-product, frameworks/native/build/phone-xxhdpi-3072-hwui-memory.mk)

 DEVICE_PATH := device/xiaomi/wayne

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml

# Init
 PRODUCT_PACKAGES += \
 	libinit_wayne

# IRSC
 PRODUCT_COPY_FILES += \
     $(DEVICE_PATH)/configs/sec_config:$(TARGET_COPY_OUT_VENDOR)/etc/sec_config
     
# Keylayout
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/keylayout/gpio-keys.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/gpio-keys.kl \
    $(DEVICE_PATH)/keylayout/uinput-fpc.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/uinput-fpc.kl
    
# Lights
 PRODUCT_PACKAGES += \
     android.hardware.light@2.0-service.xiaomi_clover

# Screen density
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Boot animation
TARGET_SCREEN_HEIGHT := 2160
TARGET_SCREEN_WIDTH := 1080

# Set those variables here to overwrite the inherited values.
 PRODUCT_NAME := aosp_wayne
 PRODUCT_DEVICE := wayne
 PRODUCT_MODEL := Mi 6X (AOSP)
 PRODUCT_BRAND := Xiaomi
 PRODUCT_MANUFACTURER := Xiaomi
