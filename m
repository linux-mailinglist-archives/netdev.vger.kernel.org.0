Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CCA69E859
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 20:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjBUTcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 14:32:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBUTcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 14:32:45 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C7DA275;
        Tue, 21 Feb 2023 11:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677007963; x=1708543963;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=oBKvYMaQGACsbz1EqLukZAAjWQY7HrpNQl9o8pOFa2k=;
  b=LkkUO5hv+PjUE2Bd/gfRjPF5Y/F81bZDQugXplaXXLHj+8kOZlxIhlZ+
   UfZ3ZuOkj+SHQ8POCijDZO4ixnLwd+JgkThhhcR0VWli8P3WVpBo7aGKl
   RkIZpjWf76Xh/iQaA7oUSzamf1MNGyw7vJN+ftMBRROig25rSQ9oR5gaM
   NyeFrMWN97ABdkFx20sQY9WKF1sfEyXUZ41/No1Jdpk5bncTMfgpN29ux
   WJFsB12JHjxdHZ07hd6/g6unVXKtWif76favlv4B5iJXs5m+P3/j9Xqtg
   ZyPULZy1ibWkUPt2VKEKlpo2zSnONyHPGJLVjN+UddBgP3tfK/pauKlkG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="316453905"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="316453905"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 11:32:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="649287478"
X-IronPort-AV: E=Sophos;i="5.97,315,1669104000"; 
   d="scan'208";a="649287478"
Received: from lkp-server01.sh.intel.com (HELO eac18b5d7d93) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 21 Feb 2023 11:32:38 -0800
Received: from kbuild by eac18b5d7d93 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pUYNS-0000C1-00;
        Tue, 21 Feb 2023 19:32:38 +0000
Date:   Wed, 22 Feb 2023 03:32:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     platform-driver-x86@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-arch@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        bpf@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 465461cf48465b8a0a54025db5ae2b3df7a04577
Message-ID: <63f51c3f.SKhEo/gg7HFz2Xwg%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 465461cf48465b8a0a54025db5ae2b3df7a04577  Add linux-next specific files for 20230221

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202302062224.ByzeTXh1-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302092211.54EYDhYH-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302111601.jtY4lKrA-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302112104.g75cGHZd-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302151041.0SWs1RHK-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302162019.2WhIRkSA-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302170355.Ljqlzucu-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302192254.EGOAcwpm-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302210350.lynWcL4t-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/admin-guide/pm/amd-pstate.rst:343: WARNING: duplicate label admin-guide/pm/amd-pstate:user space interface in ``sysfs``, other instance in Documentation/admin-guide/pm/amd-pstate.rst
Documentation/sphinx/templates/kernel-toc.html: 1:36 Invalid token: #}
ERROR: modpost: "__umoddi3" [fs/btrfs/btrfs.ko] undefined!
arch/mips/include/asm/page.h:227:55: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
arch/mips/kernel/vpe.c:643:41: error: 'struct module' has no member named 'mod_mem'
arch/riscv/net/bpf_jit_comp64.c:691:9: error: call to undeclared function 'patch_text'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_optc.c:294:6: warning: no previous prototype for 'optc3_wait_drr_doublebuffer_pending_clear' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn32/dcn32_resource_helpers.c:62:18: warning: variable 'cursor_bpp' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1199: warning: expecting prototype for dc_link_detect_connection_type(). Prototype was for link_detect_connection_type() instead
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_capability.c:1292:32: warning: variable 'result_write_min_hblank' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_training.c:1586:38: warning: variable 'result' set but not used [-Wunused-but-set-variable]
fs/btrfs/volumes.c:6514: undefined reference to `__umoddi3'
fsl-edma.c:(.text+0x104e): undefined reference to `devm_platform_ioremap_resource'
idma64.c:(.text+0x1d76): undefined reference to `devm_platform_ioremap_resource'
include/asm-generic/div64.h:238:36: error: passing argument 1 of '__div64_32' from incompatible pointer type [-Werror=incompatible-pointer-types]
s390-linux-ld: fsl-edma.c:(.text+0x1174): undefined reference to `devm_platform_ioremap_resource'
volumes.c:(.text+0x7dd4): undefined reference to `__aeabi_uldivmod'
volumes.c:(.text+0xb65b): undefined reference to `__umoddi3'

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/gpu/drm/i915/display/intel_color.c:1400 intel_color_prepare_commit() warn: ignoring unreachable code.
drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c:4393 guc_init_global_schedule_policy() error: uninitialized symbol 'ret'.
drivers/gpu/drm/i915/i915_hwmon.c:383 hwm_power_max_read() error: uninitialized symbol 'r'.
drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c:65 cpt_af_flt_intr_handler() error: uninitialized symbol 'eng'.
drivers/net/ethernet/mellanox/mlx5/core/eq.c:1010 mlx5_comp_irq_get_affinity_mask() warn: iterator used outside loop: 'eq'
drivers/platform/x86/mlx-platform.c:6013 mlxplat_mlxcpld_verify_bus_topology() error: uninitialized symbol 'shift'.
drivers/usb/gadget/composite.c:2082:33: sparse: sparse: restricted __le16 degrades to integer
drivers/usb/host/xhci-rcar.c:269:34: warning: unused variable 'usb_xhci_of_match' [-Wunused-const-variable]

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- alpha-randconfig-s033-20230219
|   `-- drivers-usb-gadget-composite.c:sparse:sparse:restricted-__le16-degrades-to-integer
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|   `-- include-asm-generic-div64.h:error:passing-argument-of-__div64_32-from-incompatible-pointer-type
|-- arm-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|   `-- include-asm-generic-div64.h:error:passing-argument-of-__div64_32-from-incompatible-pointer-type
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|   `-- include-asm-generic-div64.h:error:passing-argument-of-__div64_32-from-incompatible-pointer-type
|-- arm-randconfig-r035-20230219
|   `-- volumes.c:(.text):undefined-reference-to-__aeabi_uldivmod
|-- arm-randconfig-s052-20230219
|   `-- drivers-usb-gadget-composite.c:sparse:sparse:restricted-__le16-degrades-to-integer
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn30-dcn30_optc.c:warning:no-previous-prototype-for-optc3_wait_drr_doublebuffer_pending_clear
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_resource_helpers.c:warning:variable-cursor_bpp-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- csky-randconfig-s041-20230219
|   `-- drivers-usb-gadget-composite.c:sparse:sparse:restricted-__le16-degrades-to-integer
|-- csky-randconfig-s042-20230219
|   |-- include-asm-generic-cmpxchg-local.h:sparse:sparse:cast-truncates-bits-from-constant-value-(-becomes-)
|   `-- include-asm-generic-cmpxchg-local.h:sparse:sparse:cast-truncates-bits-from-constant-value-(aaa31337-becomes-)
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn30-dcn30_optc.c:warning:no-previous-prototype-for-optc3_wait_drr_doublebuffer_pending_clear
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_resource_helpers.c:warning:variable-cursor_bpp-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|   `-- volumes.c:(.text):undefined-reference-to-__umoddi3
|-- i386-debian-10.3
|   `-- ERROR:__umoddi3-fs-btrfs-btrfs.ko-undefined
|-- i386-debian-10.3-func
|   `-- ERROR:__umoddi3-fs-btrfs-btrfs.ko-undefined
|-- i386-debian-10.3-kselftests
|   `-- ERROR:__umoddi3-fs-btrfs-btrfs.ko-undefined
|-- i386-debian-10.3-kunit
clang_recent_errors
|-- hexagon-randconfig-r005-20230220
|   `-- drivers-usb-host-xhci-rcar.c:warning:unused-variable-usb_xhci_of_match
|-- i386-randconfig-a013-20230220
|   `-- ERROR:__umoddi3-fs-btrfs-btrfs.ko-undefined
`-- riscv-randconfig-r004-20230221
    `-- arch-riscv-net-bpf_jit_comp64.c:error:call-to-undeclared-function-patch_text-ISO-C99-and-later-do-not-support-implicit-function-declarations

elapsed time: 724m

configs tested: 114
configs skipped: 7

gcc tested configs:
alpha                            allyesconfig
alpha                               defconfig
arc                              allyesconfig
arc                                 defconfig
arc                  randconfig-r043-20230219
arc                  randconfig-r043-20230220
arm                              allmodconfig
arm                              allyesconfig
arm                         axm55xx_defconfig
arm                                 defconfig
arm                  randconfig-r046-20230220
arm64                            allyesconfig
arm64                               defconfig
csky                                defconfig
i386                             allyesconfig
i386                              debian-10.3
i386                         debian-10.3-func
i386                   debian-10.3-kselftests
i386                        debian-10.3-kunit
i386                          debian-10.3-kvm
i386                                defconfig
i386                 randconfig-a001-20230220
i386                 randconfig-a002-20230220
i386                 randconfig-a003-20230220
i386                 randconfig-a004-20230220
i386                 randconfig-a005-20230220
i386                 randconfig-a006-20230220
i386                          randconfig-c001
ia64                             allmodconfig
ia64                                defconfig
loongarch                        allmodconfig
loongarch                         allnoconfig
loongarch                           defconfig
m68k                             allmodconfig
m68k                                defconfig
m68k                        m5307c3_defconfig
m68k                           sun3_defconfig
mips                             allmodconfig
mips                             allyesconfig
mips                         cobalt_defconfig
nios2                               defconfig
parisc                              defconfig
parisc64                            defconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
powerpc                     ep8248e_defconfig
powerpc                  iss476-smp_defconfig
powerpc                       maple_defconfig
powerpc                      mgcoge_defconfig
powerpc                     redwood_defconfig
riscv                            allmodconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                randconfig-r042-20230219
riscv                          rv32_defconfig
s390                             allmodconfig
s390                             allyesconfig
s390                                defconfig
s390                 randconfig-r044-20230219
sh                               alldefconfig
sh                               allmodconfig
sh                        dreamcast_defconfig
sh                          landisk_defconfig
sh                          polaris_defconfig
sh                          sdk7780_defconfig
sparc                               defconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                           alldefconfig
x86_64                            allnoconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                                  kexec
x86_64               randconfig-a001-20230220
x86_64               randconfig-a002-20230220
x86_64               randconfig-a003-20230220
x86_64               randconfig-a004-20230220
x86_64               randconfig-a005-20230220
x86_64               randconfig-a006-20230220
x86_64                               rhel-8.3
xtensa                              defconfig
xtensa                    xip_kc705_defconfig

clang tested configs:
arm                         bcm2835_defconfig
arm                         lpc32xx_defconfig
arm                            mmp2_defconfig
arm                        mvebu_v5_defconfig
arm                  randconfig-r046-20230219
arm                        spear3xx_defconfig
hexagon              randconfig-r041-20230219
hexagon              randconfig-r041-20230220
hexagon              randconfig-r045-20230219
hexagon              randconfig-r045-20230220
i386                 randconfig-a011-20230220
i386                 randconfig-a012-20230220
i386                 randconfig-a013-20230220
i386                 randconfig-a014-20230220
i386                 randconfig-a015-20230220
i386                 randconfig-a016-20230220
mips                       lemote2f_defconfig
mips                        omega2p_defconfig
powerpc                    ge_imp3a_defconfig
powerpc                      katmai_defconfig
powerpc                   microwatt_defconfig
powerpc                     skiroot_defconfig
powerpc                      walnut_defconfig
riscv                randconfig-r042-20230220
s390                 randconfig-r044-20230220
x86_64               randconfig-a011-20230220
x86_64               randconfig-a012-20230220
x86_64               randconfig-a013-20230220
x86_64               randconfig-a014-20230220
x86_64               randconfig-a015-20230220
x86_64               randconfig-a016-20230220
x86_64                        randconfig-k001

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
