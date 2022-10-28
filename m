Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1CF3611873
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 18:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiJ1Q6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 12:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiJ1Q6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 12:58:21 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB582248D3;
        Fri, 28 Oct 2022 09:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666976270; x=1698512270;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=CsAjO6F7Pf0KaWAvJqCa4wx+02xCaYRf2NDvydAD4zc=;
  b=ZN8WbP8nhWjnYwENkhdqzeV11WtkER/HqawGZGnapp0xfQYQ2nrRzWk2
   YV+viRu+atU0aUfUT5YplZ2EVoWWOSmh/t2O/rib9z9pT5kgrzUeXCeJe
   cPDDcMpnZHYVF2WwuViPNfsCjItcB/zijXrCWPmNNoLNzi40IBxJ4SZN0
   7IY1P01ukI1m0xp5ci3mD0p55uNXtx2tSTVm6F87+WjQXLz9KiYPMumO8
   U7llrApDNr3dud6HRG9WZNklRT1/nLxdMrd3lNJYpp+PX/BuoaolUpS6A
   wAwTWnLvCqEhYLIjKs5prl5qoUG6JkwukcGb84gDWJnWt1t/8HXBGEH6I
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10514"; a="372750159"
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="372750159"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2022 09:57:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10514"; a="583983809"
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="583983809"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 28 Oct 2022 09:57:45 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ooSfx-000A4N-0G;
        Fri, 28 Oct 2022 16:57:45 +0000
Date:   Sat, 29 Oct 2022 00:56:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     ntfs3@lists.linux.dev, netdev@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-hwmon@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-can@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 fd8dab197cca2746e1fcd399a218eec5164726d4
Message-ID: <635c09d2.Uo03FEcDk/bchhMt%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: fd8dab197cca2746e1fcd399a218eec5164726d4  Add linux-next specific files for 20221028

Error/Warning reports:

https://lore.kernel.org/linux-mm/202210090954.pTR6m6rj-lkp@intel.com
https://lore.kernel.org/linux-mm/202210111318.mbUfyhps-lkp@intel.com
https://lore.kernel.org/linux-mm/202210261404.b6UlzG7H-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202210270637.Q5Y7FiKJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202210271517.snUEnhD0-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202210281745.XFMUiMEf-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202210282021.SKiobE3i-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202210282125.x112bh8U-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

ERROR: modpost: "__ld_r13_to_r18_ret" [lib/zstd/zstd_decompress.ko] undefined!
ERROR: modpost: "__ld_r13_to_r22" [lib/zstd/zstd_decompress.ko] undefined!
arch/mips/pic32/pic32mzda/early_console.c:141:11: warning: result of comparison of constant -1 with expression of type 'char' is always false [-Wtautological-constant-out-of-range-compare]
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc.c:4878: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
drivers/hwmon/smpro-hwmon.c:378:2: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]
drivers/phy/mediatek/phy-mtk-hdmi-mt2701.c:116:2: warning: result of comparison of constant 18446744073709551615 with expression of type 'typeof (_Generic((mask_), char: (unsigned char)0, unsigned char: (unsigned char)0, signed char: (unsigned char)0, unsigned short: (unsigned short)0, short: (unsigned short)0, unsigned int: (unsigned int)0, int: (unsigned int)0, unsigned long: (unsigned long)0, long: (unsigned long)0, unsigned long long: (unsigned long long)0, long long: (unsigned long long)0, default: (mask_)))' (aka 'unsigned long') is always false [-Wtautological-constant-out-of-range-compare]
drivers/phy/mediatek/phy-mtk-hdmi-mt8173.c:160:2: warning: result of comparison of constant 18446744073709551615 with expression of type 'typeof (_Generic((mask_), char: (unsigned char)0, unsigned char: (unsigned char)0, signed char: (unsigned char)0, unsigned short: (unsigned short)0, short: (unsigned short)0, unsigned int: (unsigned int)0, int: (unsigned int)0, unsigned long: (unsigned long)0, long: (unsigned long)0, unsigned long long: (unsigned long long)0, long long: (unsigned long long)0, default: (mask_)))' (aka 'unsigned long') is always false [-Wtautological-constant-out-of-range-compare]
drivers/phy/mediatek/phy-mtk-mipi-dsi-mt8173.c:207:2: warning: result of comparison of constant 18446744073709551615 with expression of type 'typeof (_Generic((mask_), char: (unsigned char)0, unsigned char: (unsigned char)0, signed char: (unsigned char)0, unsigned short: (unsigned short)0, short: (unsigned short)0, unsigned int: (unsigned int)0, int: (unsigned int)0, unsigned long: (unsigned long)0, long: (unsigned long)0, unsigned long long: (unsigned long long)0, long long: (unsigned long long)0, default: (mask_)))' (aka 'unsigned long') is always false [-Wtautological-constant-out-of-range-compare]
drivers/phy/mediatek/phy-mtk-mipi-dsi-mt8183.c:83:2: warning: result of comparison of constant 18446744073709551615 with expression of type 'typeof (_Generic((mask_), char: (unsigned char)0, unsigned char: (unsigned char)0, signed char: (unsigned char)0, unsigned short: (unsigned short)0, short: (unsigned short)0, unsigned int: (unsigned int)0, int: (unsigned int)0, unsigned long: (unsigned long)0, long: (unsigned long)0, unsigned long long: (unsigned long long)0, long long: (unsigned long long)0, default: (mask_)))' (aka 'unsigned long') is always false [-Wtautological-constant-out-of-range-compare]
include/asm-generic/div64.h:222:35: warning: comparison of distinct pointer types lacks a cast
include/asm-generic/div64.h:234:32: warning: right shift count >= width of type [-Wshift-count-overflow]

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c:555:6: warning: Redundant initialization for 'err'. The initialized value is overwritten before it is read. [redundantInitialization]
drivers/net/ethernet/microchip/lan743x_ethtool.c:442:33: warning: Parameter 'data' can be declared as pointer to const [constParameter]
drivers/net/ethernet/microchip/lan743x_main.c:3522:49: warning: Operator '|' with one operand equal to zero is redundant. [badBitmaskCheck]
drivers/net/ethernet/microchip/lan743x_main.c:532:6: warning: Redundant initialization for 'ret'. The initialized value is overwritten before it is read. [redundantInitialization]
drivers/net/ieee802154/mcr20a.c:388:54: warning: Operator '|' with one operand equal to zero is redundant. [badBitmaskCheck]
drivers/net/phy/micrel.c:2043:9: warning: Uninitialized variable: ret [uninitvar]
drivers/net/phy/micrel.c:2323:24: warning: Uninitialized variable: &rx_ts->seq_id [uninitvar]
lib/zstd/compress/huf_compress.c:460 HUF_getIndex() warn: the 'RANK_POSITION_LOG_BUCKETS_BEGIN' macro might need parens
lib/zstd/decompress/zstd_decompress_block.c:1009 ZSTD_execSequence() warn: inconsistent indenting
lib/zstd/decompress/zstd_decompress_block.c:894 ZSTD_execSequenceEnd() warn: inconsistent indenting
lib/zstd/decompress/zstd_decompress_block.c:942 ZSTD_execSequenceEndSplitLitBuffer() warn: inconsistent indenting
lib/zstd/decompress/zstd_decompress_internal.h:206 ZSTD_DCtx_get_bmi2() warn: inconsistent indenting

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- arc-allyesconfig
|   |-- include-asm-generic-div64.h:warning:comparison-of-distinct-pointer-types-lacks-a-cast
|   `-- include-asm-generic-div64.h:warning:right-shift-count-width-of-type
|-- arc-randconfig-r043-20221028
|   |-- ERROR:__ld_r13_to_r18_ret-lib-zstd-zstd_decompress.ko-undefined
|   `-- ERROR:__ld_r13_to_r22-lib-zstd-zstd_decompress.ko-undefined
|-- arm-allyesconfig
|   |-- include-asm-generic-div64.h:warning:comparison-of-distinct-pointer-types-lacks-a-cast
|   `-- include-asm-generic-div64.h:warning:right-shift-count-width-of-type
|-- arm64-randconfig-s041-20221026
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-int-priv1-got-restricted-__le16-addressable-usertype-fc_len
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-int-tag-got-restricted-__le16-addressable-usertype-fc_tag
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-short-usertype-tag-got-restricted-__le16-addressable-usertype-fc_tag
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le16-usertype-fc_len-got-unsigned-short-usertype
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le16-usertype-fc_tag-got-unsigned-short-usertype
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-int-tag-got-restricted-__le16-usertype-fc_tag
|   `-- fs-ext4-fast_commit.c:sparse:sparse:restricted-__le16-degrades-to-integer
|-- arm64-randconfig-s053-20221026
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-int-priv1-got-restricted-__le16-addressable-usertype-fc_len
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-int-tag-got-restricted-__le16-addressable-usertype-fc_tag
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-short-usertype-tag-got-restricted-__le16-addressable-usertype-fc_tag
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le16-usertype-fc_len-got-unsigned-short-usertype
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le16-usertype-fc_tag-got-unsigned-short-usertype
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-int-tag-got-restricted-__le16-usertype-fc_tag
|   |-- fs-ext4-fast_commit.c:sparse:sparse:restricted-__le16-degrades-to-integer
|   |-- fs-ntfs3-index.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- fs-ntfs3-namei.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-__le16-const-usertype-s1-got-unsigned-short
|   `-- fs-ntfs3-namei.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-__le16-const-usertype-s2-got-unsigned-short
|-- csky-randconfig-r003-20221027
|   |-- include-asm-generic-div64.h:warning:comparison-of-distinct-pointer-types-lacks-a-cast
|   `-- include-asm-generic-div64.h:warning:right-shift-count-width-of-type
|-- csky-randconfig-s033-20221026
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-int-priv1-got-restricted-__le16-addressable-usertype-fc_len
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-int-tag-got-restricted-__le16-addressable-usertype-fc_tag
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-short-usertype-tag-got-restricted-__le16-addressable-usertype-fc_tag
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le16-usertype-fc_len-got-unsigned-short-usertype
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-__le16-usertype-fc_tag-got-unsigned-short-usertype
|   |-- fs-ext4-fast_commit.c:sparse:sparse:incorrect-type-in-initializer-(different-base-types)-expected-int-tag-got-restricted-__le16-usertype-fc_tag
|   `-- fs-ext4-fast_commit.c:sparse:sparse:restricted-__le16-degrades-to-integer
|-- i386-randconfig-m021
|   |-- arch-x86-boot-compressed-..-..-..-..-lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequence()-warn:inconsistent-indenting
|   |-- arch-x86-boot-compressed-..-..-..-..-lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequenceEnd()-warn:inconsistent-indenting
|   |-- arch-x86-boot-compressed-..-..-..-..-lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequenceEndSplitLitBuffer()-warn:inconsistent-indenting
|   |-- arch-x86-boot-compressed-..-..-..-..-lib-zstd-decompress-zstd_decompress_internal.h-ZSTD_DCtx_get_bmi2()-warn:inconsistent-indenting
|   |-- lib-zstd-compress-huf_compress.c-HUF_getIndex()-warn:the-RANK_POSITION_LOG_BUCKETS_BEGIN-macro-might-need-parens
|   |-- lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequence()-warn:inconsistent-indenting
|   |-- lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequenceEnd()-warn:inconsistent-indenting
|   |-- lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequenceEndSplitLitBuffer()-warn:inconsistent-indenting
|   `-- lib-zstd-decompress-zstd_decompress_internal.h-ZSTD_DCtx_get_bmi2()-warn:inconsistent-indenting
|-- ia64-randconfig-p001-20221026
clang_recent_errors
|-- hexagon-randconfig-r034-20221028
|   `-- drivers-hwmon-smpro-hwmon.c:warning:unannotated-fall-through-between-switch-labels
|-- hexagon-randconfig-r041-20221027
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   `-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8183.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|-- mips-pic32mzda_defconfig
|   `-- arch-mips-pic32-pic32mzda-early_console.c:warning:result-of-comparison-of-constant-with-expression-of-type-char-is-always-false
`-- powerpc-randconfig-r031-20221026
    |-- drivers-phy-mediatek-phy-mtk-hdmi-mt2701.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
    `-- drivers-phy-mediatek-phy-mtk-hdmi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns

elapsed time: 726m

configs tested: 78
configs skipped: 2

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
i386                                defconfig
i386                          randconfig-a001
i386                          randconfig-a003
arc                                 defconfig
x86_64                           rhel-8.3-kvm
x86_64                               rhel-8.3
s390                             allmodconfig
x86_64                           rhel-8.3-syz
ia64                             allmodconfig
x86_64                         rhel-8.3-kunit
i386                          randconfig-a005
arm                                 defconfig
x86_64                        randconfig-a002
x86_64                           allyesconfig
alpha                               defconfig
arc                  randconfig-r043-20221027
arc                              allyesconfig
powerpc                           allnoconfig
x86_64                        randconfig-a013
s390                             allyesconfig
arm                            pleb_defconfig
s390                                defconfig
x86_64                          rhel-8.3-func
arc                    vdk_hs38_smp_defconfig
x86_64                        randconfig-a011
alpha                            allyesconfig
powerpc                    sam440ep_defconfig
powerpc                          allmodconfig
i386                             allyesconfig
x86_64                        randconfig-a015
x86_64                        randconfig-a006
arm                              allyesconfig
x86_64                    rhel-8.3-kselftests
m68k                             allyesconfig
sh                               allmodconfig
i386                          randconfig-a014
x86_64                        randconfig-a004
m68k                             allmodconfig
mips                             allyesconfig
i386                          randconfig-a012
arm64                            allyesconfig
i386                          randconfig-a016
m68k                        m5307c3_defconfig
arm                        keystone_defconfig
arm                        mvebu_v7_defconfig
x86_64                           alldefconfig
sh                           sh2007_defconfig
powerpc                mpc7448_hpc2_defconfig
riscv                            allmodconfig
i386                          randconfig-c001
loongarch                         allnoconfig
ia64                        generic_defconfig

clang tested configs:
i386                          randconfig-a002
x86_64                        randconfig-a014
hexagon              randconfig-r041-20221027
i386                          randconfig-a006
x86_64                        randconfig-a005
i386                          randconfig-a004
x86_64                        randconfig-a016
x86_64                        randconfig-a012
hexagon              randconfig-r045-20221027
s390                 randconfig-r044-20221027
x86_64                        randconfig-a001
riscv                randconfig-r042-20221027
i386                          randconfig-a013
powerpc                     tqm5200_defconfig
i386                          randconfig-a015
x86_64                        randconfig-a003
i386                          randconfig-a011
powerpc                 mpc836x_mds_defconfig
arm                         mv78xx0_defconfig
arm                      pxa255-idp_defconfig
arm                   milbeaut_m10v_defconfig
x86_64                          rhel-8.3-rust
mips                        maltaup_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
