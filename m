Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B62D5F6EA2
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 22:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiJFUIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 16:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiJFUIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 16:08:49 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60100BF8;
        Thu,  6 Oct 2022 13:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665086928; x=1696622928;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=swAucizbwUxhdAX/SMI13ZfrywiGOKfoDpdfjfgG+SE=;
  b=a/Kdo3ZASmyCLvKpJqe5xiNpaIWikZNbEJIq2WEyXp3udkS+Y9EgGu7r
   R0G0APPs8r5A+eFkFW/St74w2tPtb/L5M/4lSnowqsbI/5OEVLJT7aho2
   ElhSsaG4yC5+npqBUZAqMCyyOhzTW2Nv10i7uN6OL+5aX9sQqEfTri7Cl
   kkjtnWhk6bjMUQezI6y8pmAqT9Dwx5qQGF5U0SgHlJD6mjxd1BXBABfOa
   wHSzYSIxOoKc+kMGOSx8XOjQfq9PLCldgP+jew/ez5IwzNgrmdWTnQVwG
   MXH5eFYR7eZJMr/GM9xGVIemtMd/QQPYwjS5HSNUUB75UEb5ol3BNJgu/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="365499871"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="365499871"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 13:08:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="953763896"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="953763896"
Received: from lkp-server01.sh.intel.com (HELO 3c15167049b7) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 06 Oct 2022 13:08:43 -0700
Received: from kbuild by 3c15167049b7 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ogXAh-0000QR-0v;
        Thu, 06 Oct 2022 20:08:43 +0000
Date:   Fri, 07 Oct 2022 04:07:45 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, loongarch@lists.linux.dev,
        linuxppc-dev@lists.ozlabs.org, linux-nvme@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-ext4@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 7da9fed0474b4cd46055dd92d55c42faf32c19ac
Message-ID: <633f3591.GEF0zMh+7lpySqUP%lkp@intel.com>
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
branch HEAD: 7da9fed0474b4cd46055dd92d55c42faf32c19ac  Add linux-next specific files for 20221006

Error/Warning reports:

https://lore.kernel.org/linux-doc/202210070057.NpbaMyxB-lkp@intel.com
https://lore.kernel.org/llvm/202209220019.Yr2VuXhg-lkp@intel.com
https://lore.kernel.org/llvm/202210062012.XvdAjoOT-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

ERROR: modpost: "devm_ioremap_resource" [drivers/dma/fsl-edma.ko] undefined!
ERROR: modpost: "devm_ioremap_resource" [drivers/dma/idma64.ko] undefined!
ERROR: modpost: "devm_ioremap_resource" [drivers/dma/qcom/hdma.ko] undefined!
ERROR: modpost: "devm_memremap" [drivers/misc/open-dice.ko] undefined!
ERROR: modpost: "devm_memunmap" [drivers/misc/open-dice.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/char/xillybus/xillybus_of.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/ethernet/8390/pcnet_cs.ko] undefined!
ERROR: modpost: "ioremap" [drivers/tty/ipwireless/ipwireless.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/ethernet/8390/pcnet_cs.ko] undefined!
ERROR: modpost: "iounmap" [drivers/tty/ipwireless/ipwireless.ko] undefined!
Warning: MAINTAINERS references a file that doesn't exist: Documentation/devicetree/bindings/mtd/amlogic,meson-nand.txt
arch/arm64/kernel/alternative.c:199:6: warning: no previous prototype for 'apply_alternatives_vdso' [-Wmissing-prototypes]
arch/arm64/kernel/alternative.c:295:14: warning: no previous prototype for 'alt_cb_patch_nops' [-Wmissing-prototypes]
arch/loongarch/mm/init.c:166:24: warning: variable 'new' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/virtual/virtual_link_hwss.c:40:6: warning: no previous prototype for 'virtual_disable_link_output' [-Wmissing-prototypes]
drivers/net/ethernet/freescale/fman/fman_memac.c:1246 memac_initialization() error: uninitialized symbol 'fixed_link'.
drivers/nvme/target/loop.c:578 nvme_loop_create_ctrl() warn: 'opts->queue_size - 1' 4294967295 can't fit into 65535 'ctrl->ctrl.sqsize'
drivers/vfio/pci/mlx5/cmd.c:432 combine_ranges() error: uninitialized symbol 'last'.
drivers/vfio/pci/mlx5/cmd.c:453 combine_ranges() error: potentially dereferencing uninitialized 'comb_end'.
drivers/vfio/pci/mlx5/cmd.c:453 combine_ranges() error: potentially dereferencing uninitialized 'comb_start'.
drivers/vfio/pci/vfio_pci_core.c:1035 vfio_pci_ioctl_get_region_info() warn: potential spectre issue 'vdev->region' [r]
drivers/vfio/pci/vfio_pci_core.c:958 vfio_pci_ioctl_get_region_info() warn: potential spectre issue 'pdev->resource' [w]
fs/ext4/super.c:1744:19: warning: 'deprecated_msg' defined but not used [-Wunused-const-variable=]
include/linux/compiler_types.h:357:45: error: call to '__compiletime_assert_417' declared with attribute error: FIELD_GET: mask is not constant
lib/test_vmalloc.c:154 random_size_alloc_test() error: uninitialized symbol 'n'.

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_disable_link_output
|-- arc-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_disable_link_output
|-- arm-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_disable_link_output
|-- arm64-allyesconfig
|   |-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-alt_cb_patch_nops
|   |-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-apply_alternatives_vdso
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_disable_link_output
|-- arm64-randconfig-r006-20221002
|   |-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-alt_cb_patch_nops
|   `-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-apply_alternatives_vdso
|-- arm64-randconfig-r016-20221003
|   |-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-alt_cb_patch_nops
|   |-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-apply_alternatives_vdso
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_disable_link_output
|-- csky-buildonly-randconfig-r005-20221002
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_disable_link_output
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_disable_link_output
|   `-- fs-ext4-super.c:warning:deprecated_msg-defined-but-not-used
|-- i386-defconfig
|   `-- fs-ext4-super.c:warning:deprecated_msg-defined-but-not-used
|-- i386-randconfig-a013-20221003
|   `-- fs-ext4-super.c:warning:deprecated_msg-defined-but-not-used
|-- i386-randconfig-a014-20221003
|   `-- fs-ext4-super.c:warning:deprecated_msg-defined-but-not-used
|-- i386-randconfig-a015-20221003
|   `-- fs-ext4-super.c:warning:deprecated_msg-defined-but-not-used
|-- i386-randconfig-c001
|   `-- fs-ext4-super.c:warning:deprecated_msg-defined-but-not-used
|-- i386-randconfig-c021
|   `-- fs-ext4-super.c:warning:deprecated_msg-defined-but-not-used
|-- i386-randconfig-r024-20221003
|   `-- fs-ext4-super.c:warning:deprecated_msg-defined-but-not-used
|-- ia64-allmodconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_disable_link_output
|-- ia64-randconfig-r026-20221003
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_disable_link_output
|-- loongarch-alldefconfig
|   `-- arch-loongarch-mm-init.c:warning:variable-new-set-but-not-used
|-- loongarch-randconfig-c024-20221002
|   |-- arch-loongarch-mm-init.c:warning:variable-new-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_disable_link_output
|-- loongarch-randconfig-c44-20221002
|   `-- arch-loongarch-mm-init.c:warning:variable-new-set-but-not-used
|-- m68k-randconfig-c041-20221002
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-virtual_disable_link_output
|-- m68k-randconfig-s051-20221002
clang_recent_errors
|-- arm-omap1_defconfig
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- arm-pcm027_defconfig
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- hexagon-buildonly-randconfig-r005-20221003
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   `-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8183.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|-- hexagon-randconfig-r011-20221002
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- hexagon-randconfig-r015-20221003
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- hexagon-randconfig-r041-20221003
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- i386-randconfig-a002-20221003
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- i386-randconfig-a005-20221003
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- i386-randconfig-a006-20221003
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- mips-malta_defconfig
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- mips-rs90_defconfig
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-function-virtual_disable_link_output
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt2701.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8183.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   |-- drivers-phy-mediatek-phy-mtk-tphy.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(unsigned-c
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- powerpc-mvme5100_defconfig
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- riscv-buildonly-randconfig-r002-20221002
|   `-- ERROR:riscv_cbom_block_size-arch-riscv-kvm-kvm.ko-undefined
|-- riscv-randconfig-r031-20221003
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-function-virtual_disable_link_output
|-- riscv-rv32_defconfig
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- s390-randconfig-r005-20221003
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- x86_64-randconfig-a001-20221003
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- x86_64-randconfig-a003-20221003
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
|-- x86_64-randconfig-a005-20221003
|   `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg
`-- x86_64-rhel-8.3-rust
    `-- fs-ext4-super.c:warning:unused-variable-deprecated_msg

elapsed time: 731m

configs tested: 87
configs skipped: 5

gcc tested configs:
arc                                 defconfig
arc                               allnoconfig
alpha                             allnoconfig
alpha                               defconfig
riscv                             allnoconfig
um                             i386_defconfig
powerpc                           allnoconfig
csky                              allnoconfig
um                           x86_64_defconfig
arm                                 defconfig
s390                             allmodconfig
riscv                randconfig-r042-20221003
i386                 randconfig-a014-20221003
arc                  randconfig-r043-20221003
s390                                defconfig
i386                                defconfig
x86_64                          rhel-8.3-func
i386                 randconfig-a011-20221003
x86_64               randconfig-a011-20221003
i386                 randconfig-a012-20221003
x86_64                           rhel-8.3-syz
i386                 randconfig-a013-20221003
arc                        nsim_700_defconfig
arm                          simpad_defconfig
i386                 randconfig-a015-20221003
mips                        bcm47xx_defconfig
x86_64                              defconfig
s390                 randconfig-r044-20221003
sh                          r7780mp_defconfig
i386                 randconfig-a016-20221003
s390                             allyesconfig
x86_64                         rhel-8.3-kunit
x86_64                               rhel-8.3
x86_64               randconfig-a012-20221003
x86_64                    rhel-8.3-kselftests
x86_64                           rhel-8.3-kvm
x86_64               randconfig-a013-20221003
xtensa                              defconfig
x86_64               randconfig-a016-20221003
x86_64               randconfig-a015-20221003
x86_64               randconfig-a014-20221003
x86_64                           allyesconfig
sh                               allmodconfig
arm64                            allyesconfig
m68k                             allmodconfig
mips                  decstation_64_defconfig
i386                             allyesconfig
mips                             allyesconfig
arm                              allyesconfig
m68k                            q40_defconfig
powerpc                          allmodconfig
powerpc                     tqm8548_defconfig
arc                              allyesconfig
alpha                            allyesconfig
m68k                             allyesconfig
arc                           tb10x_defconfig
powerpc                       eiger_defconfig
powerpc                 mpc85xx_cds_defconfig
powerpc                     taishan_defconfig
ia64                             allmodconfig
parisc                generic-64bit_defconfig
loongarch                        alldefconfig
arm                       omap2plus_defconfig
i386                          randconfig-c001

clang tested configs:
hexagon              randconfig-r045-20221003
arm                          pcm027_defconfig
hexagon              randconfig-r041-20221003
arm                           omap1_defconfig
x86_64               randconfig-a003-20221003
x86_64               randconfig-a005-20221003
mips                           rs90_defconfig
x86_64               randconfig-a002-20221003
x86_64               randconfig-a001-20221003
riscv                          rv32_defconfig
x86_64               randconfig-a004-20221003
x86_64               randconfig-a006-20221003
powerpc                    mvme5100_defconfig
powerpc                     ppa8548_defconfig
mips                           ip28_defconfig
i386                 randconfig-a004-20221003
i386                 randconfig-a003-20221003
i386                 randconfig-a002-20221003
i386                 randconfig-a001-20221003
i386                 randconfig-a005-20221003
i386                 randconfig-a006-20221003
mips                          malta_defconfig
powerpc                          allmodconfig
x86_64                          rhel-8.3-rust

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
