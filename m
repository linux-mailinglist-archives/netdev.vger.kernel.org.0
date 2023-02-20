Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E08B69D482
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 21:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbjBTULe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 15:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbjBTULd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 15:11:33 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC931EFF4;
        Mon, 20 Feb 2023 12:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676923891; x=1708459891;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=kn4pld7IQxDxYFj1OkmASNOLxEzb1abPukEUl/1gRJc=;
  b=a/7NBj7rdfg6+FvAzm/CLwh/WM0KfDvJbgi6qln692frvIlgtcwN/0d+
   mTMZvjMVXN3BlgsjUbUJiTXg595D1HxciJaATO5FrntPjT4yV5to5HNX9
   JMONrgcNpBibQBbx6iTjEved3GtWMOyx48LZ02ciXlkuwJMrZPiYes3H7
   iosekel4XttkQONaLij90XEfQ5duyiZebgnKLfaXztYfsivENqjw1wzYW
   uM/W1EK4SN1llc/HBYKvqyw7iE63/b3MrKhFBMC/lEV3M8DN2w7VEZ6mR
   s/B1XLxLlgUVSR9WvyBItXjyYGU+6R0sOPjKo7388+j+OrZ757kshABq9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="418706419"
X-IronPort-AV: E=Sophos;i="5.97,313,1669104000"; 
   d="scan'208";a="418706419"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2023 12:11:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10627"; a="760282644"
X-IronPort-AV: E=Sophos;i="5.97,313,1669104000"; 
   d="scan'208";a="760282644"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Feb 2023 12:11:28 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pUCVT-000E9N-2U;
        Mon, 20 Feb 2023 20:11:27 +0000
Date:   Tue, 21 Feb 2023 04:11:12 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 d2af0fa4bfa4ec29d03b449ccd43fee39501112d
Message-ID: <63f3d3e0.jVwHKeaSAe5ASSpD%lkp@intel.com>
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
branch HEAD: d2af0fa4bfa4ec29d03b449ccd43fee39501112d  Add linux-next specific files for 20230220

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202302062224.ByzeTXh1-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302092211.54EYDhYH-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302111601.jtY4lKrA-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302170355.Ljqlzucu-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302210017.XT59WvsM-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202302210350.lynWcL4t-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/sphinx/templates/kernel-toc.html: 1:36 Invalid token: #}
ERROR: modpost: "__umoddi3" [fs/btrfs/btrfs.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/fsl-edma.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/idma64.ko] undefined!
FAILED: load BTF from vmlinux: No data available
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn30/dcn30_optc.c:294:6: warning: no previous prototype for 'optc3_wait_drr_doublebuffer_pending_clear' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn32/dcn32_resource_helpers.c:62:18: warning: variable 'cursor_bpp' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_detection.c:1199: warning: expecting prototype for dc_link_detect_connection_type(). Prototype was for link_detect_connection_type() instead
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_capability.c:1292:32: warning: variable 'result_write_min_hblank' set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_dp_training.c:1586:38: warning: variable 'result' set but not used [-Wunused-but-set-variable]
drivers/net/ethernet/sfc/ef100_nic.c:1197:9: warning: variable 'rc' is uninitialized when used here [-Wuninitialized]
drivers/net/ethernet/sfc/efx_devlink.c:326:58: error: expected ')' before 'build_id'
drivers/net/ethernet/sfc/efx_devlink.c:338:55: error: expected ';' before '}' token
drivers/of/unittest.c:3042:41: error: 'struct device_node' has no member named 'kobj'
drivers/pwm/pwm-dwc.c:314:1: error: type defaults to 'int' in declaration of 'module_pci_driver' [-Werror=implicit-int]
include/asm-generic/div64.h:238:36: error: passing argument 1 of '__div64_32' from incompatible pointer type [-Werror=incompatible-pointer-types]

Unverified Error/Warning (likely false positive, please contact us if interested):

drivers/infiniband/hw/hfi1/verbs.c:1661 hfi1_alloc_hw_device_stats() error: we previously assumed 'dev_cntr_descs' could be null (see line 1650)
drivers/net/phy/phy-c45.c:712 genphy_c45_write_eee_adv() error: uninitialized symbol 'changed'.
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188e.c:1678 rtl8188e_handle_ra_tx_report2() warn: ignoring unreachable code.
drivers/usb/gadget/composite.c:2082:33: sparse: sparse: restricted __le16 degrades to integer
drivers/virtio/virtio_ring.c:1585 virtqueue_add_packed_vring() error: uninitialized symbol 'prev'.
drivers/virtio/virtio_ring.c:1593 virtqueue_add_packed_vring() error: uninitialized symbol 'head_flags'.
drivers/virtio/virtio_ring.c:697 virtqueue_add_split_vring() error: uninitialized symbol 'prev'.
pahole: .tmp_vmlinux.btf: No such file or directory

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- alpha-buildonly-randconfig-r006-20230219
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|   `-- include-asm-generic-div64.h:error:passing-argument-of-__div64_32-from-incompatible-pointer-type
|-- arc-randconfig-r001-20230219
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|-- arc-randconfig-r043-20230219
|   `-- drivers-of-unittest.c:error:struct-device_node-has-no-member-named-kobj
|-- arm-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|   `-- include-asm-generic-div64.h:error:passing-argument-of-__div64_32-from-incompatible-pointer-type
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|   `-- include-asm-generic-div64.h:error:passing-argument-of-__div64_32-from-incompatible-pointer-type
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn30-dcn30_optc.c:warning:no-previous-prototype-for-optc3_wait_drr_doublebuffer_pending_clear
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_resource_helpers.c:warning:variable-cursor_bpp-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- csky-randconfig-s041-20230219
|   `-- drivers-usb-gadget-composite.c:sparse:sparse:restricted-__le16-degrades-to-integer
|-- csky-randconfig-s042-20230219
|   |-- include-asm-generic-cmpxchg-local.h:sparse:sparse:cast-truncates-bits-from-constant-value-(-becomes-)
|   `-- include-asm-generic-cmpxchg-local.h:sparse:sparse:cast-truncates-bits-from-constant-value-(aaa31337-becomes-)
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn30-dcn30_optc.c:warning:no-previous-prototype-for-optc3_wait_drr_doublebuffer_pending_clear
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn32-dcn32_resource_helpers.c:warning:variable-cursor_bpp-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-link_detection.c:warning:expecting-prototype-for-dc_link_detect_connection_type().-Prototype-was-for-link_detect_connection_type()-instead
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_capability.c:warning:variable-result_write_min_hblank-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-..-display-dc-link-protocols-link_dp_training.c:warning:variable-result-set-but-not-used
|-- i386-randconfig-m021
|   |-- drivers-virtio-virtio_ring.c-virtqueue_add_packed_vring()-error:uninitialized-symbol-head_flags-.
|   |-- drivers-virtio-virtio_ring.c-virtqueue_add_packed_vring()-error:uninitialized-symbol-prev-.
|   `-- drivers-virtio-virtio_ring.c-virtqueue_add_split_vring()-error:uninitialized-symbol-prev-.
|-- ia64-randconfig-r025-20230220
clang_recent_errors
|-- i386-randconfig-a001-20230213
|   `-- ERROR:__umoddi3-fs-btrfs-btrfs.ko-undefined
`-- powerpc-skiroot_defconfig
    `-- drivers-net-ethernet-sfc-ef100_nic.c:warning:variable-rc-is-uninitialized-when-used-here

elapsed time: 843m

configs tested: 96
configs skipped: 6

gcc tested configs:
alpha                            allyesconfig
alpha                               defconfig
arc                              alldefconfig
arc                              allyesconfig
arc                          axs103_defconfig
arc                                 defconfig
arc                  randconfig-r043-20230219
arc                  randconfig-r043-20230220
arc                        vdk_hs38_defconfig
arm                              allmodconfig
arm                              allyesconfig
arm                         axm55xx_defconfig
arm                                 defconfig
arm                  randconfig-r046-20230220
arm64                            allyesconfig
arm64                               defconfig
csky                                defconfig
i386                             allyesconfig
i386                              debian-10.3
i386                                defconfig
i386                 randconfig-a001-20230220
i386                 randconfig-a002-20230220
i386                 randconfig-a003-20230220
i386                 randconfig-a004-20230220
i386                 randconfig-a005-20230220
i386                 randconfig-a006-20230220
i386                          randconfig-c001
ia64                             allmodconfig
ia64                                defconfig
loongarch                        allmodconfig
loongarch                         allnoconfig
loongarch                           defconfig
m68k                             allmodconfig
m68k                                defconfig
mips                             allmodconfig
mips                             allyesconfig
mips                     decstation_defconfig
mips                            gpr_defconfig
nios2                               defconfig
parisc                              defconfig
parisc64                            defconfig
powerpc                          allmodconfig
powerpc                           allnoconfig
powerpc                     ep8248e_defconfig
powerpc                 linkstation_defconfig
powerpc                      makalu_defconfig
powerpc                     taishan_defconfig
riscv                            allmodconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                randconfig-r042-20230219
riscv                          rv32_defconfig
s390                             allmodconfig
s390                             allyesconfig
s390                                defconfig
s390                 randconfig-r044-20230219
sh                               allmodconfig
sh                        apsh4ad0a_defconfig
sh                             espt_defconfig
sh                     magicpanelr2_defconfig
sh                     sh7710voipgw_defconfig
sparc                               defconfig
sparc                       sparc32_defconfig
um                             i386_defconfig
um                           x86_64_defconfig
x86_64                           alldefconfig
x86_64                            allnoconfig
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                                  kexec
x86_64                               rhel-8.3
xtensa                  cadence_csp_defconfig

clang tested configs:
arm                     davinci_all_defconfig
arm                  randconfig-r046-20230219
arm                       spear13xx_defconfig
hexagon              randconfig-r041-20230219
hexagon              randconfig-r041-20230220
hexagon              randconfig-r045-20230219
hexagon              randconfig-r045-20230220
i386                 randconfig-a011-20230220
i386                 randconfig-a012-20230220
i386                 randconfig-a013-20230220
i386                 randconfig-a014-20230220
i386                 randconfig-a015-20230220
i386                 randconfig-a016-20230220
mips                          ath25_defconfig
powerpc                    ge_imp3a_defconfig
powerpc                     skiroot_defconfig
riscv                randconfig-r042-20230220
s390                 randconfig-r044-20230220
x86_64               randconfig-a011-20230220
x86_64               randconfig-a012-20230220
x86_64               randconfig-a013-20230220
x86_64               randconfig-a014-20230220
x86_64               randconfig-a015-20230220
x86_64               randconfig-a016-20230220

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
