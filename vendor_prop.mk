PRODUCT_PROPERTY_OVERRIDES += \
	persist.sys.job_delay=true \
	persist.sys.mcd_config_file=/system/etc/mcd_default.conf \
	ro.control_privapp_permissions=log \
	drm.service.enabled=true \
	qemu.hw.mainkeys=0 \
	vendor.video.disable.ubwc=1 \
	dalvik.vm.heapgrowthlimit=256m \
	dalvik.vm.heapstartsize=8m \
	dalvik.vm.heapsize=512m \
	dalvik.vm.heaptargetutilization=0.75 \
	dalvik.vm.heapminfree=512k \
	dalvik.vm.heapmaxfree=8m \
	ro.hardware.nfc_nci=nqx.default \
	vendor.hw.fm.init=0 \
	persist.radio.multisim.config=dsds \
	persist.vendor.qcomsysd.enabled=1 \
	keyguard.no_require_sim=true \
	ro.com.android.dataroaming=false \
	ro.dalvik.vm.native.bridge=0 \
	ro.vendor.extension_library=libqti-perfd-client.so \
	persist.vendor.radio.apm_sim_not_pwdn=1 \
	persist.vendor.radio.sib16_support=1 \
	persist.vendor.radio.custom_ecc=1 \
	persist.vendor.radio.rat_on=combine \
	persist.vendor.radio.procedure_bytes=SKIP \
	persist.vendor.radio.flexmap_type=none \
	persist.backup.ntpServer=0.pool.ntp.org \
	sys.vendor.shutdown.waittime=500 \
	ro.build.shutdown_timeout=0 \
	ro.frp.pst=/dev/block/bootdevice/by-name/frp \
	ro.opengles.version=196610 \
	vendor.qcom.bluetooth.soc=cherokee \
	persist.bluetooth.bluetooth_audio_hal.disabled=false \
	ro.vendor.bluetooth.wipower=false \
	af.fast_track_multiplier=1 \
	vendor.audio_hal.period_size=192 \
	vendor.audio.snd_card.open.retries=50 \
	ro.vendor.audio.sdk.fluencetype=none \
	persist.vendor.audio.fluence.voicecall=true \
	persist.vendor.audio.fluence.voicerec=false \
	persist.vendor.audio.fluence.speaker=true \
	vendor.audio.tunnel.encode=false \
	persist.vendor.audio.ras.enabled=false \
	vendor.audio.offload.buffer.size.kb=64 \
	audio.offload.min.duration.secs=30 \
	audio.offload.video=true \
	vendor.audio.offload.track.enable=false \
	audio.deep_buffer.media=true \
	vendor.voice.path.for.pcm.voip=true \
	vendor.audio.offload.multiaac.enable=true \
	vendor.audio.dolby.ds2.enabled=false \
	vendor.audio.dolby.ds2.hardbypass=false \
	vendor.audio.offload.multiple.enabled=false \
	vendor.audio.offload.passthrough=false \
	ro.vendor.audio.sdk.ssr=false \
	vendor.audio.offload.gapless.enabled=true \
	vendor.audio.safx.pbe.enabled=false \
	vendor.audio.parser.ip.buffer.size=262144 \
	vendor.audio.flac.sw.decoder.24bit=true \
	persist.vendor.bt.a2dp_offload_cap=sbc-aptx-aptxhd-aac \
	vendor.audio.use.sw.alac.decoder=true \
	vendor.audio.use.sw.ape.decoder=true \
	vendor.audio.hw.aac.encoder=true \
	vendor.fm.a2dp.conc.disabled=true \
    audio.sys.noisy.broadcast.delay=600 \
	persist.vendor.audio.hifi.int_codec=true \
    audio.sys.offload.pstimeout.secs=3 \
	ro.af.client_heap_size_kbyte=7168 \
	persist.vendor.audio.hw.binder.size_kbyte=1024 \
	ro.vendor.audio.sos=true \
	ro.vendor.audio.soundtrigger=none \
	ro.vendor.audio.soundtrigger.lowpower=false \
	ro.vendor.sensors.facing=false \
	ro.vendor.sensors.cmc=false \
	ro.vendor.sdk.sensors.gestures=false \
	rild.libpath=/system/vendor/lib64/libril-qc-hal-qmi.so \
	ro.vendor.audio.voice.volume.boost=manual

# Properties IMS
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
	persist.dbg.ims_volte_enable=1 \
	persist.dbg.volte_avail_ovr=1 \
	persist.dbg.vt_avail_ovr=1 \
	persist.dbg.wfc_avail_ovr=1 \
	persist.vendor.radio.rat_on=combine \
	persist.vendor.radio.data_ltd_sys_ind=1 \
	persist.vendor.radio.data_con_rprt=1 \
	persist.radio.calls.on.ims=1
	
# SurfaceFlinger
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.protected_contents=true \
    ro.surface_flinger.force_hwc_copy_for_virtual_displays=true \
    ro.surface_flinger.max_virtual_display_dimension=4096 \
    ro.surface_flinger.vsync_event_phase_offset_ns=2000000 \
    ro.surface_flinger.vsync_sf_event_phase_offset_ns=6000000
	
# Codec2 switch
PRODUCT_PROPERTY_OVERRIDES += \
    debug.media.codec2=2

# Enable headset calibration
PRODUCT_PROPERTY_OVERRIDES += \
	vendor.audio.volume.headset.gain.depcal=true

# Add dynamic feature flags here
PRODUCT_PROPERTY_OVERRIDES += \
	vendor.audio.feature.afe_proxy.enable=true \
	vendor.audio.feature.anc_headset.enable=true \
	vendor.audio.feature.battery_listener.enable=false \
	vendor.audio.feature.compr_cap.enable=false \
	vendor.audio.feature.compress_in.enable=false \
	vendor.audio.feature.compress_meta_data.enable=true \
	vendor.audio.feature.compr_voip.enable=true \
	vendor.audio.feature.concurrent_capture.enable=false \
	vendor.audio.feature.custom_stereo.enable=true \
	vendor.audio.feature.display_port.enable=true \
	vendor.audio.feature.dsm_feedback.enable=false \
	vendor.audio.feature.dynamic_ecns.enable=false \
	vendor.audio.feature.ext_hw_plugin.enable=false \
	vendor.audio.feature.external_dsp.enable=false \
	vendor.audio.feature.external_speaker.enable=false \
	vendor.audio.feature.external_speaker_tfa.enable=false \
	vendor.audio.feature.fluence.enable=false \
	vendor.audio.feature.fm.enable=true \
	vendor.audio.feature.hdmi_edid.enable=true \
	vendor.audio.feature.hdmi_passthrough.enable=true \
	vendor.audio.feature.hfp.enable=true \
	vendor.audio.feature.hifi_audio.enable=true \
	vendor.audio.feature.hwdep_cal.enable=false \
	vendor.audio.feature.incall_music.enable=false \
	vendor.audio.feature.multi_voice_session.enable=true \
	vendor.audio.feature.keep_alive.enable=false \
	vendor.audio.feature.kpi_optimize.enable=true \
	vendor.audio.feature.maxx_audio.enable=false \
	vendor.audio.feature.ras.enable=true \
	vendor.audio.feature.record_play_concurency.enable=false \
	vendor.audio.feature.src_trkn.enable=true \
	vendor.audio.feature.spkr_prot.enable=true \
	vendor.audio.feature.ssrec.enable=true \
	vendor.audio.feature.usb_offload.enable=true \
	vendor.audio.feature.usb_offload_burst_mode.enable=false \
	vendor.audio.feature.usb_offload_sidetone_volume.enable=false \
	vendor.audio.feature.deepbuffer_as_primary.enable=false \
	vendor.audio.feature.vbat.enable=true \
	vendor.audio.feature.wsa.enable=false \
	vendor.audio.feature.audiozoom.enable=false \
	vendor.audio.feature.snd_mon.enable=true

# Enable dualmic fluence for voice communication
PRODUCT_PROPERTY_OVERRIDES += \
	persist.audio.fluence.voicecomm=true

# Enable AAC frame ctl for A2DP sinks
PRODUCT_PROPERTY_OVERRIDES += \
	persist.vendor.bt.aac_frm_ctl.enabled=true

# Set speaker protection cal tx path sampling rate to 48k
PRODUCT_PROPERTY_OVERRIDES += \
	vendor.audio.spkr_prot.tx.sampling_rate=48000

# Enable FIFO scheduling for UI and Render threads by default
PRODUCT_PROPERTY_OVERRIDES += \
    sys.use_fifo_ui=1

# Rendering
PRODUCT_PROPERTY_OVERRIDES += \
    debug.enable.sglscale=1 \
    debug.egl.hw=1 \
    debug.sf.disable_hwc=0 \
    debug.sf.recomputecrop=0 \
    persist.hwc.ptor.enable=true \
    debug.sf.gpu_comp_tiling=1

# Fling
PRODUCT_PROPERTY_OVERRIDES += \
    ro.min.fling_velocity=160 \
    ro.max.fling_velocity=20000
