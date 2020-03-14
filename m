Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1939C1859A0
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgCODRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:17:52 -0400
Received: from mail-pg1-f199.google.com ([209.85.215.199]:36985 "EHLO
        mail-pg1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbgCODRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:17:52 -0400
Received: by mail-pg1-f199.google.com with SMTP id q29so9272553pgk.4
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 20:17:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=MkGh048u7lTTgWiIkdmzifoUQZi+CzVvNN+xZ+507Jo=;
        b=r7H0dNchsXa30T5QbP59AKZ23Ltg3x9r/ScqMVgZuM6JGhRPn0S8n6NdFdtm954rJd
         /EVwamw84b5om0Z1N28wBjy9caToJLKyG70OVkjBELYaCgxEL5FxTsTXOJCfJCW3KUWr
         m0q1evzzuYb45EgbDLW+qn/vQEQlxRET8581G/FSet9DD6SBrUwBUYEu6O2GhVnT3JT0
         PSIER8jolglxah6kOZcM1RSMTMgTFwzb4ZMyJaM9g478f9QI0jADE3J7rV+5zWo8/M3t
         YjRD8UneFyT6HYo3BRHB3+o4fWLepI1KlZFjpDbBGvqfdOLjE+lc2fVOmM+rWqL6yys5
         /0tA==
X-Gm-Message-State: ANhLgQ3QO4b7idTClyHxjKJCulSsm8qXZFNySL4o/qMDT2USqVyb1dAd
        xSj7OX1Y9wYDAvSNSvupU3f1pqiX/6GckUsKaazt3Wi07gZt
X-Google-Smtp-Source: ADFU+vvbs9MzQdw3HSKpAFPoI3LYWJRFKad0hgGW2B0nThGTLQjZKSVx133U0cJNIcisEwuITYRy2Y1SrFT61CsT0jnfQe+XZm2u
MIME-Version: 1.0
X-Received: by 2002:a92:3c1c:: with SMTP id j28mr16838980ila.304.1584158882833;
 Fri, 13 Mar 2020 21:08:02 -0700 (PDT)
Date:   Fri, 13 Mar 2020 21:08:02 -0700
In-Reply-To: <CADG63jBWgdO1KpffWqEd3K5iXfK8LcEmv49Fz6Xy_JiS6J9CpA@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007aaa9a05a0c8bba1@google.com>
Subject: Re: WARNING: refcount bug in sctp_wfree
From:   syzbot <syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com>
To:     anenbupt@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot tried to test the proposed patch but build/boot failed:

/platform/chrome/cros_kbd_led_backlight.o
  CC      drivers/media/rc/keymaps/rc-msi-digivox-iii.o
  CC      drivers/hid/hid-a4tech.o
  CC      drivers/md/dm-mpath.o
  CC      drivers/md/dm-round-robin.o
  CC      drivers/infiniband/sw/rxe/rxe_qp.o
  CC      drivers/staging/exfat/exfat_nls.o
  CC      drivers/md/dm-queue-length.o
  CC      drivers/infiniband/hw/mlx4/alias_GUID.o
  CC      drivers/gpu/drm/i915/display/dvo_ch7017.o
  CC      drivers/gpu/drm/i915/display/dvo_ch7xxx.o
  CC      drivers/staging/exfat/exfat_upcase.o
  CC      drivers/gpu/drm/i915/display/dvo_ivch.o
  CC      net/netfilter/xt_multiport.o
  AR      drivers/mailbox/built-in.a
  CC      drivers/hid/hid-axff.o
  CC      drivers/infiniband/hw/mlx4/sysfs.o
  CC      drivers/hid/hid-apple.o
  CC      drivers/infiniband/sw/rxe/rxe_cq.o
  CC      drivers/infiniband/sw/siw/siw_verbs.o
  CC      drivers/soundwire/mipi_disco.o
  CC      drivers/infiniband/hw/usnic/usnic_ib_sysfs.o
  CC      drivers/md/dm-service-time.o
  CC      drivers/media/rc/keymaps/rc-msi-tvanywhere.o
  CC      drivers/hid/hid-belkin.o
  CC      drivers/infiniband/sw/rxe/rxe_mr.o
  AR      drivers/infiniband/ulp/opa_vnic/built-in.a
  AR      drivers/infiniband/ulp/built-in.a
  CC      drivers/platform/chrome/cros_ec_chardev.o
  CC      drivers/ras/ras.o
  AR      drivers/extcon/built-in.a
  AR      drivers/isdn/mISDN/built-in.a
  CC      drivers/crypto/qat/qat_common/qat_uclo.o
  AR      drivers/isdn/built-in.a
  CC      drivers/infiniband/core/fmr_pool.o
  CC      drivers/platform/chrome/cros_ec_lightbar.o
  CC      drivers/ras/debugfs.o
  CC      net/netfilter/xt_nfacct.o
  CC      drivers/crypto/qat/qat_common/qat_hal.o
  CC      drivers/infiniband/sw/rxe/rxe_opcode.o
  CC      drivers/soundwire/stream.o
  CC      drivers/crypto/qat/qat_common/adf_transport_debug.o
  CC      drivers/hid/hid-cherry.o
  CC      drivers/gpu/drm/i915/display/dvo_ns2501.o
  CC      drivers/soundwire/debugfs.o
  CC      net/netfilter/xt_osf.o
  CC      drivers/infiniband/hw/usnic/usnic_ib_verbs.o
  CC      drivers/infiniband/core/cache.o
  CC      drivers/thunderbolt/nhi.o
  CC      drivers/infiniband/hw/usnic/usnic_debugfs.o
  CC      drivers/hid/hid-chicony.o
  CC      drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.o
  CC      drivers/media/rc/keymaps/rc-nebula.o
  AR      drivers/hwtracing/intel_th/built-in.a
  CC      drivers/thunderbolt/nhi_ops.o
  CC      drivers/hid/hid-cypress.o
  CC      drivers/hid/hid-dr.o
  CC      drivers/infiniband/core/netlink.o
  CC      drivers/platform/chrome/cros_ec_debugfs.o
  CC      drivers/crypto/qat/qat_common/adf_sriov.o
  CC      drivers/platform/chrome/cros_ec_sysfs.o
  CC      drivers/infiniband/sw/rxe/rxe_mmap.o
  CC      drivers/android/binder.o
  CC      drivers/android/binder_alloc.o
  CC      drivers/hid/hid-emsff.o
  CC      drivers/infiniband/sw/rxe/rxe_icrc.o
  CC      drivers/hid/hid-elecom.o
  CC      drivers/hid/hid-ezkey.o
  CC      drivers/hid/hid-google-hammer.o
  CC      drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.o
  CC      drivers/md/dm-snap.o
  CC      net/netfilter/xt_owner.o
  CC      drivers/infiniband/core/roce_gid_mgmt.o
  CC      drivers/infiniband/core/mr_pool.o
  CC      drivers/hid/hid-gyration.o
  CC      drivers/hid/hid-holtek-kbd.o
  CC      drivers/hid/hid-holtek-mouse.o
  CC      net/netfilter/xt_cgroup.o
  CC      drivers/nvmem/core.o
  CC      drivers/gpu/drm/i915/display/dvo_sil164.o
  CC      drivers/gpu/drm/i915/display/dvo_tfp410.o
  CC      drivers/crypto/qat/qat_common/adf_pf2vf_msg.o
  CC      drivers/nvmem/nvmem-sysfs.o
  CC      drivers/counter/counter.o
  CC      drivers/crypto/qat/qat_common/adf_vf2pf_msg.o
  CC      drivers/thunderbolt/ctl.o
  CC      drivers/infiniband/sw/rxe/rxe_mcast.o
  CC      drivers/gpu/drm/i915/display/icl_dsi.o
  CC      drivers/thunderbolt/tb.o
  CC      drivers/gpu/drm/i915/display/intel_crt.o
  CC      drivers/md/dm-exception-store.o
  CC      drivers/thunderbolt/switch.o
  CC      drivers/media/rc/keymaps/rc-norwood.o
  CC      drivers/infiniband/sw/rxe/rxe_task.o
  CC      drivers/infiniband/sw/rxe/rxe_net.o
  CC      drivers/infiniband/sw/rxe/rxe_sysfs.o
  CC      net/netfilter/xt_physdev.o
  AR      drivers/platform/chrome/built-in.a
  CC      drivers/crypto/qat/qat_common/adf_vf_isr.o
  CC      drivers/media/rc/keymaps/rc-npgtech.o
  AR      drivers/platform/built-in.a
  CC      drivers/media/rc/keymaps/rc-odroid.o
  CC      drivers/infiniband/core/sa_query.o
  CC      drivers/infiniband/core/addr.o
  CC      drivers/media/rc/keymaps/rc-pctv-sedna.o
  CC      drivers/infiniband/sw/rxe/rxe_hw_counters.o
  CC      drivers/media/rc/keymaps/rc-pinnacle-color.o
  CC      net/netfilter/xt_pkttype.o
  CC      net/netfilter/xt_policy.o
  CC      drivers/media/rc/keymaps/rc-pinnacle-grey.o
  CC      net/netfilter/xt_quota.o
  CC      drivers/hid/hid-holtekff.o
  CC      drivers/hid/hid-ite.o
  CC      drivers/thunderbolt/cap.o
  CC      net/netfilter/xt_rateest.o
  CC      drivers/thunderbolt/path.o
  CC      drivers/thunderbolt/tunnel.o
  CC      drivers/gpu/drm/i915/display/intel_ddi.o
  CC      net/netfilter/xt_realm.o
  AR      drivers/vhost/built-in.a
  CC      drivers/thunderbolt/eeprom.o
  AR      drivers/ras/built-in.a
  CC      drivers/gpu/drm/i915/display/intel_dp.o
  CC      drivers/gpu/drm/i915/display/intel_dp_aux_backlight.o
  CC      drivers/thunderbolt/domain.o
  CC      drivers/thunderbolt/dma_port.o
  CC      drivers/gpu/drm/i915/display/intel_dp_link_training.o
  CC      drivers/thunderbolt/icm.o
  CC      drivers/hid/hid-kensington.o
  CC      drivers/hid/hid-keytouch.o
  AR      drivers/soundwire/built-in.a
  CC      drivers/infiniband/core/multicast.o
  AR      drivers/staging/exfat/built-in.a
  AR      drivers/staging/built-in.a
  CC      drivers/gpu/drm/i915/display/intel_dp_mst.o
  CC      drivers/md/dm-snap-transient.o
  CC      drivers/hid/hid-kye.o
  CC      drivers/md/dm-snap-persistent.o
  AR      drivers/infiniband/hw/usnic/built-in.a
  CC      drivers/md/dm-raid1.o
  CC      drivers/md/dm-log.o
  AR      drivers/infiniband/sw/siw/built-in.a
  CC      drivers/md/dm-region-hash.o
  CC      drivers/thunderbolt/property.o
  CC      drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.o
  CC      drivers/thunderbolt/xdomain.o
  CC      drivers/hid/hid-lcpower.o
  CC      drivers/gpu/drm/i915/display/intel_dsi.o
  CC      drivers/media/rc/keymaps/rc-pixelview.o
  CC      drivers/hid/hid-lg.o
  CC      drivers/media/rc/keymaps/rc-pixelview-mk12.o
  CC      drivers/media/rc/keymaps/rc-pixelview-002t.o
  CC      drivers/hid/hid-lgff.o
  CC      drivers/thunderbolt/lc.o
  CC      drivers/infiniband/core/mad.o
  CC      net/netfilter/xt_recent.o
  CC      drivers/infiniband/core/smi.o
  CC      drivers/md/dm-zero.o
  CC      drivers/media/rc/keymaps/rc-pixelview-new.o
  CC      net/netfilter/xt_sctp.o
  CC      drivers/infiniband/core/agent.o
  CC      net/netfilter/xt_socket.o
  CC      drivers/media/rc/keymaps/rc-powercolor-real-angel.o
  CC      drivers/md/dm-raid.o
  AR      drivers/crypto/qat/qat_common/built-in.a
  CC      drivers/md/dm-thin.o
  AR      drivers/nvmem/built-in.a
  AR      drivers/crypto/qat/built-in.a
  CC      drivers/hid/hid-lg2ff.o
  AR      drivers/crypto/built-in.a
  CC      net/netfilter/xt_state.o
  CC      drivers/gpu/drm/i915/display/intel_dsi_dcs_backlight.o
  CC      net/netfilter/xt_statistic.o
  CC      drivers/hid/hid-lg3ff.o
  CC      drivers/hid/hid-lg4ff.o
  CC      drivers/thunderbolt/tmu.o
  CC      drivers/hid/hid-lg-g15.o
  CC      net/netfilter/xt_string.o
  CC      drivers/thunderbolt/usb4.o
  CC      net/netfilter/xt_tcpmss.o
  CC      drivers/gpu/drm/i915/display/intel_dsi_vbt.o
  CC      drivers/gpu/drm/i915/display/intel_dvo.o
  CC      drivers/md/dm-thin-metadata.o
  CC      drivers/md/dm-verity-fec.o
  CC      drivers/md/dm-verity-target.o
  CC      drivers/hid/hid-logitech-dj.o
  CC      drivers/media/rc/keymaps/rc-proteus-2309.o
  CC      drivers/md/dm-cache-target.o
  AR      drivers/counter/built-in.a
  CC      drivers/md/dm-cache-metadata.o
  CC      drivers/gpu/drm/i915/display/intel_gmbus.o
  CC      drivers/hid/hid-logitech-hidpp.o
  CC      drivers/hid/hid-magicmouse.o
  CC      drivers/gpu/drm/i915/display/intel_hdmi.o
  CC      drivers/gpu/drm/i915/display/intel_lspcon.o
  AR      drivers/infiniband/sw/rxe/built-in.a
  CC      drivers/infiniband/core/mad_rmpp.o
  CC      drivers/media/rc/keymaps/rc-purpletv.o
  CC      drivers/gpu/drm/i915/display/intel_lvds.o
  CC      drivers/md/dm-cache-policy.o
  CC      drivers/infiniband/core/nldev.o
  CC      drivers/infiniband/core/restrack.o
  CC      net/netfilter/xt_time.o
  CC      net/netfilter/xt_u32.o
  CC      drivers/infiniband/core/counters.o
  CC      drivers/hid/hid-microsoft.o
  CC      drivers/hid/hid-monterey.o
  CC      drivers/media/rc/keymaps/rc-pv951.o
  CC      drivers/hid/hid-multitouch.o
  CC      drivers/media/rc/keymaps/rc-hauppauge.o
  CC      drivers/hid/hid-ntrig.o
  AR      drivers/infiniband/sw/rdmavt/built-in.a
  AR      drivers/infiniband/sw/built-in.a
  CC      drivers/hid/hid-ortek.o
  CC      drivers/gpu/drm/i915/display/intel_panel.o
  CC      drivers/infiniband/core/ib_core_uverbs.o
  CC      drivers/media/rc/keymaps/rc-real-audio-220-32-keys.o
  CC      drivers/media/rc/keymaps/rc-rc6-mce.o
  CC      drivers/gpu/drm/i915/display/intel_sdvo.o
  CC      drivers/md/dm-cache-background-tracker.o
  CC      drivers/hid/hid-prodikeys.o
  CC      drivers/gpu/drm/i915/display/intel_tv.o
  CC      drivers/media/rc/keymaps/rc-reddo.o
  CC      drivers/media/rc/keymaps/rc-snapstream-firefly.o
  CC      drivers/media/rc/keymaps/rc-streamzap.o
  CC      drivers/md/dm-cache-policy-smq.o
  CC      drivers/hid/hid-pl.o
  CC      drivers/gpu/drm/i915/display/intel_vdsc.o
  CC      drivers/gpu/drm/i915/display/vlv_dsi.o
  CC      drivers/hid/hid-petalynx.o
  CC      drivers/hid/hid-picolcd_core.o
  CC      drivers/media/rc/keymaps/rc-tango.o
  CC      drivers/md/dm-clone-target.o
  CC      drivers/media/rc/keymaps/rc-tanix-tx3mini.o
  CC      drivers/hid/hid-picolcd_debugfs.o
  CC      drivers/md/dm-clone-metadata.o
  CC      drivers/md/dm-integrity.o
  CC      drivers/md/dm-zoned-target.o
  CC      drivers/hid/hid-plantronics.o
  CC      drivers/gpu/drm/i915/display/vlv_dsi_pll.o
  CC      drivers/md/dm-zoned-metadata.o
  AR      drivers/thunderbolt/built-in.a
  CC      drivers/hid/hid-primax.o
  CC      drivers/media/rc/keymaps/rc-tanix-tx5max.o
  CC      drivers/infiniband/core/trace.o
  CC      drivers/infiniband/core/security.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_hsw.o
  CC      drivers/md/dm-zoned-reclaim.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_bdw.o
  CC      drivers/media/rc/keymaps/rc-tbs-nec.o
  CC      drivers/media/rc/keymaps/rc-technisat-ts35.o
  CC      drivers/md/dm-writecache.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_chv.o
  CC      drivers/hid/hid-roccat.o
  AR      net/netfilter/built-in.a
  CC      drivers/infiniband/core/cgroup.o
Makefile:1683: recipe for target 'net' failed
make: *** [net] Error 2
make: *** Waiting for unfinished jobs....
  CC      drivers/media/rc/keymaps/rc-technisat-usb2.o
  CC      drivers/media/rc/keymaps/rc-terratec-cinergy-c-pci.o
  AR      drivers/infiniband/hw/mlx4/built-in.a
  CC      drivers/gpu/drm/i915/oa/i915_oa_sklgt2.o
  AR      drivers/infiniband/hw/built-in.a
  CC      drivers/gpu/drm/i915/oa/i915_oa_sklgt3.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_sklgt4.o
  CC      drivers/hid/hid-roccat-common.o
  CC      drivers/infiniband/core/cm.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_bxt.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_kblgt2.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_kblgt3.o
  CC      drivers/media/rc/keymaps/rc-terratec-cinergy-s2-hd.o
  CC      drivers/media/rc/keymaps/rc-terratec-cinergy-xs.o
  CC      drivers/media/rc/keymaps/rc-terratec-slim.o
  CC      drivers/media/rc/keymaps/rc-terratec-slim-2.o
  CC      drivers/infiniband/core/iwcm.o
  CC      drivers/infiniband/core/iwpm_util.o
  CC      drivers/infiniband/core/iwpm_msg.o
  CC      drivers/media/rc/keymaps/rc-tevii-nec.o
  CC      drivers/media/rc/keymaps/rc-tivo.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_glk.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_cflgt2.o
  CC      drivers/hid/hid-roccat-arvo.o
  CC      drivers/infiniband/core/cma.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_cflgt3.o
  CC      drivers/hid/hid-roccat-isku.o
  CC      drivers/infiniband/core/cma_trace.o
  CC      drivers/media/rc/keymaps/rc-total-media-in-hand.o
  CC      drivers/media/rc/keymaps/rc-total-media-in-hand-02.o
  CC      drivers/hid/hid-roccat-kone.o
  CC      drivers/media/rc/keymaps/rc-trekstor.o
  CC      drivers/infiniband/core/cma_configfs.o
  CC      drivers/infiniband/core/user_mad.o
  CC      drivers/infiniband/core/uverbs_main.o
  CC      drivers/hid/hid-roccat-koneplus.o
  CC      drivers/media/rc/keymaps/rc-tt-1500.o
  CC      drivers/infiniband/core/uverbs_cmd.o
  CC      drivers/infiniband/core/uverbs_marshall.o
  CC      drivers/hid/hid-roccat-konepure.o
  CC      drivers/hid/hid-roccat-kovaplus.o
  CC      drivers/media/rc/keymaps/rc-twinhan-dtv-cab-ci.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_cnl.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_icl.o
  CC      drivers/infiniband/core/rdma_core.o
  CC      drivers/hid/hid-roccat-lua.o
  CC      drivers/hid/hid-roccat-pyra.o
  CC      drivers/hid/hid-roccat-ryos.o
  CC      drivers/infiniband/core/uverbs_std_types.o
  CC      drivers/media/rc/keymaps/rc-twinhan1027.o
  CC      drivers/gpu/drm/i915/oa/i915_oa_tgl.o
  CC      drivers/infiniband/core/uverbs_ioctl.o
  CC      drivers/gpu/drm/i915/i915_perf.o
  CC      drivers/gpu/drm/i915/i915_gpu_error.o
  CC      drivers/media/rc/keymaps/rc-vega-s9x.o
  CC      drivers/gpu/drm/i915/i915_vgpu.o
  CC      drivers/hid/hid-roccat-savu.o
  CC      drivers/hid/hid-rmi.o
  CC      drivers/media/rc/keymaps/rc-videomate-m1f.o
  CC      drivers/hid/hid-saitek.o
  CC      drivers/hid/hid-samsung.o
  CC      drivers/hid/hid-sjoy.o
  CC      drivers/infiniband/core/uverbs_std_types_cq.o
  CC      drivers/infiniband/core/uverbs_std_types_flow_action.o
  CC      drivers/infiniband/core/uverbs_std_types_dm.o
  CC      drivers/infiniband/core/uverbs_std_types_mr.o
  CC      drivers/hid/hid-sony.o
  CC      drivers/infiniband/core/uverbs_std_types_counters.o
  CC      drivers/hid/hid-speedlink.o
  CC      drivers/infiniband/core/uverbs_uapi.o
  CC      drivers/infiniband/core/uverbs_std_types_device.o
  CC      drivers/infiniband/core/uverbs_std_types_async_fd.o
  CC      drivers/hid/hid-sunplus.o
  CC      drivers/infiniband/core/umem.o
  CC      drivers/media/rc/keymaps/rc-videomate-s350.o
  CC      drivers/hid/hid-gaff.o
  CC      drivers/infiniband/core/umem_odp.o
  CC      drivers/infiniband/core/ucma.o
  CC      drivers/media/rc/keymaps/rc-videomate-tv-pvr.o
  CC      drivers/hid/hid-tmff.o
  CC      drivers/hid/hid-tivo.o
  CC      drivers/media/rc/keymaps/rc-wetek-hub.o
  CC      drivers/media/rc/keymaps/rc-wetek-play2.o
  CC      drivers/hid/hid-topseed.o
  CC      drivers/media/rc/keymaps/rc-winfast.o
  CC      drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.o
  CC      drivers/media/rc/keymaps/rc-su3000.o
  CC      drivers/hid/hid-twinhan.o
  CC      drivers/hid/hid-uclogic-core.o
  CC      drivers/hid/hid-uclogic-rdesc.o
  CC      drivers/hid/hid-uclogic-params.o
  CC      drivers/media/rc/keymaps/rc-xbox-dvd.o
  CC      drivers/media/rc/keymaps/rc-x96max.o
  CC      drivers/media/rc/keymaps/rc-zx-irdec.o
  CC      drivers/hid/hid-zpff.o
  CC      drivers/hid/hid-led.o
  CC      drivers/hid/wacom_wac.o
  CC      drivers/hid/hid-zydacron.o
  CC      drivers/hid/wacom_sys.o
  CC      drivers/hid/hid-waltop.o
  CC      drivers/hid/hid-wiimote-core.o
  CC      drivers/hid/hid-wiimote-modules.o
  CC      drivers/hid/hid-wiimote-debug.o
  AR      drivers/media/rc/keymaps/built-in.a
  AR      drivers/media/rc/built-in.a
  AR      drivers/media/built-in.a
  AR      drivers/android/built-in.a
  AR      drivers/gpu/drm/i915/built-in.a
  AR      drivers/gpu/drm/built-in.a
  AR      drivers/gpu/built-in.a
  AR      drivers/md/built-in.a
  AR      drivers/hid/built-in.a
  AR      drivers/infiniband/core/built-in.a
  AR      drivers/infiniband/built-in.a
  AR      drivers/built-in.a


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=1718bb81e00000


Tested on:

commit:         110ca3ce fix
git tree:       https://github.com/hqj/hqjagain_test.git sctp_wfree
dashboard link: https://syzkaller.appspot.com/bug?extid=cea71eec5d6de256d54d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

