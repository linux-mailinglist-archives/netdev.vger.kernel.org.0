Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2426E52AE67
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 01:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiEQXHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 19:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbiEQXHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 19:07:15 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA0637A12;
        Tue, 17 May 2022 16:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652828832; x=1684364832;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=wmo18y74fRnnh3ecs8IVi4S/YNotLQWQ1xrRBglLbyg=;
  b=gzKlTOaNOq2kqj7/Qyvdw7kjxNvh6TY97fO4r//VvQVKaU6lJETg47T7
   ExRWPvKKES9CSVj6TbIGS0UK+/D42iuftmZvvoqKQqZt/QX/7nuJMKUOo
   Fb1EUfhfmYcnjCZbeoxaAgEsFIvtsoA5557PrEqnpnrNvmXzQfeC5C7SL
   CbSHs/vEpl2sHjrtQ6ZwXE+YlZ+eg6oXXxRpeH6XQe66cyPoSNAm9P020
   zX4YATKejYf9+GMtfTQfhdSfzyGLn1D2+GRMYXRPnzmDSX3ATF/gZaM/T
   zIetXhH+8pR/2ci51TNjBdln2VhHPJYeaRZ0Na1aZdP4RBOyUx6JuoaE8
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="271063150"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="271063150"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 16:07:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="817134895"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by fmsmga006.fm.intel.com with ESMTP; 17 May 2022 16:07:07 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nr6HT-0001YG-4H;
        Tue, 17 May 2022 23:07:07 +0000
Date:   Wed, 18 May 2022 07:06:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-mm@kvack.org, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        bpf@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 47c1c54d1bcd0a69a56b49473bc20f17b70e5242
Message-ID: <62842a88.kfUYggQn50N4+5J7%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 47c1c54d1bcd0a69a56b49473bc20f17b70e5242  Add linux-next specific files for 20220517

Error/Warning reports:

https://lore.kernel.org/linux-mm/202204181931.klAC6fWo-lkp@intel.com
https://lore.kernel.org/linux-mm/202204291924.vTGZmerI-lkp@intel.com
https://lore.kernel.org/linux-mm/202205030636.LYGgeLHv-lkp@intel.com
https://lore.kernel.org/linux-mm/202205041248.WgCwPcEV-lkp@intel.com
https://lore.kernel.org/linux-mm/202205150051.3RzuooAG-lkp@intel.com
https://lore.kernel.org/linux-mm/202205150117.sd6HzBVm-lkp@intel.com
https://lore.kernel.org/linux-mm/202205172305.y8xOBeEG-lkp@intel.com
https://lore.kernel.org/linux-mm/202205172344.3GFeaum1-lkp@intel.com
https://lore.kernel.org/llvm/202205052057.2TyEsXsL-lkp@intel.com
https://lore.kernel.org/llvm/202205162125.ZhvoOFZf-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

arch/arm/mach-versatile/versatile.c:56:14: warning: no previous prototype for function 'mmc_status' [-Wmissing-prototypes]
arch/riscv/include/asm/pgtable.h:695:9: error: call to undeclared function 'pud_leaf'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
arch/x86/kvm/pmu.h:20:32: warning: 'vmx_icl_pebs_cpu' defined but not used [-Wunused-const-variable=]
csky-linux-ld: drivers/nvme/host/fc.c:1915: undefined reference to `blkcg_get_fc_appid'
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1364:5: warning: no previous prototype for 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/soc21.c:171:6: warning: no previous prototype for 'soc21_grbm_select' [-Wmissing-prototypes]
drivers/gpu/drm/solomon/ssd130x-spi.c:154:35: warning: 'ssd130x_spi_table' defined but not used [-Wunused-const-variable=]
drivers/nvme/host/fc.c:1914: undefined reference to `blkcg_get_fc_appid'
drivers/video/fbdev/omap/hwa742.c:492:5: warning: no previous prototype for 'hwa742_update_window_async' [-Wmissing-prototypes]
fs/buffer.c:2254:5: warning: stack frame size (2152) exceeds limit (1024) in 'block_read_full_folio' [-Wframe-larger-than]
fs/ntfs/aops.c:378:12: warning: stack frame size (2216) exceeds limit (1024) in 'ntfs_read_folio' [-Wframe-larger-than]
kernel/trace/fgraph.c:37:12: warning: no previous prototype for 'ftrace_enable_ftrace_graph_caller' [-Wmissing-prototypes]
kernel/trace/fgraph.c:37:12: warning: no previous prototype for function 'ftrace_enable_ftrace_graph_caller' [-Wmissing-prototypes]
kernel/trace/fgraph.c:46:12: warning: no previous prototype for 'ftrace_disable_ftrace_graph_caller' [-Wmissing-prototypes]
kernel/trace/fgraph.c:46:12: warning: no previous prototype for function 'ftrace_disable_ftrace_graph_caller' [-Wmissing-prototypes]
powerpc64-linux-ld: drivers/nfc/nxp-nci/firmware.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/nfc/nxp-nci/core.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/nfc/s3fwrn5/nci.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/nfc/s3fwrn5/firmware.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/nvme/target/discovery.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/nvme/target/fabrics-cmd.o:(.bss+0x0): first defined here
powerpc64-linux-ld: fs/ntfs/attrib.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/ntfs/aops.o:(.bss+0x0): first defined here
powerpc64-linux-ld: net/mac80211/he.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; net/mac80211/aead_api.o:(.bss+0x0): first defined here
powerpc64-linux-ld: net/nfc/nci/ntf.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; net/nfc/nci/data.o:(.bss+0x0): first defined here
powerpc64-linux-ld: net/nfc/rawsock.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; net/nfc/af_nfc.o:(.bss+0x40): first defined here
powerpc64-linux-ld: net/wireless/sysfs.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; net/wireless/core.o:(.bss+0x1c0): first defined here
powerpc64-linux-ld: sound/pci/ac97/ac97_pcm.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; sound/pci/ac97/ac97_codec.o:(.bss+0x40): first defined here

Unverified Error/Warning (likely false positive, please contact us if interested):

Makefile:686: arch/h8300/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5102:14: warning: variable 'allow_lttpr_non_transparent_mode' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5147:6: warning: no previous prototype for 'dp_parse_lttpr_mode' [-Wmissing-prototypes]
drivers/gpu/drm/bridge/adv7511/adv7511.h:229:17: warning: 'ADV7511_REG_CEC_RX_FRAME_HDR' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/bridge/adv7511/adv7511.h:235:17: warning: 'ADV7511_REG_CEC_RX_FRAME_LEN' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:276:27: error: implicit declaration of function 'sysfs_gt_attribute_r_max_func' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:327:16: error: implicit declaration of function 'sysfs_gt_attribute_w_func' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:416:24: error: implicit declaration of function 'sysfs_gt_attribute_r_min_func' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:47 sysfs_gt_attribute_w_func() error: uninitialized symbol 'ret'.
drivers/tty/hvc/hvc_dcc.c:98:6: warning: Value stored to 'cpu' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
fc.c:(.text+0xad3): undefined reference to `blkcg_get_fc_appid'
include/linux/userfaultfd_k.h:147 vma_can_userfault() warn: bitwise AND condition is false here
kernel/bpf/verifier.c:5354 process_kptr_func() warn: passing zero to 'PTR_ERR'
kismet: WARNING: unmet direct dependencies detected for RISCV_ALTERNATIVE when selected by ERRATA_THEAD
kismet: WARNING: unmet direct dependencies detected for RISCV_ALTERNATIVE when selected by RISCV_ISA_SVPBMT
ld.lld: error: undefined symbol: blkcg_get_fc_appid
make[1]: *** No rule to make target 'arch/h8300/Makefile'.
mm/shmem.c:1910 shmem_getpage_gfp() warn: should '(((1) << 12) / 512) << folio_order(folio)' be a 64 bit type?
powerpc64-linux-ld: drivers/char/ipmi/ipmi_si_hardcode.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/char/ipmi/ipmi_si_hotmod.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/char/tpm/tpmrm-dev.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/char/tpm/tpm-dev.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/crypto/hisilicon/sec/sec_drv.o:(.bss+0x80): multiple definition of `____cacheline_aligned'; drivers/crypto/hisilicon/sec/sec_algs.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/gpu/drm/bridge/adv7511/adv7533.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/gpu/drm/bridge/adv7511/adv7511_drv.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/gpu/drm/drm_fb_cma_helper.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/gpu/drm/drm_gem_cma_helper.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/gpu/drm/mxsfb/mxsfb_kms.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/gpu/drm/mxsfb/mxsfb_drv.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/gpu/drm/selftests/test-drm_framebuffer.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/gpu/drm/selftests/test-drm_plane_helper.o:(.bss+0x340): first defined here
powerpc64-linux-ld: drivers/gpu/drm/vgem/vgem_fence.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/gpu/drm/vgem/vgem_drv.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/gpu/drm/vkms/vkms_crtc.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/gpu/drm/vkms/vkms_plane.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/hid/hid-debug.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/hid/hid-quirks.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/hid/hid-picolcd_fb.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/hid/hid-picolcd_core.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/hid/hid-wiimote-modules.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/hid/hid-wiimote-core.o:(.bss+0x80): first defined here
powerpc64-linux-ld: drivers/i2c/busses/i2c-designware-master.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/i2c/busses/i2c-designware-common.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/input/input-compat.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/input/input.o:(.bss+0x80): first defined here
powerpc64-linux-ld: drivers/input/mouse/elan_i2c_i2c.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/input/mouse/elan_i2c_core.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/input/rmi4/rmi_driver.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/input/rmi4/rmi_bus.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/md/dm-bio-prison-v2.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/md/dm-bio-prison-v1.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/md/dm-cache-metadata.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/md/dm-cache-target.o:(.bss+0x100): first defined here
powerpc64-linux-ld: drivers/md/dm-thin-metadata.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/md/dm-thin.o:(.bss+0x180): first defined here
powerpc64-linux-ld: drivers/md/md-bitmap.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/md/md.o:(.bss+0x180): first defined here
powerpc64-linux-ld: drivers/md/persistent-data/dm-bitset.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/md/persistent-data/dm-array.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/md/raid5-cache.o:(.bss+0xc0): multiple definition of `____cacheline_aligned'; drivers/md/raid5.o:(.bss+0x100): first defined here
powerpc64-linux-ld: drivers/media/dvb-core/dvb_demux.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/media/dvb-core/dmxdev.o:(.bss+0x80): first defined here
powerpc64-linux-ld: drivers/media/rc/rc-ir-raw.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/media/rc/rc-main.o:(.bss+0x80): first defined here
powerpc64-linux-ld: drivers/media/tuners/tda18271-common.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/media/tuners/tda18271-maps.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/media/v4l2-core/v4l2-fh.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/media/v4l2-core/v4l2-dev.o:(.bss+0x900): first defined here
powerpc64-linux-ld: drivers/mfd/cs47l35-tables.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/mfd/madera-core.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/mfd/mt6397-irq.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/mfd/mt6397-core.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/mfd/pcf50633-irq.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/mfd/pcf50633-core.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/misc/altera-stapl/altera-jtag.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/misc/altera-stapl/altera-lpt.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/mmc/core/host.o:(.bss+0x80): multiple definition of `____cacheline_aligned'; drivers/mmc/core/bus.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/mtd/spi-nor/swp.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/mtd/spi-nor/sfdp.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/net/can/dev/length.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/net/can/dev/bittiming.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/net/can/flexcan/flexcan-ethtool.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/net/can/flexcan/flexcan-core.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/slimbus/messaging.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/slimbus/core.o:(.bss+0x80): first defined here
powerpc64-linux-ld: drivers/ssb/scan.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/ssb/main.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/staging/ks7010/ks_wlan_net.o:(.bss+0x80): multiple definition of `____cacheline_aligned'; drivers/staging/ks7010/ks_hostif.o:(.bss+0x80): first defined here
powerpc64-linux-ld: drivers/video/fbdev/omap2/omapfb/dss/dispc_coefs.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/video/fbdev/omap2/omapfb/dss/dispc.o:(.bss+0x1100): first defined here
powerpc64-linux-ld: drivers/video/fbdev/omap2/omapfb/omapfb-ioctl.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/video/fbdev/omap2/omapfb/omapfb-sysfs.o:(.bss+0x0): first defined here
powerpc64-linux-ld: fs/autofs/symlink.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/autofs/inode.o:(.bss+0x40): first defined here
powerpc64-linux-ld: fs/befs/btree.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/befs/datastream.o:(.bss+0x0): first defined here
powerpc64-linux-ld: fs/fat/dir.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/fat/cache.o:(.bss+0x40): first defined here
powerpc64-linux-ld: fs/fscache/io.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/fscache/cache.o:(.bss+0x40): first defined here
powerpc64-linux-ld: fs/hfs/bfind.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/hfs/bitmap.o:(.bss+0x0): first defined here
powerpc64-linux-ld: fs/minix/itree_v1.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/minix/bitmap.o:(.bss+0x0): first defined here
powerpc64-linux-ld: fs/netfs/objects.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; fs/netfs/buffered_read.o:(.bss+0x0): first defined here
powerpc64-linux-ld: fs/overlayfs/namei.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/overlayfs/super.o:(.bss+0x40): first defined here
powerpc64-linux-ld: lib/raid6/recov.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; lib/raid6/algos.o:(.bss+0x40): first defined here
powerpc64-linux-ld: net/atm/svc.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; net/atm/pvc.o:(.bss+0x0): first defined here
powerpc64-linux-ld: net/ax25/ax25_dev.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; net/ax25/ax25_addr.o:(.bss+0x0): first defined here
powerpc64-linux-ld: net/bridge/br_forward.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; net/bridge/br_fdb.o:(.bss+0x0): first defined here
powerpc64-linux-ld: net/ceph/messenger.o:(.bss+0x880): multiple definition of `____cacheline_aligned'; net/ceph/ceph_common.o:(.bss+0x40): first defined here
powerpc64-linux-ld: net/phonet/socket.o:(.bss+0x940): multiple definition of `____cacheline_aligned'; net/phonet/pn_dev.o:(.bss+0x40): first defined here
powerpc64-linux-ld: net/rds/cong.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; net/rds/bind.o:(.bss+0x180): first defined here
powerpc64-linux-ld: net/rds/tcp_connect.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; net/rds/tcp.o:(.bss+0x40): first defined here
powerpc64-linux-ld: net/x25/x25_out.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; net/x25/x25_in.o:(.bss+0x0): first defined here
powerpc64-linux-ld: security/keys/trusted-keys/trusted_tpm1.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; security/keys/trusted-keys/trusted_core.o:(.bss+0x40): first defined here
{standard input}:1991: Error: unknown pseudo-op: `.lc'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arm-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|-- arm-randconfig-r031-20220516
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- csky-randconfig-r025-20220516
|   `-- csky-linux-ld:drivers-nvme-host-fc.c:undefined-reference-to-blkcg_get_fc_appid
|-- h8300-allyesconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allyesconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|-- i386-debian-10.3
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- i386-debian-10.3-kselftests
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- i386-randconfig-a011-20220516
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-c021-20220516
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_max_func
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_min_func
|   `-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_w_func
|-- i386-randconfig-m021
|   |-- kernel-bpf-verifier.c-process_kptr_func()-warn:passing-zero-to-PTR_ERR
|   `-- mm-shmem.c-shmem_getpage_gfp()-warn:should-((()-)-)-folio_order(folio)-be-a-bit-type
|-- i386-randconfig-r014-20220516
|   `-- fc.c:(.text):undefined-reference-to-blkcg_get_fc_appid
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- microblaze-randconfig-s031-20220516
|   |-- drivers-nvme-host-fc.c:undefined-reference-to-blkcg_get_fc_appid
|   |-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_disable_ftrace_graph_caller
|   `-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_enable_ftrace_graph_caller
|-- mips-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- openrisc-randconfig-m031-20220517
|   |-- include-linux-userfaultfd_k.h-vma_can_userfault()-warn:bitwise-AND-condition-is-false-here
|   `-- kernel-bpf-verifier.c-process_kptr_func()-warn:passing-zero-to-PTR_ERR
|-- parisc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-gpu-drm-rockchip-rockchip_drm_vop2.c:Unneeded-semicolon
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- powerpc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- powerpc64-randconfig-r015-20220516
|   |-- multiple-definition-of-____cacheline_aligned-drivers-char-ipmi-ipmi_si_hotmod.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-char-tpm-tpm-dev.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-gpu-drm-bridge-adv7511-adv7511_drv.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-gpu-drm-drm_gem_cma_helper.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-gpu-drm-mxsfb-mxsfb_drv.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-gpu-drm-selftests-test-drm_plane_helper.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-gpu-drm-vgem-vgem_drv.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-gpu-drm-vkms-vkms_plane.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-input-input.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-input-mouse-elan_i2c_core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-md-dm-bio-prison-v1.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-md-dm-cache-target.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-md-dm-thin.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-md-md.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-md-persistent-data-dm-array.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-md-raid5.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-media-dvb-core-dmxdev.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-media-rc-rc-main.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-media-tuners-tda18271-maps.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-media-v4l2-core-v4l2-dev.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mfd-mt6397-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mfd-pcf50633-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-misc-altera-stapl-altera-lpt.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mmc-core-bus.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-nvme-target-fabrics-cmd.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-staging-ks7010-ks_hostif.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-autofs-inode.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-befs-datastream.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-fat-cache.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-hfs-bitmap.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-minix-bitmap.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-ntfs-aops.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-overlayfs-super.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-lib-raid6-algos.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-atm-pvc.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-ceph-ceph_common.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-mac80211-aead_api.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-phonet-pn_dev.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-rds-bind.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-rds-tcp.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-wireless-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-x25-x25_in.o:(.bss):first-defined-here
|   `-- multiple-definition-of-____cacheline_aligned-security-keys-trusted-keys-trusted_core.o:(.bss):first-defined-here
|-- powerpc64-randconfig-r016-20220516
|   |-- multiple-definition-of-____cacheline_aligned-drivers-char-tpm-tpm-dev.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-crypto-hisilicon-sec-sec_algs.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-hid-hid-picolcd_core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-hid-hid-quirks.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-hid-hid-wiimote-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-i2c-busses-i2c-designware-common.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-input-rmi4-rmi_bus.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-media-rc-rc-main.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mfd-madera-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mfd-mt6397-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-misc-altera-stapl-altera-lpt.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mmc-core-bus.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mtd-spi-nor-sfdp.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-net-can-dev-bittiming.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-net-can-flexcan-flexcan-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-nfc-nxp-nci-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-nfc-s3fwrn5-firmware.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-slimbus-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-ssb-main.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-video-fbdev-omap2-omapfb-dss-dispc.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-video-fbdev-omap2-omapfb-omapfb-sysfs.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-fscache-cache.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-netfs-buffered_read.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-atm-pvc.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-ax25-ax25_addr.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-bridge-br_fdb.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-mac80211-aead_api.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-nfc-af_nfc.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-nfc-nci-data.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-wireless-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-security-keys-trusted-keys-trusted_core.o:(.bss):first-defined-here
|   `-- multiple-definition-of-____cacheline_aligned-sound-pci-ac97-ac97_codec.o:(.bss):first-defined-here
|-- riscv-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- riscv-allnoconfig
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-RISCV_ALTERNATIVE-when-selected-by-ERRATA_THEAD
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-RISCV_ALTERNATIVE-when-selected-by-RISCV_ISA_SVPBMT
|-- riscv-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- s390-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- sh-allmodconfig
|   `-- standard-input:Error:unknown-pseudo-op:lc
|-- sparc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- sparc-randconfig-r003-20220516
|   |-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_disable_ftrace_graph_caller
|   `-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_enable_ftrace_graph_caller
|-- sparc-randconfig-r036-20220516
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- um-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- x86_64-allyesconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|-- x86_64-kexec
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-randconfig-a012-20220516
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- x86_64-randconfig-a014-20220516
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-randconfig-c001-20220516
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- x86_64-randconfig-m001-20220516
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c-sysfs_gt_attribute_w_func()-error:uninitialized-symbol-ret-.
|   `-- kernel-bpf-verifier.c-process_kptr_func()-warn:passing-zero-to-PTR_ERR
|-- x86_64-randconfig-r024-20220516
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- x86_64-rhel-8.3
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-rhel-8.3-func
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-rhel-8.3-kselftests
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-rhel-8.3-kunit
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-rhel-8.3-syz
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
`-- xtensa-allyesconfig
    |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
    |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
    `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select

clang_recent_errors
|-- arm-randconfig-c002-20220516
|   `-- drivers-tty-hvc-hvc_dcc.c:warning:Value-stored-to-cpu-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
|-- arm-versatile_defconfig
|   `-- arch-arm-mach-versatile-versatile.c:warning:no-previous-prototype-for-function-mmc_status
|-- hexagon-buildonly-randconfig-r005-20220516
|   `-- ld.lld:error:undefined-symbol:blkcg_get_fc_appid
|-- hexagon-randconfig-r045-20220516
|   |-- fs-buffer.c:warning:stack-frame-size-()-exceeds-limit-()-in-block_read_full_folio
|   `-- fs-ntfs-aops.c:warning:stack-frame-size-()-exceeds-limit-()-in-ntfs_read_folio
|-- i386-randconfig-a006-20220516
|   `-- ld.lld:error:undefined-symbol:blkcg_get_fc_appid
|-- riscv-randconfig-r001-20220516
|   |-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-function-ftrace_disable_ftrace_graph_caller
|   `-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-function-ftrace_enable_ftrace_graph_caller
`-- riscv-randconfig-r004-20220516
    `-- arch-riscv-include-asm-pgtable.h:error:call-to-undeclared-function-pud_leaf-ISO-C99-and-later-do-not-support-implicit-function-declarations

elapsed time: 730m

configs tested: 114
configs skipped: 3

gcc tested configs:
arm                              allmodconfig
arm                              allyesconfig
arm                                 defconfig
arm64                               defconfig
arm64                            allyesconfig
i386                 randconfig-c001-20220516
arm                      integrator_defconfig
sh                ecovec24-romimage_defconfig
sh                            titan_defconfig
powerpc                     redwood_defconfig
sh                              ul2_defconfig
xtensa                         virt_defconfig
powerpc                   currituck_defconfig
openrisc                 simple_smp_defconfig
arc                          axs101_defconfig
mips                         cobalt_defconfig
sh                          urquell_defconfig
sh                           se7722_defconfig
m68k                          sun3x_defconfig
sh                           se7780_defconfig
sh                           se7705_defconfig
powerpc                     sequoia_defconfig
arm                  randconfig-c002-20220516
x86_64               randconfig-c001-20220516
ia64                                defconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
alpha                               defconfig
csky                                defconfig
alpha                            allyesconfig
nios2                            allyesconfig
arc                                 defconfig
h8300                            allyesconfig
sh                               allmodconfig
xtensa                           allyesconfig
parisc                              defconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
parisc64                            defconfig
s390                             allyesconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
nios2                               defconfig
arc                              allyesconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
powerpc                          allyesconfig
x86_64               randconfig-a012-20220516
x86_64               randconfig-a011-20220516
x86_64               randconfig-a013-20220516
x86_64               randconfig-a014-20220516
x86_64               randconfig-a016-20220516
x86_64               randconfig-a015-20220516
i386                 randconfig-a014-20220516
i386                 randconfig-a011-20220516
i386                 randconfig-a013-20220516
i386                 randconfig-a015-20220516
i386                 randconfig-a012-20220516
i386                 randconfig-a016-20220516
arc                  randconfig-r043-20220516
s390                 randconfig-r044-20220516
riscv                randconfig-r042-20220516
riscv                             allnoconfig
riscv                            allyesconfig
riscv                            allmodconfig
riscv                    nommu_k210_defconfig
riscv                          rv32_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                                  kexec
x86_64                           rhel-8.3-syz
x86_64                          rhel-8.3-func
x86_64                               rhel-8.3
x86_64                         rhel-8.3-kunit

clang tested configs:
arm                       cns3420vb_defconfig
arm                       versatile_defconfig
arm                          collie_defconfig
powerpc                     kilauea_defconfig
mips                      malta_kvm_defconfig
arm                       mainstone_defconfig
arm                  colibri_pxa300_defconfig
mips                            e55_defconfig
powerpc                   microwatt_defconfig
powerpc                     akebono_defconfig
powerpc                    mvme5100_defconfig
x86_64               randconfig-a002-20220516
x86_64               randconfig-a001-20220516
x86_64               randconfig-a003-20220516
x86_64               randconfig-a005-20220516
x86_64               randconfig-a004-20220516
x86_64               randconfig-a006-20220516
i386                 randconfig-a003-20220516
i386                 randconfig-a001-20220516
i386                 randconfig-a004-20220516
i386                 randconfig-a006-20220516
i386                 randconfig-a002-20220516
i386                 randconfig-a005-20220516
hexagon              randconfig-r045-20220516
hexagon              randconfig-r041-20220516

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
