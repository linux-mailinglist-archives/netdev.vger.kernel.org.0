Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB885F4CD6
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 01:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiJDXvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 19:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJDXvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 19:51:47 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA5F3FD5F;
        Tue,  4 Oct 2022 16:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664927506; x=1696463506;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=j5j93ep56qWM4Aggptg3rLl2Drpk5XL00qe9ecX3sk8=;
  b=g1gf58HbYRDKaWGkO5+yk3tScaOipwCiJtt5oi7zUiJEHc4w3V7aGxCK
   Q/86B7351wM1II/cqh71JMqHDBWYjv2MPuJWBzgx/RAbgZKP6pFg5S0KB
   RmRKyDlTIjH8Ide8iyGPcj04xNzcmRohSiH0bHCh6a25E6WiUgHjTdLfw
   NHSm2EtMuo6CIo/tJbpfX8zLl6BrgPQ4aFr/4KY96jjQazkqhPr1X1VuT
   8msslzoZ5EJ5C2a1Fd9gG1eNTjHXazRhYEgoX8Fz9Xuf7ucJCKDL/S+32
   Q8HwMLQaZM3A/qukPk2n2aDU2VYbTakPQEQ4Y6psPDZdtvbE/UfcX1TMJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="367170915"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="367170915"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 16:51:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="713229064"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="713229064"
Received: from lkp-server01.sh.intel.com (HELO d4f44333118a) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Oct 2022 16:51:42 -0700
Received: from kbuild by d4f44333118a with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1ofrhN-0000ft-1y;
        Tue, 04 Oct 2022 23:51:41 +0000
Date:   Wed, 05 Oct 2022 07:51:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, loongarch@lists.linux.dev,
        linux-spi@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        bpf@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 4d80748d16c82a9c2c4ea5feea96e476de3cd876
Message-ID: <633cc6f0.nUuOxmXokJvNe3YF%lkp@intel.com>
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
branch HEAD: 4d80748d16c82a9c2c4ea5feea96e476de3cd876  Add linux-next specific files for 20221004

Error/Warning reports:

https://lore.kernel.org/linux-mm/202209150141.WgbAKqmX-lkp@intel.com
https://lore.kernel.org/linux-mm/202209251400.1TMn7RdE-lkp@intel.com
https://lore.kernel.org/linux-mm/202210010718.2kaVANGb-lkp@intel.com
https://lore.kernel.org/llvm/202209200834.EFwaTsIj-lkp@intel.com
https://lore.kernel.org/llvm/202209220019.Yr2VuXhg-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

ERROR: modpost: "devm_ioremap_resource" [drivers/dma/fsl-edma.ko] undefined!
ERROR: modpost: "devm_ioremap_resource" [drivers/dma/idma64.ko] undefined!
ERROR: modpost: "devm_ioremap_resource" [drivers/dma/qcom/hdma.ko] undefined!
ERROR: modpost: "devm_memremap" [drivers/misc/open-dice.ko] undefined!
ERROR: modpost: "devm_memunmap" [drivers/misc/open-dice.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/char/xillybus/xillybus_of.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/clk/xilinx/clk-xlnx-clock-wizard.ko] undefined!
ERROR: modpost: "ioremap" [drivers/tty/ipwireless/ipwireless.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/ethernet/8390/pcnet_cs.ko] undefined!
ERROR: modpost: "iounmap" [drivers/tty/ipwireless/ipwireless.ko] undefined!
arch/arm64/kernel/alternative.c:199:6: warning: no previous prototype for 'apply_alternatives_vdso' [-Wmissing-prototypes]
arch/arm64/kernel/alternative.c:295:14: warning: no previous prototype for 'alt_cb_patch_nops' [-Wmissing-prototypes]
arch/loongarch/kernel/traps.c:250 die() warn: variable dereferenced before check 'regs' (see line 244)
arch/loongarch/mm/init.c:166:24: warning: variable 'new' set but not used [-Wunused-but-set-variable]
drivers/platform/loongarch/loongson-laptop.c:377 loongson_laptop_get_brightness() warn: impossible condition '(level < 0) => (0-255 < 0)'
drivers/spi/spi.c:4215:33: warning: use of uninitialized value '((int *)_38 = PHI <&x(2), _91(3)>)[11]' [CWE-457] [-Wanalyzer-use-of-uninitialized-value]
include/linux/compiler_types.h:357:45: error: call to '__compiletime_assert_417' declared with attribute error: FIELD_GET: mask is not constant
kernel/bpf/memalloc.c:500 bpf_mem_alloc_destroy() error: potentially dereferencing uninitialized 'c'.
net/dsa/port.c:1684 dsa_port_phylink_create() warn: passing zero to 'PTR_ERR'
pahole: .tmp_vmlinux.btf: No such file or directory

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- arm-randconfig-c002-20221002
|   `-- drivers-spi-spi.c:warning:use-of-uninitialized-value-((int-)_38-PHI-x()-_91()-)-CWE
|-- arm64-allyesconfig
|   |-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-alt_cb_patch_nops
|   `-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-apply_alternatives_vdso
|-- arm64-randconfig-r004-20221002
|   |-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-alt_cb_patch_nops
|   `-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-apply_alternatives_vdso
|-- arm64-randconfig-r016-20221003
|   |-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-alt_cb_patch_nops
|   `-- arch-arm64-kernel-alternative.c:warning:no-previous-prototype-for-apply_alternatives_vdso
|-- i386-randconfig-m021-20221003
|   `-- net-dsa-port.c-dsa_port_phylink_create()-warn:passing-zero-to-PTR_ERR
|-- loongarch-buildonly-randconfig-r006-20221003
|   `-- arch-loongarch-mm-init.c:warning:variable-new-set-but-not-used
|-- loongarch-randconfig-m031-20221002
|   `-- arch-loongarch-mm-init.c:warning:variable-new-set-but-not-used
|-- loongarch-randconfig-m041-20221002
|   |-- arch-loongarch-kernel-traps.c-die()-warn:variable-dereferenced-before-check-regs-(see-line-)
|   |-- arch-loongarch-mm-init.c:warning:variable-new-set-but-not-used
|   |-- drivers-platform-loongarch-loongson-laptop.c-loongson_laptop_get_brightness()-warn:impossible-condition-(level-)-(-)
|   `-- kernel-bpf-memalloc.c-bpf_mem_alloc_destroy()-error:potentially-dereferencing-uninitialized-c-.
|-- loongarch-randconfig-r001-20221002
|   `-- arch-loongarch-mm-init.c:warning:variable-new-set-but-not-used
|-- m68k-randconfig-r004-20221003
|   `-- pahole:.tmp_vmlinux.btf:No-such-file-or-directory
|-- s390-allmodconfig
|   |-- ERROR:devm_ioremap_resource-drivers-dma-fsl-edma.ko-undefined
|   |-- ERROR:devm_ioremap_resource-drivers-dma-idma64.ko-undefined
|   |-- ERROR:devm_ioremap_resource-drivers-dma-qcom-hdma.ko-undefined
|   |-- ERROR:devm_memremap-drivers-misc-open-dice.ko-undefined
|   |-- ERROR:devm_memunmap-drivers-misc-open-dice.ko-undefined
|   |-- ERROR:devm_platform_ioremap_resource-drivers-char-xillybus-xillybus_of.ko-undefined
|   |-- ERROR:devm_platform_ioremap_resource-drivers-clk-xilinx-clk-xlnx-clock-wizard.ko-undefined
|   |-- ERROR:ioremap-drivers-tty-ipwireless-ipwireless.ko-undefined
|   |-- ERROR:iounmap-drivers-net-ethernet-pcnet_cs.ko-undefined
|   `-- ERROR:iounmap-drivers-tty-ipwireless-ipwireless.ko-undefined
`-- x86_64-randconfig-a012-20221003
    `-- include-linux-compiler_types.h:error:call-to-__compiletime_assert_NNN-declared-with-attribute-error:FIELD_GET:mask-is-not-constant
clang_recent_errors
|-- arm-randconfig-r022-20221003
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt2701.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   `-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8183.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|-- mips-randconfig-r003-20221002
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt2701.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   `-- drivers-phy-mediatek-phy-mtk-hdmi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|-- s390-randconfig-r021-20221002
|   |-- manage.c:(.text):undefined-reference-to-__tsan_memcpy
|   |-- s39-linux-ld:setup.c:(.init.text):undefined-reference-to-__tsan_memcpy
|   |-- s39-linux-ld:trace.c:(.init.text):undefined-reference-to-__tsan_memcpy
|   |-- trace.c:(.init.text):undefined-reference-to-__tsan_memcpy
|   `-- workqueue.c:(.init.text):undefined-reference-to-__tsan_memcpy
|-- s390-randconfig-r026-20221002
|   `-- ERROR:devm_ioremap_resource-drivers-dma-idma64.ko-undefined
`-- x86_64-buildonly-randconfig-r005-20221003
    |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-virtual-virtual_link_hwss.c:warning:no-previous-prototype-for-function-virtual_disable_link_output
    `-- drivers-iommu-ipmmu-vmsa.c:warning:unused-variable-ipmmu_of_ids

elapsed time: 726m

configs tested: 58
configs skipped: 3

gcc tested configs:
powerpc                           allnoconfig
arc                                 defconfig
alpha                               defconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                          rhel-8.3-func
x86_64                              defconfig
x86_64                    rhel-8.3-kselftests
sh                               allmodconfig
s390                                defconfig
s390                             allmodconfig
riscv                randconfig-r042-20221003
arc                  randconfig-r043-20221003
x86_64                               rhel-8.3
arc                              allyesconfig
i386                                defconfig
arm                                 defconfig
alpha                            allyesconfig
i386                 randconfig-a011-20221003
x86_64                           rhel-8.3-syz
i386                 randconfig-a012-20221003
s390                 randconfig-r044-20221003
mips                             allyesconfig
s390                             allyesconfig
m68k                             allmodconfig
x86_64                         rhel-8.3-kunit
powerpc                          allmodconfig
i386                 randconfig-a013-20221003
m68k                             allyesconfig
i386                 randconfig-a015-20221003
x86_64                           rhel-8.3-kvm
i386                 randconfig-a014-20221003
x86_64                           allyesconfig
ia64                             allmodconfig
x86_64               randconfig-a011-20221003
arm                              allyesconfig
x86_64               randconfig-a012-20221003
arm64                            allyesconfig
x86_64               randconfig-a013-20221003
x86_64               randconfig-a015-20221003
x86_64               randconfig-a014-20221003
x86_64               randconfig-a016-20221003
i386                             allyesconfig

clang tested configs:
hexagon              randconfig-r045-20221003
i386                 randconfig-a004-20221003
hexagon              randconfig-r041-20221003
i386                 randconfig-a003-20221003
i386                 randconfig-a002-20221003
i386                 randconfig-a001-20221003
i386                 randconfig-a006-20221003
i386                 randconfig-a005-20221003
x86_64               randconfig-a002-20221003
x86_64               randconfig-a001-20221003
x86_64               randconfig-a004-20221003
x86_64               randconfig-a006-20221003
x86_64               randconfig-a003-20221003
x86_64               randconfig-a005-20221003
x86_64                          rhel-8.3-rust

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
