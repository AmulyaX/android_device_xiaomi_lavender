#!/bin/bash
#
# Copyright (C) 2017-2019 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

# Required!
export DEVICE=jasmine_sprout
export DEVICE_COMMON=sdm660-common
export VENDOR=xiaomi

export DEVICE_BRINGUP_YEAR=2018

GOODIX="$LINEAGE_ROOT"/vendor/"$VENDOR"/"$DEVICE"/proprietary/vendor/lib64/libgf_ca.so
sed -i "s|/system/etc/firmware|/vendor/firmware\x0\x0\x0\x0|g" $GOODIX

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
