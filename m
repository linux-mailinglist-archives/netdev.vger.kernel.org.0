Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5F466E3F2
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 17:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjAQQpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 11:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbjAQQpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 11:45:19 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8114A166FF;
        Tue, 17 Jan 2023 08:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673973917; x=1705509917;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=RBZt2E+UjQgwITQDNCDVPQ6Xk3YNL2NVc+Xo+G6dahY=;
  b=iHXdMI46hvtB5lBhYeVlvn0Tvc18Jbd3MGEpX/gadK8YBN0bJzbHBgYM
   91VU2fTbU283Rm8YlwdYh0Y3lRo/0nDhGBmjmkeS1ZKRDxPYA+EcMBKYT
   Nu1xc4MFhs1AxafG8wmAxi2L6nxzxr0lWpU5E5Dg27noIPO/QapwtHf/Q
   V6yO7r4k0kLIi9xMrXJeiQujFBRRraORF0DVcTCjlm6legpYD6qmz0hBD
   0ZcugK4n4CnJPsuPFnLcoPTDcHFWU1BzY8XwEnFo9Av85+KW06OP/WcV9
   XLueY55Qpyd3ALUUnwSonoUIiFVRJcA0Lz69Bi6kkbeXWz7TE1YKGtLZN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="308309457"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="308309457"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 08:45:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="691647966"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="691647966"
Received: from lkp-server02.sh.intel.com (HELO f57cd993bc73) ([10.239.97.151])
  by orsmga001.jf.intel.com with ESMTP; 17 Jan 2023 08:45:14 -0800
Received: from kbuild by f57cd993bc73 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pHp5F-0001J0-1f;
        Tue, 17 Jan 2023 16:45:13 +0000
Date:   Wed, 18 Jan 2023 00:44:23 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 9ce08dd7ea24253aac5fd2519f9aea27dfb390c9
Message-ID: <63c6d067.0pY/lCH78LfKL+l6%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 9ce08dd7ea24253aac5fd2519f9aea27dfb390c9  Add linux-next specific files for 20230117

Error/Warning reports:

https://lore.kernel.org/oe-kbuild-all/202301100332.4EaKi4d1-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202301171414.xpf8WpXn-lkp@intel.com
https://lore.kernel.org/oe-kbuild-all/202301171511.4ZszviYP-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

Documentation/mm/unevictable-lru.rst:186: WARNING: Title underline too short.
ERROR: modpost: "kunit_running" [drivers/gpu/drm/vc4/vc4.ko] undefined!
arch/arm/kernel/entry-armv.S:485:5: warning: "CONFIG_ARM_THUMB" is not defined, evaluates to 0 [-Wundef]
drivers/gpu/drm/ttm/ttm_bo_util.c:364:32: error: implicit declaration of function 'vmap'; did you mean 'kmap'? [-Werror=implicit-function-declaration]
drivers/gpu/drm/ttm/ttm_bo_util.c:429:17: error: implicit declaration of function 'vunmap'; did you mean 'kunmap'? [-Werror=implicit-function-declaration]
drivers/scsi/qla2xxx/qla_mid.c:1094:51: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'unsigned int' [-Wformat=]
drivers/scsi/qla2xxx/qla_mid.c:1189:6: warning: no previous prototype for 'qla_trim_buf' [-Wmissing-prototypes]
drivers/scsi/qla2xxx/qla_mid.c:1221:6: warning: no previous prototype for '__qla_adjust_buf' [-Wmissing-prototypes]
libbpf: failed to find '.BTF' ELF section in vmlinux
usr/include/asm/kvm.h:508:17: error: expected specifier-qualifier-list before '__DECLARE_FLEX_ARRAY'

Unverified Error/Warning (likely false positive, please contact us if interested):

FAILED: load BTF from vmlinux: No data available
drivers/firmware/arm_scmi/bus.c:156:24: warning: Uninitialized variable: victim->id_table [uninitvar]
drivers/firmware/arm_scmi/virtio.c:341:12: warning: Uninitialized variable: msg->poll_status [uninitvar]
drivers/gpio/gpio-mxc.c:293:32: warning: Uninitialized variable: port->hwdata [uninitvar]
drivers/gpio/gpio-mxc.c:550:31: warning: Shifting signed 32-bit value by 31 bits is implementation-defined behaviour [shiftTooManyBitsSigned]
drivers/gpio/gpio-mxc.c:550:31: warning: Signed integer overflow for expression '1<<i'. [integerOverflow]
drivers/gpio/gpio-mxc.c:596:22: warning: Uninitialized variables: port.node, port.clk, port.irq, port.irq_high, port.domain, port.gc, port.dev, port.both_edges, port.gpio_saved_reg, port.power_off, port.wakeup_pads, port.is_pad_wakeup, port.hwdata [uninitvar]
drivers/gpio/gpio-mxc.c:615:25: warning: Uninitialized variables: port.node, port.irq, port.irq_high, port.domain, port.gc, port.dev, port.both_edges, port.gpio_saved_reg, port.power_off, port.wakeup_pads, port.is_pad_wakeup, port.hwdata [uninitvar]
drivers/nvmem/imx-ocotp.c:599:21: sparse: sparse: symbol 'imx_ocotp_layout' was not declared. Should it be static?
net/devlink/leftover.c:7181 devlink_fmsg_prepare_skb() error: uninitialized symbol 'err'.

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- arc-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- arm-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- arm-buildonly-randconfig-r002-20230117
|   `-- arch-arm-kernel-entry-armv.S:warning:CONFIG_ARM_THUMB-is-not-defined-evaluates-to
|-- arm-randconfig-r046-20230117
|   `-- arch-arm-kernel-entry-armv.S:warning:CONFIG_ARM_THUMB-is-not-defined-evaluates-to
|-- arm64-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- arm64-randconfig-r033-20230117
|   `-- ERROR:kunit_running-drivers-gpu-drm-vc4-vc4.ko-undefined
|-- i386-allyesconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- i386-randconfig-a016-20230116
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- ia64-allmodconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-ttm-ttm_bo_util.c:error:implicit-declaration-of-function-vmap
|   |-- drivers-gpu-drm-ttm-ttm_bo_util.c:error:implicit-declaration-of-function-vunmap
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- nios2-randconfig-c031-20230115
|   |-- FAILED:load-BTF-from-vmlinux:No-data-available
|   `-- libbpf:failed-to-find-.BTF-ELF-section-in-vmlinux
|-- parisc-randconfig-r033-20230116
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
|-- parisc-randconfig-s051-20230116
|   `-- drivers-nvmem-imx-ocotp.c:sparse:sparse:symbol-imx_ocotp_layout-was-not-declared.-Should-it-be-static
|-- powerpc-allmodconfig
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:format-ld-expects-argument-of-type-long-int-but-argument-has-type-unsigned-int
|   |-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-__qla_adjust_buf
|   `-- drivers-scsi-qla2xxx-qla_mid.c:warning:no-previous-prototype-for-qla_trim_buf
clang_recent_errors
`-- x86_64-buildonly-randconfig-r006-20230116
    `-- ERROR:kunit_running-drivers-gpu-drm-vc4-vc4.ko-undefined

elapsed time: 724m

configs tested: 68
configs skipped: 22

gcc tested configs:
x86_64                              defconfig
x86_64                            allnoconfig
x86_64                               rhel-8.3
x86_64                           rhel-8.3-bpf
x86_64                          rhel-8.3-func
x86_64                    rhel-8.3-kselftests
x86_64                           rhel-8.3-syz
x86_64                         rhel-8.3-kunit
arm64                            allyesconfig
x86_64                           rhel-8.3-kvm
ia64                             allmodconfig
x86_64                           allyesconfig
i386                 randconfig-a014-20230116
i386                 randconfig-a013-20230116
i386                 randconfig-a012-20230116
i386                 randconfig-a011-20230116
x86_64               randconfig-a011-20230116
i386                 randconfig-a015-20230116
x86_64               randconfig-a013-20230116
x86_64               randconfig-a012-20230116
x86_64               randconfig-a015-20230116
i386                 randconfig-a016-20230116
x86_64               randconfig-a014-20230116
x86_64               randconfig-a016-20230116
mips                         db1xxx_defconfig
powerpc                 mpc837x_rdb_defconfig
m68k                         apollo_defconfig
um                               alldefconfig
sh                 kfr2r09-romimage_defconfig
arc                  randconfig-r043-20230115
s390                 randconfig-r044-20230116
riscv                randconfig-r042-20230116
arc                  randconfig-r043-20230116
arm                  randconfig-r046-20230115
arm                  randconfig-r046-20230117
arc                  randconfig-r043-20230117
arm                       multi_v4t_defconfig
sh                        dreamcast_defconfig
arm64                               defconfig
s390                          debug_defconfig

clang tested configs:
i386                 randconfig-a002-20230116
x86_64                          rhel-8.3-rust
i386                 randconfig-a004-20230116
i386                 randconfig-a003-20230116
i386                 randconfig-a001-20230116
i386                 randconfig-a006-20230116
i386                 randconfig-a005-20230116
x86_64               randconfig-a001-20230116
x86_64               randconfig-a006-20230116
x86_64               randconfig-a003-20230116
x86_64               randconfig-a002-20230116
x86_64               randconfig-a004-20230116
x86_64               randconfig-a005-20230116
arm                            dove_defconfig
hexagon              randconfig-r041-20230116
riscv                randconfig-r042-20230117
hexagon              randconfig-r045-20230117
s390                 randconfig-r044-20230117
hexagon              randconfig-r045-20230115
hexagon              randconfig-r041-20230117
riscv                randconfig-r042-20230115
arm                  randconfig-r046-20230116
s390                 randconfig-r044-20230115
hexagon              randconfig-r045-20230116
hexagon              randconfig-r041-20230115
arm                           omap1_defconfig
riscv                    nommu_virt_defconfig
x86_64                        randconfig-k001

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
