Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F2C60D257
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 19:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbiJYRSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 13:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiJYRSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 13:18:24 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A89F159A37;
        Tue, 25 Oct 2022 10:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666718303; x=1698254303;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=o+HzEuDfAAEoVRMr0f+9fq2bvIH6vQ0gqFpLaf4Zkdw=;
  b=LzjbAQCh/U9D3m4WH9YidHSLA3/8VgMThlVysJrpLvbYErl/z25HNr/8
   C5TxEw0iAbilugUTE18NYm8REBOkQ+kVhYHF/MJyXdn/sTTExtydBnMBb
   uwe79LKIufIHBX5EWmAgO2INzAEKPUi3wp4bBh3j/hY5P3tZNxhAJbqV8
   XCKBu3XByLQkM/hhGb8QBLMMlg+lPRXX5LNiromdAvBNpkjZUHxw0C+FS
   Jh9E4979aT6TMQgqc2J/CL0nQ+1xja25rQfZt0I7/C96hL1wxLdZ496AF
   ZdiMWIlu/Jq/zgqURTBVLB5Yzw0clQZLg//wrVtE3ZLkycY/W3VRkkRty
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="287458334"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="287458334"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 10:18:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="631707576"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="631707576"
Received: from lkp-server02.sh.intel.com (HELO b6d29c1a0365) ([10.239.97.151])
  by orsmga002.jf.intel.com with ESMTP; 25 Oct 2022 10:18:19 -0700
Received: from kbuild by b6d29c1a0365 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1onNZD-0006UG-0E;
        Tue, 25 Oct 2022 17:18:19 +0000
Date:   Wed, 26 Oct 2022 01:17:48 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     ntfs3@lists.linux.dev, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        linux-mm@kvack.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 89bf6e28373beef9577fa71f996a5f73a569617c
Message-ID: <63581a3c.U6bx8B6mFoRe2pWN%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,SUSPICIOUS_RECIPS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 89bf6e28373beef9577fa71f996a5f73a569617c  Add linux-next specific files for 20221025

Error/Warning reports:

https://lore.kernel.org/linux-mm/202210110857.9s0tXVNn-lkp@intel.com
https://lore.kernel.org/linux-mm/202210240729.zs46Cfzo-lkp@intel.com
https://lore.kernel.org/linux-mm/202210251946.eT92YAhG-lkp@intel.com
https://lore.kernel.org/llvm/202210260009.9qq1JXZi-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/net/ethernet/broadcom/genet/bcmgenet.c:1497:5-13: ERROR: invalid reference to the index variable of the iterator on line 1475
drivers/scsi/pm8001/pm8001_sas.c:996 pm8001_abort_task() warn: variable dereferenced before check 'task' (see line 986)

Unverified Error/Warning (likely false positive, please contact us if interested):

ERROR: modpost: "devm_ioremap" [drivers/net/ethernet/altera/altera_tse.ko] undefined!
ERROR: modpost: "ioremap" [drivers/net/ethernet/fujitsu/fmvj18x_cs.ko] undefined!
ERROR: modpost: "ioremap" [drivers/tty/ipwireless/ipwireless.ko] undefined!
ERROR: modpost: "iounmap" [drivers/net/ethernet/fujitsu/fmvj18x_cs.ko] undefined!
ERROR: modpost: "iounmap" [drivers/tty/ipwireless/ipwireless.ko] undefined!
mm/khugepaged.c:1729:7: warning: variable 'index' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
mm/khugepaged.c:1729:7: warning: variable 'nr' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- ia64-randconfig-c033-20221025
|   `-- drivers-net-ethernet-broadcom-genet-bcmgenet.c:ERROR:invalid-reference-to-the-index-variable-of-the-iterator-on-line
`-- x86_64-randconfig-m001-20221024
    `-- drivers-scsi-pm8001-pm8001_sas.c-pm8001_abort_task()-warn:variable-dereferenced-before-check-task-(see-line-)
clang_recent_errors
|-- arm-randconfig-r013-20221024
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt2701.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8183.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- arm-randconfig-r014-20221024
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt2701.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8183.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   |-- drivers-phy-mediatek-phy-mtk-tphy.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(unsigned-c
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- hexagon-randconfig-r045-20221023
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt2701.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   |-- drivers-phy-mediatek-phy-mtk-hdmi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(uns
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8173.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   |-- drivers-phy-mediatek-phy-mtk-mipi-dsi-mt8183.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:
|   |-- drivers-phy-mediatek-phy-mtk-tphy.c:warning:result-of-comparison-of-constant-with-expression-of-type-typeof-(_Generic((mask_)-char:(unsigned-char)-unsigned-char:(unsigned-char)-signed-char:(unsigned-c
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- i386-randconfig-a001-20221024
|   |-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|   `-- mm-khugepaged.c:warning:variable-index-is-used-uninitialized-whenever-if-condition-is-true
|-- mips-randconfig-r012-20221024
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- powerpc-randconfig-r024-20221025
|   `-- arch-powerpc-mm-nohash-e500.c:error:no-previous-prototype-for-function-relocate_init-Werror-Wmissing-prototypes
|-- riscv-randconfig-r042-20221023
|   `-- ld.lld:error:undefined-symbol:dax_holder_notify_failure
|-- s390-randconfig-r004-20221024
|   |-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|   |-- mm-khugepaged.c:warning:variable-index-is-used-uninitialized-whenever-if-condition-is-true
|   `-- mm-khugepaged.c:warning:variable-nr-is-used-uninitialized-whenever-if-condition-is-true
|-- s390-randconfig-r012-20221023
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- s390-randconfig-r026-20221025
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- s390-randconfig-r044-20221023
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- s390-randconfig-r044-20221025
|   |-- ERROR:devm_ioremap-drivers-net-ethernet-altera-altera_tse.ko-undefined
|   |-- ERROR:ioremap-drivers-net-ethernet-fujitsu-fmvj18x_cs.ko-undefined
|   |-- ERROR:ioremap-drivers-tty-ipwireless-ipwireless.ko-undefined
|   |-- ERROR:iounmap-drivers-net-ethernet-fujitsu-fmvj18x_cs.ko-undefined
|   `-- ERROR:iounmap-drivers-tty-ipwireless-ipwireless.ko-undefined
|-- x86_64-randconfig-a004-20221024
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- x86_64-randconfig-a005-20221024
|   `-- fs-ntfs3-namei.c:warning:variable-uni1-is-used-uninitialized-whenever-if-condition-is-true
|-- x86_64-randconfig-a012

elapsed time: 726m

configs tested: 74
configs skipped: 2

gcc tested configs:
powerpc                           allnoconfig
um                             i386_defconfig
arc                                 defconfig
um                           x86_64_defconfig
alpha                               defconfig
x86_64                              defconfig
s390                                defconfig
x86_64                           rhel-8.3-syz
s390                             allmodconfig
x86_64                         rhel-8.3-kunit
x86_64                        randconfig-a013
x86_64                           rhel-8.3-kvm
x86_64                        randconfig-a011
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
x86_64                        randconfig-a015
s390                             allyesconfig
i386                                defconfig
x86_64                               rhel-8.3
arm                                 defconfig
arc                  randconfig-r043-20221024
i386                 randconfig-a014-20221024
i386                 randconfig-a013-20221024
riscv                randconfig-r042-20221024
i386                 randconfig-a012-20221024
arc                  randconfig-r043-20221023
i386                             allyesconfig
i386                 randconfig-a016-20221024
x86_64                           allyesconfig
arm                              allyesconfig
i386                 randconfig-a011-20221024
powerpc                       eiger_defconfig
i386                 randconfig-a015-20221024
sh                               allmodconfig
m68k                             allmodconfig
arm64                            allyesconfig
s390                 randconfig-r044-20221024
powerpc                      chrp32_defconfig
sh                            migor_defconfig
arc                              allyesconfig
mips                             allyesconfig
sh                      rts7751r2d1_defconfig
csky                             alldefconfig
powerpc                          allmodconfig
alpha                            allyesconfig
m68k                             allyesconfig
sh                          lboxre2_defconfig
powerpc                     tqm8555_defconfig
sh                           se7712_defconfig

clang tested configs:
x86_64                        randconfig-a012
x86_64                        randconfig-a014
hexagon              randconfig-r041-20221024
x86_64                        randconfig-a016
riscv                randconfig-r042-20221023
x86_64               randconfig-a001-20221024
hexagon              randconfig-r045-20221024
i386                 randconfig-a001-20221024
x86_64               randconfig-a003-20221024
x86_64               randconfig-a004-20221024
s390                 randconfig-r044-20221023
i386                 randconfig-a002-20221024
x86_64               randconfig-a002-20221024
x86_64               randconfig-a005-20221024
i386                 randconfig-a005-20221024
i386                 randconfig-a003-20221024
hexagon              randconfig-r041-20221023
x86_64                          rhel-8.3-rust
powerpc                 xes_mpc85xx_defconfig
i386                 randconfig-a004-20221024
hexagon              randconfig-r045-20221023
x86_64               randconfig-a006-20221024
i386                 randconfig-a006-20221024
powerpc                 mpc832x_mds_defconfig
powerpc                     powernv_defconfig

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
