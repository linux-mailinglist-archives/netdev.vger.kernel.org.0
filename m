Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9F9650D66
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 15:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiLSOfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 09:35:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiLSOfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 09:35:15 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA613B49;
        Mon, 19 Dec 2022 06:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671460514; x=1702996514;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=LVsOQvzkOtTm5a/HbIKG/rvJvKxEXOkq5De3oJvkS9U=;
  b=PHRdOQHDJgwpccjshx6HRAg49Xw+dcOe5J/pLeWnkBWlegxpHelOxiGd
   OhgiCHhkpPQZy1PV4BFMvtxeuP9+xseqMQGnAbIzJJa6zwb8g8FEKjpoy
   n0xmgqOy51XogRJCh+EvsxUDasUATYZ4j2dRUUJHeMO3rtBAhk/KZBdeu
   qkwIo4LLsotxyvRwinPgmNlS5p8z7FBsTz0jPGDd9DUrR/qM4f837REvX
   WDt/f1zfCIbcDVis9RJMW3SPPm6287nhDgoBfAlfTEi0KT4/Bi92nCqKz
   FA6DcKAKoo6WSdKp+Rta8KqHRUTee7z3l7nU4uuky8mKVDMvGaGCSWbDI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="307034207"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="307034207"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 06:35:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="896064818"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="896064818"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 19 Dec 2022 06:35:09 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p7HES-0008kZ-17;
        Mon, 19 Dec 2022 14:35:08 +0000
Date:   Mon, 19 Dec 2022 22:34:58 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     speakup@linux-speakup.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-xfs@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-media@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-can@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 d650871875b2ccc670f1044be7f3cc90f276745d
Message-ID: <63a07692.6I76+dHvnFt0bil/%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: d650871875b2ccc670f1044be7f3cc90f276745d  Add linux-next specific files for 20221219

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202211242120.MzZVGULn-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212020520.0OkMIno3-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212040713.rVney9e8-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212061455.6GE7y0jg-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212090509.NjAl9tbo-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212142121.vendKsOc-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212191708.Xk9yBj52-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/gpu/drm-internals:179: ./include/drm/drm_file.h:411: WARNING: undefined label: drm_accel_node (if the link has no caption the label must precede a section header)
Documentation/networking/devlink/etas_es58x.rst: WARNING: document isn't included in any toctree
Warning: tools/power/cpupower/man/cpupower-powercap-info.1 references a file that doesn't exist: Documentation/power/powercap/powercap.txt
aarch64-linux-ld: ID map text too big or misaligned
arch/arm/kernel/entry-armv.S:485:5: warning: "CONFIG_ARM_THUMB" is not defined, evaluates to 0 [-Wundef]
arch/powerpc/kernel/kvm_emul.o: warning: objtool: kvm_template_end(): can't find starting instruction
arch/powerpc/kernel/optprobes_head.o: warning: objtool: optprobe_template_end(): can't find starting instruction
cistpl.c:(.text+0x82): undefined reference to `iounmap'
drivers/regulator/tps65219-regulator.c:310:32: warning: parameter 'dev' set but not used [-Wunused-but-set-parameter]
drivers/regulator/tps65219-regulator.c:310:60: warning: parameter 'dev' set but not used [-Wunused-but-set-parameter]
drivers/regulator/tps65219-regulator.c:370:26: warning: ordered comparison of pointer with integer zero [-Wextra]
irq-al-fic.c:(.init.text+0x2e): undefined reference to `of_iomap'
lib/dhry_run.c:61:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
s390x-linux-ld: cistpl.c:(.text+0x210): undefined reference to `iounmap'
s390x-linux-ld: cistpl.c:(.text+0x222): undefined reference to `ioremap'
s390x-linux-ld: irq-al-fic.c:(.init.text+0x898): undefined reference to `iounmap'

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/accessibility/speakup/main.c:1290:26: sparse: sparse: obsolete array initializer, use C99 syntax
drivers/cxl/core/mbox.c:832:18: sparse: sparse: cast from non-scalar
drivers/cxl/core/mbox.c:832:18: sparse: sparse: cast to non-scalar
drivers/i2c/busses/i2c-qcom-geni.c:1028:28: sparse: sparse: symbol 'i2c_master_hub' was not declared. Should it be static?
drivers/media/test-drivers/visl/visl-video.c:690:22: sparse: sparse: symbol 'visl_qops' was not declared. Should it be static?
drivers/usb/misc/sisusbvga/sisusbvga.c:528:9: sparse: sparse: incorrect type in assignment (different base types)
fs/xfs/xfs_iomap.c:86:29: sparse: sparse: symbol 'xfs_iomap_page_ops' was not declared. Should it be static?
hidma.c:(.text+0x9a): undefined reference to `devm_ioremap_resource'
s390x-linux-ld: fsl-edma.c:(.text+0x15c): undefined reference to `devm_ioremap_resource'
s390x-linux-ld: fsl-edma.c:(.text+0x49c): undefined reference to `devm_ioremap_resource'
timer-of.c:(.init.text+0x1aee): undefined reference to `iounmap'
timer-of.c:(.init.text+0x5a2): undefined reference to `of_iomap'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-randconfig-s031-20221218
|   |-- drivers-cxl-core-mbox.c:sparse:sparse:cast-from-non-scalar
|   `-- drivers-cxl-core-mbox.c:sparse:sparse:cast-to-non-scalar
|-- arc-randconfig-r031-20221219
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- arc-randconfig-s033-20221218
|   |-- drivers-cxl-core-mbox.c:sparse:sparse:cast-from-non-scalar
|   `-- drivers-cxl-core-mbox.c:sparse:sparse:cast-to-non-scalar
|-- arm-cerfcube_defconfig
|   `-- arch-arm-kernel-entry-armv.S:warning:CONFIG_ARM_THUMB-is-not-defined-evaluates-to
|-- arm-footbridge_defconfig
|   `-- arch-arm-kernel-entry-armv.S:warning:CONFIG_ARM_THUMB-is-not-defined-evaluates-to
|-- arm64-allyesconfig
|   `-- aarch64-linux-ld:ID-map-text-too-big-or-misaligned
|-- csky-randconfig-s051-20221218
|   |-- drivers-nvmem-u-boot-env.c:sparse:sparse:cast-to-restricted-__le32
|   `-- drivers-nvmem-u-boot-env.c:sparse:sparse:restricted-__le32-degrades-to-integer
|-- i386-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- i386-randconfig-s002
|   `-- fs-xfs-xfs_iomap.c:sparse:sparse:symbol-xfs_iomap_page_ops-was-not-declared.-Should-it-be-static
|-- ia64-allmodconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- loongarch-randconfig-s053-20221218
|   |-- drivers-cxl-core-mbox.c:sparse:sparse:cast-from-non-scalar
|   |-- drivers-cxl-core-mbox.c:sparse:sparse:cast-to-non-scalar
|   `-- drivers-media-test-drivers-visl-visl-video.c:sparse:sparse:symbol-visl_qops-was-not-declared.-Should-it-be-static
|-- microblaze-randconfig-s052-20221218
|   |-- drivers-cxl-core-mbox.c:sparse:sparse:cast-from-non-scalar
|   `-- drivers-cxl-core-mbox.c:sparse:sparse:cast-to-non-scalar
|-- nios2-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- openrisc-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- openrisc-randconfig-r025-20221219
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- parisc-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- powerpc-allmodconfig
|   |-- arch-powerpc-kernel-kvm_emul.o:warning:objtool:kvm_template_end():can-t-find-starting-instruction
|   |-- arch-powerpc-kernel-optprobes_head.o:warning:objtool:optprobe_template_end():can-t-find-starting-instruction
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
clang_recent_errors
|-- riscv-randconfig-r024-20221219
|   |-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|   `-- lib-dhry_run.c:warning:variable-ret-is-used-uninitialized-whenever-if-condition-is-false
|-- s390-randconfig-r003-20221218
|   |-- hidma.c:(.text):undefined-reference-to-devm_ioremap_resource
|   |-- irq-al-fic.c:(.init.text):undefined-reference-to-of_iomap
|   |-- s39-linux-ld:fsl-edma.c:(.text):undefined-reference-to-devm_ioremap_resource
|   |-- s39-linux-ld:irq-al-fic.c:(.init.text):undefined-reference-to-iounmap
|   |-- timer-of.c:(.init.text):undefined-reference-to-iounmap
|   `-- timer-of.c:(.init.text):undefined-reference-to-of_iomap
|-- s390-randconfig-r036-20221218
|   |-- cistpl.c:(.text):undefined-reference-to-iounmap
|   |-- s39-linux-ld:cistpl.c:(.text):undefined-reference-to-ioremap
|   |-- s39-linux-ld:cistpl.c:(.text):undefined-reference-to-iounmap
|   `-- s39-linux-ld:fsl-edma.c:(.text):undefined-reference-to-devm_ioremap_resource
`-- x86_64-rhel-8.3-rust
    `-- vmlinux.o:warning:objtool:___ksymtab_gpl-_RNvNtCsfATHBUcknU9_6kernel5print16call_printk_cont:data-relocation-to-ENDBR:_RNvNtCsfATHBUcknU9_6kernel5print16call_printk_cont

elapsed time: 745m

configs tested: 109
configs skipped: 3

gcc tested configs:
x86_64               randconfig-a002-20221219
um                             i386_defconfig
x86_64                            allnoconfig
x86_64               randconfig-a003-20221219
x86_64               randconfig-a001-20221219
um                           x86_64_defconfig
x86_64               randconfig-a004-20221219
x86_64               randconfig-a005-20221219
x86_64               randconfig-a006-20221219
i386                 randconfig-a001-20221219
i386                 randconfig-a003-20221219
arm                            pleb_defconfig
i386                 randconfig-a002-20221219
i386                 randconfig-a004-20221219
i386                 randconfig-a006-20221219
ia64                             allmodconfig
i386                 randconfig-a005-20221219
powerpc                     taishan_defconfig
powerpc                   currituck_defconfig
arm                        cerfcube_defconfig
arc                          axs103_defconfig
powerpc                     ep8248e_defconfig
arm                           sama5_defconfig
openrisc                            defconfig
powerpc                           allnoconfig
x86_64                           rhel-8.3-bpf
x86_64                           rhel-8.3-syz
i386                                defconfig
x86_64                    rhel-8.3-kselftests
riscv                randconfig-r042-20221218
alpha                            allyesconfig
m68k                             allyesconfig
x86_64                         rhel-8.3-kunit
m68k                             allmodconfig
x86_64                          rhel-8.3-func
arc                              allyesconfig
x86_64                              defconfig
x86_64                           rhel-8.3-kvm
sh                               allmodconfig
arc                                 defconfig
sh                             sh03_defconfig
s390                             allmodconfig
alpha                               defconfig
mips                             allyesconfig
arm                                 defconfig
powerpc                      ppc40x_defconfig
x86_64                               rhel-8.3
powerpc                          allmodconfig
s390                             allyesconfig
arm64                            allyesconfig
s390                                defconfig
i386                             allyesconfig
arm                              allyesconfig
mips                      fuloong2e_defconfig
ia64                                defconfig
x86_64                           allyesconfig
m68k                            mac_defconfig
riscv                               defconfig
i386                          randconfig-c001
arc                  randconfig-r043-20221219
arm                      footbridge_defconfig
arm                  randconfig-r046-20221219
powerpc                  storcenter_defconfig
arc                  randconfig-r043-20221218
s390                 randconfig-r044-20221218
mips                    maltaup_xpa_defconfig
powerpc                  iss476-smp_defconfig
nios2                               defconfig
parisc                              defconfig
riscv                             allnoconfig
i386                        debian-10.3-kunit
i386                         debian-10.3-func
i386                          debian-10.3-kvm
riscv                    nommu_virt_defconfig
riscv                    nommu_k210_defconfig
parisc64                            defconfig
riscv                          rv32_defconfig
i386                              debian-10.3
nios2                            allyesconfig
parisc                           allyesconfig

clang tested configs:
powerpc                     ppa8548_defconfig
arm                          pxa168_defconfig
x86_64               randconfig-a011-20221219
x86_64               randconfig-a012-20221219
mips                       rbtx49xx_defconfig
arm                         s5pv210_defconfig
x86_64               randconfig-a014-20221219
x86_64               randconfig-a015-20221219
x86_64               randconfig-a013-20221219
x86_64                          rhel-8.3-rust
arm                  randconfig-r046-20221218
x86_64               randconfig-a016-20221219
i386                 randconfig-a014-20221219
i386                 randconfig-a012-20221219
i386                 randconfig-a013-20221219
i386                 randconfig-a011-20221219
hexagon              randconfig-r041-20221218
hexagon              randconfig-r045-20221219
s390                 randconfig-r044-20221219
i386                 randconfig-a015-20221219
hexagon              randconfig-r041-20221219
powerpc                     tqm8560_defconfig
i386                 randconfig-a016-20221219
hexagon              randconfig-r045-20221218
riscv                randconfig-r042-20221219
mips                     cu1830-neo_defconfig
arm                       imx_v4_v5_defconfig
x86_64                        randconfig-k001
powerpc                      ppc44x_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
