Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D8252FA45
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 11:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiEUJTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 05:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiEUJTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 05:19:43 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB6613C1C4;
        Sat, 21 May 2022 02:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653124780; x=1684660780;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=cxZtWM+4zfVWZh8CJ/lp52uV9o1xbS01bnpUOMRVYdE=;
  b=d9XogswbtH+t/dmIwen/3vd/yNRN+yP7geogehDLoARuJwNZJEWHUrbl
   o/+s3QCTc8wTmGUC0EGww9LASNU129m2kq3YT5I1f2Mk2IytTee23yQ7O
   U5YKHpkbBpwQKjZHj7yBXKR6NUzP75H6u/J4yKqGZfvL/i1pj1x6GOgZY
   t6WBaDzlAarS5lHtr3/JlyDedUoi0nOM3MZn01LQ/8q7VlTJzQQRI2xRL
   EjwYtVWE791Jk5F4Biw40SHQGGyflbGQejaAZhdUvxfyhJcrpvlnQ0rHR
   QhDqe4Haf84XNfmQ1ZIANU97HYDHU9g+G7eGDbZqguJxUdnecF6px0F3X
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="272541646"
X-IronPort-AV: E=Sophos;i="5.91,242,1647327600"; 
   d="scan'208";a="272541646"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 02:19:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,242,1647327600"; 
   d="scan'208";a="557844186"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 21 May 2022 02:19:35 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nsLGo-00069q-NI;
        Sat, 21 May 2022 09:19:34 +0000
Date:   Sat, 21 May 2022 17:19:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-sh@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-mm@kvack.org,
        linux-hwmon@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bpf@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 18ecd30af1a8402c162cca1bd58771c0e5be7815
Message-ID: <6288ae86.BlL8pIJBtOKwrL6J%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 18ecd30af1a8402c162cca1bd58771c0e5be7815  Add linux-next specific files for 20220520

Error/Warning reports:

https://lore.kernel.org/linux-mm/202204291924.vTGZmerI-lkp@intel.com
https://lore.kernel.org/linux-mm/202205031017.4TwMan3l-lkp@intel.com
https://lore.kernel.org/linux-mm/202205041248.WgCwPcEV-lkp@intel.com
https://lore.kernel.org/linux-mm/202205122113.uLKzd3SZ-lkp@intel.com
https://lore.kernel.org/linux-mm/202205150051.3RzuooAG-lkp@intel.com
https://lore.kernel.org/linux-mm/202205150117.sd6HzBVm-lkp@intel.com
https://lore.kernel.org/linux-mm/202205192041.eAjgoXSY-lkp@intel.com
https://lore.kernel.org/linux-mm/202205192334.DNijFnTC-lkp@intel.com
https://lore.kernel.org/linux-mm/202205200219.llzx7zfy-lkp@intel.com
https://lore.kernel.org/linux-mm/202205201624.A4IhDdYX-lkp@intel.com
https://lore.kernel.org/linux-mm/202205210210.UpT8c7tZ-lkp@intel.com
https://lore.kernel.org/linux-mm/202205211550.ifuEnz5n-lkp@intel.com
https://lore.kernel.org/lkml/202205100617.5UUm3Uet-lkp@intel.com
https://lore.kernel.org/llvm/202205052057.2TyEsXsL-lkp@intel.com
https://lore.kernel.org/llvm/202205060132.uhqyUx1l-lkp@intel.com
https://lore.kernel.org/llvm/202205210041.hiIpWG5f-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

<command-line>: fatal error: ./include/generated/utsrelease.h: No such file or directory
arch/x86/kvm/hyperv.c:1959:22: error: shift count >= width of type [-Werror,-Wshift-count-overflow]
arch/x86/kvm/hyperv.c:1959:22: warning: shift count >= width of type [-Wshift-count-overflow]
arch/x86/kvm/pmu.h:20:32: warning: 'vmx_icl_pebs_cpu' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1364:5: warning: no previous prototype for 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c:1986:6: warning: no previous prototype for function 'gfx_v11_0_rlc_stop' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/soc21.c:171:6: warning: no previous prototype for 'soc21_grbm_select' [-Wmissing-prototypes]
drivers/gpu/drm/solomon/ssd130x-spi.c:154:35: warning: 'ssd130x_spi_table' defined but not used [-Wunused-const-variable=]
drivers/hwmon/nct6775-platform.c:199:9: sparse:    unsigned char
drivers/hwmon/nct6775-platform.c:199:9: sparse:    void
drivers/net/ethernet/dec/tulip/eeprom.c:120:54: error: 'struct pci_dev' has no member named 'pdev'; did you mean 'dev'?
drivers/ufs/host/ufs-exynos.c:1598:34: warning: unused variable 'exynos_ufs_of_match' [-Wunused-const-variable]
drivers/video/fbdev/omap/hwa742.c:492:5: warning: no previous prototype for 'hwa742_update_window_async' [-Wmissing-prototypes]
fs/buffer.c:2254:5: warning: stack frame size (2144) exceeds limit (1024) in 'block_read_full_folio' [-Wframe-larger-than]
fs/ntfs/aops.c:378:12: warning: stack frame size (2224) exceeds limit (1024) in 'ntfs_read_folio' [-Wframe-larger-than]
include/asm-generic/bitops/const_hweight.h:21:76: error: right shift count >= width of type [-Werror=shift-count-overflow]
include/asm-generic/bitops/const_hweight.h:21:76: warning: right shift count >= width of type [-Wshift-count-overflow]
kernel/trace/fgraph.c:37:12: warning: no previous prototype for function 'ftrace_enable_ftrace_graph_caller' [-Wmissing-prototypes]
kernel/trace/fgraph.c:46:12: warning: no previous prototype for function 'ftrace_disable_ftrace_graph_caller' [-Wmissing-prototypes]
llvm-objcopy: error: invalid output format: 'elf64-s390'

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
drivers/infiniband/hw/hns/hns_roce_hw_v2.c:309:9: sparse: sparse: dubious: x & !y
drivers/staging/vt6655/card.c:758:16: sparse: sparse: cast to restricted __le64
drivers/vdpa/virtio_pci/vp_vdpa.c:634:2: warning: Attempt to free released memory [clang-analyzer-unix.Malloc]
kernel/bpf/verifier.c:5354 process_kptr_func() warn: passing zero to 'PTR_ERR'
make[1]: *** No rule to make target 'arch/h8300/Makefile'.
mm/shmem.c:1949 shmem_getpage_gfp() warn: should '(((1) << 12) / 512) << folio_order(folio)' be a 64 bit type?
{standard input}:1991: Error: unknown pseudo-op: `.lc'

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
|-- alpha-randconfig-r025-20220519
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
|-- arc-randconfig-r043-20220519
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arm-allmodconfig
|   |-- arch-arm-mach-omap2-dma.c:Unneeded-variable:errata-Return-on-line
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|-- arm-allyesconfig
|   |-- arch-arm-mach-omap2-dma.c:Unneeded-variable:errata-Return-on-line
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|-- arm-multi_v7_defconfig
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- arm64-allmodconfig
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:dereference-of-noderef-expression
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-user_ctxs-noderef-__user-user-got-struct-user_ctxs
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- arm64-allyesconfig
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:dereference-of-noderef-expression
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-user_ctxs-noderef-__user-user-got-struct-user_ctxs
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
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
|-- h8300-randconfig-r012-20220519
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-s031-20220519
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allmodconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- include-asm-generic-bitops-const_hweight.h:warning:right-shift-count-width-of-type
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- i386-allyesconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|   `-- include-asm-generic-bitops-const_hweight.h:warning:right-shift-count-width-of-type
|-- i386-debian-10.3
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   `-- include-asm-generic-bitops-const_hweight.h:warning:right-shift-count-width-of-type
|-- i386-debian-10.3-kselftests
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   `-- include-asm-generic-bitops-const_hweight.h:warning:right-shift-count-width-of-type
|-- i386-randconfig-a003
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   `-- include-asm-generic-bitops-const_hweight.h:warning:right-shift-count-width-of-type
|-- i386-randconfig-a012
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-a012-20220509
|   `-- include-asm-generic-bitops-const_hweight.h:error:right-shift-count-width-of-type
|-- i386-randconfig-a014
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-a016
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-c021
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-m021
|   |-- kernel-bpf-verifier.c-process_kptr_func()-warn:passing-zero-to-PTR_ERR
|   `-- mm-shmem.c-shmem_getpage_gfp()-warn:should-((()-)-)-folio_order(folio)-be-a-bit-type
|-- i386-randconfig-s001
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|-- i386-randconfig-s002
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- ia64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- m68k-allmodconfig
|   |-- drivers-hwmon-nct6775-platform.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-hwmon-nct6775-platform.c:sparse:unsigned-char
|   `-- drivers-hwmon-nct6775-platform.c:sparse:void
|-- m68k-allyesconfig
|   |-- drivers-hwmon-nct6775-platform.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-hwmon-nct6775-platform.c:sparse:unsigned-char
|   `-- drivers-hwmon-nct6775-platform.c:sparse:void
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
|   |-- drivers-net-ethernet-dec-tulip-eeprom.c:error:struct-pci_dev-has-no-member-named-pdev
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- parisc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-net-ethernet-dec-tulip-eeprom.c:error:struct-pci_dev-has-no-member-named-pdev
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- parisc-defconfig
|   `-- drivers-net-ethernet-dec-tulip-eeprom.c:error:struct-pci_dev-has-no-member-named-pdev
|-- parisc-randconfig-s032-20220519
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|-- parisc64-defconfig
|   `-- drivers-net-ethernet-dec-tulip-eeprom.c:error:struct-pci_dev-has-no-member-named-pdev
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- powerpc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- powerpc-randconfig-c023-20220519
|   `-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|-- riscv-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- riscv-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- s390-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
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
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- sparc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- sparc-randconfig-r023-20220519
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- sparc64-buildonly-randconfig-r001-20220519
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- x86_64-allyesconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- x86_64-kexec
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-randconfig-a002
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-randconfig-a011
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- x86_64-randconfig-a015
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-randconfig-s021
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|-- x86_64-randconfig-s022
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
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
|-- xtensa-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
`-- xtensa-allyesconfig
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
    `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select

clang_recent_errors
|-- arm-randconfig-c002-20220519
|   `-- drivers-vdpa-virtio_pci-vp_vdpa.c:warning:Attempt-to-free-released-memory-clang-analyzer-unix.Malloc
|-- hexagon-randconfig-r001-20220519
|   `-- drivers-ufs-host-ufs-exynos.c:warning:unused-variable-exynos_ufs_of_match
|-- hexagon-randconfig-r005-20220519
|   |-- fs-buffer.c:warning:stack-frame-size-()-exceeds-limit-()-in-block_read_full_folio
|   `-- fs-ntfs-aops.c:warning:stack-frame-size-()-exceeds-limit-()-in-ntfs_read_folio
|-- i386-randconfig-a002
|   `-- arch-x86-kvm-hyperv.c:error:shift-count-width-of-type-Werror-Wshift-count-overflow
|-- i386-randconfig-a011
|   `-- arch-x86-kvm-hyperv.c:warning:shift-count-width-of-type
|-- riscv-randconfig-r042-20220519
|   |-- arch-riscv-include-asm-tlbflush.h:error:expected-assembly-time-absolute-expression
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-function-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ucode.c:warning:no-previous-prototype-for-function-amdgpu_ucode_print_imu_hdr
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v11_0.c:warning:no-previous-prototype-for-function-gfx_v11_0_rlc_stop
|   |-- drivers-gpu-drm-amd-amdgpu-imu_v11_0.c:warning:no-previous-prototype-for-function-program_imu_rlc_ram
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-function-soc21_grbm_select
|   |-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-function-ftrace_disable_ftrace_graph_caller
|   `-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-function-ftrace_enable_ftrace_graph_caller
`-- s390-randconfig-r024-20220519
    `-- llvm-objcopy:error:invalid-output-format:elf64-s390

elapsed time: 1087m

configs tested: 106
configs skipped: 3

gcc tested configs:
arm                              allyesconfig
arm                                 defconfig
arm64                               defconfig
arm64                            allyesconfig
arm                              allmodconfig
mips                             allyesconfig
um                           x86_64_defconfig
riscv                            allmodconfig
um                             i386_defconfig
mips                             allmodconfig
riscv                            allyesconfig
powerpc                          allmodconfig
m68k                             allyesconfig
s390                             allmodconfig
m68k                             allmodconfig
powerpc                          allyesconfig
s390                             allyesconfig
sparc                            allyesconfig
parisc                           allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
arc                              allyesconfig
alpha                            allyesconfig
nios2                            allyesconfig
mips                  maltasmvp_eva_defconfig
s390                          debug_defconfig
powerpc                      chrp32_defconfig
ia64                        generic_defconfig
powerpc                    klondike_defconfig
sh                                  defconfig
powerpc                        cell_defconfig
um                                  defconfig
ia64                         bigsur_defconfig
arm                        multi_v7_defconfig
arm                           h5000_defconfig
sh                          landisk_defconfig
m68k                       m5208evb_defconfig
mips                  decstation_64_defconfig
m68k                       bvme6000_defconfig
powerpc                     rainier_defconfig
ia64                             allmodconfig
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
i386                             allyesconfig
sparc                               defconfig
nios2                               defconfig
powerpc                           allnoconfig
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
arc                  randconfig-r043-20220519
riscv                             allnoconfig
riscv                    nommu_k210_defconfig
riscv                          rv32_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                                  kexec
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                    rhel-8.3-kselftests
x86_64                           rhel-8.3-syz

clang tested configs:
arm                       versatile_defconfig
arm                   milbeaut_m10v_defconfig
powerpc                 xes_mpc85xx_defconfig
arm                       cns3420vb_defconfig
mips                     loongson1c_defconfig
powerpc                     tqm8560_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
x86_64                        randconfig-a014
x86_64                        randconfig-a016
x86_64                        randconfig-a012
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
hexagon              randconfig-r041-20220519
hexagon              randconfig-r045-20220519
riscv                randconfig-r042-20220519
s390                 randconfig-r044-20220519

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
