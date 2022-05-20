Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C5252E4C4
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 08:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344538AbiETGKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 02:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234755AbiETGKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 02:10:11 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75E114B672;
        Thu, 19 May 2022 23:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653027008; x=1684563008;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=0IGNZy702JKiu4Ffd+miSfnDB5aL95QU70i4umciOZU=;
  b=nMje4jNl21GKaG7y7MeqERj2cfFKj7CzwZMn+boqkviRLEsG11FS3U9o
   GzK09/dAjU2bSUo5DYhcvotApEfeBb2gGd+ElvBz2A9tbGF0PY6UrvAml
   x9iqyS0YJ49622ymdZqPqck8s+ZeNN/olGlMvqOAzmfLYOQXhvI1bt/yZ
   CODlUn7dAc9Mh0/OUeHk1MH12Nbo/OA7XMMtk+GJ5P1iLxRVbT4bChvBr
   ANMkXeD9bxOtco79T2Gw+ro6bE2FgCds60737YNO5DWZuvD77Q4NGENDY
   Y/IsDI0+17J6OObDNsIkyy2A+qCL+9TII5QgfmnpA+dukxzsHjNg4d1ei
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="253019642"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="253019642"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 23:10:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="576024797"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 19 May 2022 23:10:03 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrvpr-0004Lj-5P;
        Fri, 20 May 2022 06:10:03 +0000
Date:   Fri, 20 May 2022 14:08:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-sh@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-mm@kvack.org, linux-hwmon@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 21498d01d045c5b95b93e0a0625ae965b4330ebe
Message-ID: <62873074.g1g0twvcKbX70gr/%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 21498d01d045c5b95b93e0a0625ae965b4330ebe  Add linux-next specific files for 20220519

Error/Warning reports:

https://lore.kernel.org/linux-mm/202204291924.vTGZmerI-lkp@intel.com
https://lore.kernel.org/linux-mm/202205041248.WgCwPcEV-lkp@intel.com
https://lore.kernel.org/linux-mm/202205122113.uLKzd3SZ-lkp@intel.com
https://lore.kernel.org/linux-mm/202205172344.3GFeaum1-lkp@intel.com
https://lore.kernel.org/linux-mm/202205192041.eAjgoXSY-lkp@intel.com
https://lore.kernel.org/linux-mm/202205192334.DNijFnTC-lkp@intel.com
https://lore.kernel.org/linux-mm/202205200219.llzx7zfy-lkp@intel.com
https://lore.kernel.org/llvm/202205052057.2TyEsXsL-lkp@intel.com
https://lore.kernel.org/llvm/202205060132.uhqyUx1l-lkp@intel.com
https://lore.kernel.org/llvm/202205170352.5YjuBP5H-lkp@intel.com
https://lore.kernel.org/llvm/202205200012.68rPHREP-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

<command-line>: fatal error: ./include/generated/utsrelease.h: No such file or directory
ERROR: modpost: "devm_ioremap_resource" [drivers/net/can/ctucanfd/ctucanfd_platform.ko] undefined!
arch/x86/kvm/hyperv.c:1983:22: error: shift count >= width of type [-Werror,-Wshift-count-overflow]
arch/x86/kvm/pmu.h:20:32: warning: 'vmx_icl_pebs_cpu' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1364:5: warning: no previous prototype for 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c:1986:6: warning: no previous prototype for function 'gfx_v11_0_rlc_stop' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/soc21.c:171:6: warning: no previous prototype for 'soc21_grbm_select' [-Wmissing-prototypes]
drivers/gpu/drm/solomon/ssd130x-spi.c:154:35: warning: 'ssd130x_spi_table' defined but not used [-Wunused-const-variable=]
drivers/hwmon/nct6775-platform.c:199:9: sparse:    unsigned char
drivers/hwmon/nct6775-platform.c:199:9: sparse:    void
drivers/net/ethernet/dec/tulip/eeprom.c:120:54: error: 'struct pci_dev' has no member named 'pdev'; did you mean 'dev'?
drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h:22:6: warning: no previous prototype for function 'mlx5_lag_mpesw_init' [-Wmissing-prototypes]
drivers/net/ethernet/mellanox/mlx5/core/lag/mpesw.h:23:6: warning: no previous prototype for function 'mlx5_lag_mpesw_cleanup' [-Wmissing-prototypes]
drivers/nvme/host/fc.c:1914: undefined reference to `blkcg_get_fc_appid'
drivers/video/fbdev/omap/hwa742.c:492:5: warning: no previous prototype for 'hwa742_update_window_async' [-Wmissing-prototypes]
include/asm-generic/bitops/const_hweight.h:21:76: warning: right shift count >= width of type [-Wshift-count-overflow]
kernel/trace/fgraph.c:37:12: warning: no previous prototype for function 'ftrace_enable_ftrace_graph_caller' [-Wmissing-prototypes]
kernel/trace/fgraph.c:46:12: warning: no previous prototype for function 'ftrace_disable_ftrace_graph_caller' [-Wmissing-prototypes]

Unverified Error/Warning (likely false positive, please contact us if interested):

Makefile:686: arch/h8300/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
arch/riscv/include/asm/tlbflush.h:23:2: error: expected assembly-time absolute expression
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1364:5: warning: no previous prototype for function 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c:129:6: warning: no previous prototype for function 'amdgpu_ucode_print_imu_hdr' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/imu_v11_0.c:302:6: warning: no previous prototype for function 'program_imu_rlc_ram' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/soc21.c:171:6: warning: no previous prototype for function 'soc21_grbm_select' [-Wmissing-prototypes]
drivers/gpu/drm/bridge/adv7511/adv7511.h:229:17: warning: 'ADV7511_REG_CEC_RX_FRAME_HDR' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/bridge/adv7511/adv7511.h:235:17: warning: 'ADV7511_REG_CEC_RX_FRAME_LEN' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:276:27: error: implicit declaration of function 'sysfs_gt_attribute_r_max_func' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:327:16: error: implicit declaration of function 'sysfs_gt_attribute_w_func' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:416:24: error: implicit declaration of function 'sysfs_gt_attribute_r_min_func' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:47 sysfs_gt_attribute_w_func() error: uninitialized symbol 'ret'.
drivers/gpu/drm/i915/gt/intel_rps.c:2325 rps_read_mmio() error: uninitialized symbol 'val'.
drivers/infiniband/hw/hns/hns_roce_hw_v2.c:309:9: sparse: sparse: dubious: x & !y
drivers/staging/vt6655/card.c:759:16: sparse: sparse: cast to restricted __le64
fc.c:(.text+0x432): undefined reference to `blkcg_get_fc_appid'
fc.c:(.text+0x492): undefined reference to `blkcg_get_fc_appid'
fc.c:(.text+0x5fe): undefined reference to `blkcg_get_fc_appid'
fc.c:(.text+0x790): undefined reference to `blkcg_get_fc_appid'
fc.c:(.text+0x7de): undefined reference to `blkcg_get_fc_appid'
kernel/bpf/verifier.c:5354 process_kptr_func() warn: passing zero to 'PTR_ERR'
ld.lld: error: undefined symbol: blkcg_get_fc_appid
make[1]: *** No rule to make target 'arch/h8300/Makefile'.
mm/shmem.c:1910 shmem_getpage_gfp() warn: should '(((1) << 12) / 512) << folio_order(folio)' be a 64 bit type?
powerpc64-linux-ld: drivers/gpu/drm/bridge/analogix/analogix_dp_reg.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/gpu/drm/bridge/analogix/analogix_dp_core.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/mfd/mt6397-irq.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/mfd/mt6397-core.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/mmc/core/host.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/mmc/core/bus.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/mtd/mtdchar.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/mtd/mtdsuper.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/nfc/nxp-nci/firmware.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/nfc/nxp-nci/core.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/nfc/s3fwrn5/nci.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/nfc/s3fwrn5/firmware.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/soundwire/master.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/soundwire/bus.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/staging/greybus/audio_manager_module.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/staging/greybus/audio_manager.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/w1/w1_int.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/w1/w1.o:(.bss+0x40): first defined here
powerpc64-linux-ld: fs/exfat/namei.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/exfat/inode.o:(.bss+0x0): first defined here
powerpc64-linux-ld: fs/hpfs/anode.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/hpfs/alloc.o:(.bss+0x0): first defined here
powerpc64-linux-ld: fs/omfs/dir.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/omfs/bitmap.o:(.bss+0x0): first defined here
powerpc64-linux-ld: fs/pstore/pmsg.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; fs/pstore/platform.o:(.bss+0x40): first defined here
powerpc64-linux-ld: net/decnet/dn_route.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; net/decnet/dn_nsp_out.o:(.bss+0x0): first defined here
powerpc64-linux-ld: net/nfc/nci/ntf.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; net/nfc/nci/data.o:(.bss+0x0): first defined here
powerpc64-linux-ld: net/nfc/rawsock.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; net/nfc/af_nfc.o:(.bss+0x40): first defined here
powerpc64-linux-ld: net/unix/sysctl_net_unix.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; net/unix/garbage.o:(.bss+0x40): first defined here
powerpc64-linux-ld: sound/soc/bcm/bcm63xx-pcm-whistler.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; sound/soc/bcm/bcm63xx-i2s-whistler.o:(.bss+0x0): first defined here
{standard input}:1991: Error: unknown pseudo-op: `.lc'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- alpha-randconfig-s032-20220519
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- arc-randconfig-r043-20220519
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arm-allmodconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|-- arm-allyesconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|-- arm-randconfig-r024-20220519
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- arm-rpc_defconfig
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- arm64-allmodconfig
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- arm64-allyesconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arm64-randconfig-r006-20220519
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- csky-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- csky-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- h8300-allmodconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-allyesconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allmodconfig
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- i386-allyesconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|-- i386-debian-10.3
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- i386-debian-10.3-kselftests
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- i386-randconfig-a003
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   `-- include-asm-generic-bitops-const_hweight.h:warning:right-shift-count-width-of-type
|-- i386-randconfig-a012
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-a014
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- fc.c:(.text):undefined-reference-to-blkcg_get_fc_appid
|-- i386-randconfig-a016
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-c001
|   `-- fc.c:(.text):undefined-reference-to-blkcg_get_fc_appid
|-- i386-randconfig-m021
|   |-- kernel-bpf-verifier.c-process_kptr_func()-warn:passing-zero-to-PTR_ERR
|   `-- mm-shmem.c-shmem_getpage_gfp()-warn:should-((()-)-)-folio_order(folio)-be-a-bit-type
|-- i386-randconfig-s001
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_max_func
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_min_func
|   `-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_w_func
|-- i386-randconfig-s002
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- ia64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- m68k-allmodconfig
|   |-- drivers-hwmon-nct6775-platform.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-hwmon-nct6775-platform.c:sparse:unsigned-char
|   `-- drivers-hwmon-nct6775-platform.c:sparse:void
|-- m68k-allyesconfig
|   |-- drivers-hwmon-nct6775-platform.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-hwmon-nct6775-platform.c:sparse:unsigned-char
|   `-- drivers-hwmon-nct6775-platform.c:sparse:void
|-- mips-allmodconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- mips-allyesconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- mips-randconfig-r014-20220519
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- nios2-randconfig-r015-20220519
|   `-- drivers-nvme-host-fc.c:undefined-reference-to-blkcg_get_fc_appid
|-- parisc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-net-ethernet-dec-tulip-eeprom.c:error:struct-pci_dev-has-no-member-named-pdev
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- parisc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-net-ethernet-dec-tulip-eeprom.c:error:struct-pci_dev-has-no-member-named-pdev
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- parisc-defconfig
|   `-- drivers-net-ethernet-dec-tulip-eeprom.c:error:struct-pci_dev-has-no-member-named-pdev
|-- parisc64-allmodconfig
|   `-- drivers-net-ethernet-dec-tulip-eeprom.c:error:struct-pci_dev-has-no-member-named-pdev
|-- parisc64-defconfig
|   `-- drivers-net-ethernet-dec-tulip-eeprom.c:error:struct-pci_dev-has-no-member-named-pdev
|-- powerpc-allmodconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- powerpc-allyesconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- powerpc-randconfig-r001-20220519
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- powerpc-randconfig-r005-20220519
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- powerpc64-randconfig-c003-20220519
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- powerpc64-randconfig-r036-20220519
|   |-- multiple-definition-of-____cacheline_aligned-drivers-gpu-drm-bridge-analogix-analogix_dp_core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mfd-mt6397-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mmc-core-bus.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mtd-mtdsuper.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-nfc-nxp-nci-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-nfc-s3fwrn5-firmware.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-soundwire-bus.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-staging-greybus-audio_manager.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-w1-w1.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-exfat-inode.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-hpfs-alloc.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-omfs-bitmap.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-pstore-platform.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-decnet-dn_nsp_out.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-nfc-af_nfc.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-nfc-nci-data.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-unix-garbage.o:(.bss):first-defined-here
|   `-- multiple-definition-of-____cacheline_aligned-sound-soc-bcm-bcm63xx-i2s-whistler.o:(.bss):first-defined-here
|-- riscv-allmodconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- riscv-allyesconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- riscv-randconfig-r034-20220519
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- s390-allmodconfig
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- s390-allyesconfig
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- s390-randconfig-r002-20220519
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- s390-randconfig-r034-20220519
|   `-- ERROR:devm_ioremap_resource-drivers-net-can-ctucanfd-ctucanfd_platform.ko-undefined
|-- sh-allmodconfig
|   |-- arch-sh-kernel-crash_dump.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-addr-got-void-noderef-__iomem
|   `-- standard-input:Error:unknown-pseudo-op:lc
|-- sh-allyesconfig
|   |-- arch-sh-kernel-crash_dump.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-addr-got-void-noderef-__iomem
|   `-- standard-input:Error:unknown-pseudo-op:lc
|-- sparc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- sparc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- x86_64-allmodconfig
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- x86_64-allyesconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|-- x86_64-kexec
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-randconfig-a002
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   `-- fc.c:(.text):undefined-reference-to-blkcg_get_fc_appid
|-- x86_64-randconfig-a011
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_max_func
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_min_func
|   `-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_w_func
|-- x86_64-randconfig-a015
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   `-- fc.c:(.text):undefined-reference-to-blkcg_get_fc_appid
|-- x86_64-randconfig-c002
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_max_func
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_min_func
|   `-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_w_func
|-- x86_64-randconfig-s021
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- fc.c:(.text):undefined-reference-to-blkcg_get_fc_appid
|-- x86_64-rhel-8.3
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-rhel-8.3-func
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-rhel-8.3-kselftests
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c-sysfs_gt_attribute_w_func()-error:uninitialized-symbol-ret-.
|   |-- drivers-gpu-drm-i915-gt-intel_rps.c-rps_read_mmio()-error:uninitialized-symbol-val-.
|   `-- kernel-bpf-verifier.c-process_kptr_func()-warn:passing-zero-to-PTR_ERR
|-- x86_64-rhel-8.3-kunit
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-rhel-8.3-syz
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- xtensa-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
`-- xtensa-allyesconfig
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
    `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select

clang_recent_errors
|-- i386-randconfig-a002
|   `-- arch-x86-kvm-hyperv.c:error:shift-count-width-of-type-Werror-Wshift-count-overflow
|-- i386-randconfig-a004
|   `-- ld.lld:error:undefined-symbol:blkcg_get_fc_appid
|-- i386-randconfig-a015
|   |-- drivers-net-ethernet-mellanox-mlx5-core-lag-mpesw.h:warning:no-previous-prototype-for-function-mlx5_lag_mpesw_cleanup
|   `-- drivers-net-ethernet-mellanox-mlx5-core-lag-mpesw.h:warning:no-previous-prototype-for-function-mlx5_lag_mpesw_init
|-- riscv-randconfig-r042-20220519
|   |-- arch-riscv-include-asm-tlbflush.h:error:expected-assembly-time-absolute-expression
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-function-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ucode.c:warning:no-previous-prototype-for-function-amdgpu_ucode_print_imu_hdr
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v11_0.c:warning:no-previous-prototype-for-function-gfx_v11_0_rlc_stop
|   |-- drivers-gpu-drm-amd-amdgpu-imu_v11_0.c:warning:no-previous-prototype-for-function-program_imu_rlc_ram
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-function-soc21_grbm_select
|   |-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-function-ftrace_disable_ftrace_graph_caller
|   `-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-function-ftrace_enable_ftrace_graph_caller
`-- x86_64-randconfig-a003
    `-- ld.lld:error:undefined-symbol:blkcg_get_fc_appid

elapsed time: 1189m

configs tested: 102
configs skipped: 4

gcc tested configs:
arm                              allmodconfig
arm                              allyesconfig
arm64                            allyesconfig
arm                                 defconfig
arm64                               defconfig
x86_64                           allyesconfig
i386                             allyesconfig
ia64                             allmodconfig
mips                             allyesconfig
riscv                            allyesconfig
um                           x86_64_defconfig
riscv                            allmodconfig
um                             i386_defconfig
mips                             allmodconfig
powerpc                          allmodconfig
m68k                             allyesconfig
s390                             allmodconfig
s390                             allyesconfig
m68k                             allmodconfig
powerpc                          allyesconfig
i386                          randconfig-c001
sparc                            allyesconfig
parisc                           allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
arc                              allyesconfig
alpha                            allyesconfig
nios2                            allyesconfig
powerpc                     mpc83xx_defconfig
sh                           se7705_defconfig
powerpc                     taishan_defconfig
arm                             rpc_defconfig
m68k                       m5208evb_defconfig
m68k                        mvme147_defconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                                defconfig
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
nios2                               defconfig
powerpc                           allnoconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
arc                  randconfig-r043-20220519
riscv                    nommu_k210_defconfig
riscv                          rv32_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
riscv                             allnoconfig
x86_64                    rhel-8.3-kselftests
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-syz
x86_64                          rhel-8.3-func
x86_64                                  kexec
x86_64                               rhel-8.3
x86_64                              defconfig

clang tested configs:
powerpc                     mpc512x_defconfig
arm                          pxa168_defconfig
mips                      pic32mzda_defconfig
mips                  cavium_octeon_defconfig
mips                malta_qemu_32r6_defconfig
arm                       mainstone_defconfig
powerpc                   bluestone_defconfig
arm                          ixp4xx_defconfig
powerpc                  mpc866_ads_defconfig
mips                           rs90_defconfig
arm                         socfpga_defconfig
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
hexagon              randconfig-r041-20220519
hexagon              randconfig-r045-20220519
s390                 randconfig-r044-20220519
riscv                randconfig-r042-20220519

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
