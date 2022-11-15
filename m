Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D53662A304
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 21:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbiKOUdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 15:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiKOUc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 15:32:59 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1322D751;
        Tue, 15 Nov 2022 12:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668544222; x=1700080222;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=nwVVHGJwYKY5kCjLKGilRmLEBJRYK6W7/9ysp6hMtaQ=;
  b=d9HHfMeTlUVRnoXO3UiE144L7AMM9YzXa6Qb719N+z5QJ8riwJTBaQIw
   1+4CuDfweYnYM1qnv4S5CxBMbn1xBUGm6mJh12vreV9vwuBzxxAxPKFdZ
   Oy6ZZ6LPt0p4FpDvEJG7iaHXlHuVCTpAaSQC9XNEdREqsFwQNg8kSa89e
   ZDySZAOOXICcNChgBnkvlpiClcEM/gAXJ/Hzl2+EUYhN1IMam7KCrk8aq
   vJEdxEY9TnOSv0kTVUNeobefnnoI+EqxzJ+e/BnAjv0EzDuajbDraBcbb
   TGgmOLRB2iuQnVYyGkHrPc0JGGVbXl1R7cCXdC1049Fij2oG53sHyJ4je
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="312367031"
X-IronPort-AV: E=Sophos;i="5.96,166,1665471600"; 
   d="scan'208";a="312367031"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2022 12:30:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10532"; a="813814464"
X-IronPort-AV: E=Sophos;i="5.96,166,1665471600"; 
   d="scan'208";a="813814464"
Received: from lkp-server01.sh.intel.com (HELO ebd99836cbe0) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 15 Nov 2022 12:30:18 -0800
Received: from kbuild by ebd99836cbe0 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ov2ZV-0001e7-2k;
        Tue, 15 Nov 2022 20:30:17 +0000
Date:   Wed, 16 Nov 2022 04:30:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-clk@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-afs@lists.infradead.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 3c1f24109dfc4fb1a3730ed237e50183c6bb26b3
Message-ID: <6373f6cf.OhGqx4uDp+acnhuc%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 3c1f24109dfc4fb1a3730ed237e50183c6bb26b3  Add linux-next specific files for 20221115

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202211041320.coq8EELJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202211090634.RyFKK0WS-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202211130053.Np70VIdn-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202211152134.2APMmViw-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

arch/arm/mach-s3c/devs.c:32:10: fatal error: linux/platform_data/dma-s3c24xx.h: No such file or directory
drivers/clk/clk.c:1022:5: error: redefinition of 'clk_prepare'
drivers/clk/clk.c:1268:6: error: redefinition of 'clk_is_enabled_when_prepared'
drivers/clk/clk.c:941:6: error: redefinition of 'clk_unprepare'
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc.c:4887: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link_dp.c:5073:24: warning: implicit conversion from 'enum <anonymous>' to 'enum dc_status' [-Wenum-conversion]
drivers/gpu/drm/nouveau/nvkm/engine/fifo/gf100.c:451:1: warning: no previous prototype for 'gf100_fifo_nonstall_block' [-Wmissing-prototypes]
drivers/gpu/drm/nouveau/nvkm/engine/fifo/runl.c:34:1: warning: no previous prototype for 'nvkm_engn_cgrp_get' [-Wmissing-prototypes]
drivers/gpu/drm/nouveau/nvkm/engine/gr/tu102.c:210:1: warning: no previous prototype for 'tu102_gr_load' [-Wmissing-prototypes]
drivers/gpu/drm/nouveau/nvkm/nvfw/acr.c:49:1: warning: no previous prototype for 'wpr_generic_header_dump' [-Wmissing-prototypes]
drivers/gpu/drm/nouveau/nvkm/subdev/acr/lsfw.c:221:21: warning: variable 'loc' set but not used [-Wunused-but-set-variable]
ld.lld: error: .btf.vmlinux.bin.o: unknown file type
ld.lld: error: undefined symbol: ipv6_icmp_error
net/rxrpc/local_object.c:36: undefined reference to `ipv6_icmp_error'
vmlinux.o: warning: objtool: __btrfs_map_block+0x1e22: unreachable instruction

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/cpufreq/acpi-cpufreq.c:970 acpi_cpufreq_boost_init() error: uninitialized symbol 'ret'.
lib/zstd/compress/huf_compress.c:460 HUF_getIndex() warn: the 'RANK_POSITION_LOG_BUCKETS_BEGIN' macro might need parens
lib/zstd/decompress/zstd_decompress_block.c:1009 ZSTD_execSequence() warn: inconsistent indenting
lib/zstd/decompress/zstd_decompress_block.c:894 ZSTD_execSequenceEnd() warn: inconsistent indenting
lib/zstd/decompress/zstd_decompress_block.c:942 ZSTD_execSequenceEndSplitLitBuffer() warn: inconsistent indenting
lib/zstd/decompress/zstd_decompress_internal.h:206 ZSTD_DCtx_get_bmi2() warn: inconsistent indenting
mm/khugepaged.c:2038 collapse_file() warn: iterator used outside loop: 'page'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-gf100.c:warning:no-previous-prototype-for-gf100_fifo_nonstall_block
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-runl.c:warning:no-previous-prototype-for-nvkm_engn_cgrp_get
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-gr-tu102.c:warning:no-previous-prototype-for-tu102_gr_load
|   |-- drivers-gpu-drm-nouveau-nvkm-nvfw-acr.c:warning:no-previous-prototype-for-wpr_generic_header_dump
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-acr-lsfw.c:warning:variable-loc-set-but-not-used
|-- alpha-randconfig-r032-20221114
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-gf100.c:warning:no-previous-prototype-for-gf100_fifo_nonstall_block
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-runl.c:warning:no-previous-prototype-for-nvkm_engn_cgrp_get
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-gr-tu102.c:warning:no-previous-prototype-for-tu102_gr_load
|   |-- drivers-gpu-drm-nouveau-nvkm-nvfw-acr.c:warning:no-previous-prototype-for-wpr_generic_header_dump
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-acr-lsfw.c:warning:variable-loc-set-but-not-used
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-gf100.c:warning:no-previous-prototype-for-gf100_fifo_nonstall_block
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-runl.c:warning:no-previous-prototype-for-nvkm_engn_cgrp_get
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-gr-tu102.c:warning:no-previous-prototype-for-tu102_gr_load
|   |-- drivers-gpu-drm-nouveau-nvkm-nvfw-acr.c:warning:no-previous-prototype-for-wpr_generic_header_dump
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-acr-lsfw.c:warning:variable-loc-set-but-not-used
|-- arm-allyesconfig
|   |-- arch-arm-mach-s3c-devs.c:fatal-error:linux-platform_data-dma-s3c24xx.h:No-such-file-or-directory
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-gf100.c:warning:no-previous-prototype-for-gf100_fifo_nonstall_block
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-runl.c:warning:no-previous-prototype-for-nvkm_engn_cgrp_get
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-gr-tu102.c:warning:no-previous-prototype-for-tu102_gr_load
|   |-- drivers-gpu-drm-nouveau-nvkm-nvfw-acr.c:warning:no-previous-prototype-for-wpr_generic_header_dump
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-acr-lsfw.c:warning:variable-loc-set-but-not-used
|-- arm-defconfig
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-gf100.c:warning:no-previous-prototype-for-gf100_fifo_nonstall_block
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-runl.c:warning:no-previous-prototype-for-nvkm_engn_cgrp_get
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-gr-tu102.c:warning:no-previous-prototype-for-tu102_gr_load
|   |-- drivers-gpu-drm-nouveau-nvkm-nvfw-acr.c:warning:no-previous-prototype-for-wpr_generic_header_dump
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-acr-lsfw.c:warning:variable-loc-set-but-not-used
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-gf100.c:warning:no-previous-prototype-for-gf100_fifo_nonstall_block
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-runl.c:warning:no-previous-prototype-for-nvkm_engn_cgrp_get
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-gr-tu102.c:warning:no-previous-prototype-for-tu102_gr_load
|   |-- drivers-gpu-drm-nouveau-nvkm-nvfw-acr.c:warning:no-previous-prototype-for-wpr_generic_header_dump
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-acr-lsfw.c:warning:variable-loc-set-but-not-used
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_link_dp.c:warning:implicit-conversion-from-enum-anonymous-to-enum-dc_status
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-gf100.c:warning:no-previous-prototype-for-gf100_fifo_nonstall_block
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-fifo-runl.c:warning:no-previous-prototype-for-nvkm_engn_cgrp_get
|   |-- drivers-gpu-drm-nouveau-nvkm-engine-gr-tu102.c:warning:no-previous-prototype-for-tu102_gr_load
|   |-- drivers-gpu-drm-nouveau-nvkm-nvfw-acr.c:warning:no-previous-prototype-for-wpr_generic_header_dump
|   `-- drivers-gpu-drm-nouveau-nvkm-subdev-acr-lsfw.c:warning:variable-loc-set-but-not-used
clang_recent_errors
|-- hexagon-randconfig-r041-20221114
|   `-- ld.lld:error:undefined-symbol:ipv6_icmp_error
|-- i386-randconfig-a015
|   `-- ld.lld:error:undefined-symbol:ipv6_icmp_error
|-- x86_64-randconfig-a005
|   |-- ld.lld:error:.btf.vmlinux.bin.o:unknown-file-type
|   `-- ld.lld:error:undefined-symbol:ipv6_icmp_error
`-- x86_64-randconfig-a012-20221114
    `-- vmlinux.o:warning:objtool:handle_bug:call-to-kmsan_unpoison_entry_regs()-leaves-.noinstr.text-section

elapsed time: 734m

configs tested: 64
configs skipped: 2

gcc tested configs:
i386                                defconfig
x86_64                        randconfig-a004
um                             i386_defconfig
x86_64                        randconfig-a002
um                           x86_64_defconfig
powerpc                          allmodconfig
x86_64                        randconfig-a006
i386                 randconfig-a001-20221114
mips                             allyesconfig
x86_64                              defconfig
x86_64                           rhel-8.3-syz
powerpc                           allnoconfig
i386                 randconfig-a002-20221114
x86_64                            allnoconfig
x86_64                         rhel-8.3-kunit
sh                               allmodconfig
i386                 randconfig-a005-20221114
i386                 randconfig-a006-20221114
arc                  randconfig-r043-20221115
x86_64                           rhel-8.3-kvm
arc                                 defconfig
riscv                randconfig-r042-20221115
ia64                             allmodconfig
i386                             allyesconfig
arm                                 defconfig
arc                  randconfig-r043-20221114
i386                 randconfig-a003-20221114
x86_64                    rhel-8.3-kselftests
s390                 randconfig-r044-20221115
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
i386                 randconfig-a004-20221114
s390                             allmodconfig
i386                          randconfig-a014
alpha                               defconfig
s390                                defconfig
m68k                             allyesconfig
m68k                             allmodconfig
s390                             allyesconfig
arc                              allyesconfig
i386                          randconfig-a012
x86_64                           allyesconfig
i386                          randconfig-a016
alpha                            allyesconfig
arm                              allyesconfig
arm64                            allyesconfig

clang tested configs:
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64               randconfig-a014-20221114
x86_64               randconfig-a012-20221114
x86_64               randconfig-a013-20221114
x86_64               randconfig-a011-20221114
x86_64               randconfig-a016-20221114
x86_64               randconfig-a015-20221114
hexagon              randconfig-r045-20221114
hexagon              randconfig-r045-20221115
hexagon              randconfig-r041-20221114
i386                          randconfig-a013
s390                 randconfig-r044-20221114
hexagon              randconfig-r041-20221115
riscv                randconfig-r042-20221114
i386                          randconfig-a011
i386                          randconfig-a015

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
