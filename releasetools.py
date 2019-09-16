# Copyright (C) 2009 The Android Open Source Project
# Copyright (c) 2011-2013, The Linux Foundation. All rights reserved.
# Copyright (C) 2019 The LineageOS Project
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

import hashlib
import common
import re

bootImages = {}
binImages = {}
fwImages = {}

# Parse filesmap file containing firmware residing places
def LoadFilesMap(zip, name="RADIO/filesmap"):
  try:
    data = zip.read(name)
  except KeyError:
    print "Warning: could not find %s in %s." % (name, zip)
    data = ""
  d = {}
  for line in data.split("\n"):
    line = line.strip()
    if not line or line.startswith("#"):
      continue
    pieces = line.split()
    if not (len(pieces) == 2):
      raise ValueError("malformed filesmap line: \"%s\"" % (line,))
    d[pieces[0]] = pieces[1]
  return d

# Read firmware images from target files zip
def GetRadioFiles(z):
  out = {}
  for info in z.infolist():
    f = info.filename
    if f.startswith("RADIO/") and (f.__len__() > len("RADIO/")):
      fn = f[6:]
      if fn.startswith("filesmap"):
        continue
      data = z.read(f)
      out[fn] = common.File(f, data)

  return out

# Get firmware residing place from filesmap
def GetFileDestination(fn, filesmap):
  # get backup destination as well if present
  backup = None
  if fn + ".bak" in filesmap:
    backup = filesmap[fn + ".bak"]

  # If full filename is not specified in filesmap get only the name part
  # and look for this token
  if fn not in filesmap:
    fn = fn.split(".")[0] + ".*"
    if fn not in filesmap:
      print "warning radio-update: '%s' not found in filesmap" % (fn)
      return None, backup
  return filesmap[fn], backup

# Separate image types as each type needs different handling
def SplitFwTypes(files):
  boot = {}
  bin = {}
  fw = {}

  for f in files:
    extIdx = -1
    dotSeparated = f.split(".")

    if dotSeparated[extIdx] == 'mbn' or dotSeparated[extIdx] == 'elf' or  dotSeparated[extIdx] == 'img':
      boot[f] = files[f]
    elif dotSeparated[extIdx] == 'bin':
      bin[f] = files[f]
    else:
      fw[f] = files[f]
  return boot, bin, fw

# Prepare radio-update files and verify them
def OTA_VerifyEnd(info, api_version, target_zip, source_zip=None):
  if api_version < 3:
    print "warning radio-update: no support for api_version less than 3"
    return False

  print "Loading radio filesmap..."
  filesmap = LoadFilesMap(target_zip)
  if filesmap == {}:
    print "warning radio-update: no or invalid filesmap file found"
    return False

  print "Loading radio target..."
  tgt_files = GetRadioFiles(target_zip)
  if tgt_files == {}:
    print "warning radio-update: no radio images in input target_files"
    return False

  src_files = None
  if source_zip is not None:
    print "Loading radio source..."
    src_files = GetRadioFiles(source_zip)

  update_list = {}
  largest_source_size = 0

  print "Preparing radio-update files..."
  for fn in tgt_files:
    dest, destBak = GetFileDestination(fn, filesmap)
    if dest is None:
      continue

    tf = tgt_files[fn]
    sf = None
    if src_files is not None:
      sf = src_files.get(fn, None)

    full = sf is None or fn.endswith('.enc')
    if not full:
      # no difference - skip this file
      if tf.sha1 == sf.sha1:
        continue
      d = common.Difference(tf, sf)
      _, _, d = d.ComputePatch()
      # no difference - skip this file
      if d is None:
        continue
      # if patch is almost as big as the file - don't bother patching
      full = len(d) > tf.size * common.OPTIONS.patch_threshold
      if not full:
        f = "patch/firmware-update/" + fn + ".p"
        common.ZipWriteStr(info.output_zip, f, d)
        update_list[f] = (dest, destBak, tf, sf)
        largest_source_size = max(largest_source_size, sf.size)
    if full:
      f = "firmware-update/" + fn
      common.ZipWriteStr(info.output_zip, f, tf.data)
      update_list[f] = (dest, destBak, None, None)

  global bootImages
  global binImages
  global fwImages
  bootImages, binImages, fwImages = SplitFwTypes(update_list)

  # If there are incremental patches verify them
  if largest_source_size != 0:
    info.script.Comment("---- radio update verification ----")
    info.script.Print("Verifying radio-update...")

    for f in bootImages:
      dest, destBak, tf, sf = bootImages[f]
      # Not incremental
      if sf is None:
        continue
      info.script.PatchCheck("EMMC:%s:%d:%s:%d:%s" %
              (dest, sf.size, sf.sha1, tf.size, tf.sha1))
      if destBak is not None:
        info.script.PatchCheck("EMMC:%s:%d:%s:%d:%s" %
                (destBak, sf.size, sf.sha1, tf.size, tf.sha1))
    for f in binImages:
      dest, destBak, tf, sf = binImages[f]
      # Not incremental
      if sf is None:
        continue
      info.script.PatchCheck("EMMC:%s:%d:%s:%d:%s" %
              (dest, sf.size, sf.sha1, tf.size, tf.sha1))

    last_mounted = ""
    for f in fwImages:
      dest, destBak, tf, sf = fwImages[f]
      # Not incremental
      if sf is None:
        continue
      # Get the filename without the path and the patch (.p) extention
      f = f.split("/")[-1][:-2]
      # Parse filesmap destination paths for "/dev/" pattern in the beginng.
      # This would mean that the file must be written to block device -
      # fs mount needed
      if dest.startswith("/dev/"):
        if last_mounted != dest:
          info.script.AppendExtra('unmount("/firmware");')
          info.script.AppendExtra('mount("vfat", "EMMC", "%s", "/firmware");' %
                                    (dest))
          last_mounted = dest
        dest = "/firmware/image/" + f
      else:
        dest = dest + "/" + f
      info.script.PatchCheck(dest, tf.sha1, sf.sha1)

    info.script.CacheFreeSpaceCheck(largest_source_size)
  return True

# This function handles only non-HLOS whole partition images
def InstallRawImage(script, f, dest, tf, sf):
  script.AppendExtra('package_extract_file("%s", "%s");' % (f, dest))
  return

# This function handles only non-HLOS boot images - files list must contain
# only such images (aboot, tz, etc)
def InstallBootImages(script, files):
  for f in files:
    dest, _, tf, sf = files[f]
    InstallRawImage(script, f, dest, tf, sf)
  return

# This function handles only non-HLOS bin images
def InstallBinImages(script, files):
  for f in files:
    dest, _, tf, sf = files[f]
    InstallRawImage(script, f, dest, tf, sf)
  return

def FullOTA_InstallEnd(info):
  OTA_InstallEnd(info)
  return

def IncrementalOTA_InstallEnd(info):
  OTA_InstallEnd(info)
  return

def FullOTA_Assertions(info):
  AddTrustZoneAssertion(info, info.input_zip)
  return

def IncrementalOTA_Assertions(info):
  AddTrustZoneAssertion(info, info.target_zip)
  return

def IncrementalOTA_VerifyEnd(info):
 OTA_VerifyEnd(info, info.target_version, info.target_zip, info.source_zip)
 return

def AddImage(info, basename, dest):
  path = "IMAGES/" + basename
  if path not in info.input_zip.namelist():
    return

  data = info.input_zip.read(path)
  common.ZipWriteStr(info.output_zip, basename, data)
  info.script.AppendExtra('package_extract_file("%s", "%s");' % (basename, dest))

def OTA_InstallEnd(info):
  info.script.Print("Patching device-tree and verity images...")
  AddImage(info, "dtbo.img", "/dev/block/bootdevice/by-name/dtbo")
  AddImage(info, "vbmeta.img", "/dev/block/bootdevice/by-name/vbmeta")

  if OTA_VerifyEnd(info, info.input_version, info.input_zip):
    print "Applying radio-update script modifications..."
    info.script.Comment("---- radio update tasks ----")
    info.script.Print("Patching firmware images...")

    if bootImages != {}:
      InstallBootImages(info.script, bootImages)
    if binImages != {}:
      InstallBinImages(info.script, binImages)
    if fwImages != {}:
      InstallFwImages(info.script, fwImages)

  return

def AddTrustZoneAssertion(info, input_zip):
  android_info = info.input_zip.read("OTA/android-info.txt")
  m = re.search(r'require\s+version-trustzone\s*=\s*(\S+)', android_info)
  if m:
    versions = m.group(1).split('|')
    if len(versions) and '*' not in versions:
      cmd = 'assert(lavender.verify_trustzone(' + ','.join(['"%s"' % tz for tz in versions]) + ') == "1");'
      info.script.AppendExtra(cmd)
  return