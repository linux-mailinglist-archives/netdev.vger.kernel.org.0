Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22736D6E58
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 22:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbjDDUry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 16:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbjDDUrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 16:47:52 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8223544A1;
        Tue,  4 Apr 2023 13:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680641270; x=1712177270;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=Z6j/cGpZOXVTreuxHNHRJUI608KQQ2b8yubZngfX3x4=;
  b=Oz20NsPIGA7KO+bXHtV/nYmi77S2rCwpGHBC7+ES7sCpht+6wpx3FW05
   oRMAz3We1k19S0TEqDup0S5PLca+d5LNf0tqEmaNt3b66sUqZmjMGo76/
   D7sJIBZSC3FS0jOxve/enE1OaSD4pi0xfEJDbqN7L1D1AWn6Bjedz3NXS
   1/Cr0tPa4rR4y8l6VhzcfvPaiZR8AkzN6u0MAURC1A9pty+U6FnA4gT7K
   jqdme8+1mwdVM40OAUnXNoJYNKjJx3eGIWALfjaF6tVaiJquKHXQldcQj
   K/d5ZmYG0rUFBRx+/LCbpZ8HozPHowUVDag4fDhj/bnIIoqmdMkZE8c7Y
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="407378520"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="407378520"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2023 13:47:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10670"; a="636658836"
X-IronPort-AV: E=Sophos;i="5.98,318,1673942400"; 
   d="scan'208";a="636658836"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 04 Apr 2023 13:47:46 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pjnZB-000Q1q-17;
        Tue, 04 Apr 2023 20:47:45 +0000
Date:   Wed, 05 Apr 2023 04:47:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-gpio@vger.kernel.org,
        linux-acpi@vger.kernel.org, kvm@vger.kernel.org,
        io-uring@vger.kernel.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 6a53bda3aaf3de5edeea27d0b1d8781d067640b6
Message-ID: <642c8ceb.LBEdj8abbmwftu9h%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 6a53bda3aaf3de5edeea27d0b1d8781d067640b6  Add linux-next specific files for 20230404

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202303082135.NjdX1Bij-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202303161521.jbGbaFjJ-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202304041708.siWlxmyD-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202304041748.0sQc4K4l-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202304042104.UFIuevBp-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202304050029.38NdbQPf-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/virt/kvm/api.rst:8303: WARNING: Field list ends without a blank line; unexpected unindent.
ERROR: modpost: "bpf_fentry_test1" [tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.ko] undefined!
Error: failed to load BTF from vmlinux: No data available
Makefile:77: *** Cannot find a vmlinux for VMLINUX_BTF at any of "vmlinux vmlinux ../../../../vmlinux /sys/kernel/btf/vmlinux /boot/vmlinux-5.9.0-0.bpo.2-amd64".  Stop.
arch/m68k/include/asm/irq.h:78:11: error: expected ';' before 'void'
arch/m68k/include/asm/irq.h:78:40: warning: 'struct pt_regs' declared inside parameter list will not be visible outside of this definition or declaration
diff: tools/arch/s390/include/uapi/asm/ptrace.h: No such file or directory
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:351:13: warning: variable 'bw_needed' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_validation.c:352:25: warning: variable 'link' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:309:17: sparse:    int
drivers/gpu/drm/amd/amdgpu/../pm/swsmu/smu13/smu_v13_0_6_ppt.c:309:17: sparse:    void
drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c:148:31: error: implicit declaration of function 'pci_msix_can_alloc_dyn' [-Werror=implicit-function-declaration]
drivers/net/wireless/legacy/ray_cs.c:628:17: warning: 'strncpy' specified bound 32 equals destination size [-Wstringop-truncation]
kernel/bpf/verifier.c:18503: undefined reference to `find_kallsyms_symbol_value'
ld.lld: error: .btf.vmlinux.bin.o: unknown file type
ld.lld: error: undefined symbol: find_kallsyms_symbol_value
tcp_mmap.c:211:61: warning: 'lu' may be used uninitialized in this function [-Wmaybe-uninitialized]
thermal_nl.h:6:10: fatal error: netlink/netlink.h: No such file or directory
thermometer.c:21:10: fatal error: libconfig.h: No such file or directory

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/acpi/property.c:985 acpi_data_prop_read_single() error: potentially dereferencing uninitialized 'obj'.
drivers/pinctrl/pinctrl-mlxbf3.c:162:20: sparse: sparse: symbol 'mlxbf3_pmx_funcs' was not declared. Should it be static?
drivers/soc/fsl/qe/tsa.c:140:26: sparse: sparse: incorrect type in argument 2 (different address spaces)
drivers/soc/fsl/qe/tsa.c:150:27: sparse: sparse: incorrect type in argument 1 (different address spaces)
drivers/soc/fsl/qe/tsa.c:189:26: sparse: sparse: dereference of noderef expression
drivers/soc/fsl/qe/tsa.c:663:22: sparse: sparse: incorrect type in assignment (different address spaces)
drivers/soc/fsl/qe/tsa.c:673:21: sparse: sparse: incorrect type in assignment (different address spaces)
include/linux/gpio/consumer.h: linux/err.h is included more than once.
include/linux/gpio/driver.h: asm/bug.h is included more than once.
io_uring/io_uring.c:432 io_prep_async_work() error: we previously assumed 'req->file' could be null (see line 425)
io_uring/kbuf.c:221 __io_remove_buffers() warn: variable dereferenced before check 'bl->buf_ring' (see line 219)

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   `-- drivers-net-wireless-legacy-ray_cs.c:warning:strncpy-specified-bound-equals-destination-size
|-- alpha-buildonly-randconfig-r005-20230403
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- alpha-randconfig-s051-20230403
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:int
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-gpu-drm-amd-amdgpu-..-pm-swsmu-smu13-smu_v13_0_6_ppt.c:sparse:void
|   `-- drivers-pinctrl-pinctrl-mlxbf3.c:sparse:sparse:symbol-mlxbf3_pmx_funcs-was-not-declared.-Should-it-be-static
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- arm-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- i386-randconfig-m021-20230403
|   |-- drivers-acpi-property.c-acpi_data_prop_read_single()-error:potentially-dereferencing-uninitialized-obj-.
|   |-- io_uring-io_uring.c-io_prep_async_work()-error:we-previously-assumed-req-file-could-be-null-(see-line-)
|   `-- io_uring-kbuf.c-__io_remove_buffers()-warn:variable-dereferenced-before-check-bl-buf_ring-(see-line-)
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|   `-- drivers-net-wireless-legacy-ray_cs.c:warning:strncpy-specified-bound-equals-destination-size
|-- loongarch-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- loongarch-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- loongarch-defconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-bw_needed-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_validation.c:warning:variable-link-set-but-not-used
|-- m68k-randconfig-s041-20230403
|   |-- arch-m68k-include-asm-irq.h:error:expected-before-void
|   `-- arch-m68k-include-asm-irq.h:warning:struct-pt_regs-declared-inside-parameter-list-will-not-be-visible-outside-of-this-definition-or-declaration
|-- microblaze-buildonly-randconfig-r006-20230403
|   `-- drivers-net-ethernet-mellanox-mlx5-core-pci_irq.c:error:implicit-declaration-of-function-pci_msix_can_alloc_dyn
|-- mips-allmodconfig
clang_recent_errors
`-- arm-randconfig-r046-20230403
    |-- ld.lld:error:.btf.vmlinux.bin.o:unknown-file-type
    `-- ld.lld:error:undefined-symbol:find_kallsyms_symbol_value

elapsed time: 840m

configs tested: 113
configs skipped: 4

tested configs:
alpha                            allyesconfig   gcc  
alpha        buildonly-randconfig-r005-20230403   gcc  
alpha                               defconfig   gcc  
alpha                randconfig-r023-20230403   gcc  
alpha                randconfig-r036-20230404   gcc  
arc                              allyesconfig   gcc  
arc                                 defconfig   gcc  
arc                  randconfig-r034-20230403   gcc  
arc                  randconfig-r043-20230403   gcc  
arm                              allmodconfig   gcc  
arm                              allyesconfig   gcc  
arm          buildonly-randconfig-r001-20230403   clang
arm                                 defconfig   gcc  
arm                          exynos_defconfig   gcc  
arm                  randconfig-r046-20230403   clang
arm64                            allyesconfig   gcc  
arm64                               defconfig   gcc  
arm64                randconfig-r021-20230403   gcc  
csky                                defconfig   gcc  
csky                 randconfig-r033-20230403   gcc  
hexagon              randconfig-r016-20230403   clang
hexagon              randconfig-r035-20230403   clang
hexagon              randconfig-r041-20230403   clang
hexagon              randconfig-r045-20230403   clang
i386                             allyesconfig   gcc  
i386                              debian-10.3   gcc  
i386                                defconfig   gcc  
i386                 randconfig-a001-20230403   clang
i386                 randconfig-a002-20230403   clang
i386                 randconfig-a003-20230403   clang
i386                 randconfig-a004-20230403   clang
i386                 randconfig-a005-20230403   clang
i386                 randconfig-a006-20230403   clang
i386                 randconfig-a011-20230403   gcc  
i386                 randconfig-a012-20230403   gcc  
i386                 randconfig-a013-20230403   gcc  
i386                 randconfig-a014-20230403   gcc  
i386                 randconfig-a015-20230403   gcc  
i386                 randconfig-a016-20230403   gcc  
i386                 randconfig-r015-20230403   gcc  
i386                 randconfig-r022-20230403   gcc  
i386                 randconfig-r036-20230403   clang
ia64                             alldefconfig   gcc  
ia64                             allmodconfig   gcc  
ia64                                defconfig   gcc  
ia64                 randconfig-r002-20230403   gcc  
loongarch                        allmodconfig   gcc  
loongarch                         allnoconfig   gcc  
loongarch                           defconfig   gcc  
m68k                             allmodconfig   gcc  
m68k         buildonly-randconfig-r002-20230403   gcc  
m68k         buildonly-randconfig-r006-20230403   gcc  
m68k                                defconfig   gcc  
m68k                 randconfig-r024-20230403   gcc  
m68k                 randconfig-r034-20230404   gcc  
mips                             allmodconfig   gcc  
mips                             allyesconfig   gcc  
mips                 randconfig-r005-20230403   gcc  
nios2                               defconfig   gcc  
nios2                randconfig-r033-20230404   gcc  
openrisc             randconfig-r013-20230403   gcc  
openrisc             randconfig-r026-20230403   gcc  
parisc                              defconfig   gcc  
parisc               randconfig-r001-20230403   gcc  
parisc               randconfig-r014-20230403   gcc  
parisc64                            defconfig   gcc  
powerpc                          allmodconfig   gcc  
powerpc                           allnoconfig   gcc  
powerpc                     ep8248e_defconfig   gcc  
powerpc                     kmeter1_defconfig   clang
powerpc              randconfig-r025-20230403   gcc  
riscv                            allmodconfig   gcc  
riscv                             allnoconfig   gcc  
riscv                               defconfig   gcc  
riscv             nommu_k210_sdcard_defconfig   gcc  
riscv                randconfig-r042-20230403   gcc  
riscv                          rv32_defconfig   gcc  
s390                             allmodconfig   gcc  
s390                             allyesconfig   gcc  
s390                                defconfig   gcc  
s390                 randconfig-r004-20230403   clang
s390                 randconfig-r012-20230403   gcc  
s390                 randconfig-r031-20230404   gcc  
s390                 randconfig-r044-20230403   gcc  
sh                               allmodconfig   gcc  
sh                   randconfig-r011-20230403   gcc  
sh                   randconfig-r031-20230403   gcc  
sparc        buildonly-randconfig-r004-20230403   gcc  
sparc                               defconfig   gcc  
sparc64              randconfig-r003-20230403   gcc  
um                             i386_defconfig   gcc  
um                           x86_64_defconfig   gcc  
x86_64                            allnoconfig   gcc  
x86_64                           allyesconfig   gcc  
x86_64                              defconfig   gcc  
x86_64                                  kexec   gcc  
x86_64               randconfig-a001-20230403   clang
x86_64               randconfig-a002-20230403   clang
x86_64               randconfig-a003-20230403   clang
x86_64               randconfig-a004-20230403   clang
x86_64               randconfig-a005-20230403   clang
x86_64               randconfig-a006-20230403   clang
x86_64               randconfig-a011-20230403   gcc  
x86_64               randconfig-a012-20230403   gcc  
x86_64               randconfig-a013-20230403   gcc  
x86_64               randconfig-a014-20230403   gcc  
x86_64               randconfig-a015-20230403   gcc  
x86_64               randconfig-a016-20230403   gcc  
x86_64               randconfig-r032-20230403   clang
x86_64                               rhel-8.3   gcc  
xtensa       buildonly-randconfig-r003-20230403   gcc  
xtensa               randconfig-r006-20230403   gcc  
xtensa               randconfig-r035-20230404   gcc  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
