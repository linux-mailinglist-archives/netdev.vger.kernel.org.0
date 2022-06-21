Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BD5553E59
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 00:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiFUWMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 18:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356446AbiFUWLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 18:11:22 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7E82ED5B;
        Tue, 21 Jun 2022 15:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655849481; x=1687385481;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=9NbVKjA2l2L/qGvXTLnS4RyFyYSq0q4alQPvEo9eP1A=;
  b=ISRCLGcx1I7BvCgszhUnCdZ+xdG20lKpiLlFcYVmBCecAZnk9tAj42Nl
   vxNwD1dsda29YHeHft4NPtwb1HNuQ+nY0JWtLt1sF6qI9dGBUxX3yjBOh
   K0uUFdXr9+VJ/D7AqFy4jbej9yY8ykHs5Ef/un/XT4QIKfTS1hBpXxXyC
   7XfySYCsx1vWjzegBq3jKC3h85yJcCrNTtD5izQs+SxSGBRCS0wpAn5a2
   FC/4+oGHhAjU4jUmfN/PmDniZG1gCSKU8kpl4OG2/KYdjo7vZE3hjdPaM
   2p1ZMV0ojNm92ozr4p3f3WrQVRFKhFbiLXvgf0Hj6LrBH/E/nucfuvh1J
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="344243145"
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="344243145"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 15:11:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,210,1650956400"; 
   d="scan'208";a="730031253"
Received: from lkp-server02.sh.intel.com (HELO a67cc04a5eeb) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 21 Jun 2022 15:11:17 -0700
Received: from kbuild by a67cc04a5eeb with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o3m5c-0000UT-By;
        Tue, 21 Jun 2022 22:11:16 +0000
Date:   Wed, 22 Jun 2022 06:10:27 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     ntb@lists.linux.dev, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-xfs@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-perf-users@vger.kernel.org,
        kvm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 34d1d36073ea4d4c532e8c8345627a9702be799e
Message-ID: <62b241d3.CmOrZi26Vac8nqGm%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 34d1d36073ea4d4c532e8c8345627a9702be799e  Add linux-next specific files for 20220621

Error/Warning reports:

https://lore.kernel.org/linux-mm/202206212029.Yr5m7Cd3-lkp@intel.com
https://lore.kernel.org/linux-mm/202206212033.3lgl72Fw-lkp@intel.com
https://lore.kernel.org/lkml/202206071511.FI7WLdZo-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

ERROR: modpost: "acpi_dev_for_each_child" [drivers/mfd/mfd-core.ko] undefined!
arch/powerpc/kernel/interrupt.c:542:55: warning: suggest braces around empty body in an 'if' statement [-Wempty-body]
drivers/ntb/test/ntb_perf.c:1067: undefined reference to `__umoddi3'
irq-xilinx-intc.c:(.init.text+0x8c): undefined reference to `of_iomap'
microblaze-linux-ld: drivers/ntb/test/ntb_perf.c:1095: undefined reference to `__umoddi3'
net/ipv6/raw.c:335:25: warning: variable 'saddr' set but not used [-Wunused-but-set-variable]
net/ipv6/raw.c:335:32: warning: variable 'saddr' set but not used [-Wunused-but-set-variable]
net/ipv6/raw.c:335:33: warning: variable 'daddr' set but not used [-Wunused-but-set-variable]
net/ipv6/raw.c:335:40: warning: variable 'daddr' set but not used [-Wunused-but-set-variable]
net/ipv6/raw.c:338:25: warning: variable 'saddr' set but not used [-Wunused-but-set-variable]
net/ipv6/raw.c:338:32: warning: variable 'saddr' set but not used [-Wunused-but-set-variable]
net/ipv6/raw.c:338:33: warning: variable 'daddr' set but not used [-Wunused-but-set-variable]
net/ipv6/raw.c:338:40: warning: variable 'daddr' set but not used [-Wunused-but-set-variable]
s390-linux-ld: irq-xilinx-intc.c:(.init.text+0x3ba): undefined reference to `iounmap'

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:9143:27: warning: variable 'abo' set but not used [-Wunused-but-set-variable]

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- alpha-buildonly-randconfig-r001-20220620
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|-- alpha-buildonly-randconfig-r006-20220621
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   `-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|-- arm-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- arm-defconfig
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- arm-randconfig-r022-20220620
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- arm-randconfig-r031-20220619
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- arm64-defconfig
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   `-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|-- i386-debian-10.3-kselftests
|   `-- ERROR:acpi_dev_for_each_child-drivers-mfd-mfd-core.ko-undefined
|-- i386-randconfig-a001
|   `-- ntb_perf.c:(.text):undefined-reference-to-__umoddi3
|-- i386-randconfig-a004-20220620
|   `-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|-- i386-randconfig-c021
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- i386-randconfig-m021
|   |-- arch-x86-events-core.c-init_hw_perf_events()-warn:missing-error-code-err
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- i386-randconfig-s001
|   |-- drivers-vfio-pci-vfio_pci_config.c:sparse:sparse:restricted-pci_power_t-degrades-to-integer
|   |-- kernel-signal.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-lockdep_map-const-lock-got-struct-lockdep_map-noderef-__rcu
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- i386-randconfig-s002
|   |-- fs-xfs-xfs_file.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-vm_fault_t-usertype-ret-got-int
|   |-- kernel-signal.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-struct-lockdep_map-const-lock-got-struct-lockdep_map-noderef-__rcu
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- ia64-randconfig-r021-20220620
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|-- ia64-randconfig-r023-20220619
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- m68k-allmodconfig
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- m68k-allyesconfig
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- m68k-defconfig
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- m68k-randconfig-r026-20220620
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- m68k-virt_defconfig
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- microblaze-buildonly-randconfig-r001-20220622
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- microblaze-randconfig-r005-20220620
|   |-- microblaze-linux-ld:drivers-ntb-test-ntb_perf.c:undefined-reference-to-__umoddi3
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- microblaze-randconfig-r024-20220619
|   `-- drivers-ntb-test-ntb_perf.c:undefined-reference-to-__umoddi3
|-- mips-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- mips-buildonly-randconfig-r005-20220621
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- nios2-allyesconfig
|   `-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|-- nios2-randconfig-s032-20220622
|   |-- fs-xfs-xfs_file.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-restricted-vm_fault_t-usertype-ret-got-int
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- parisc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- parisc-defconfig
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- parisc-randconfig-m031-20220622
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c-amdgpu_discovery_reg_base_init()-error:testing-array-offset-adev-vcn.num_vcn_inst-after-use.
|   |-- drivers-gpu-drm-vc4-vc4_perfmon.c-vc4_perfmon_get()-warn:variable-dereferenced-before-check-perfmon-(see-line-)
|   |-- drivers-gpu-drm-vc4-vc4_perfmon.c-vc4_perfmon_get_values_ioctl()-warn:variable-dereferenced-before-check-perfmon-(see-line-)
|   `-- drivers-gpu-drm-vc4-vc4_validate.c-vc4_check_tex_size()-warn:signedness-bug-returning
|-- parisc-randconfig-r036-20220619
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|-- parisc64-defconfig
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- powerpc-allmodconfig
|   |-- arch-powerpc-kernel-interrupt.c:warning:suggest-braces-around-empty-body-in-an-if-statement
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- powerpc-allyesconfig
|   |-- arch-powerpc-kernel-interrupt.c:warning:suggest-braces-around-empty-body-in-an-if-statement
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- riscv-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- riscv-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- riscv-defconfig
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- riscv-rv32_defconfig
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- s390-allmodconfig
|   |-- irq-xilinx-intc.c:(.init.text):undefined-reference-to-of_iomap
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|   `-- s390-linux-ld:irq-xilinx-intc.c:(.init.text):undefined-reference-to-iounmap
|-- s390-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- s390-buildonly-randconfig-r004-20220621
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- s390-defconfig
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- sh-allmodconfig
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- sparc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- sparc-buildonly-randconfig-r006-20220622
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- sparc-defconfig
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- sparc-randconfig-r021-20220619
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- sparc-sparc64_defconfig
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- sparc64-randconfig-r024-20220619
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
|   |-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-randconfig-a001-20220620
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-randconfig-a005-20220620
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-randconfig-a006-20220620
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-randconfig-c022
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-randconfig-m001
|   |-- arch-x86-events-core.c-init_hw_perf_events()-warn:missing-error-code-err
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-rhel-8.3
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-rhel-8.3-func
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-rhel-8.3-kselftests
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-rhel-8.3-kunit
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-rhel-8.3-syz
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
`-- xtensa-allyesconfig
    |-- drivers-gpu-drm-amd-amdgpu-..-display-amdgpu_dm-amdgpu_dm.c:warning:variable-abo-set-but-not-used
    `-- drivers-staging-rtl8723bs-hal-hal_btcoex.c:warning:variable-pHalData-set-but-not-used

clang_recent_errors
|-- arm-multi_v5_defconfig
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- hexagon-randconfig-r041-20220619
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- i386-randconfig-a012-20220620
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-randconfig-a011-20220620
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-randconfig-a012-20220620
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-randconfig-a014-20220620
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
|-- x86_64-randconfig-a015-20220620
|   |-- drivers-ufs-host-tc-dwc-g210-pltfrm.c:warning:unused-variable-tc_dwc_g210_pltfm_match
|   |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
|   `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used
`-- x86_64-randconfig-a016-20220620
    |-- drivers-ufs-host-tc-dwc-g210-pltfrm.c:warning:unused-variable-tc_dwc_g210_pltfm_match
    |-- net-ipv6-raw.c:warning:variable-daddr-set-but-not-used
    `-- net-ipv6-raw.c:warning:variable-saddr-set-but-not-used

elapsed time: 725m

configs tested: 108
configs skipped: 3

gcc tested configs:
arm                              allmodconfig
arm                              allyesconfig
arm64                            allyesconfig
arm                                 defconfig
arm64                               defconfig
arc                              alldefconfig
mips                         rt305x_defconfig
arc                     haps_hs_smp_defconfig
sparc                       sparc64_defconfig
sh                          rsk7203_defconfig
arm                        realview_defconfig
powerpc                 mpc837x_rdb_defconfig
powerpc                     redwood_defconfig
sh                           se7724_defconfig
m68k                           virt_defconfig
sh                         apsh4a3a_defconfig
powerpc                 mpc837x_mds_defconfig
arm                           h3600_defconfig
arm                         cm_x300_defconfig
sh                 kfr2r09-romimage_defconfig
powerpc                       holly_defconfig
xtensa                generic_kc705_defconfig
ia64                                defconfig
ia64                             allmodconfig
m68k                                defconfig
m68k                             allyesconfig
m68k                             allmodconfig
nios2                               defconfig
arc                              allyesconfig
alpha                               defconfig
csky                                defconfig
alpha                            allyesconfig
nios2                            allyesconfig
sh                               allmodconfig
arc                                 defconfig
xtensa                           allyesconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
mips                             allyesconfig
parisc                              defconfig
s390                             allmodconfig
parisc                           allyesconfig
s390                                defconfig
s390                             allyesconfig
parisc64                            defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
mips                             allmodconfig
powerpc                          allyesconfig
x86_64               randconfig-a003-20220620
x86_64               randconfig-a004-20220620
x86_64               randconfig-a002-20220620
x86_64               randconfig-a001-20220620
x86_64               randconfig-a005-20220620
x86_64               randconfig-a006-20220620
i386                 randconfig-a003-20220620
i386                 randconfig-a001-20220620
i386                 randconfig-a002-20220620
i386                 randconfig-a004-20220620
i386                 randconfig-a005-20220620
i386                 randconfig-a006-20220620
arc                  randconfig-r043-20220619
riscv                randconfig-r042-20220619
arc                  randconfig-r043-20220620
s390                 randconfig-r044-20220619
riscv                             allnoconfig
riscv                            allyesconfig
riscv                            allmodconfig
riscv                    nommu_k210_defconfig
riscv                          rv32_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                           rhel-8.3-syz
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                                  kexec
x86_64                               rhel-8.3
x86_64                           allyesconfig

clang tested configs:
arm                        multi_v5_defconfig
mips                           ip27_defconfig
mips                      bmips_stb_defconfig
arm                              alldefconfig
x86_64               randconfig-a013-20220620
x86_64               randconfig-a012-20220620
x86_64               randconfig-a015-20220620
x86_64               randconfig-a016-20220620
x86_64               randconfig-a011-20220620
x86_64               randconfig-a014-20220620
i386                 randconfig-a012-20220620
i386                 randconfig-a013-20220620
i386                 randconfig-a011-20220620
i386                 randconfig-a016-20220620
i386                 randconfig-a014-20220620
i386                 randconfig-a015-20220620
hexagon              randconfig-r045-20220619
hexagon              randconfig-r045-20220620
riscv                randconfig-r042-20220620
hexagon              randconfig-r041-20220619
hexagon              randconfig-r041-20220620
s390                 randconfig-r044-20220620

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
