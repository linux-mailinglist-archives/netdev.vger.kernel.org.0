Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5AE536EA1
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 23:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiE1V3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 17:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiE1V3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 17:29:07 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1C9E2788;
        Sat, 28 May 2022 14:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653773344; x=1685309344;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=rNpCc7WSe3ferawQYDypuSLt/chEhlgLqj2SCSPJvd8=;
  b=BI6oOtPd/RqILd8Ew11FAWUsriGPCdsoJSlmnZ5RXsRFEWMtrgDAfCUV
   V18V2cZ2qO3HFu9m/EAGpLrE7kBnfonPSKfNDUhb/Zpsn52wOgfJ2TI3R
   ZPQHG2GGWHXtmG1JqHalXIJ6uUO7pyq668mXiZIe6HXIEuVigyTQEcm/8
   v527ehFJg0w85KpbbBJq+sZY2HHzJYlXNdyyJ2CwxKuZsj5eEcggM4FB5
   cHjAJ4MVew/CcksaL3KPOr6cU2OJMGq34XyrqzfJOMMkZAKBzB3ryPgIh
   4iLYh4HPlBa2OZNMsrXPEQf/iF/G9Hd3e9xnNqqmnWIr5FlGpdjawNn7d
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10361"; a="337759106"
X-IronPort-AV: E=Sophos;i="5.91,259,1647327600"; 
   d="scan'208";a="337759106"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2022 14:29:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,259,1647327600"; 
   d="scan'208";a="561419741"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 28 May 2022 14:28:59 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nv3zW-0000Xw-UY;
        Sat, 28 May 2022 21:28:58 +0000
Date:   Sun, 29 May 2022 05:28:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-riscv@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-parport@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-input@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bpf@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 d3fde8ff50ab265749704bd7fbcf70d35235421f
Message-ID: <62929407.W5RRq61c3EX0H7F2%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: d3fde8ff50ab265749704bd7fbcf70d35235421f  Add linux-next specific files for 20220527

Error/Warning reports:

https://lore.kernel.org/linux-mm/202205031017.4TwMan3l-lkp@intel.com
https://lore.kernel.org/linux-mm/202205041248.WgCwPcEV-lkp@intel.com
https://lore.kernel.org/linux-mm/202205150051.3RzuooAG-lkp@intel.com
https://lore.kernel.org/linux-mm/202205150117.sd6HzBVm-lkp@intel.com
https://lore.kernel.org/linux-mm/202205211550.ifuEnz5n-lkp@intel.com
https://lore.kernel.org/linux-mm/202205281607.E8GoKzmW-lkp@intel.com
https://lore.kernel.org/lkml/202205100617.5UUm3Uet-lkp@intel.com
https://lore.kernel.org/llvm/202205060132.uhqyUx1l-lkp@intel.com
https://lore.kernel.org/llvm/202205110148.mrGBBmTn-lkp@intel.com
https://lore.kernel.org/llvm/202205141122.qihFGUem-lkp@intel.com
https://lore.kernel.org/llvm/202205280829.utNOVd5s-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

WARNING: modpost: vmlinux.o(.text.unlikely+0x11f90): Section mismatch in reference from the function find_next_bit() to the variable .init.rodata:__setup_str_initcall_blacklist
drivers/gpu/drm/amd/amdgpu/../display/include/ddc_service_types.h:130:17: warning: 'DP_SINK_BRANCH_DEV_NAME_7580' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_7_ppt.c:1407:12: warning: stack frame size (1040) exceeds limit (1024) in 'smu_v13_0_7_get_power_profile_mode' [-Wframe-larger-than]
drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c:1986:6: warning: no previous prototype for function 'gfx_v11_0_rlc_stop' [-Wmissing-prototypes]
drivers/gpu/drm/solomon/ssd130x-spi.c:154:35: warning: 'ssd130x_spi_table' defined but not used [-Wunused-const-variable=]
drivers/video/fbdev/omap/hwa742.c:492:5: warning: no previous prototype for 'hwa742_update_window_async' [-Wmissing-prototypes]
fs/buffer.c:2254:5: warning: stack frame size (2144) exceeds limit (1024) in 'block_read_full_folio' [-Wframe-larger-than]
fs/ntfs/aops.c:378:12: warning: stack frame size (2216) exceeds limit (1024) in 'ntfs_read_folio' [-Wframe-larger-than]
kernel/trace/fgraph.c:37:12: warning: no previous prototype for 'ftrace_enable_ftrace_graph_caller' [-Wmissing-prototypes]
kernel/trace/fgraph.c:46:12: warning: no previous prototype for 'ftrace_disable_ftrace_graph_caller' [-Wmissing-prototypes]
llvm-objcopy: error: invalid output format: 'elf64-s390'

Unverified Error/Warning (likely false positive, please contact us if interested):

.__mulsi3.o.cmd: No such file or directory
<inline asm>:27:6: error: expected assembly-time absolute expression
Makefile:686: arch/h8300/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
arch/riscv/include/asm/pgtable-64.h:109:2: error: expected assembly-time absolute expression
arch/riscv/kernel/cpufeature.c:292:6: warning: variable 'cpu_apply_feature' set but not used [-Wunused-but-set-variable]
arch/riscv/purgatory/kexec-purgatory.c:1860:9: sparse: sparse: trying to concatenate 29720-character string (8191 bytes max)
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1133 amdgpu_discovery_reg_base_init() error: testing array offset 'adev->vcn.num_vcn_inst' after use.
drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c:129:6: warning: no previous prototype for function 'amdgpu_ucode_print_imu_hdr' [-Wmissing-prototypes]
drivers/gpu/drm/bridge/adv7511/adv7511.h:229:17: warning: 'ADV7511_REG_CEC_RX_FRAME_HDR' defined but not used [-Wunused-const-variable=]
drivers/gpu/drm/bridge/adv7511/adv7511.h:235:17: warning: 'ADV7511_REG_CEC_RX_FRAME_LEN' defined but not used [-Wunused-const-variable=]
drivers/iio/accel/bma400_core.c:1056:3: warning: Assigned value is garbage or undefined [clang-analyzer-core.uninitialized.Assign]
drivers/infiniband/hw/hns/hns_roce_hw_v2.c:309:9: sparse: sparse: dubious: x & !y
drivers/input/joystick/sensehat-joystick.c:102:2-9: line 102 is redundant because platform_get_irq() already prints an error
drivers/input/misc/iqs7222.c:2418:9-34: WARNING: Threaded IRQ with no primary handler requested without IRQF_ONESHOT (unless it is nested IRQ)
drivers/misc/cardreader/rts5261.c:406:13: warning: variable 'setting_reg2' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
drivers/pinctrl/stm32/pinctrl-stm32.c:294:24: warning: Value stored to 'pctl' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/rpmsg/rpmsg_core.c:607:3: warning: Call to function 'strcpy' is insecure as it does not provide bounding of the memory buffer. Replace unbounded copy functions with analogous functions that support length arguments such as 'strlcpy'. CWE-119 [clang-analyzer-security.insecureAPI.strcpy]
drivers/staging/rtl8723bs/hal/hal_btcoex.c:1182:30: warning: variable 'pHalData' set but not used [-Wunused-but-set-variable]
drivers/staging/vt6655/card.c:758:16: sparse: sparse: cast to restricted __le64
drivers/ufs/host/tc-dwc-g210-pltfrm.c:36:34: warning: unused variable 'tc_dwc_g210_pltfm_match' [-Wunused-const-variable]
include/linux/workqueue.h:610:2: warning: call to __warn_flushing_systemwide_wq declared with 'warning' attribute: Please avoid flushing system-wide workqueues. [-Wattribute-warning]
include/linux/workqueue.h:610:9: warning: call to '__warn_flushing_systemwide_wq' declared with attribute warning: Please avoid flushing system-wide workqueues. [-Wattribute-warning]
kernel/bpf/helpers.c:1490:29: sparse: sparse: symbol 'bpf_dynptr_from_mem_proto' was not declared. Should it be static?
kernel/bpf/helpers.c:1516:29: sparse: sparse: symbol 'bpf_dynptr_read_proto' was not declared. Should it be static?
kernel/bpf/helpers.c:1542:29: sparse: sparse: symbol 'bpf_dynptr_write_proto' was not declared. Should it be static?
kernel/bpf/helpers.c:1569:29: sparse: sparse: symbol 'bpf_dynptr_data_proto' was not declared. Should it be static?
ld.lld: warning: call to __warn_flushing_systemwide_wq marked "dontcall-warn": Please avoid flushing system-wide workqueues.
make[1]: *** No rule to make target 'arch/h8300/Makefile'.
powerpc64-linux-ld: drivers/gpu/drm/display/drm_dp_helper.o:arch/powerpc/include/asm/paca.h:286: multiple definition of `____cacheline_aligned'; drivers/gpu/drm/display/drm_dp_dual_mode_helper.o:arch/powerpc/include/asm/paca.h:286: first defined here
powerpc64-linux-ld: drivers/ufs/core/ufs-sysfs.o:arch/powerpc/include/asm/paca.h:286: multiple definition of `____cacheline_aligned'; drivers/ufs/core/ufshcd.o:arch/powerpc/include/asm/paca.h:286: first defined here
riscv64-linux-ld: arch/riscv/kernel/compat_syscall_table.o:(.rodata+0x6f8): undefined reference to `compat_sys_fadvise64_64'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- arc-randconfig-m031-20220524
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c-amdgpu_discovery_reg_base_init()-error:testing-array-offset-adev-vcn.num_vcn_inst-after-use.
|-- arc-randconfig-s031-20220527
|   `-- drivers-misc-lkdtm-cfi.c:sparse:sparse:Using-plain-integer-as-NULL-pointer
|-- arm-allmodconfig
|   |-- arch-arm-mach-omap2-dma.c:Unneeded-variable:errata-Return-on-line
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|   |-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- arm-allyesconfig
|   |-- arch-arm-mach-omap2-dma.c:Unneeded-variable:errata-Return-on-line
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- drivers-video-fbdev-omap-hwa742.c:warning:no-previous-prototype-for-hwa742_update_window_async
|   |-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- arm64-allmodconfig
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:dereference-of-noderef-expression
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-user_ctxs-noderef-__user-user-got-struct-user_ctxs
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- arm64-allyesconfig
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:dereference-of-noderef-expression
|   |-- arch-arm64-kernel-signal.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-user_ctxs-noderef-__user-user-got-struct-user_ctxs
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-stackleak.c:sparse:sparse:symbol-stackleak_erase_off_task_stack-was-not-declared.-Should-it-be-static
|-- arm64-randconfig-r012-20220526
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- arm64-randconfig-r016-20220524
|   |-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_disable_ftrace_graph_caller
|   `-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_enable_ftrace_graph_caller
|-- csky-allyesconfig
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- csky-randconfig-r013-20220524
|   |-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_disable_ftrace_graph_caller
|   `-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_enable_ftrace_graph_caller
|-- csky-randconfig-s032-20220524
|   `-- drivers-vfio-pci-vfio_pci_config.c:sparse:sparse:restricted-pci_power_t-degrades-to-integer
|-- h8300-allmodconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-allyesconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-buildonly-randconfig-r004-20220524
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-p002-20220524
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r005-20220524
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r006-20220524
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r011-20220524
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r012-20220524
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r015-20220524
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r015-20220526
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r025-20220524
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allmodconfig
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-include-ddc_service_types.h:warning:DP_SINK_BRANCH_DEV_NAME_7580-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- i386-debian-10.3-kselftests
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- i386-randconfig-a005
|   `-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|-- i386-randconfig-a012
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-a014
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-a016
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-c001
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- i386-randconfig-c021
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   `-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|-- i386-randconfig-s001
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|-- i386-randconfig-s002
|   `-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|-- ia64-allyesconfig
|   `-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|-- m68k-allmodconfig
|   |-- drivers-block-paride-bpck.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-comm.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-dstr.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-epat.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-epia.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-friq.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-frpw.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-kbic.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-on26.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-block-paride-ppc6lnx.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-comedi-drivers-aio_aio12_8.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-comedi-drivers-das16m1.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-comedi-drivers-ni_at_ao.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-comedi-drivers-ni_daq_700.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-ethernet-apne.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-ethernet-xircom-xirc2ps_cs.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- drivers-tty-ipwireless-hardware.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-restricted-__le16-usertype-raw_data-got-int
|   |-- drivers-tty-ipwireless-hardware.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-unsigned-short-unused-usertype-__v-got-restricted-__le16-assigned-usertype-raw_data
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- microblaze-randconfig-r011-20220526
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- microblaze-randconfig-r013-20220529
|   |-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_disable_ftrace_graph_caller
|   `-- kernel-trace-fgraph.c:warning:no-previous-prototype-for-ftrace_enable_ftrace_graph_caller
|-- mips-allmodconfig
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- mips-allyesconfig
|   |-- drivers-input-joystick-sensehat-joystick.c:line-is-redundant-because-platform_get_irq()-already-prints-an-error
|   |-- drivers-input-misc-iqs7222.c:WARNING:Threaded-IRQ-with-no-primary-handler-requested-without-IRQF_ONESHOT-(unless-it-is-nested-IRQ)
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- nios2-allmodconfig
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- nios2-allyesconfig
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- openrisc-randconfig-r015-20220524
|   `-- __mulsi3.o.cmd:No-such-file-or-directory
|-- openrisc-randconfig-r015-20220529
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- powerpc-allmodconfig
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- powerpc-allyesconfig
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- powerpc-randconfig-r015-20220524
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- powerpc64-randconfig-r011-20220526
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- powerpc64-randconfig-r023-20220526
|   |-- multiple-definition-of-____cacheline_aligned-drivers-gpu-drm-display-drm_dp_dual_mode_helper.o:arch-powerpc-include-asm-paca.h:first-defined-here
|   `-- multiple-definition-of-____cacheline_aligned-drivers-ufs-core-ufshcd.o:arch-powerpc-include-asm-paca.h:first-defined-here
|-- riscv-allmodconfig
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- riscv-allyesconfig
|   |-- arch-riscv-kernel-machine_kexec.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-got-void-noderef-__user-buf
|   |-- arch-riscv-purgatory-kexec-purgatory.c:sparse:sparse:trying-to-concatenate-character-string-(-bytes-max)
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-fork.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-atomic_t-usertype-lock-got-struct-atomic_t-noderef-__rcu
|   `-- kernel-seccomp.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-atomic_t-usertype-lock-got-struct-atomic_t-noderef-__rcu
|-- riscv-randconfig-r013-20220524
|   `-- riscv64-linux-ld:arch-riscv-kernel-compat_syscall_table.o:(.rodata):undefined-reference-to-compat_sys_fadvise64_64
|-- riscv-randconfig-r016-20220524
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- s390-allmodconfig
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- s390-allyesconfig
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- sh-allmodconfig
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- sparc-allmodconfig
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- sparc-allyesconfig
|   |-- drivers-infiniband-hw-hns-hns_roce_hw_v2.c:sparse:sparse:dubious:x-y
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- drivers-staging-vt6655-card.c:sparse:sparse:cast-to-restricted-__le64
|   |-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- x86_64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-include-ddc_service_types.h:warning:DP_SINK_BRANCH_DEV_NAME_7580-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- x86_64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-include-ddc_service_types.h:warning:DP_SINK_BRANCH_DEV_NAME_7580-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:ssd13_spi_table-defined-but-not-used
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- x86_64-randconfig-a011
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- x86_64-randconfig-s021
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_HDR-defined-but-not-used
|   |-- drivers-gpu-drm-bridge-adv7511-adv7511.h:warning:ADV7511_REG_CEC_RX_FRAME_LEN-defined-but-not-used
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- kernel-signal.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-lockdep_map-const-lock-got-struct-lockdep_map-noderef-__rcu
|   `-- lib-iov_iter.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-p-got-void-noderef-__user-assigned-base
|-- x86_64-randconfig-s022
|   |-- drivers-pci-pci.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-pci_power_t-assigned-usertype-state-got-int
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_data_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_from_mem_proto-was-not-declared.-Should-it-be-static
|   |-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_read_proto-was-not-declared.-Should-it-be-static
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_dynptr_write_proto-was-not-declared.-Should-it-be-static
|-- x86_64-rhel-8.3-kselftests
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
|-- xtensa-randconfig-r016-20220526
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-attribute-warning:Please-avoid-flushing-system-wide-workqueues.
`-- xtensa-randconfig-r036-20220524
    `-- Section-mismatch-in-reference-from-the-function-find_next_bit()-to-the-variable-.init.rodata:str_initcall_blacklist

clang_recent_errors
|-- arm-randconfig-c002-20220524
|   |-- drivers-iio-accel-bma400_core.c:warning:Assigned-value-is-garbage-or-undefined-clang-analyzer-core.uninitialized.Assign
|   `-- drivers-pinctrl-stm32-pinctrl-stm32.c:warning:Value-stored-to-pctl-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
|-- arm-randconfig-c002-20220527
|   `-- drivers-rpmsg-rpmsg_core.c:warning:Call-to-function-strcpy-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer.-Replace-unbounded-copy-functions-with-analogous-functions-that-support-leng
|-- arm-randconfig-r013-20220524
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-warning-attribute:Please-avoid-flushing-system-wide-workqueues.
|-- hexagon-randconfig-r033-20220529
|   `-- drivers-ufs-host-tc-dwc-g210-pltfrm.c:warning:unused-variable-tc_dwc_g210_pltfm_match
|-- hexagon-randconfig-r034-20220524
|   |-- fs-buffer.c:warning:stack-frame-size-()-exceeds-limit-()-in-block_read_full_folio
|   `-- fs-ntfs-aops.c:warning:stack-frame-size-()-exceeds-limit-()-in-ntfs_read_folio
|-- i386-randconfig-a013
|   |-- drivers-misc-cardreader-rts5261.c:warning:variable-setting_reg2-is-used-uninitialized-whenever-if-condition-is-false
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-warning-attribute:Please-avoid-flushing-system-wide-workqueues.
|-- powerpc-randconfig-r033-20220526
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_7_ppt.c:warning:stack-frame-size-()-exceeds-limit-()-in-smu_v13_0_7_get_power_profile_mode
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ucode.c:warning:no-previous-prototype-for-function-amdgpu_ucode_print_imu_hdr
|   `-- drivers-gpu-drm-amd-amdgpu-gfx_v11_0.c:warning:no-previous-prototype-for-function-gfx_v11_0_rlc_stop
|-- riscv-randconfig-c006-20220524
|   |-- arch-riscv-include-asm-pgtable-.h:error:expected-assembly-time-absolute-expression
|   `-- inline-asm:error:expected-assembly-time-absolute-expression
|-- riscv-randconfig-r016-20220527
|   `-- arch-riscv-kernel-cpufeature.c:warning:variable-cpu_apply_feature-set-but-not-used
|-- riscv-randconfig-r042-20220527
|   |-- arch-riscv-kernel-cpufeature.c:warning:variable-cpu_apply_feature-set-but-not-used
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-get_symbol_offset:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_markers
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-get_symbol_offset:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_names
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-kallsyms_on_each_symbol:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_num_syms
|   |-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-kallsyms_on_each_symbol:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_offsets
|   `-- ld.lld:error:kernel-built-in.a(kallsyms.o):(function-kallsyms_on_each_symbol:.text):relocation-R_RISCV_PCREL_HI20-out-of-range:is-not-in-references-kallsyms_relative_base
|-- s390-randconfig-r012-20220529
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_ucode.c:warning:no-previous-prototype-for-function-amdgpu_ucode_print_imu_hdr
|   |-- drivers-gpu-drm-amd-amdgpu-gfx_v11_0.c:warning:no-previous-prototype-for-function-gfx_v11_0_rlc_stop
|   `-- llvm-objcopy:error:invalid-output-format:elf64-s390
|-- s390-randconfig-r036-20220524
|   `-- llvm-objcopy:error:invalid-output-format:elf64-s390
|-- x86_64-randconfig-a014
|   |-- drivers-misc-cardreader-rts5261.c:warning:variable-setting_reg2-is-used-uninitialized-whenever-if-condition-is-false
|   `-- include-linux-workqueue.h:warning:call-to-__warn_flushing_systemwide_wq-declared-with-warning-attribute:Please-avoid-flushing-system-wide-workqueues.
`-- x86_64-randconfig-c007
    `-- ld.lld:warning:call-to-__warn_flushing_systemwide_wq-marked-dontcall-warn:Please-avoid-flushing-system-wide-workqueues.

elapsed time: 2237m

configs tested: 114
configs skipped: 3

gcc tested configs:
arm                              allmodconfig
arm                              allyesconfig
arm64                            allyesconfig
arm                                 defconfig
arm64                               defconfig
ia64                             allmodconfig
x86_64                           allyesconfig
i386                             allyesconfig
ia64                             allyesconfig
riscv                            allyesconfig
um                           x86_64_defconfig
um                             i386_defconfig
mips                             allmodconfig
mips                             allyesconfig
riscv                            allmodconfig
m68k                             allyesconfig
s390                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
m68k                             allmodconfig
s390                             allyesconfig
i386                          randconfig-c001
sparc                            allyesconfig
parisc                           allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
nios2                            allyesconfig
arc                              allyesconfig
alpha                            allyesconfig
mips                         db1xxx_defconfig
arm                            mps2_defconfig
arm                         assabet_defconfig
sh                          polaris_defconfig
powerpc                      pcm030_defconfig
powerpc                     rainier_defconfig
sh                           sh2007_defconfig
openrisc                         alldefconfig
sh                            titan_defconfig
sh                           se7712_defconfig
powerpc                   motionpro_defconfig
nios2                         10m50_defconfig
arm                            zeus_defconfig
arm                          pxa910_defconfig
sh                           se7780_defconfig
mips                 decstation_r4k_defconfig
arm                        trizeps4_defconfig
s390                       zfcpdump_defconfig
sh                            hp6xx_defconfig
arm                  randconfig-c002-20220524
ia64                                defconfig
m68k                                defconfig
nios2                               defconfig
alpha                               defconfig
csky                                defconfig
arc                                 defconfig
parisc                              defconfig
parisc64                            defconfig
s390                                defconfig
sparc                               defconfig
i386                                defconfig
i386                              debian-10.3
i386                   debian-10.3-kselftests
powerpc                           allnoconfig
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                          randconfig-a012
i386                          randconfig-a014
i386                          randconfig-a016
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
arc                  randconfig-r043-20220527
riscv                randconfig-r042-20220524
arc                  randconfig-r043-20220524
s390                 randconfig-r044-20220524
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
powerpc                  mpc885_ads_defconfig
mips                       rbtx49xx_defconfig
powerpc                      walnut_defconfig
mips                           ip28_defconfig
arm                     am200epdkit_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a014
x86_64                        randconfig-a016
x86_64                        randconfig-a012
i386                          randconfig-a013
i386                          randconfig-a015
i386                          randconfig-a011
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
hexagon              randconfig-r045-20220524
hexagon              randconfig-r041-20220527
riscv                randconfig-r042-20220527
hexagon              randconfig-r041-20220524
s390                 randconfig-r044-20220527

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
