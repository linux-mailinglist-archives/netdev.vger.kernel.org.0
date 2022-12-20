Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFC36521B9
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbiLTNtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:49:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiLTNtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:49:39 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D962E65F1;
        Tue, 20 Dec 2022 05:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671544178; x=1703080178;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=ILvH76aAgDaS9txxLdxKFTa4pafrJSu2zimzPO8hm0o=;
  b=Q0KdwWehjyjPhPBo94tVDzcQdGxR0PM9AgDg0duQCGWm7jRZnZS+iuBe
   qp4lNm7X3MYVznxy0Ui+Apl5th/L0h2dYj5cSB4LGhy+pUPBvW7bgYnAQ
   jBI+81JULyi5bWE1yTdL8A1lnPaT3775wNAVAIeR9POnz5mnOQriY1fzU
   poe3kSOQBhkGFfzTmWs4pnhm1hqch0Z8a3AnOQkofuUmDwpQpI5Ud077E
   42EMkbFohsiDsHSTg7uNlYiNV43K+zbzrDRMqeUqon4NCHDk11P/jpYAo
   R1t4oVTVcfwFK+i41u8eFgkDUsX0sawJ3AmBtW7/UIHGxqewZAvtbYWs7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="299956961"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="299956961"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 05:49:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="714435955"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="714435955"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 20 Dec 2022 05:49:34 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p7czu-0009XY-00;
        Tue, 20 Dec 2022 13:49:34 +0000
Date:   Tue, 20 Dec 2022 21:49:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     virtualization@lists.linux-foundation.org,
        speakup@linux-speakup.org, netdev@vger.kernel.org,
        loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
        linux-xfs@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-mm@kvack.org, linux-media@vger.kernel.org,
        linux-cxl@vger.kernel.org, linux-can@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 e45fb347b630ee76482fe938ba76cf8eab811290
Message-ID: <63a1bd54.a88xtgO0grxGBbe+%lkp@intel.com>
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
branch HEAD: e45fb347b630ee76482fe938ba76cf8eab811290  Add linux-next specific files for 20221220

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202211242120.MzZVGULn-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212020520.0OkMIno3-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212040713.rVney9e8-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212061455.6GE7y0jg-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212090509.NjAl9tbo-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212191708.Xk9yBj52-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212201859.qUGugK1F-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212202020.qL8Aaqu0-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/gpu/drm-internals:179: ./include/drm/drm_file.h:411: WARNING: undefined label: drm_accel_node (if the link has no caption the label must precede a section header)
Documentation/networking/devlink/etas_es58x.rst: WARNING: document isn't included in any toctree
Warning: tools/power/cpupower/man/cpupower-powercap-info.1 references a file that doesn't exist: Documentation/power/powercap/powercap.txt
arch/arm/kernel/entry-armv.S:485:5: warning: "CONFIG_ARM_THUMB" is not defined, evaluates to 0 [-Wundef]
arch/loongarch/kernel/asm-offsets.c:265:6: warning: no previous prototype for 'output_pbe_defines' [-Wmissing-prototypes]
arch/powerpc/kernel/kvm_emul.o: warning: objtool: kvm_template_end(): can't find starting instruction
arch/powerpc/kernel/optprobes_head.o: warning: objtool: optprobe_template_end(): can't find starting instruction
drivers/regulator/tps65219-regulator.c:310:32: warning: parameter 'dev' set but not used [-Wunused-but-set-parameter]
drivers/regulator/tps65219-regulator.c:310:60: warning: parameter 'dev' set but not used [-Wunused-but-set-parameter]
drivers/regulator/tps65219-regulator.c:370:26: warning: ordered comparison of pointer with integer zero [-Wextra]
lib/dhry_run.c:61:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
mm/memfd.c:274:31: warning: unused variable 'ns' [-Wunused-variable]

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/accessibility/speakup/main.c:1290:26: sparse: sparse: obsolete array initializer, use C99 syntax
drivers/cxl/core/mbox.c:832:18: sparse: sparse: cast from non-scalar
drivers/cxl/core/mbox.c:832:18: sparse: sparse: cast to non-scalar
drivers/i2c/busses/i2c-qcom-geni.c:1028:28: sparse: sparse: symbol 'i2c_master_hub' was not declared. Should it be static?
drivers/media/platform/ti/davinci/vpif.c:483:20: sparse: sparse: cast from non-scalar
drivers/media/platform/ti/davinci/vpif.c:483:20: sparse: sparse: cast to non-scalar
fs/xfs/xfs_iomap.c:86:29: sparse: sparse: symbol 'xfs_iomap_page_ops' was not declared. Should it be static?

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- arc-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- arm-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- arm-buildonly-randconfig-r005-20221219
|   `-- arch-arm-kernel-entry-armv.S:warning:CONFIG_ARM_THUMB-is-not-defined-evaluates-to
|-- arm64-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- i386-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- i386-buildonly-randconfig-r001-20221219
|   `-- mm-memfd.c:warning:unused-variable-ns
|-- ia64-allmodconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- loongarch-allyesconfig
|   `-- arch-loongarch-kernel-asm-offsets.c:warning:no-previous-prototype-for-output_pbe_defines
|-- loongarch-randconfig-s051-20221218
|   |-- drivers-i2c-busses-i2c-qcom-geni.c:sparse:sparse:symbol-i2c_master_hub-was-not-declared.-Should-it-be-static
|   `-- fs-xfs-xfs_iomap.c:sparse:sparse:symbol-xfs_iomap_page_ops-was-not-declared.-Should-it-be-static
|-- m68k-allmodconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- m68k-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- mips-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- powerpc-allmodconfig
|   |-- arch-powerpc-kernel-kvm_emul.o:warning:objtool:kvm_template_end():can-t-find-starting-instruction
|   |-- arch-powerpc-kernel-optprobes_head.o:warning:objtool:optprobe_template_end():can-t-find-starting-instruction
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- riscv-randconfig-s041-20221218
|   |-- drivers-accessibility-speakup-main.c:sparse:sparse:obsolete-array-initializer-use-C99-syntax
|   `-- fs-xfs-xfs_iomap.c:sparse:sparse:symbol-xfs_iomap_page_ops-was-not-declared.-Should-it-be-static
|-- riscv-randconfig-s042-20221218
|   |-- drivers-cxl-core-mbox.c:sparse:sparse:cast-from-non-scalar
|   |-- drivers-cxl-core-mbox.c:sparse:sparse:cast-to-non-scalar
|   |-- drivers-net-thunderbolt.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le16-usertype-frame_id-got-unsigned-short-usertype
|   |-- drivers-net-thunderbolt.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le16-usertype-frame_index-got-unsigned-short-usertype
|   |-- drivers-net-thunderbolt.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le32-usertype-frame_count-got-unsigned-int-usertype
clang_recent_errors
|-- hexagon-allmodconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|   `-- lib-dhry_run.c:warning:variable-ret-is-used-uninitialized-whenever-if-condition-is-false
`-- x86_64-rhel-8.3-rust
    `-- vmlinux.o:warning:objtool:___ksymtab_gpl-_RNvNtCsfATHBUcknU9_6kernel5print16call_printk_cont:data-relocation-to-ENDBR:_RNvNtCsfATHBUcknU9_6kernel5print16call_printk_cont

elapsed time: 726m

configs tested: 66
configs skipped: 2

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
powerpc                           allnoconfig
arc                                 defconfig
x86_64                    rhel-8.3-kselftests
s390                             allmodconfig
x86_64                          rhel-8.3-func
alpha                               defconfig
i386                                defconfig
s390                                defconfig
arm                                 defconfig
sh                               allmodconfig
s390                             allyesconfig
x86_64               randconfig-a002-20221219
x86_64               randconfig-a003-20221219
alpha                            allyesconfig
x86_64               randconfig-a001-20221219
m68k                             allyesconfig
x86_64               randconfig-a004-20221219
mips                             allyesconfig
m68k                             allmodconfig
powerpc                          allmodconfig
arc                              allyesconfig
x86_64               randconfig-a005-20221219
arc                  randconfig-r043-20221220
x86_64                           rhel-8.3-bpf
x86_64               randconfig-a006-20221219
x86_64                           rhel-8.3-syz
riscv                randconfig-r042-20221220
x86_64                         rhel-8.3-kunit
ia64                             allmodconfig
x86_64                            allnoconfig
arm                              allyesconfig
x86_64                           rhel-8.3-kvm
arm64                            allyesconfig
s390                 randconfig-r044-20221220
i386                             allyesconfig
i386                 randconfig-a001-20221219
i386                 randconfig-a003-20221219
i386                 randconfig-a002-20221219
i386                 randconfig-a006-20221219
i386                 randconfig-a005-20221219
i386                 randconfig-a004-20221219
powerpc                     ep8248e_defconfig
powerpc                     rainier_defconfig
x86_64                              defconfig
x86_64                               rhel-8.3
x86_64                           allyesconfig

clang tested configs:
x86_64                          rhel-8.3-rust
hexagon              randconfig-r041-20221220
arm                  randconfig-r046-20221220
i386                 randconfig-a011-20221219
i386                 randconfig-a014-20221219
hexagon              randconfig-r045-20221220
i386                 randconfig-a012-20221219
i386                 randconfig-a013-20221219
i386                 randconfig-a015-20221219
i386                 randconfig-a016-20221219
x86_64               randconfig-a014-20221219
x86_64               randconfig-a015-20221219
x86_64               randconfig-a012-20221219
x86_64               randconfig-a011-20221219
arm                             mxs_defconfig
x86_64               randconfig-a016-20221219
powerpc                     ppa8548_defconfig
x86_64               randconfig-a013-20221219

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
