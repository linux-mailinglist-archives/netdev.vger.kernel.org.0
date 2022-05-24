Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F1F53200C
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 02:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiEXA6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 20:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiEXA6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 20:58:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1825395DC3;
        Mon, 23 May 2022 17:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653353878; x=1684889878;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=Dv+V0Sxn6r3rO7wPPjJm/GMzIhNmu+5eg3j5wmrhTuY=;
  b=b2IyVompfZJ5PY+UxOwTMOm+luckeSvlJRImD+4tBzYp6Q6jrls3pmPB
   kN+PUsEfhVRoXKX/Q4kG7FrHRH2jSJDAwKSiBqhx6mwxmYPztqpuh94PR
   OQLO/hdVTDehG5jUAJ0zACBfgy66UxIc0F5O+w4Pt7NTPKyPPmJpTar99
   vwYzyXsEMfyWtvRptJX/F7+r74Ia4UMQ0zLfK5rntzHZe8B/asjz8FkYH
   8JSeS0OVA9uJpEhOr9CqPvGJpAEp5ywEedOGVBUDh50p+57P9ZxNpdSbe
   N1WcasEL1cEuQw01cvsDk7nlXzRJvuYcLCfCqR43o566QZWsseGGZM1rM
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="334045138"
X-IronPort-AV: E=Sophos;i="5.91,247,1647327600"; 
   d="scan'208";a="334045138"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 17:57:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,247,1647327600"; 
   d="scan'208";a="663691966"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 23 May 2022 17:57:53 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ntIrw-0001Ys-Ag;
        Tue, 24 May 2022 00:57:52 +0000
Date:   Tue, 24 May 2022 08:57:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-sh@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-mm@kvack.org, linux-m68k@lists.linux-m68k.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 cc63e8e92cb872081f249ea16e6c460642f3e4fb
Message-ID: <628c2d6c.JBAeRpKohca9/VBR%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: cc63e8e92cb872081f249ea16e6c460642f3e4fb  Add linux-next specific files for 20220523

Error/Warning reports:

https://lore.kernel.org/linux-mm/202204291924.vTGZmerI-lkp@intel.com
https://lore.kernel.org/linux-mm/202205031017.4TwMan3l-lkp@intel.com
https://lore.kernel.org/linux-mm/202205041248.WgCwPcEV-lkp@intel.com
https://lore.kernel.org/linux-mm/202205122113.uLKzd3SZ-lkp@intel.com
https://lore.kernel.org/linux-mm/202205150051.3RzuooAG-lkp@intel.com
https://lore.kernel.org/linux-mm/202205150117.sd6HzBVm-lkp@intel.com
https://lore.kernel.org/linux-mm/202205211550.ifuEnz5n-lkp@intel.com
https://lore.kernel.org/lkml/202205100617.5UUm3Uet-lkp@intel.com
https://lore.kernel.org/llvm/202205060132.uhqyUx1l-lkp@intel.com
https://lore.kernel.org/llvm/202205110148.mrGBBmTn-lkp@intel.com
https://lore.kernel.org/llvm/202205221120.Tt6UxePI-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

<command-line>: fatal error: ./include/generated/utsrelease.h: No such file or directory
arch/m68k/q40/config.c:173: undefined reference to `mach_get_rtc_pll'
config.c:(.init.text+0xf2): undefined reference to `mach_get_rtc_pll'
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_7_ppt.c:1407:12: warning: stack frame size (1040) exceeds limit (1024) in 'smu_v13_0_7_get_power_profile_mode' [-Wframe-larger-than]
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1364:5: warning: no previous prototype for 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c:1986:6: warning: no previous prototype for function 'gfx_v11_0_rlc_stop' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/soc21.c:171:6: warning: no previous prototype for 'soc21_grbm_select' [-Wmissing-prototypes]
drivers/gpu/drm/solomon/ssd130x-spi.c:154:35: warning: 'ssd130x_spi_table' defined but not used [-Wunused-const-variable=]
drivers/rtc/rtc-rzn1.c:291:3: warning: variable 'val' is uninitialized when used here [-Wuninitialized]
drivers/video/fbdev/omap/hwa742.c:492:5: warning: no previous prototype for 'hwa742_update_window_async' [-Wmissing-prototypes]
fs/buffer.c:2254:5: warning: stack frame size (2144) exceeds limit (1024) in 'block_read_full_folio' [-Wframe-larger-than]
fs/ntfs/aops.c:378:12: warning: stack frame size (2216) exceeds limit (1024) in 'ntfs_read_folio' [-Wframe-larger-than]
llvm-objcopy: error: invalid output format: 'elf64-s390'
m68k-linux-ld: arch/m68k/q40/config.c:174: undefined reference to `mach_set_rtc_pll'
m68k-linux-ld: config.c:(.init.text+0xfc): undefined reference to `mach_set_rtc_pll'

Unverified Error/Warning (likely false positive, please contact us if interested):

Error: Section .bss not empty in prom_init.c
Makefile:686: arch/h8300/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1364:5: warning: no previous prototype for function 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c:129:6: warning: no previous prototype for function 'amdgpu_ucode_print_imu_hdr' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/imu_v11_0.c:302:6: warning: no previous prototype for function 'program_imu_rlc_ram' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/soc21.c:171:6: warning: no previous prototype for function 'soc21_grbm_select' [-Wmissing-prototypes]
drivers/gpu/drm/bridge/adv7511/adv7511.h:229:17: warning: 'ADV7511_REG_CEC_RX_FRAME_HDR' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/bridge/adv7511/adv7511.h:235:17: warning: 'ADV7511_REG_CEC_RX_FRAME_LEN' defined but not used [-Wunused-const-variable=]
drivers/infiniband/hw/hns/hns_roce_hw_v2.c:309:9: sparse: sparse: dubious: x & !y
drivers/staging/vt6655/card.c:758:16: sparse: sparse: cast to restricted __le64
drivers/ufs/host/ufs-exynos.c:1598:34: warning: unused variable 'exynos_ufs_of_match' [-Wunused-const-variable]
kernel/bpf/verifier.c:5355 process_kptr_func() warn: passing zero to 'PTR_ERR'
ld.lld: warning: call to __warn_flushing_systemwide_wq marked "dontcall-warn": Please avoid flushing system-wide workqueues.
make[1]: *** No rule to make target 'arch/h8300/Makefile'.
mm/shmem.c:1949 shmem_getpage_gfp() warn: should '(((1) << 12) / 512) << folio_order(folio)' be a 64 bit type?
powerpc64-linux-ld: drivers/gpu/drm/vkms/vkms_crtc.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/gpu/drm/vkms/vkms_plane.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/hid/hid-wiimote-modules.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/hid/hid-wiimote-core.o:(.bss+0x80): first defined here
powerpc64-linux-ld: drivers/mfd/rsmu_i2c.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/mfd/rsmu_core.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/mtd/ubi/vmt.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/mtd/ubi/vtbl.o:(.bss+0xc0): first defined here
powerpc64-linux-ld: drivers/slimbus/messaging.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/slimbus/core.o:(.bss+0x80): first defined here
powerpc64-linux-ld: fs/autofs/symlink.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/autofs/inode.o:(.bss+0x40): first defined here
powerpc64-linux-ld: fs/ecryptfs/inode.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/ecryptfs/dentry.o:(.bss+0x40): first defined here
powerpc64-linux-ld: fs/orangefs/file.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/orangefs/acl.o:(.bss+0x0): first defined here
riscv64-linux-ld: arch/riscv/kernel/compat_syscall_table.o:(.rodata+0x6f8): undefined reference to `compat_sys_fadvise64_64'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- alpha-randconfig-r024-20220522
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- alpha-randconfig-r033-20220522
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- alpha-randconfig-r035-20220522
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- arc-randconfig-r043-20220522
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arm-allmodconfig
|   |-- arch-arm-mach-omap2-dma.c:Unneeded-variable:errata-Return-on-line
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|-- arm-allyesconfig
|   |-- arch-arm-mach-omap2-dma.c:Unneeded-variable:errata-Return-on-line
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|-- arm-clps711x_defconfig
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- arm64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- csky-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- csky-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- h8300-allmodconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-allyesconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r012-20220523
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r034-20220522
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|-- i386-randconfig-a003-20220523
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-a006-20220523
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-c021
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-m021
|   |-- kernel-bpf-verifier.c-process_kptr_func()-warn:passing-zero-to-PTR_ERR
|   `-- mm-shmem.c-shmem_getpage_gfp()-warn:should-((()-)-)-folio_order(folio)-be-a-bit-type
|-- i386-randconfig-r003-20220523
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- ia64-buildonly-randconfig-r002-20220522
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- m68k-randconfig-r011-20220522
|   |-- config.c:(.init.text):undefined-reference-to-mach_get_rtc_pll
|   `-- m68k-linux-ld:config.c:(.init.text):undefined-reference-to-mach_set_rtc_pll
|-- m68k-randconfig-r023-20220523
|   |-- arch-m68k-q40-config.c:undefined-reference-to-mach_get_rtc_pll
|   `-- m68k-linux-ld:arch-m68k-q40-config.c:undefined-reference-to-mach_set_rtc_pll
|-- mips-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- parisc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- parisc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- parisc-randconfig-r014-20220522
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- powerpc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- powerpc64-randconfig-r014-20220522
|   |-- Error:Section-.bss-not-empty-in-prom_init.c
|   |-- multiple-definition-of-____cacheline_aligned-drivers-gpu-drm-vkms-vkms_plane.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-hid-hid-wiimote-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mfd-rsmu_core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mtd-ubi-vtbl.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-slimbus-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-autofs-inode.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-ecryptfs-dentry.o:(.bss):first-defined-here
|   `-- multiple-definition-of-____cacheline_aligned-fs-orangefs-acl.o:(.bss):first-defined-here
|-- riscv-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- riscv-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- riscv-randconfig-r024-20220522
|   `-- riscv64-linux-ld:arch-riscv-kernel-compat_syscall_table.o:(.rodata):undefined-reference-to-compat_sys_fadvise64_64
|-- riscv-randconfig-r042-20220522
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- s390-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|-- s390-randconfig-m031-20220523
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- s390-randconfig-r012-20220522
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- s390-randconfig-s031-20220522
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|-- sh-allmodconfig
|   `-- arch-sh-kernel-crash_dump.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-addr-got-void-noderef-__iomem
|-- sh-allyesconfig
|   `-- arch-sh-kernel-crash_dump.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-addr-got-void-noderef-__iomem
|-- sparc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- sparc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- sparc64-randconfig-s032-20220522
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|-- x86_64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- x86_64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- x86_64-randconfig-a002-20220523
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- x86_64-randconfig-a003-20220523
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- x86_64-randconfig-a006-20220523
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- x86_64-randconfig-s022
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|-- xtensa-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- xtensa-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- xtensa-randconfig-r025-20220522
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
`-- xtensa-randconfig-r025-20220523
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
    `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select

clang_recent_errors
|-- hexagon-randconfig-r041-20220523
|   `-- fs-buffer.c:warning:stack-frame-size-()-exceeds-limit-()-in-block_read_full_folio
|-- hexagon-randconfig-r045-20220522
|   |-- drivers-ufs-host-ufs-exynos.c:warning:unused-variable-exynos_ufs_of_match
|   |-- fs-buffer.c:warning:stack-frame-size-()-exceeds-limit-()-in-block_read_full_folio
|   `-- fs-ntfs-aops.c:warning:stack-frame-size-()-exceeds-limit-()-in-ntfs_read_folio
|-- powerpc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-function-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ucode.c:warning:no-previous-prototype-for-function-amdgpu_ucode_print_imu_hdr
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v11_0.c:warning:no-previous-prototype-for-function-gfx_v11_0_rlc_stop
|   |-- drivers-gpu-drm-amd-amdgpu-imu_v11_0.c:warning:no-previous-prototype-for-function-program_imu_rlc_ram
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-function-soc21_grbm_select
|   `-- drivers-rtc-rtc-rzn1.c:warning:variable-val-is-uninitialized-when-used-here
|-- powerpc-randconfig-r022-20220523
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_7_ppt.c:warning:stack-frame-size-()-exceeds-limit-()-in-smu_v13_0_7_get_power_profile_mode
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-function-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ucode.c:warning:no-previous-prototype-for-function-amdgpu_ucode_print_imu_hdr
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v11_0.c:warning:no-previous-prototype-for-function-gfx_v11_0_rlc_stop
|   |-- drivers-gpu-drm-amd-amdgpu-imu_v11_0.c:warning:no-previous-prototype-for-function-program_imu_rlc_ram
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-function-soc21_grbm_select
|-- powerpc-randconfig-r024-20220523
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_7_ppt.c:warning:stack-frame-size-()-exceeds-limit-()-in-smu_v13_0_7_get_power_profile_mode
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-function-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ucode.c:warning:no-previous-prototype-for-function-amdgpu_ucode_print_imu_hdr
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v11_0.c:warning:no-previous-prototype-for-function-gfx_v11_0_rlc_stop
|   |-- drivers-gpu-drm-amd-amdgpu-imu_v11_0.c:warning:no-previous-prototype-for-function-program_imu_rlc_ram
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-function-soc21_grbm_select
|-- powerpc64-randconfig-r003-20220522
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-function-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ucode.c:warning:no-previous-prototype-for-function-amdgpu_ucode_print_imu_hdr
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v11_0.c:warning:no-previous-prototype-for-function-gfx_v11_0_rlc_stop
|   |-- drivers-gpu-drm-amd-amdgpu-imu_v11_0.c:warning:no-previous-prototype-for-function-program_imu_rlc_ram
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-function-soc21_grbm_select
|-- powerpc64-randconfig-r014-20220523
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-function-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ucode.c:warning:no-previous-prototype-for-function-amdgpu_ucode_print_imu_hdr
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v11_0.c:warning:no-previous-prototype-for-function-gfx_v11_0_rlc_stop
|   |-- drivers-gpu-drm-amd-amdgpu-imu_v11_0.c:warning:no-previous-prototype-for-function-program_imu_rlc_ram
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-function-soc21_grbm_select
|-- s390-randconfig-r044-20220523
|   `-- llvm-objcopy:error:invalid-output-format:elf64-s390
`-- x86_64-randconfig-c007
    `-- ld.lld:warning:call-to-__warn_flushing_systemwide_wq-marked-dontcall-warn:Please-avoid-flushing-system-wide-workqueues.

elapsed time: 720m

configs tested: 108
configs skipped: 3

gcc tested configs:
arm                              allmodconfig
arm                              allyesconfig
arm                                 defconfig
arm64                               defconfig
arm64                            allyesconfig
i386                             allyesconfig
ia64                             allmodconfig
ia64                             allyesconfig
x86_64                           allyesconfig
mips                             allyesconfig
um                           x86_64_defconfig
riscv                            allmodconfig
um                             i386_defconfig
mips                             allmodconfig
riscv                            allyesconfig
m68k                             allyesconfig
s390                             allmodconfig
m68k                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
s390                             allyesconfig
sparc                            allyesconfig
parisc                           allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
alpha                            allyesconfig
nios2                            allyesconfig
arc                              allyesconfig
arm                         lpc18xx_defconfig
powerpc                     rainier_defconfig
mips                            ar7_defconfig
arm                            lart_defconfig
um                                  defconfig
arm                        clps711x_defconfig
arm                          pxa3xx_defconfig
arc                              alldefconfig
powerpc                 mpc85xx_cds_defconfig
ia64                        generic_defconfig
sh                               j2_defconfig
ia64                                defconfig
m68k                                defconfig
nios2                               defconfig
alpha                               defconfig
csky                                defconfig
arc                                 defconfig
parisc                              defconfig
s390                                defconfig
parisc64                            defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
sparc                               defconfig
powerpc                           allnoconfig
i386                 randconfig-a001-20220523
i386                 randconfig-a005-20220523
i386                 randconfig-a003-20220523
i386                 randconfig-a002-20220523
i386                 randconfig-a006-20220523
i386                 randconfig-a004-20220523
x86_64               randconfig-a003-20220523
x86_64               randconfig-a002-20220523
x86_64               randconfig-a006-20220523
x86_64               randconfig-a004-20220523
x86_64               randconfig-a001-20220523
x86_64               randconfig-a005-20220523
arc                  randconfig-r043-20220523
s390                 randconfig-r044-20220522
riscv                randconfig-r042-20220522
arc                  randconfig-r043-20220522
riscv                             allnoconfig
riscv                    nommu_k210_defconfig
riscv                          rv32_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
x86_64                              defconfig
x86_64                                  kexec
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                    rhel-8.3-kselftests
x86_64                           rhel-8.3-syz

clang tested configs:
mips                     cu1000-neo_defconfig
powerpc                    ge_imp3a_defconfig
mips                     cu1830-neo_defconfig
powerpc                          allyesconfig
arm                          moxart_defconfig
mips                         tb0219_defconfig
powerpc                   bluestone_defconfig
powerpc                     ppa8548_defconfig
arm                       netwinder_defconfig
x86_64               randconfig-a013-20220523
x86_64               randconfig-a012-20220523
x86_64               randconfig-a015-20220523
x86_64               randconfig-a011-20220523
x86_64               randconfig-a016-20220523
x86_64               randconfig-a014-20220523
i386                 randconfig-a013-20220523
i386                 randconfig-a012-20220523
i386                 randconfig-a011-20220523
i386                 randconfig-a014-20220523
i386                 randconfig-a015-20220523
i386                 randconfig-a016-20220523
hexagon              randconfig-r041-20220523
hexagon              randconfig-r045-20220523
hexagon              randconfig-r041-20220522
s390                 randconfig-r044-20220523
hexagon              randconfig-r045-20220522
riscv                randconfig-r042-20220523

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
