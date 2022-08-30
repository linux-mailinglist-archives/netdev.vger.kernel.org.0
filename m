Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018CE5A6E0F
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 22:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiH3UDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 16:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiH3UDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 16:03:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A11385FF0;
        Tue, 30 Aug 2022 13:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661889705; x=1693425705;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=CqNTEbBj+aU8uQLnwNgs4Fx+qVT4u7TMvnZMsVQSRo8=;
  b=VCANYLn4F/pytvihWyANiUQjEXe9o2kXyATGcUHEdsE7EYHxEpyciyfD
   NWrgz0gI/ZJVm4YYUI4XiJlKH33DSDZ7LrlwNK+7XxfwJMktmYRaQzZbr
   bS6QSLEs7RHtoetYkjclkYbOer49dUygsBGR6vH6CVOC2Ywm+Ey2TraEK
   ZC7YBHbCTPHA08Cfyva1loBOHTUXuEbYDuPZqX2HtcqrN8Ts0mivGHt21
   72elje9B2zSO9x4Qimw19/1g/Ndk5GkNAopsrRxnAzey4/3//QOJAdHG8
   XWFgGaktVB98wndP55zCMGAh7UBAJSz5bCkYCeEHz+rnTsZi+qS8Yr5M9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="296566889"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="296566889"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 13:01:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="940171478"
Received: from lkp-server02.sh.intel.com (HELO 77b6d4e16fc5) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 30 Aug 2022 13:01:29 -0700
Received: from kbuild by 77b6d4e16fc5 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oT7QP-0000YF-0y;
        Tue, 30 Aug 2022 20:01:29 +0000
Date:   Wed, 31 Aug 2022 04:00:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     platform-driver-x86@vger.kernel.org, netdev@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 282342f2dc97ccf54254c5de51bcc1101229615f
Message-ID: <630e6c69.DblIjjIUeOlyMD/o%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 282342f2dc97ccf54254c5de51bcc1101229615f  Add linux-next specific files for 20220830

Error/Warning reports:

https://lore.kernel.org/linux-mm/202208190147.RwbMifl8-lkp@intel.com
https://lore.kernel.org/linux-mm/202208302355.iv88x9c8-lkp@intel.com
https://lore.kernel.org/linux-mm/202208310340.bfIiSHdK-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

drivers/base/regmap/regmap-mmio.c:221:17: error: implicit declaration of function 'writesb'; did you mean 'writeb'? [-Werror=implicit-function-declaration]
drivers/base/regmap/regmap-mmio.c:224:17: error: implicit declaration of function 'writesw'; did you mean 'writew'? [-Werror=implicit-function-declaration]
drivers/base/regmap/regmap-mmio.c:227:17: error: implicit declaration of function 'writesl'; did you mean 'writel'? [-Werror=implicit-function-declaration]
drivers/base/regmap/regmap-mmio.c:231:17: error: implicit declaration of function 'writesq'; did you mean 'writeq'? [-Werror=implicit-function-declaration]
drivers/base/regmap/regmap-mmio.c:231:17: error: implicit declaration of function 'writesq'; did you mean 'writesl'? [-Werror=implicit-function-declaration]
drivers/base/regmap/regmap-mmio.c:358:17: error: implicit declaration of function 'readsb'; did you mean 'readb'? [-Werror=implicit-function-declaration]
drivers/base/regmap/regmap-mmio.c:361:17: error: implicit declaration of function 'readsw'; did you mean 'readw'? [-Werror=implicit-function-declaration]
drivers/base/regmap/regmap-mmio.c:364:17: error: implicit declaration of function 'readsl'; did you mean 'readl'? [-Werror=implicit-function-declaration]
drivers/base/regmap/regmap-mmio.c:368:17: error: implicit declaration of function 'readsq'; did you mean 'readq'? [-Werror=implicit-function-declaration]
drivers/base/regmap/regmap-mmio.c:368:17: error: implicit declaration of function 'readsq'; did you mean 'readsl'? [-Werror=implicit-function-declaration]
drivers/platform/mellanox/mlxreg-lc.c:866 mlxreg_lc_probe() warn: passing zero to 'PTR_ERR'
fs/btrfs/volumes.c:6549 __btrfs_map_block() error: we previously assumed 'mirror_num_ret' could be null (see line 6376)
mm/memory-tiers.c:647:49: error: 'top_tier_adistance' undeclared (first use in this function)
net/ieee802154/nl802154.c:2503:26: error: 'NL802154_CMD_DEL_SEC_LEVEL' undeclared here (not in a function); did you mean 'NL802154_CMD_SET_CCA_ED_LEVEL'?

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsb
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsl
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsq
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsw
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-writesb
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-writesl
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-writesq
|   `-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-writesw
|-- alpha-randconfig-c033-20220830
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsb
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsl
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsq
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsw
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-writesb
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-writesl
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-writesq
|   `-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-writesw
|-- alpha-randconfig-r016-20220830
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsb
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsl
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsq
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsw
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-writesb
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-writesl
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-writesq
|   `-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-writesw
|-- i386-randconfig-c001
|   `-- net-ieee802154-nl802154.c:error:NL802154_CMD_DEL_SEC_LEVEL-undeclared-here-(not-in-a-function)
|-- i386-randconfig-c021
|   `-- net-ieee802154-nl802154.c:error:NL802154_CMD_DEL_SEC_LEVEL-undeclared-here-(not-in-a-function)
|-- i386-randconfig-s001
|   `-- include-trace-events-kmem.h:sparse:sparse:restricted-gfp_t-degrades-to-integer
|-- i386-randconfig-s002
|   `-- include-trace-events-kmem.h:sparse:sparse:restricted-gfp_t-degrades-to-integer
|-- i386-randconfig-s003
|   `-- include-trace-events-kmem.h:sparse:sparse:restricted-gfp_t-degrades-to-integer
|-- loongarch-randconfig-c041-20220830
|   `-- net-ieee802154-nl802154.c:error:NL802154_CMD_DEL_SEC_LEVEL-undeclared-here-(not-in-a-function)
|-- loongarch-randconfig-r003-20220830
|   `-- mm-memory-tiers.c:error:top_tier_adistance-undeclared-(first-use-in-this-function)
|-- microblaze-randconfig-s033-20220830
|   `-- include-trace-events-kmem.h:sparse:sparse:restricted-gfp_t-degrades-to-integer
|-- mips-randconfig-s031-20220830
|   |-- include-trace-events-kmem.h:sparse:sparse:restricted-gfp_t-degrades-to-integer
|   `-- mm-vmscan.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-lockdep_map-const-lock-got-struct-lockdep_map-noderef-__rcu
|-- parisc-buildonly-randconfig-r002-20220830
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsb
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsl
|   |-- drivers-base-regmap-regmap-mmio.c:error:implicit-declaration-of-function-readsw
clang_recent_errors
|-- powerpc-buildonly-randconfig-r005-20220830
|   `-- drivers-net-ethernet-mellanox-mlx5-core-en_rep.c:warning:variable-err-is-used-uninitialized-whenever-if-condition-is-false
`-- x86_64-randconfig-a016
    `-- mm-memory-tiers.c:error:use-of-undeclared-identifier-top_tier_adistance

elapsed time: 737m

configs tested: 96
configs skipped: 3

gcc tested configs:
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                               rhel-8.3
arm                                 defconfig
i386                                defconfig
x86_64                        randconfig-a013
arc                  randconfig-r043-20220830
x86_64                    rhel-8.3-kselftests
arc                               allnoconfig
i386                          randconfig-a001
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                        randconfig-a011
x86_64                           allyesconfig
x86_64                           rhel-8.3-kvm
mips                           gcw0_defconfig
openrisc                 simple_smp_defconfig
i386                          randconfig-a003
alpha                             allnoconfig
x86_64                        randconfig-a015
x86_64                           rhel-8.3-syz
powerpc                           allnoconfig
powerpc                 mpc837x_mds_defconfig
powerpc                        cell_defconfig
riscv                             allnoconfig
m68k                        m5407c3_defconfig
csky                              allnoconfig
i386                          randconfig-a005
mips                             allyesconfig
powerpc                          allmodconfig
i386                          randconfig-a014
arm                              allyesconfig
m68k                             allmodconfig
sh                         ecovec24_defconfig
arm                            mps2_defconfig
arm64                            allyesconfig
loongarch                 loongson3_defconfig
s390                       zfcpdump_defconfig
i386                          randconfig-a012
arm                        shmobile_defconfig
i386                          randconfig-a016
arc                              allyesconfig
sh                            migor_defconfig
sh                               allmodconfig
i386                             allyesconfig
alpha                            allyesconfig
x86_64                        randconfig-a004
ia64                      gensparse_defconfig
x86_64                           alldefconfig
x86_64                        randconfig-a002
ia64                             alldefconfig
sh                      rts7751r2d1_defconfig
m68k                             allyesconfig
ia64                             allmodconfig
powerpc                  storcenter_defconfig
x86_64                        randconfig-a006
arc                                 defconfig
csky                                defconfig
sparc                               defconfig
alpha                               defconfig
x86_64                                  kexec
i386                          randconfig-c001
riscv                               defconfig
s390                                defconfig
s390                             allmodconfig

clang tested configs:
hexagon              randconfig-r045-20220830
x86_64                        randconfig-a014
mips                        maltaup_defconfig
hexagon              randconfig-r041-20220830
x86_64                        randconfig-a016
arm                         orion5x_defconfig
x86_64                        randconfig-a012
s390                 randconfig-r044-20220830
powerpc                        fsp2_defconfig
riscv                randconfig-r042-20220830
i386                          randconfig-a002
powerpc                 mpc8315_rdb_defconfig
riscv                             allnoconfig
powerpc                     kmeter1_defconfig
i386                          randconfig-a013
i386                          randconfig-a004
i386                          randconfig-a006
arm                       mainstone_defconfig
i386                          randconfig-a011
powerpc                 mpc832x_rdb_defconfig
mips                     cu1830-neo_defconfig
i386                          randconfig-a015
powerpc                  mpc885_ads_defconfig
mips                       rbtx49xx_defconfig
arm                            dove_defconfig
x86_64                        randconfig-a001
powerpc                     pseries_defconfig
x86_64                        randconfig-a003
x86_64                        randconfig-a005
x86_64                          rhel-8.3-rust
x86_64                        randconfig-k001

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
