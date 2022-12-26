Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F53656442
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 17:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiLZQ4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 11:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiLZQzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 11:55:31 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A609F6413;
        Mon, 26 Dec 2022 08:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672073701; x=1703609701;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=SfZzdNV19bg9UmQpe6KYIZYymHxtUypJH/O7nO8s6g4=;
  b=h31mID8Nj5IvQhElF9vkmX2MwemEqgYnIN6yGlU2CZyWEac6EvWXINt7
   l5mr/uWh8P0XXMqpyY+DImnkCpzuQoiOLMHQNkjnGqMbt6mMQVAkvWg4z
   hj+qhEZ5WAY5AFarg1LsBGlqdJ9qL67uPj6rUFbhHN0Y70lSuVLXgTXW8
   rqQTxFviXwYYhJIIuAHkrPJNJDSzNLB+ShXcNPWJYa9GYJ/s3OqPVu6yD
   idmnf7K4mV/AcO6GoTntodEJf3aM2/aWvOftu6AcpJLXRQRv1nfRoEGvR
   9MlniTegoPbXWLjkxruZ33hcPBnYfy+hr1LAdqJpFRbQ79mQ4RMo4rCfc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="308338533"
X-IronPort-AV: E=Sophos;i="5.96,276,1665471600"; 
   d="scan'208";a="308338533"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2022 08:55:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10572"; a="646205184"
X-IronPort-AV: E=Sophos;i="5.96,276,1665471600"; 
   d="scan'208";a="646205184"
Received: from lkp-server01.sh.intel.com (HELO b5d47979f3ad) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 26 Dec 2022 08:54:55 -0800
Received: from kbuild by b5d47979f3ad with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1p9qkZ-000EZN-0D;
        Mon, 26 Dec 2022 16:54:55 +0000
Date:   Tue, 27 Dec 2022 00:54:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     virtualization@lists.linux-foundation.org,
        speakup@linux-speakup.org, netdev@vger.kernel.org,
        loongarch@lists.linux.dev, linux-xfs@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-media@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 c76083fac3bae1a87ae3d005b5cb1cbc761e31d5
Message-ID: <63a9d1b2.869GAwHafmAB6R7M%lkp@intel.com>
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
branch HEAD: c76083fac3bae1a87ae3d005b5cb1cbc761e31d5  Add linux-next specific files for 20221226

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202212020520.0OkMIno3-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212041528.4TbQL9ys-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212051759.cEv6fyHy-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212061455.6GE7y0jg-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212080938.RHVtvwt0-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212090509.NjAl9tbo-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212242239.hWUlGmm0-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202212250859.uLjFpJy3-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

ERROR: modpost: "input_ff_create_memless" [drivers/hid/hid-betopff.ko] undefined!
ERROR: modpost: "input_ff_create_memless" [drivers/hid/hid-logitech.ko] undefined!
ERROR: modpost: "input_ff_create_memless" [drivers/hid/hid-megaworld.ko] undefined!
ERROR: modpost: "input_ff_create_memless" [drivers/hid/hid-mf.ko] undefined!
ERROR: modpost: "input_ff_create_memless" [drivers/input/misc/drv260x.ko] undefined!
ERROR: modpost: "input_ff_create_memless" [drivers/input/misc/drv2665.ko] undefined!
ERROR: modpost: "input_ff_create_memless" [drivers/input/misc/gpio-vibra.ko] undefined!
ERROR: modpost: "input_ff_create_memless" [drivers/input/misc/regulator-haptic.ko] undefined!
ERROR: modpost: "input_ff_create_memless" [drivers/input/misc/sc27xx-vibra.ko] undefined!
aarch64-linux-ld: ID map text too big or misaligned
arch/arm/kernel/entry-armv.S:485:5: warning: "CONFIG_ARM_THUMB" is not defined, evaluates to 0 [-Wundef]
arch/arm64/include/asm/pgtable-hwdef.h:82:64: warning: "PMD_SHIFT" is not defined, evaluates to 0 [-Wundef]
arch/loongarch/kernel/asm-offsets.c:265:6: warning: no previous prototype for 'output_pbe_defines' [-Wmissing-prototypes]
drivers/regulator/tps65219-regulator.c:310:32: warning: parameter 'dev' set but not used [-Wunused-but-set-parameter]
drivers/regulator/tps65219-regulator.c:310:60: warning: parameter 'dev' set but not used [-Wunused-but-set-parameter]
drivers/regulator/tps65219-regulator.c:370:26: sparse:    int
drivers/regulator/tps65219-regulator.c:370:26: sparse:    struct regulator_dev *[assigned] rdev
drivers/regulator/tps65219-regulator.c:370:26: warning: ordered comparison of pointer with integer zero [-Wextra]
loongarch64-linux-ld: sleep.c:(.text+0x22c): undefined reference to `loongarch_wakeup_start'
sleep.c:(.text+0x228): undefined reference to `loongarch_wakeup_start'

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/accessibility/speakup/main.c:1290:26: sparse: sparse: obsolete array initializer, use C99 syntax
drivers/block/null_blk/zoned.c:769 zone_cond_store() warn: potential spectre issue 'dev->zones' [w] (local cap)
drivers/block/virtio_blk.c:721:9: sparse:    bad type *
drivers/block/virtio_blk.c:721:9: sparse:    unsigned int *
drivers/block/virtio_blk.c:721:9: sparse: sparse: incompatible types in comparison expression (different base types):
drivers/block/virtio_blk.c:721:9: sparse: sparse: no generic selection for 'restricted __le32 [addressable] virtio_cread_v'
drivers/block/virtio_blk.c:721:9: sparse: sparse: no generic selection for 'restricted __le32 virtio_cread_v'
drivers/cxl/core/mbox.c:832:18: sparse: sparse: cast from non-scalar
drivers/cxl/core/mbox.c:832:18: sparse: sparse: cast to non-scalar
drivers/i2c/busses/i2c-qcom-geni.c:1028:28: sparse: sparse: symbol 'i2c_master_hub' was not declared. Should it be static?
drivers/iio/adc/twl6030-gpadc.c:955:16-23: duplicated argument to & or |
drivers/iio/light/tsl2563.c:751:8-33: WARNING: Threaded IRQ with no primary handler requested without IRQF_ONESHOT (unless it is nested IRQ)
drivers/media/platform/ti/davinci/vpif.c:483:20: sparse: sparse: cast from non-scalar
drivers/media/platform/ti/davinci/vpif.c:483:20: sparse: sparse: cast to non-scalar
drivers/media/test-drivers/visl/visl-video.c:690:22: sparse: sparse: symbol 'visl_qops' was not declared. Should it be static?
fs/exfat/dir.c:862 exfat_get_dentry_set() warn: missing unwind goto?
fs/xfs/xfs_iomap.c:86:29: sparse: sparse: symbol 'xfs_iomap_page_ops' was not declared. Should it be static?

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- arc-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- arc-randconfig-r024-20221225
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- arc-randconfig-s041-20221225
|   `-- fs-xfs-xfs_iomap.c:sparse:sparse:symbol-xfs_iomap_page_ops-was-not-declared.-Should-it-be-static
|-- arm-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- arm-badge4_defconfig
|   `-- arch-arm-kernel-entry-armv.S:warning:CONFIG_ARM_THUMB-is-not-defined-evaluates-to
|-- arm64-allyesconfig
|   |-- aarch64-linux-ld:ID-map-text-too-big-or-misaligned
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- arm64-randconfig-c034-20221225
|   `-- arch-arm64-include-asm-pgtable-hwdef.h:warning:PMD_SHIFT-is-not-defined-evaluates-to
|-- csky-randconfig-c033-20221225
|   |-- drivers-iio-light-tsl2563.c:WARNING:Threaded-IRQ-with-no-primary-handler-requested-without-IRQF_ONESHOT-(unless-it-is-nested-IRQ)
|   `-- drivers-mtd-ubi-build.c:WARNING:conversion-to-bool-not-needed-here
|-- i386-allyesconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- i386-randconfig-c021-20221226
|   `-- drivers-iio-light-tsl2563.c:WARNING:Threaded-IRQ-with-no-primary-handler-requested-without-IRQF_ONESHOT-(unless-it-is-nested-IRQ)
|-- i386-randconfig-m021-20221226
|   `-- fs-exfat-dir.c-exfat_get_dentry_set()-warn:missing-unwind-goto
|-- i386-randconfig-s002
|   `-- fs-xfs-xfs_iomap.c:sparse:sparse:symbol-xfs_iomap_page_ops-was-not-declared.-Should-it-be-static
|-- ia64-allmodconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- loongarch-allyesconfig
|   `-- arch-loongarch-kernel-asm-offsets.c:warning:no-previous-prototype-for-output_pbe_defines
|-- loongarch-randconfig-s043-20221225
|   |-- arch-loongarch-kernel-asm-offsets.c:warning:no-previous-prototype-for-output_pbe_defines
|   |-- drivers-cxl-core-mbox.c:sparse:sparse:cast-from-non-scalar
|   |-- drivers-cxl-core-mbox.c:sparse:sparse:cast-to-non-scalar
|   |-- drivers-i2c-busses-i2c-qcom-geni.c:sparse:sparse:symbol-i2c_master_hub-was-not-declared.-Should-it-be-static
|   |-- fs-xfs-xfs_iomap.c:sparse:sparse:symbol-xfs_iomap_page_ops-was-not-declared.-Should-it-be-static
|   |-- loongarch64-linux-ld:sleep.c:(.text):undefined-reference-to-loongarch_wakeup_start
|   `-- sleep.c:(.text):undefined-reference-to-loongarch_wakeup_start
|-- m68k-allmodconfig
|   |-- drivers-regulator-tps65219-regulator.c:warning:ordered-comparison-of-pointer-with-integer-zero
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
clang_recent_errors
|-- hexagon-buildonly-randconfig-r003-20221225
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- hexagon-randconfig-r002-20221225
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- riscv-randconfig-r021-20221225
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
|-- x86_64-allyesconfig
|   `-- drivers-regulator-tps65219-regulator.c:warning:parameter-dev-set-but-not-used
`-- x86_64-randconfig-a003-20221226
    `-- vmlinux.o:warning:objtool:___ksymtab_gpl-_RNvNtCsfATHBUcknU9_6kernel5print16call_printk_cont:data-relocation-to-ENDBR:_RNvNtCsfATHBUcknU9_6kernel5print16call_printk_cont

elapsed time: 720m

configs tested: 89
configs skipped: 2

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
arc                                 defconfig
alpha                               defconfig
i386                 randconfig-a012-20221226
x86_64                    rhel-8.3-kselftests
arm                                 defconfig
i386                 randconfig-a011-20221226
x86_64                          rhel-8.3-func
i386                                defconfig
i386                 randconfig-a013-20221226
x86_64                           rhel-8.3-bpf
s390                             allmodconfig
s390                                defconfig
ia64                             allmodconfig
i386                 randconfig-a014-20221226
x86_64                           rhel-8.3-syz
x86_64                              defconfig
i386                 randconfig-a016-20221226
s390                             allyesconfig
i386                 randconfig-a015-20221226
x86_64                         rhel-8.3-kunit
x86_64                           rhel-8.3-kvm
x86_64                            allnoconfig
x86_64               randconfig-a014-20221226
powerpc                           allnoconfig
x86_64               randconfig-a013-20221226
x86_64                               rhel-8.3
arm64                            allyesconfig
x86_64               randconfig-a011-20221226
arm                              allyesconfig
x86_64               randconfig-a012-20221226
i386                             allyesconfig
x86_64               randconfig-a015-20221226
x86_64               randconfig-a016-20221226
sh                               allmodconfig
m68k                             allyesconfig
mips                             allyesconfig
powerpc                          allmodconfig
x86_64                           allyesconfig
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
arm                  randconfig-r046-20221225
arc                  randconfig-r043-20221225
arc                  randconfig-r043-20221226
riscv                randconfig-r042-20221226
s390                 randconfig-r044-20221226
x86_64                           alldefconfig
sh                          lboxre2_defconfig
arc                               allnoconfig
sh                             shx3_defconfig
arm                           tegra_defconfig
microblaze                          defconfig
m68k                       m5475evb_defconfig
m68k                        m5407c3_defconfig
xtensa                              defconfig
mips                      maltasmvp_defconfig
parisc                           alldefconfig
arm                          badge4_defconfig
powerpc                     mpc83xx_defconfig
sh                          rsk7201_defconfig
sh                 kfr2r09-romimage_defconfig
powerpc                    klondike_defconfig
sh                  sh7785lcr_32bit_defconfig

clang tested configs:
x86_64                          rhel-8.3-rust
i386                 randconfig-a004-20221226
i386                 randconfig-a001-20221226
x86_64               randconfig-a002-20221226
i386                 randconfig-a003-20221226
i386                 randconfig-a002-20221226
x86_64               randconfig-a003-20221226
x86_64               randconfig-a006-20221226
i386                 randconfig-a005-20221226
i386                 randconfig-a006-20221226
x86_64               randconfig-a001-20221226
x86_64               randconfig-a004-20221226
x86_64               randconfig-a005-20221226
hexagon              randconfig-r045-20221225
hexagon              randconfig-r041-20221225
hexagon              randconfig-r041-20221226
arm                  randconfig-r046-20221226
s390                 randconfig-r044-20221225
hexagon              randconfig-r045-20221226
riscv                randconfig-r042-20221225
powerpc                     tqm5200_defconfig
arm                         shannon_defconfig
arm                         orion5x_defconfig
arm                           sama7_defconfig
x86_64                           allyesconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
