Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A06621DC1
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiKHUhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiKHUhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:37:48 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFE76710B;
        Tue,  8 Nov 2022 12:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667939867; x=1699475867;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=G04WwAeQWk0pwDOcNnDFTPJEMbVRinCyv847NR9rxkw=;
  b=TEJg8yuS+Yia6Y6LJmbK1/t+fbQzU+QbIKDc1IrJ0qKsObmAvTu3R7M/
   3MFjLyXIPzlr7QcCwyq4VAtJ6nzZfoePkAg0EKPZOzh+n+dfIhMfYtn65
   nK0TaoNbB3AfHJYPi/ONuPynh6ixC5awF0Yua1Rw2l6EWEn0NAjc8uKk1
   x+cpZbzM7gSYMT8ANjWzl7EOZbvR57nrNR9fWC+6ZQfApv5A4t4cZdGne
   4kR3rOVSs6azVXgCxwvstLmZz/HVor+YiIIQq/yCQ4hU2mQzOoPWwwwh7
   LhDeHW8oCPuW86BGsV+EDUxVvd00VyP8TxFFroi966CZ4ZtmXi4SoJsVJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="312594911"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="312594911"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 12:34:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="587506857"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="587506857"
Received: from lkp-server01.sh.intel.com (HELO e783503266e8) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 08 Nov 2022 12:34:00 -0800
Received: from kbuild by e783503266e8 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1osVIG-0000bM-0G;
        Tue, 08 Nov 2022 20:34:00 +0000
Date:   Wed, 09 Nov 2022 04:33:17 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     ntfs3@lists.linux.dev, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 b6fc3fddade7a194bd141a49f2689e50f796ef46
Message-ID: <636abd0d.1OXnfmzy1rhQe3n4%lkp@intel.com>
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
branch HEAD: b6fc3fddade7a194bd141a49f2689e50f796ef46  Add linux-next specific files for 20221108

Error/Warning reports:

https://lore.kernel.org/linux-mm/202210111318.mbUfyhps-lkp@intel.com
https://lore.kernel.org/linux-mm/202210261404.b6UlzG7H-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202210270637.Q5Y7FiKJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202211041320.coq8EELJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202211082141.3XSHPtO1-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc.c:4878: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5044:24: warning: implicit conversion from 'enum <anonymous>' to 'enum dc_status' [-Wenum-conversion]
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c:1087:1: warning: stack frame size (1184) exceeds limit (1024) in 'dr_rule_create_rule_nic' [-Wframe-larger-than]

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c:245:23: sparse: sparse: Using plain integer as NULL pointer
lib/test_objpool.c:1007:16: sparse: sparse: symbol 'g_ot_async' was not declared. Should it be static?
lib/test_objpool.c:108:6: sparse: sparse: symbol 'ot_vfree' was not declared. Should it be static?
lib/test_objpool.c:516:3: sparse: sparse: symbol 'g_ot_sync_ops' was not declared. Should it be static?
lib/test_objpool.c:76:3: sparse: sparse: symbol 'g_ot_data' was not declared. Should it be static?
lib/test_objpool.c:824:3: sparse: sparse: symbol 'g_ot_async_ops' was not declared. Should it be static?
lib/test_objpool.c:82:6: sparse: sparse: symbol 'ot_kzalloc' was not declared. Should it be static?
lib/test_objpool.c:91:6: sparse: sparse: symbol 'ot_kfree' was not declared. Should it be static?
lib/test_objpool.c:989:16: sparse: sparse: symbol 'g_ot_sync' was not declared. Should it be static?
lib/test_objpool.c:998:16: sparse: sparse: symbol 'g_ot_miss' was not declared. Should it be static?
lib/test_objpool.c:99:6: sparse: sparse: symbol 'ot_vmalloc' was not declared. Should it be static?
lib/zstd/compress/huf_compress.c:460 HUF_getIndex() warn: the 'RANK_POSITION_LOG_BUCKETS_BEGIN' macro might need parens
lib/zstd/decompress/zstd_decompress_block.c:1009 ZSTD_execSequence() warn: inconsistent indenting
lib/zstd/decompress/zstd_decompress_block.c:894 ZSTD_execSequenceEnd() warn: inconsistent indenting
lib/zstd/decompress/zstd_decompress_block.c:942 ZSTD_execSequenceEndSplitLitBuffer() warn: inconsistent indenting
lib/zstd/decompress/zstd_decompress_internal.h:206 ZSTD_DCtx_get_bmi2() warn: inconsistent indenting
s390x-linux-ld: drivers/clk/clk-fixed-mmio.c:26: undefined reference to `of_iomap'
s390x-linux-ld: drivers/clk/clk-fixed-mmio.c:33: undefined reference to `iounmap'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- arm-randconfig-r032-20221108
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- i386-randconfig-m021-20221107
|   |-- lib-zstd-compress-huf_compress.c-HUF_getIndex()-warn:the-RANK_POSITION_LOG_BUCKETS_BEGIN-macro-might-need-parens
|   |-- lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequence()-warn:inconsistent-indenting
|   |-- lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequenceEnd()-warn:inconsistent-indenting
|   |-- lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequenceEndSplitLitBuffer()-warn:inconsistent-indenting
|   `-- lib-zstd-decompress-zstd_decompress_internal.h-ZSTD_DCtx_get_bmi2()-warn:inconsistent-indenting
|-- loongarch-randconfig-r033-20221107
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- m68k-randconfig-s033-20221108
|   |-- fs-ntfs3-index.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- fs-ntfs3-namei.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-__le16-const-usertype-s1-got-unsigned-short
|   `-- fs-ntfs3-namei.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-__le16-const-usertype-s2-got-unsigned-short
|-- microblaze-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- microblaze-randconfig-c042-20221108
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- parisc-randconfig-c032-20221108
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- s390-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- sparc-allyesconfig
clang_recent_errors
|-- powerpc-randconfig-c003-20221107
|   `-- drivers-net-ethernet-mellanox-mlx5-core-steering-dr_rule.c:warning:stack-frame-size-()-exceeds-limit-()-in-dr_rule_create_rule_nic
|-- s390-randconfig-r006-20221108
|   |-- s39-linux-ld:drivers-clk-clk-fixed-mmio.c:undefined-reference-to-iounmap
|   `-- s39-linux-ld:drivers-clk-clk-fixed-mmio.c:undefined-reference-to-of_iomap
`-- x86_64-randconfig-a016
    `-- vmlinux.o:warning:objtool:handle_bug:call-to-kmsan_unpoison_entry_regs()-leaves-.noinstr.text-section

elapsed time: 724m

configs tested: 79
configs skipped: 3

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                            allnoconfig
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
arm                                 defconfig
x86_64                           rhel-8.3-kvm
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
powerpc                           allnoconfig
mips                             allyesconfig
arm                              allyesconfig
x86_64                              defconfig
powerpc                          allmodconfig
arm64                            allyesconfig
x86_64                               rhel-8.3
sh                               allmodconfig
x86_64                           allyesconfig
x86_64                        randconfig-a013
m68k                             allyesconfig
x86_64                        randconfig-a011
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
x86_64                        randconfig-a015
arc                  randconfig-r043-20221108
s390                 randconfig-r044-20221108
riscv                randconfig-r042-20221108
i386                                defconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a002
i386                          randconfig-a014
x86_64                        randconfig-a006
i386                          randconfig-a012
arc                                 defconfig
i386                          randconfig-a016
s390                             allmodconfig
alpha                               defconfig
i386                          randconfig-a001
s390                                defconfig
i386                             allyesconfig
i386                          randconfig-a003
arc                    vdk_hs38_smp_defconfig
sh                           sh2007_defconfig
i386                          randconfig-a005
sparc                            alldefconfig
arm                      footbridge_defconfig
arm                           tegra_defconfig
s390                             allyesconfig
arm                            xcep_defconfig
sh                        sh7757lcr_defconfig
sh                ecovec24-romimage_defconfig
arm                         axm55xx_defconfig
m68k                        m5272c3_defconfig
mips                            ar7_defconfig
i386                          randconfig-c001
powerpc                        warp_defconfig
arm                            zeus_defconfig
sh                           se7722_defconfig
sh                          lboxre2_defconfig
parisc                generic-64bit_defconfig
arm                        realview_defconfig
m68k                           virt_defconfig
powerpc                      ep88xc_defconfig

clang tested configs:
x86_64                        randconfig-a012
x86_64                        randconfig-a014
x86_64                        randconfig-a016
x86_64                        randconfig-a001
i386                          randconfig-a013
x86_64                        randconfig-a003
x86_64                        randconfig-a005
i386                          randconfig-a015
i386                          randconfig-a011
i386                          randconfig-a002
i386                          randconfig-a004
powerpc                    gamecube_defconfig
i386                          randconfig-a006
mips                     cu1000-neo_defconfig
x86_64                          rhel-8.3-rust

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
