Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA4160B56F
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 20:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiJXS0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 14:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiJXS0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 14:26:33 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD117F100;
        Mon, 24 Oct 2022 10:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666631284; x=1698167284;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=9hFNN8FocKL1s+t62fqYOxCC2IjJmS0OeL8/lk60yi4=;
  b=ZB3Le7AknfvHmRCA5ulPNGOt4r+KoJBwaOnpK4h/nvonVF61OUB4S720
   Pi+5EnIdzYU5x/GSaQcowY13AKjFsC54opoLgyHRdPcm6UYCsAyOlHTsO
   5WlvLu6eE61RhNDirXrBkjpAuLt3eVQ92Dpe/OKKDTu6LXZNqxHNOXEC5
   eiCSVXtbN9Ww+OtJr+jQTJ8KNOb5+VBj0dglefCjWifzND6qAw6/kA+2e
   qSlfW55d3QM9584nwFkFIXK6iHYGeDjDKjTQXoVZTw1YmXVzROJZmOalU
   96h/lBH2lW6T1wdGMITxZl9aHsTbKyYRWIUCNXGBkDeTAnLghVTdiyqS4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="371689507"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="371689507"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 09:59:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10510"; a="662496666"
X-IronPort-AV: E=Sophos;i="5.95,209,1661842800"; 
   d="scan'208";a="662496666"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 24 Oct 2022 09:59:46 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1on0nh-0005Wl-1e;
        Mon, 24 Oct 2022 16:59:45 +0000
Date:   Tue, 25 Oct 2022 00:58:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     ntfs3@lists.linux.dev, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD SUCCESS WITH WARNING
 76cf65d1377f733af1e2a55233e3353ffa577f54
Message-ID: <6356c451.pwLIF+9EvDUrDjTY%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 76cf65d1377f733af1e2a55233e3353ffa577f54  Add linux-next specific files for 20221024

Warning reports:

https://lore.kernel.org/linux-mm/202210090954.pTR6m6rj-lkp@intel.com
https://lore.kernel.org/linux-mm/202210110857.9s0tXVNn-lkp@intel.com
https://lore.kernel.org/linux-mm/202210111318.mbUfyhps-lkp@intel.com
https://lore.kernel.org/linux-mm/202210240729.zs46Cfzo-lkp@intel.com

Warning: (recently discovered and may have been fixed)

arch/parisc/kernel/setup.c:78 setup_cmdline() warn: curly braces intended?
drivers/net/phy/phylink.c:588 phylink_validate_mask_caps() warn: variable dereferenced before check 'state' (see line 583)

Warning ids grouped by kconfigs:

gcc_recent_errors
|-- i386-randconfig-s041-20221024
|   |-- fs-ntfs3-index.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- fs-ntfs3-namei.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-__le16-const-usertype-s1-got-unsigned-short
|   `-- fs-ntfs3-namei.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-restricted-__le16-const-usertype-s2-got-unsigned-short
|-- microblaze-randconfig-m031-20221023
|   `-- drivers-net-phy-phylink.c-phylink_validate_mask_caps()-warn:variable-dereferenced-before-check-state-(see-line-)
|-- parisc-randconfig-m031-20221023
|   `-- arch-parisc-kernel-setup.c-setup_cmdline()-warn:curly-braces-intended
`-- x86_64-randconfig-m001
    `-- arch-x86-kernel-apic-apic.c-generic_processor_info()-warn:always-true-condition-(num_processors-()-)-(-u32max-)
clang_recent_errors
|-- hexagon-randconfig-r045-20221023
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt2701.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8183.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   |-- drivers-phy-mediatek-phy-mtk-tphy.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(unsigned-c
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- i386-randconfig-a001-20221024
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- i386-randconfig-a011
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- i386-randconfig-a015
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- powerpc-randconfig-r015-20221023
|   |-- drivers-gpu-drm-amd-amdgpu-mmhub_v2_0.c:warning:variable-data-is-uninitialized-when-used-here
|   |-- drivers-phy-mediatek-phy-mtk-tphy.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(unsigned-c
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- riscv-randconfig-r042-20221023
|   `-- ld.lld:error:undefined-symbol:dax_holder_notify_failure
|-- s390-randconfig-r022-20221023
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- s390-randconfig-r044-20221023
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- x86_64-randconfig-a002-20221024
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- x86_64-randconfig-a004-20221024
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
`-- x86_64-randconfig-a005-20221024
    `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true

elapsed time: 726m

configs tested: 91
configs skipped: 3

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                          rhel-8.3-func
i386                                defconfig
x86_64               randconfig-a013-20221024
x86_64                               rhel-8.3
x86_64               randconfig-a012-20221024
x86_64                           allyesconfig
x86_64                           rhel-8.3-syz
x86_64                           rhel-8.3-kvm
m68k                        m5272c3_defconfig
x86_64               randconfig-a016-20221024
powerpc                           allnoconfig
arm                                 defconfig
mips                             allyesconfig
x86_64               randconfig-a011-20221024
i386                          randconfig-a014
powerpc                          allmodconfig
x86_64               randconfig-a015-20221024
csky                              allnoconfig
i386                             allyesconfig
sh                          kfr2r09_defconfig
sh                               allmodconfig
x86_64               randconfig-a014-20221024
i386                          randconfig-a012
i386                          randconfig-a016
arc                                 defconfig
alpha                            allyesconfig
powerpc                      makalu_defconfig
arm                              allyesconfig
arm                            xcep_defconfig
m68k                             allmodconfig
powerpc                    amigaone_defconfig
sh                           sh2007_defconfig
arm64                            allyesconfig
arc                              allyesconfig
arc                  randconfig-r043-20221024
m68k                             allyesconfig
arc                         haps_hs_defconfig
alpha                               defconfig
sh                            migor_defconfig
mips                     loongson1b_defconfig
riscv                randconfig-r042-20221024
s390                                defconfig
parisc                generic-64bit_defconfig
arc                  randconfig-r043-20221023
s390                             allmodconfig
xtensa                          iss_defconfig
s390                 randconfig-r044-20221024
powerpc                      bamboo_defconfig
ia64                             allmodconfig
s390                             allyesconfig
arm                        shmobile_defconfig
arm                            hisi_defconfig
arc                          axs103_defconfig
powerpc                        cell_defconfig
mips                        bcm47xx_defconfig
sparc                       sparc64_defconfig
x86_64                         rhel-8.3-kunit

clang tested configs:
i386                 randconfig-a001-20221024
i386                 randconfig-a002-20221024
i386                 randconfig-a003-20221024
i386                 randconfig-a004-20221024
i386                 randconfig-a005-20221024
i386                 randconfig-a006-20221024
hexagon              randconfig-r045-20221023
i386                          randconfig-a013
hexagon              randconfig-r041-20221024
i386                          randconfig-a011
riscv                randconfig-r042-20221023
x86_64               randconfig-a001-20221024
arm                          moxart_defconfig
powerpc                      obs600_defconfig
x86_64               randconfig-a005-20221024
x86_64               randconfig-a003-20221024
powerpc                       ebony_defconfig
x86_64               randconfig-a006-20221024
i386                          randconfig-a015
hexagon              randconfig-r045-20221024
x86_64               randconfig-a004-20221024
arm                             mxs_defconfig
s390                 randconfig-r044-20221023
mips                       rbtx49xx_defconfig
x86_64               randconfig-a002-20221024
arm                          pxa168_defconfig
powerpc                     tqm8540_defconfig
powerpc                      ppc44x_defconfig
hexagon              randconfig-r041-20221023
arm                            dove_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
