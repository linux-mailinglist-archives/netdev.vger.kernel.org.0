Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0CC675AE1
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjATROZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjATROZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:14:25 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C766837B45;
        Fri, 20 Jan 2023 09:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674234863; x=1705770863;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=BfH+DhemtVbRApOmVu9miMo8w9suHcbrBpKwXq6ubtM=;
  b=DIa/M1FH0aUzcvsq7yQ1NsipPirrMRRCg8ov4Z6UR/eN/Oy/dJTVmGpK
   IYX3kNRW6+WlS/VckYedouMAm9hiy0pR2ca0iOTpybjzBw78t6kTu8ew6
   ZkqXcOO9ST6HJHwL/Jl7ZSIsK8Pb5SU8jmk43+Xv04NqRmXu2jUk4B54i
   d1t8H8iFNcQ3jz7jM333t1YXv0KEhrYWtybtwofoUSpjWu1ZRAGQtllOI
   PVoA9ucl94Ag51hc1dHf3tdtiZ8FeEveXKch/ll1+z77VE2QGoFzH2xHZ
   Xebjm/AssutRgTaT3Hg1AuJyCbtGQXoNKPoPkpxIe7aEaFMaxoczQYjqf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="326907271"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="326907271"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 09:14:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="803128754"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="803128754"
Received: from lkp-server01.sh.intel.com (HELO 5646d64e7320) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jan 2023 09:14:20 -0800
Received: from kbuild by 5646d64e7320 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pIuxw-0002jq-0P;
        Fri, 20 Jan 2023 17:14:12 +0000
Date:   Sat, 21 Jan 2023 01:13:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     sound-open-firmware@alsa-project.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 d514392f17fd4d386cfadde7f849d97db4ca1fb0
Message-ID: <63cacbd5.EvTYTGZtWc/zCwC9%lkp@intel.com>
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
branch HEAD: d514392f17fd4d386cfadde7f849d97db4ca1fb0  Add linux-next specific files for 20230120

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202301191616.R33Dvxk4-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202301192229.wL7iPJxS-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202301201120.aIaz7dT4-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202301202042.herfGxx6-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/virt/kvm/api.rst:5070: WARNING: Unexpected indentation.
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_dp_training.c:1585:38: warning: variable 'result' set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5253:24: sparse:    left side has type restricted __le16
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5253:24: sparse:    right side has type restricted __le32
idma64.c:(.text+0x6a): undefined reference to `devm_platform_ioremap_resource'

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/net/dsa/microchip/ksz_ptp.c:217 ksz_ptp_clock_register() warn: passing zero to 'PTR_ERR'
drivers/nvmem/imx-ocotp.c:599:21: sparse: sparse: symbol 'imx_ocotp_layout' was not declared. Should it be static?
drivers/nvmem/layouts/sl28vpd.c:143:21: sparse: sparse: symbol 'sl28vpd_layout' was not declared. Should it be static?
mm/hugetlb.c:3101 alloc_hugetlb_folio() error: uninitialized symbol 'h_cg'.
mm/zsmalloc.c:900:20: warning: unused function 'obj_allocated' [-Wunused-function]
sound/soc/sof/sof-audio.c:329 sof_prepare_widgets_in_path() error: we previously assumed 'swidget' could be null (see line 306)

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- arc-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- arm-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- arm-randconfig-s032-20230119
|   `-- drivers-nvmem-imx-ocotp.c:sparse:sparse:symbol-imx_ocotp_layout-was-not-declared.-Should-it-be-static
|-- arm64-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- csky-randconfig-m041-20230119
|   |-- drivers-net-dsa-microchip-ksz_ptp.c-ksz_ptp_clock_register()-warn:passing-zero-to-PTR_ERR
|   `-- sound-soc-sof-sof-audio.c-sof_prepare_widgets_in_path()-error:we-previously-assumed-swidget-could-be-null-(see-line-)
|-- csky-randconfig-r025-20230119
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- csky-randconfig-s043-20230119
|   |-- drivers-net-wireless-realtek-rtl8xxxu-rtl8xxxu_core.c:sparse:left-side-has-type-restricted-__le16
|   |-- drivers-net-wireless-realtek-rtl8xxxu-rtl8xxxu_core.c:sparse:right-side-has-type-restricted-__le32
|   `-- drivers-net-wireless-realtek-rtl8xxxu-rtl8xxxu_core.c:sparse:sparse:invalid-assignment:
|-- i386-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- ia64-allmodconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- ia64-randconfig-c033-20230119
|   `-- drivers-net-ethernet-microchip-vcap-vcap_api.c:WARNING-opportunity-for-kmemdup
|-- ia64-randconfig-s052-20230119
|   `-- drivers-nvmem-imx-ocotp.c:sparse:sparse:symbol-imx_ocotp_layout-was-not-declared.-Should-it-be-static
|-- loongarch-randconfig-r024-20230119
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- loongarch-randconfig-s042-20230119
|   `-- drivers-nvmem-layouts-sl28vpd.c:sparse:sparse:symbol-sl28vpd_layout-was-not-declared.-Should-it-be-static
|-- m68k-randconfig-c004-20230119
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- mips-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- openrisc-randconfig-s033-20230119
|   `-- drivers-nvmem-imx-ocotp.c:sparse:sparse:symbol-imx_ocotp_layout-was-not-declared.-Should-it-be-static
|-- powerpc-allmodconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- riscv-randconfig-s041-20230119
|   `-- drivers-nvmem-imx-ocotp.c:sparse:sparse:symbol-imx_ocotp_layout-was-not-declared.-Should-it-be-static
|-- s390-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- sparc-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
|-- x86_64-allnoconfig
|   `-- Documentation-virt-kvm-api.rst:WARNING:Unexpected-indentation.
|-- x86_64-allyesconfig
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_dp_training.c:warning:variable-result-set-but-not-used
`-- x86_64-randconfig-m001
clang_recent_errors
|-- s390-randconfig-r044-20230119
|   `-- idma64.c:(.text):undefined-reference-to-devm_platform_ioremap_resource
`-- x86_64-randconfig-a012
    `-- mm-zsmalloc.c:warning:unused-function-obj_allocated

elapsed time: 882m

configs tested: 79
configs skipped: 3

gcc tested configs:
x86_64                            allnoconfig
um                             i386_defconfig
i386                                defconfig
um                           x86_64_defconfig
x86_64                              defconfig
x86_64                               rhel-8.3
arc                                 defconfig
alpha                               defconfig
arm                                 defconfig
i386                          randconfig-a001
x86_64                          rhel-8.3-func
m68k                             allyesconfig
x86_64                           rhel-8.3-syz
x86_64                    rhel-8.3-kselftests
x86_64                           allyesconfig
powerpc                           allnoconfig
x86_64                         rhel-8.3-kunit
ia64                             allmodconfig
arm                  randconfig-r046-20230119
x86_64                        randconfig-a002
arm                              allyesconfig
arc                  randconfig-r043-20230119
m68k                             allmodconfig
i386                          randconfig-a003
arc                              allyesconfig
arm64                            allyesconfig
alpha                            allyesconfig
x86_64                           rhel-8.3-kvm
x86_64                        randconfig-a006
i386                          randconfig-a005
x86_64                           rhel-8.3-bpf
x86_64                        randconfig-a004
sparc64                          alldefconfig
riscv                             allnoconfig
sparc                       sparc32_defconfig
m68k                          hp300_defconfig
i386                             allyesconfig
powerpc                 mpc85xx_cds_defconfig
parisc                           alldefconfig
riscv                    nommu_virt_defconfig
mips                         bigsur_defconfig
arm                        keystone_defconfig
sh                   secureedge5410_defconfig
i386                          randconfig-a014
riscv                    nommu_k210_defconfig
s390                                defconfig
i386                          randconfig-a012
x86_64                        randconfig-a013
i386                          randconfig-a016
riscv                          rv32_defconfig
s390                             allmodconfig
sh                               allmodconfig
i386                   debian-10.3-kselftests
x86_64                        randconfig-a011
i386                              debian-10.3
i386                          randconfig-c001
mips                             allyesconfig
x86_64                        randconfig-a015
s390                             allyesconfig
powerpc                          allmodconfig

clang tested configs:
x86_64                          rhel-8.3-rust
x86_64                        randconfig-a005
hexagon              randconfig-r045-20230119
x86_64                        randconfig-a001
i386                          randconfig-a002
riscv                randconfig-r042-20230119
x86_64                        randconfig-a003
hexagon              randconfig-r041-20230119
s390                 randconfig-r044-20230119
i386                          randconfig-a006
x86_64                        randconfig-k001
i386                          randconfig-a004
arm                           omap1_defconfig
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
x86_64                        randconfig-a016
x86_64                        randconfig-a012
x86_64                        randconfig-a014

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
