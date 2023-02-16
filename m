Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A202699A89
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjBPQwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjBPQwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:52:40 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C044F2E0C6;
        Thu, 16 Feb 2023 08:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676566359; x=1708102359;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=0aN1YKKgVS2Iu0/5MYFzWDXan2/sj0vdXTrAjMKKBC8=;
  b=Zx3IKivTDtOJ9IhqAX291psDGAehg9h6pQTw7btGbWDvN059hxK5+IGY
   ICxa5GvTdohSwG6nPuMOz8hh5N5BTmJElyuiPHyFRuQ9WRWOz4/FnRNWG
   YdMbAc2rgUFZZoCu3u1TpG+b8vlY3EJhlon4h5ZYQx8Rf6d/LBjMPwrL6
   jwH+r94PuUcTMfb/UuY5McPvHZ5+/Z6dYNm/18aHpzHESOyjgOKuWnsB9
   3YK09HWBFokmS6Q7M6fqluSbrQZw6quimf65+cyFyemg3MEUoKG470hHA
   DpaT+bbEfMpYrW9MX4vm9LxhaCsDbdwJoSQCPbw6sxTi/oadU6hMkUfG7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="396434913"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="396434913"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 08:52:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="672252844"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="672252844"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 16 Feb 2023 08:52:31 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pShUl-000AMR-0A;
        Thu, 16 Feb 2023 16:52:31 +0000
Date:   Fri, 17 Feb 2023 00:52:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     virtualization@lists.linux-foundation.org, ntfs3@lists.linux.dev,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-media@vger.kernel.org,
        linux-cxl@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 509583475828c4fd86897113f78315c1431edcc3
Message-ID: <63ee5f4d.i/hBNqJewtXtI9Gp%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 509583475828c4fd86897113f78315c1431edcc3  Add linux-next specific files for 20230216

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202302061911.C7xvHX9v-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302062224.ByzeTXh1-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302111601.jtY4lKrA-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302112104.g75cGHZd-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302142145.iN5WZnpF-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302151041.0SWs1RHK-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302161117.pNuySGWi-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302162019.2WhIRkSA-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302162331.zGyXCiuH-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/admin-guide/pm/amd-pstate.rst:343: WARNING: duplicate label admin-guide/pm/amd-pstate:user space interface in ``sysfs``, other instance in Documentation/admin-guide/pm/amd-pstate.rst
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/fsl-edma.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/idma64.ko] undefined!
ERROR: modpost: "walk_hmem_resources" [drivers/dax/hmem/dax_hmem.ko] undefined!
arch/mips/include/asm/page.h:255:55: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
arch/mips/kernel/vpe.c:643:35: error: no member named 'mod_mem' in 'struct module'
arch/mips/kernel/vpe.c:643:41: error: 'struct module' has no member named 'mod_mem'
cxl.c:(.exit.text+0x32): undefined reference to `cxl_driver_unregister'
cxl.c:(.init.text+0x3c): undefined reference to `__cxl_driver_register'
cxl.c:(.text+0x92): undefined reference to `to_cxl_dax_region'
drivers/cxl/core/region.c:2628:6: warning: variable 'rc' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_optc.c:294:6: warning: no previous prototype for 'optc3_wait_drr_doublebuffer_pending_clear' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubbub.c:1011:6: warning: no previous prototype for 'hubbub31_init' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn32/dcn32_hubbub.c:948:6: warning: no previous prototype for 'hubbub32_init' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn32/dcn32_hubp.c:158:6: warning: no previous prototype for 'hubp32_init' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn32/dcn32_resource_helpers.c:62:18: warning: variable 'cursor_bpp' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1199: warning: expecting prototype for dc_link_detect_connection_type(). Prototype was for link_detect_connection_type() instead
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_capability.c:1292:32: warning: variable 'result_write_min_hblank' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_training.c:1586:38: warning: variable 'result' set but not used [-Wunused-but-set-variable]

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/clk/ingenic/jz4760-cgu.c:80 jz4760_cgu_calc_m_n_od() error: uninitialized symbol 'od'.
drivers/media/i2c/max9286.c:802 max9286_s_stream() error: buffer overflow 'priv->fmt' 4 <= 32
drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c:415 bnxt_rdma_aux_device_init() warn: possible memory leak of 'edev'
drivers/net/phy/phy-c45.c:296 genphy_c45_an_config_aneg() error: uninitialized symbol 'changed'.
drivers/net/phy/phy-c45.c:716 genphy_c45_write_eee_adv() error: uninitialized symbol 'changed'.
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188e.c:1702 rtl8188e_handle_ra_tx_report2() warn: ignoring unreachable code.
drivers/usb/gadget/composite.c:2082:33: sparse: sparse: restricted __le16 degrades to integer
drivers/virtio/virtio_ring.c:692 virtqueue_add_split_vring() error: uninitialized symbol 'prev'.
fs/ntfs3/super.c:1351 ntfs_fill_super() warn: passing a valid pointer to 'PTR_ERR'
net/mac80211/rx.c:2947 __ieee80211_rx_h_amsdu() error: we previously assumed 'rx->sta' could be null (see line 2933)
pahole: .tmp_vmlinux.btf: No such file or directory

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- alpha-randconfig-c041-20230212
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
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
|-- arm64-randconfig-r003-20230212
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn30-dcn30_optc.c:warning:no-previous-prototype-for-optc3_wait_drr_doublebuffer_pending_clear
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn31-dcn31_hubbub.c:warning:no-previous-prototype-for-hubbub31_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_hubbub.c:warning:no-previous-prototype-for-hubbub32_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_hubp.c:warning:no-previous-prototype-for-hubp32_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_resource_helpers.c:warning:variable-cursor_bpp-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|-- csky-randconfig-r006-20230213
|   `-- pahole:.tmp_vmlinux.btf:No-such-file-or-directory
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn30-dcn30_optc.c:warning:no-previous-prototype-for-optc3_wait_drr_doublebuffer_pending_clear
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn31-dcn31_hubbub.c:warning:no-previous-prototype-for-hubbub31_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_hubbub.c:warning:no-previous-prototype-for-hubbub32_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_hubp.c:warning:no-previous-prototype-for-hubp32_init
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_resource_helpers.c:warning:variable-cursor_bpp-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- i386-randconfig-s001
|   |-- drivers-gpu-drm-i915-gem-i915_gem_ttm.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-vm_fault_t-assigned-usertype-ret-got-int
|   `-- drivers-usb-gadget-composite.c:sparse:sparse:restricted-__le16-degrades-to-integer
clang_recent_errors
|-- mips-maltaaprp_defconfig
|   `-- arch-mips-kernel-vpe.c:error:no-member-named-mod_mem-in-struct-module
|-- x86_64-randconfig-a002-20230213
|   `-- drivers-cxl-core-region.c:warning:variable-rc-is-used-uninitialized-whenever-if-condition-is-false
|-- x86_64-randconfig-a004-20230213
|   `-- drivers-cxl-core-region.c:warning:variable-rc-is-used-uninitialized-whenever-if-condition-is-false
`-- x86_64-randconfig-a005-20230213
    `-- drivers-cxl-core-region.c:warning:variable-rc-is-used-uninitialized-whenever-if-condition-is-false

elapsed time: 725m

configs tested: 96
configs skipped: 4

gcc tested configs:
alpha                            allyesconfig
alpha                               defconfig
arc                              allyesconfig
arc                                 defconfig
arc                  randconfig-r043-20230212
arc                  randconfig-r043-20230213
arc                           tb10x_defconfig
arm                              allmodconfig
arm                              allyesconfig
arm                                 defconfig
arm                  randconfig-r046-20230212
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
m68k                                defconfig
m68k                            mac_defconfig
mips                             allmodconfig
mips                             allyesconfig
mips                           xway_defconfig
nios2                               defconfig
parisc                              defconfig
parisc64                            defconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
powerpc                      makalu_defconfig
powerpc                     mpc83xx_defconfig
powerpc                         ps3_defconfig
riscv                            allmodconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                randconfig-r042-20230213
riscv                          rv32_defconfig
s390                             allmodconfig
s390                             allyesconfig
s390                                defconfig
s390                 randconfig-r044-20230213
s390                       zfcpdump_defconfig
sh                               allmodconfig
sh                         ap325rxa_defconfig
sh                   rts7751r2dplus_defconfig
sh                            titan_defconfig
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
xtensa                    smp_lx200_defconfig

clang tested configs:
arm                  randconfig-r046-20230213
arm                          sp7021_defconfig
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
mips                          malta_defconfig
mips                      maltaaprp_defconfig
powerpc                 mpc832x_rdb_defconfig
riscv                    nommu_virt_defconfig
riscv                randconfig-r042-20230212
s390                 randconfig-r044-20230212
x86_64               randconfig-a001-20230213
x86_64               randconfig-a002-20230213
x86_64               randconfig-a003-20230213
x86_64               randconfig-a004-20230213
x86_64               randconfig-a005-20230213
x86_64               randconfig-a006-20230213

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
