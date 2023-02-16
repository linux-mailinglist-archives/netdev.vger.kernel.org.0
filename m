Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915F2698A53
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 03:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBPCGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 21:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjBPCGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 21:06:19 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F942FCEB;
        Wed, 15 Feb 2023 18:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676513177; x=1708049177;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=jRTJ4sXSQTOejxge4WJ1uV6Jrs78wwQWBIhclkA4r90=;
  b=XwWnWvwY4wVa4pop6idv3Btfx+SZ0hH33JiZH+QWcWh+yHp7DB1K/WEY
   pGdvajXySE3w83P4pWSvEifVOlbp3hEQuxgTxcbYFFGi6DNV/D9ka737S
   CCCp5Pn/7WJ+LalS7hUFCpL/8n6FlCHg6TUEonPSmSvqw3n7sLpcRheMc
   t1M1jzQxlgEOvnJdm+e0TWqFIq4Dp8jWj3sGv7qBVcxDa714jvokxdSpB
   F477u0r2GKFs2696ougzDS7H13TvBgNIczOOcvPPfoLCb95dhtR9gl1Bk
   etxZOw3cQ6y6i/dC9Am96bUDRBp12m+8nJiBp+Q5ZgtxW42UZFARfrMk+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="359029232"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="359029232"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 18:06:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="843959605"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="843959605"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 15 Feb 2023 18:06:13 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pSTf2-0009wT-1i;
        Thu, 16 Feb 2023 02:06:12 +0000
Date:   Thu, 16 Feb 2023 10:05:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-input@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-cxl@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        alsa-devel@alsa-project.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 9d9019bcea1aac7eed64a1a4966282b6b7b141c8
Message-ID: <63ed8f83.xxCUQUW24+WEYfwo%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 9d9019bcea1aac7eed64a1a4966282b6b7b141c8  Add linux-next specific files for 20230215

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202301300743.bp7Dpazv-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302061911.C7xvHX9v-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302062224.ByzeTXh1-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302092211.54EYDhYH-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302111601.jtY4lKrA-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302112104.g75cGHZd-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302142145.iN5WZnpF-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302151041.0SWs1RHK-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302151109.xlBpZKUS-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302151751.DTeft5Fn-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/admin-guide/pm/amd-pstate.rst:343: WARNING: duplicate label admin-guide/pm/amd-pstate:user space interface in ``sysfs``, other instance in Documentation/admin-guide/pm/amd-pstate.rst
Documentation/riscv/uabi.rst:24: WARNING: Enumerated list ends without a blank line; unexpected unindent.
Documentation/sphinx/templates/kernel-toc.html: 1:36 Invalid token: #}
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/fsl-edma.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/idma64.ko] undefined!
ERROR: modpost: "walk_hmem_resources" [drivers/dax/hmem/dax_hmem.ko] undefined!
arch/mips/kernel/vpe.c:643:41: error: 'struct module' has no member named 'mod_mem'
drivers/cxl/core/region.c:2628:6: warning: variable 'rc' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_optc.c:294:6: warning: no previous prototype for 'optc3_wait_drr_doublebuffer_pending_clear' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c:1011:6: warning: no previous prototype for 'hubbub31_init' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn32/dcn32_hubbub.c:948:6: warning: no previous prototype for 'hubbub32_init' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn32/dcn32_hubp.c:158:6: warning: no previous prototype for 'hubp32_init' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn32/dcn32_resource_helpers.c:62:18: warning: variable 'cursor_bpp' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1199: warning: expecting prototype for dc_link_detect_connection_type(). Prototype was for link_detect_connection_type() instead
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_capability.c:1292:32: warning: variable 'result_write_min_hblank' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_training.c:1586:38: warning: variable 'result' set but not used [-Wunused-but-set-variable]
idma64.c:(.text+0x7c): undefined reference to `devm_platform_ioremap_resource'

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/clk/ingenic/jz4760-cgu.c:80 jz4760_cgu_calc_m_n_od() error: uninitialized symbol 'od'.
drivers/hid/hid-sony.c:1726:41: warning: Uninitialized variables: entry.lock, entry.list_node, entry.hdev, entry.touchpad, entry.sensor_dev, entry.quirks, entry.state_worker, entry.send_output_report, entry.battery, entry.battery_desc, entry.device_id, entry.output_report_dmabuf, entry.state_worker_initialized, entry.defer_initialization, entry.battery_capacity, entry.battery_status, entry.led_count, entry.ghl_urb, entry.ghl_poke_timer [uninitvar]
drivers/usb/gadget/composite.c:2082:33: sparse: sparse: restricted __le16 degrades to integer
drivers/usb/host/xhci-plat.c:371 xhci_generic_plat_probe() error: we previously assumed 'sysdev' could be null (see line 361)
sound/soc/soc-ac97.c:339 snd_soc_ac97_parse_pinctl() warn: passing zero to 'PTR_ERR'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- alpha-randconfig-r033-20230212
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- arm-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn30-dcn30_optc.c:warning:no-previous-prototype-for-optc3_wait_drr_doublebuffer_pending_clear
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn31-dcn31_hubbub.c:warning:no-previous-prototype-for-hubbub31_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_hubbub.c:warning:no-previous-prototype-for-hubbub32_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_hubp.c:warning:no-previous-prototype-for-hubp32_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_resource_helpers.c:warning:variable-cursor_bpp-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn30-dcn30_optc.c:warning:no-previous-prototype-for-optc3_wait_drr_doublebuffer_pending_clear
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn31-dcn31_hubbub.c:warning:no-previous-prototype-for-hubbub31_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_hubbub.c:warning:no-previous-prototype-for-hubbub32_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_hubp.c:warning:no-previous-prototype-for-hubp32_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_resource_helpers.c:warning:variable-cursor_bpp-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- i386-randconfig-c001
|   `-- net-sched-act_pedit.c:WARNING-opportunity-for-kmemdup
|-- i386-randconfig-s001
|   |-- drivers-gpu-drm-i915-gem-i915_gem_ttm.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-vm_fault_t-assigned-usertype-ret-got-int
|   `-- drivers-usb-gadget-composite.c:sparse:sparse:restricted-__le16-degrades-to-integer
|-- i386-randconfig-s002
|   `-- drivers-gpu-drm-i915-gem-i915_gem_ttm.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-vm_fault_t-assigned-usertype-ret-got-int
|-- i386-randconfig-s003
|   `-- drivers-usb-gadget-composite.c:sparse:sparse:restricted-__le16-degrades-to-integer
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
clang_recent_errors
|-- arm-randconfig-r005-20230212
|   `-- drivers-cxl-core-region.c:warning:variable-rc-is-used-uninitialized-whenever-if-condition-is-false
|-- s390-randconfig-r001-20230213
|   `-- idma64.c:(.text):undefined-reference-to-devm_platform_ioremap_resource
|-- x86_64-randconfig-a002-20230213
|   `-- drivers-cxl-core-region.c:warning:variable-rc-is-used-uninitialized-whenever-if-condition-is-false
|-- x86_64-randconfig-a004-20230213
|   `-- drivers-cxl-core-region.c:warning:variable-rc-is-used-uninitialized-whenever-if-condition-is-false
`-- x86_64-randconfig-a005-20230213
    `-- drivers-cxl-core-region.c:warning:variable-rc-is-used-uninitialized-whenever-if-condition-is-false

elapsed time: 1294m

configs tested: 108
configs skipped: 7

gcc tested configs:
alpha                            allyesconfig
alpha                               defconfig
arc                              allyesconfig
arc                                 defconfig
arc                        nsim_700_defconfig
arc                  randconfig-r043-20230212
arc                  randconfig-r043-20230213
arm                              allmodconfig
arm                              allyesconfig
arm                                 defconfig
arm                  randconfig-r046-20230212
arm                           u8500_defconfig
arm64                            allyesconfig
arm64                               defconfig
csky                                defconfig
i386                             allyesconfig
i386                              debian-10.3
i386                                defconfig
i386                 randconfig-a011-20230213
i386                 randconfig-a012-20230213
i386                 randconfig-a013-20230213
i386                 randconfig-a014-20230213
i386                 randconfig-a015-20230213
i386                 randconfig-a016-20230213
i386                          randconfig-c001
ia64                             allmodconfig
ia64                                defconfig
loongarch                        allmodconfig
loongarch                         allnoconfig
loongarch                           defconfig
m68k                             allmodconfig
m68k                             allyesconfig
m68k                                defconfig
m68k                        mvme147_defconfig
m68k                          sun3x_defconfig
mips                             allmodconfig
mips                             allyesconfig
mips                            ar7_defconfig
mips                 decstation_r4k_defconfig
mips                           gcw0_defconfig
mips                           xway_defconfig
nios2                            allyesconfig
nios2                               defconfig
openrisc                            defconfig
parisc                              defconfig
parisc64                            defconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
powerpc                          allyesconfig
powerpc                      mgcoge_defconfig
powerpc                     stx_gp3_defconfig
powerpc                     tqm8548_defconfig
riscv                            allmodconfig
riscv                             allnoconfig
riscv                            allyesconfig
riscv                               defconfig
riscv                randconfig-r042-20230213
riscv                          rv32_defconfig
s390                             allmodconfig
s390                             allyesconfig
s390                                defconfig
s390                 randconfig-r044-20230213
sh                               allmodconfig
sh                        dreamcast_defconfig
sh                          rsk7264_defconfig
sh                           se7712_defconfig
sparc                               defconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                            allnoconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                                  kexec
x86_64               randconfig-a011-20230213
x86_64               randconfig-a012-20230213
x86_64               randconfig-a013-20230213
x86_64               randconfig-a014-20230213
x86_64               randconfig-a015-20230213
x86_64               randconfig-a016-20230213
x86_64                               rhel-8.3
xtensa                           allyesconfig
xtensa                    smp_lx200_defconfig

clang tested configs:
arm                        multi_v5_defconfig
arm                  randconfig-r046-20230213
hexagon              randconfig-r041-20230212
hexagon              randconfig-r041-20230213
hexagon              randconfig-r045-20230212
hexagon              randconfig-r045-20230213
i386                 randconfig-a001-20230213
i386                 randconfig-a002-20230213
i386                 randconfig-a003-20230213
i386                 randconfig-a004-20230213
i386                 randconfig-a005-20230213
i386                 randconfig-a006-20230213
mips                      malta_kvm_defconfig
mips                 randconfig-c004-20230212
powerpc                 mpc8313_rdb_defconfig
powerpc                      ppc44x_defconfig
powerpc              randconfig-c003-20230212
riscv                randconfig-r042-20230212
s390                 randconfig-r044-20230212
x86_64               randconfig-a001-20230213
x86_64               randconfig-a002-20230213
x86_64               randconfig-a003-20230213
x86_64               randconfig-a004-20230213
x86_64               randconfig-a005-20230213
x86_64               randconfig-a006-20230213
x86_64                        randconfig-k001

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
