Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D73E5277A6
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 15:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbiEONA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 09:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236579AbiEONAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 09:00:54 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E595F3A5;
        Sun, 15 May 2022 06:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652619650; x=1684155650;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=dDHrb8PYpGlr6mCttWzYn84AFrw78wXmHtyWuou1J90=;
  b=LlvkePFrE6yV8vbbKCL61XwN6I34VRqdTrt/+T2lJt5jid7fv36ADwhY
   tJArFYTFYlnnthWj2hiKak5ecZJKef68FBSG1wGE3SmT5eqGYoa/bvT8o
   xTAm7im9SZf0b5AIK/JO6CXRzSq3lqTfSUPq2WPiO1Mzja7JvKdqssfGB
   cOaGp2Bq5IOkRcqIx9Qs6+jVSSXhufSJa41Ax1Di7+9AxXu46f9S921mv
   2jQo/HfCp6hDv5phKuDj50Pqy9aJPdOPU2UzjQCk8E43pCeVurfryQeNv
   l+AjkT8sr2MnczRbesNBjdVef7VskoW9fuoT0KlSLQBqC3vjfEoJCnaJk
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10348"; a="251144977"
X-IronPort-AV: E=Sophos;i="5.91,228,1647327600"; 
   d="scan'208";a="251144977"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2022 06:00:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,228,1647327600"; 
   d="scan'208";a="896834710"
Received: from lkp-server01.sh.intel.com (HELO d1462bc4b09b) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 15 May 2022 06:00:42 -0700
Received: from kbuild by d1462bc4b09b with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nqDrV-0001eT-GO;
        Sun, 15 May 2022 13:00:41 +0000
Date:   Sun, 15 May 2022 21:00:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-sh@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-mm@kvack.org, linux-mips@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kunit-dev@googlegroups.com, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 1e1b28b936aed946122b4e0991e7144fdbbfd77e
Message-ID: <6280f965.kTCPpIEVY9TwoNre%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 1e1b28b936aed946122b4e0991e7144fdbbfd77e  Add linux-next specific files for 20220513

Error/Warning reports:

https://lore.kernel.org/linux-mm/202204181931.klAC6fWo-lkp@intel.com
https://lore.kernel.org/linux-mm/202204291924.vTGZmerI-lkp@intel.com
https://lore.kernel.org/linux-mm/202205031017.4TwMan3l-lkp@intel.com
https://lore.kernel.org/linux-mm/202205041248.WgCwPcEV-lkp@intel.com
https://lore.kernel.org/linux-mm/202205122113.uLKzd3SZ-lkp@intel.com
https://lore.kernel.org/linux-mm/202205150051.3RzuooAG-lkp@intel.com
https://lore.kernel.org/linux-mm/202205150117.sd6HzBVm-lkp@intel.com
https://lore.kernel.org/lkml/202205100617.5UUm3Uet-lkp@intel.com
https://lore.kernel.org/llvm/202204210555.DNvfHvIb-lkp@intel.com
https://lore.kernel.org/llvm/202205060132.uhqyUx1l-lkp@intel.com
https://lore.kernel.org/llvm/202205120010.zWBednzM-lkp@intel.com
https://lore.kernel.org/llvm/202205141122.qihFGUem-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

<command-line>: fatal error: ./include/generated/utsrelease.h: No such file or directory
arch/arm/mach-versatile/versatile.c:56:14: warning: no previous prototype for function 'mmc_status' [-Wmissing-prototypes]
arch/x86/kvm/pmu.h:20:32: warning: 'vmx_icl_pebs_cpu' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5102:7: warning: variable 'allow_lttpr_non_transparent_mode' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5147:6: warning: no previous prototype for function 'dp_parse_lttpr_mode' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1364:5: warning: no previous prototype for 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c:1983:6: warning: no previous prototype for function 'gfx_v11_0_rlc_stop' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/soc21.c:171:6: warning: no previous prototype for 'soc21_grbm_select' [-Wmissing-prototypes]
drivers/gpu/drm/solomon/ssd130x-spi.c:154:35: warning: 'ssd130x_spi_table' defined but not used [-Wunused-const-variable=]
drivers/hwmon/nct6775-platform.c:199:9: sparse:    unsigned char
drivers/hwmon/nct6775-platform.c:199:9: sparse:    void
drivers/video/fbdev/omap/hwa742.c:492:5: warning: no previous prototype for 'hwa742_update_window_async' [-Wmissing-prototypes]
fs/buffer.c:2254:5: warning: stack frame size (2144) exceeds limit (1024) in 'block_read_full_folio' [-Wframe-larger-than]
fs/ntfs/aops.c:378:12: warning: stack frame size (2224) exceeds limit (1024) in 'ntfs_read_folio' [-Wframe-larger-than]
kernel/trace/fgraph.c:37:12: warning: no previous prototype for 'ftrace_enable_ftrace_graph_caller' [-Wmissing-prototypes]
kernel/trace/fgraph.c:46:12: warning: no previous prototype for 'ftrace_disable_ftrace_graph_caller' [-Wmissing-prototypes]

Unverified Error/Warning (likely false positive, please contact us if interested):

Makefile:686: arch/h8300/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5102:14: warning: variable 'allow_lttpr_non_transparent_mode' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5147:6: warning: no previous prototype for 'dp_parse_lttpr_mode' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1364:5: warning: no previous prototype for function 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c:129:6: warning: no previous prototype for function 'amdgpu_ucode_print_imu_hdr' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/imu_v11_0.c:302:6: warning: no previous prototype for function 'program_imu_rlc_ram' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/soc21.c:171:6: warning: no previous prototype for function 'soc21_grbm_select' [-Wmissing-prototypes]
drivers/gpu/drm/bridge/adv7511/adv7511.h:229:17: warning: 'ADV7511_REG_CEC_RX_FRAME_HDR' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/bridge/adv7511/adv7511.h:235:17: warning: 'ADV7511_REG_CEC_RX_FRAME_LEN' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:276:27: error: implicit declaration of function 'sysfs_gt_attribute_r_max_func' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:327:16: error: implicit declaration of function 'sysfs_gt_attribute_w_func' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:416:24: error: implicit declaration of function 'sysfs_gt_attribute_r_min_func' [-Werror=implicit-function-declaration]
drivers/pinctrl/pinctrl-ingenic.c:162 is_soc_or_above() warn: bitwise AND condition is false here
drivers/staging/vt6655/card.c:759:16: sparse: sparse: cast to restricted __le64
kernel/bpf/verifier.c:5354 process_kptr_func() warn: passing zero to 'PTR_ERR'
kismet: WARNING: unmet direct dependencies detected for DRM_DP_AUX_BUS when selected by DRM_MSM
kismet: WARNING: unmet direct dependencies detected for NVMEM_SUNPLUS_OCOTP when selected by SP7021_EMAC
make[1]: *** No rule to make target 'arch/h8300/Makefile'.
mm/shmem.c:1910 shmem_getpage_gfp() warn: should '(((1) << 12) / 512) << folio_order(folio)' be a 64 bit type?
{standard input}:1991: Error: unknown pseudo-op: `.lc'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- arc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- arc-randconfig-r011-20220512
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arm-allmodconfig
|   |-- arch-arm-mach-omap2-dma.c:Unneeded-variable:errata-Return-on-line
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|-- arm-allyesconfig
|   |-- arch-arm-mach-omap2-dma.c:Unneeded-variable:errata-Return-on-line
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|-- arm64-allmodconfig
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:dereference-of-noderef-expression
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-user_ctxs-noderef-__user-user-got-struct-user_ctxs
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- arm64-allyesconfig
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:dereference-of-noderef-expression
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-user_ctxs-noderef-__user-user-got-struct-user_ctxs
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- csky-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- csky-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- h8300-allmodconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-allyesconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-c004-20220512
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r012-20220512
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allmodconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- i386-allyesconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- i386-randconfig-a003
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- i386-randconfig-a012
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
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
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- ia64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- m68k-allmodconfig
|   |-- drivers-hwmon-nct6775-platform.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-hwmon-nct6775-platform.c:sparse:unsigned-char
|   |-- drivers-hwmon-nct6775-platform.c:sparse:void
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   `-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|-- m68k-allyesconfig
|   |-- drivers-hwmon-nct6775-platform.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-hwmon-nct6775-platform.c:sparse:unsigned-char
|   |-- drivers-hwmon-nct6775-platform.c:sparse:void
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   `-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|-- microblaze-randconfig-r013-20220512
|   |-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_disable_ftrace_graph_caller
|   `-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_enable_ftrace_graph_caller
|-- microblaze-randconfig-r026-20220512
|   |-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_disable_ftrace_graph_caller
|   `-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_enable_ftrace_graph_caller
|-- mips-allmodconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- mips-allyesconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- mips-randconfig-r002-20220512
|   |-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_disable_ftrace_graph_caller
|   `-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_enable_ftrace_graph_caller
|-- mips-randconfig-r006-20220512
|   |-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_disable_ftrace_graph_caller
|   `-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_enable_ftrace_graph_caller
|-- nios2-allmodconfig
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   `-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|-- nios2-allyesconfig
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   `-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|-- openrisc-randconfig-m031-20220512
|   |-- drivers-pinctrl-pinctrl-ingenic.c-is_soc_or_above()-warn:bitwise-AND-condition-is-false-here
|   `-- kernel-bpf-verifier.c-process_kptr_func()-warn:passing-zero-to-PTR_ERR
|-- parisc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- parisc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- parisc64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- powerpc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- riscv-allmodconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- riscv-allyesconfig
|   |-- command-line:fatal-error:.-include-generated-utsrelease.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- s390-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   `-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|-- sh-allmodconfig
|   |-- arch-sh-kernel-crash_dump.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-addr-got-void-noderef-__iomem
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-ptr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- standard-input:Error:unknown-pseudo-op:lc
|-- sh-allyesconfig
|   |-- arch-sh-kernel-crash_dump.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-addr-got-void-noderef-__iomem
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-ptr-got-restricted-__le32
|   `-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|-- sparc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- sparc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|-- sparc64-randconfig-c004-20220512
|   `-- lib-kunit-executor.c:WARNING-opportunity-for-kmemdup
|-- x86_64-allmodconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- x86_64-allnoconfig
|   |-- kismet:WARNING:unmet-direct-dependencies-detected-for-DRM_DP_AUX_BUS-when-selected-by-DRM_MSM
|   `-- kismet:WARNING:unmet-direct-dependencies-detected-for-NVMEM_SUNPLUS_OCOTP-when-selected-by-SP7021_EMAC
|-- x86_64-allyesconfig
|   |-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- x86_64-kexec
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-randconfig-a002
|   `-- arch-x86-kvm-pmu.h:warning:vmx_icl_pebs_cpu-defined-but-not-used
|-- x86_64-randconfig-a011
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_max_func
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_min_func
|   `-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_w_func
|-- x86_64-randconfig-c001
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- x86_64-randconfig-c002
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_max_func
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_min_func
|   `-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_w_func
|-- x86_64-randconfig-s021
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
|-- xtensa-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
`-- xtensa-allyesconfig
    |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-dp_parse_lttpr_mode
    |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
    `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select

clang_recent_errors
|-- arm-multi_v5_defconfig
|   `-- arch-arm-mach-versatile-versatile.c:warning:no-previous-prototype-for-function-mmc_status
|-- arm64-buildonly-randconfig-r002-20220512
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-function-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-function-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ucode.c:warning:no-previous-prototype-for-function-amdgpu_ucode_print_imu_hdr
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v11_0.c:warning:no-previous-prototype-for-function-gfx_v11_0_rlc_stop
|   |-- drivers-gpu-drm-amd-amdgpu-imu_v11_0.c:warning:no-previous-prototype-for-function-program_imu_rlc_ram
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-function-soc21_grbm_select
|-- hexagon-randconfig-r041-20220513
|   |-- fs-buffer.c:warning:stack-frame-size-()-exceeds-limit-()-in-block_read_full_folio
|   `-- fs-ntfs-aops.c:warning:stack-frame-size-()-exceeds-limit-()-in-ntfs_read_folio
|-- riscv-allnoconfig
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-kallsyms_on_each_symbol:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_names
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-kallsyms_on_each_symbol:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_num_syms
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-kallsyms_on_each_symbol:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_offsets
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-kallsyms_on_each_symbol:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_relative_base
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-kallsyms_on_each_symbol:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_token_index
|   `-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-kallsyms_on_each_symbol:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_token_table
|-- riscv-randconfig-r031-20220512
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:no-previous-prototype-for-function-dp_parse_lttpr_mode
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:variable-allow_lttpr_non_transparent_mode-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-function-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ucode.c:warning:no-previous-prototype-for-function-amdgpu_ucode_print_imu_hdr
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v11_0.c:warning:no-previous-prototype-for-function-gfx_v11_0_rlc_stop
|   |-- drivers-gpu-drm-amd-amdgpu-imu_v11_0.c:warning:no-previous-prototype-for-function-program_imu_rlc_ram
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-function-soc21_grbm_select
`-- riscv-randconfig-r032-20220512
    `-- ld.lld:error:init-built-in.a(main.o):(function-__traceiter_initcall_level:.text):relocation-R_RISCV_HI20-out-of-range:is-not-in-references-initcall_level

elapsed time: 3078m

configs tested: 116
configs skipped: 3

gcc tested configs:
arm                              allmodconfig
arm                                 defconfig
arm64                               defconfig
arm                              allyesconfig
arm64                            allyesconfig
i386                          randconfig-c001
powerpc              randconfig-c003-20220512
i386                             allyesconfig
ia64                             allmodconfig
mips                             allyesconfig
riscv                            allyesconfig
um                           x86_64_defconfig
riscv                            allmodconfig
um                             i386_defconfig
mips                             allmodconfig
m68k                             allyesconfig
s390                             allmodconfig
m68k                             allmodconfig
powerpc                          allyesconfig
s390                             allyesconfig
powerpc                          allmodconfig
sparc                            allyesconfig
parisc                           allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
arc                              allyesconfig
alpha                            allyesconfig
nios2                            allyesconfig
arm                         nhk8815_defconfig
powerpc                  storcenter_defconfig
arm                            pleb_defconfig
powerpc                      mgcoge_defconfig
sparc                       sparc32_defconfig
m68k                        mvme16x_defconfig
arc                     haps_hs_smp_defconfig
mips                           ip32_defconfig
nios2                         3c120_defconfig
m68k                       m5208evb_defconfig
sh                           se7712_defconfig
powerpc                     rainier_defconfig
arm                            qcom_defconfig
powerpc                    adder875_defconfig
sh                                  defconfig
sh                         apsh4a3a_defconfig
arm                           corgi_defconfig
sh                        sh7785lcr_defconfig
arm                        trizeps4_defconfig
x86_64                        randconfig-c001
arm                  randconfig-c002-20220512
ia64                                defconfig
ia64                             allyesconfig
m68k                                defconfig
alpha                               defconfig
csky                                defconfig
nios2                               defconfig
arc                                 defconfig
parisc                              defconfig
s390                                defconfig
parisc64                            defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
sparc                               defconfig
powerpc                           allnoconfig
x86_64                        randconfig-a002
x86_64                        randconfig-a006
x86_64                        randconfig-a004
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
arc                  randconfig-r043-20220512
s390                 randconfig-r044-20220512
riscv                randconfig-r042-20220512
riscv                             allnoconfig
riscv                    nommu_k210_defconfig
riscv                          rv32_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                                  kexec
x86_64                          rhel-8.3-func
x86_64                               rhel-8.3
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-syz
x86_64                    rhel-8.3-kselftests

clang tested configs:
powerpc                          allyesconfig
powerpc                     tqm5200_defconfig
powerpc                        icon_defconfig
arm                        multi_v5_defconfig
powerpc                  mpc885_ads_defconfig
powerpc                     pseries_defconfig
arm                           spitz_defconfig
powerpc                 mpc8272_ads_defconfig
powerpc                     tqm8560_defconfig
mips                        maltaup_defconfig
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a016
x86_64                        randconfig-a012
x86_64                        randconfig-a014
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
hexagon              randconfig-r041-20220512
hexagon              randconfig-r045-20220512

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
