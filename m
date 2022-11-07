Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F8B61FA54
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiKGQsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:48:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbiKGQr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:47:59 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D871F2C9;
        Mon,  7 Nov 2022 08:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667839677; x=1699375677;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=ZlkYnRti0+UTe1aeerFDnAOYCAevO6FI6ZHWjCipoiU=;
  b=RkaTzkqCyCN90YEwG89LeKkpchFbTd4nakhPF8IJ04d4DOEkgruR8NMT
   KU9B//1Nv5yfOxYFrTy7O8dHogjsAbqa9Fd3ejLvtaF0VMj6+qAmKp/M3
   XOVbsMUuiWso0fX4Krai+4KvGXyMSlfyWY81de+CEe0+8tQ/DBh07gwUR
   fZb98lTLUH3PWGAWhUS1j+v4xnzzTFXCBtyXn7QAOudXYXSYRCW/eAINL
   5eajq16wBYlvJnrQ418t8uvWThXdZnJzZODxUXp/ua6i9PIQm4JmMZsXr
   EV/b62EQgpcUG4tZ1NarDUzPy9No78aCR371MDgbzyZcKQTlA5VKB211f
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="374712585"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="374712585"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 08:47:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="965218046"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="965218046"
Received: from lkp-server01.sh.intel.com (HELO 462403710aa9) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 07 Nov 2022 08:47:54 -0800
Received: from kbuild by 462403710aa9 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1os5Ht-0000pW-33;
        Mon, 07 Nov 2022 16:47:53 +0000
Date:   Tue, 08 Nov 2022 00:47:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     ntfs3@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-input@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 d8e87774068af213ab5b058b1b114dc397b577aa
Message-ID: <63693686.+ibq7thC8cVt3vzW%lkp@intel.com>
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
branch HEAD: d8e87774068af213ab5b058b1b114dc397b577aa  Add linux-next specific files for 20221107

Error/Warning reports:

https://lore.kernel.org/linux-mm/202210090954.pTR6m6rj-lkp@intel.com
https://lore.kernel.org/linux-mm/202210111318.mbUfyhps-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202211041320.coq8EELJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202211071905.HjT4Cwsk-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202211072023.hRrEPGnJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202211072213.KSrsyiuE-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc.c:4878: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5044:24: warning: implicit conversion from 'enum <anonymous>' to 'enum dc_status' [-Wenum-conversion]
drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c:75:8: error: call to undeclared function 'readl'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/gpu/drm/hisilicon/hibmc/hibmc_drm_vdac.c:80:2: error: call to undeclared function 'writel'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
lib/test_maple_tree.c:453:12: warning: result of comparison of constant 4398046511104 with expression of type 'unsigned long' is always false [-Wtautological-constant-out-of-range-compare]
lib/test_objpool.c:106:6: warning: no previous prototype for function 'ot_vfree' [-Wmissing-prototypes]
lib/test_objpool.c:80:7: warning: no previous prototype for function 'ot_kzalloc' [-Wmissing-prototypes]
lib/test_objpool.c:89:6: warning: no previous prototype for function 'ot_kfree' [-Wmissing-prototypes]
lib/test_objpool.c:97:7: warning: no previous prototype for function 'ot_vmalloc' [-Wmissing-prototypes]
net/dcb/dcbnl.c:1230:1: warning: the frame size of 1244 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/input/touchscreen/hynitron_cstxxx.c:238 cst3xx_bootloader_enter() error: uninitialized symbol 'tmp'.
lib/zstd/compress/huf_compress.c:460 HUF_getIndex() warn: the 'RANK_POSITION_LOG_BUCKETS_BEGIN' macro might need parens
lib/zstd/decompress/zstd_decompress_block.c:1009 ZSTD_execSequence() warn: inconsistent indenting
lib/zstd/decompress/zstd_decompress_block.c:894 ZSTD_execSequenceEnd() warn: inconsistent indenting
lib/zstd/decompress/zstd_decompress_block.c:942 ZSTD_execSequenceEndSplitLitBuffer() warn: inconsistent indenting
lib/zstd/decompress/zstd_decompress_internal.h:206 ZSTD_DCtx_get_bmi2() warn: inconsistent indenting

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- arc-randconfig-r002-20221106
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- i386-buildonly-randconfig-r006-20221107
|   `-- net-dcb-dcbnl.c:warning:the-frame-size-of-bytes-is-larger-than-bytes
|-- i386-randconfig-m021-20221107
|   |-- arch-x86-kernel-apic-apic.c-generic_processor_info()-warn:always-true-condition-(num_processors-()-)-(-u32max-)
|   |-- lib-zstd-compress-huf_compress.c-HUF_getIndex()-warn:the-RANK_POSITION_LOG_BUCKETS_BEGIN-macro-might-need-parens
|   |-- lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequence()-warn:inconsistent-indenting
|   |-- lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequenceEnd()-warn:inconsistent-indenting
|   |-- lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequenceEndSplitLitBuffer()-warn:inconsistent-indenting
|   `-- lib-zstd-decompress-zstd_decompress_internal.h-ZSTD_DCtx_get_bmi2()-warn:inconsistent-indenting
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- loongarch-buildonly-randconfig-r001-20221106
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- loongarch-randconfig-r005-20221106
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- loongarch-randconfig-r032-20221107
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|-- m68k-randconfig-m041-20221107
|   |-- drivers-input-touchscreen-hynitron_cstxxx.c-cst3xx_bootloader_enter()-error:uninitialized-symbol-tmp-.
|   |-- lib-zstd-compress-huf_compress.c-HUF_getIndex()-warn:the-RANK_POSITION_LOG_BUCKETS_BEGIN-macro-might-need-parens
|   |-- lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequence()-warn:inconsistent-indenting
|   |-- lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequenceEnd()-warn:inconsistent-indenting
|   |-- lib-zstd-decompress-zstd_decompress_block.c-ZSTD_execSequenceEndSplitLitBuffer()-warn:inconsistent-indenting
|   `-- lib-zstd-decompress-zstd_decompress_internal.h-ZSTD_DCtx_get_bmi2()-warn:inconsistent-indenting
|-- microblaze-randconfig-s033-20221107
|   |-- fs-ntfs3-index.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- fs-ntfs3-namei.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-__le16-const-usertype-s1-got-unsigned-short
|   `-- fs-ntfs3-namei.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-__le16-const-usertype-s2-got-unsigned-short
clang_recent_errors
|-- hexagon-randconfig-r041-20221106
|   `-- lib-test_maple_tree.c:warning:result-of-comparison-of-constant-with-expression-of-type-unsigned-long-is-always-false
|-- powerpc-buildonly-randconfig-r001-20221107
|   |-- lib-test_objpool.c:warning:no-previous-prototype-for-function-ot_kfree
|   |-- lib-test_objpool.c:warning:no-previous-prototype-for-function-ot_kzalloc
|   |-- lib-test_objpool.c:warning:no-previous-prototype-for-function-ot_vfree
|   `-- lib-test_objpool.c:warning:no-previous-prototype-for-function-ot_vmalloc
|-- s390-randconfig-r021-20221107
|   |-- drivers-gpu-drm-hisilicon-hibmc-hibmc_drm_vdac.c:error:call-to-undeclared-function-readl-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- drivers-gpu-drm-hisilicon-hibmc-hibmc_drm_vdac.c:error:call-to-undeclared-function-writel-ISO-C99-and-later-do-not-support-implicit-function-declarations
`-- x86_64-randconfig-a016
    `-- vmlinux.o:warning:objtool:handle_bug:call-to-kmsan_unpoison_entry_regs()-leaves-.noinstr.text-section

elapsed time: 723m

configs tested: 58
configs skipped: 2

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
arc                                 defconfig
s390                             allmodconfig
alpha                               defconfig
s390                             allyesconfig
x86_64                           rhel-8.3-kvm
s390                                defconfig
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
i386                                defconfig
x86_64                              defconfig
i386                 randconfig-a002-20221107
x86_64                        randconfig-a013
x86_64               randconfig-a004-20221107
i386                 randconfig-a003-20221107
ia64                             allmodconfig
i386                 randconfig-a004-20221107
arm                                 defconfig
i386                 randconfig-a005-20221107
x86_64               randconfig-a001-20221107
i386                          randconfig-a014
x86_64                               rhel-8.3
x86_64                        randconfig-a011
x86_64                           allyesconfig
i386                          randconfig-a012
x86_64               randconfig-a003-20221107
powerpc                           allnoconfig
x86_64               randconfig-a002-20221107
i386                          randconfig-a016
i386                 randconfig-a001-20221107
arm                              allyesconfig
x86_64                        randconfig-a015
x86_64               randconfig-a005-20221107
riscv                randconfig-r042-20221106
i386                 randconfig-a006-20221107
powerpc                          allmodconfig
x86_64               randconfig-a006-20221107
mips                             allyesconfig
arm64                            allyesconfig
sh                               allmodconfig
arc                  randconfig-r043-20221106
s390                 randconfig-r044-20221106
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
m68k                             allmodconfig
arc                              allyesconfig
alpha                            allyesconfig
m68k                             allyesconfig
i386                             allyesconfig

clang tested configs:
i386                          randconfig-a013
i386                          randconfig-a011
x86_64                        randconfig-a016
x86_64                        randconfig-a012
i386                          randconfig-a015
x86_64                        randconfig-a014
hexagon              randconfig-r045-20221106
hexagon              randconfig-r041-20221106

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
