Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7F24F1AF3
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379314AbiDDVTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379179AbiDDQm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 12:42:26 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86473056B;
        Mon,  4 Apr 2022 09:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649090426; x=1680626426;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=U5VfBkYI6pAwqkHe/lQGYt6BlxyUiPpHDX2ghooSW9Y=;
  b=X4ApAg7ULlDyjxcyg8d1UI0mWqWkBYIdKTR8ruYwfGSEZ3fLowj4aO4K
   D/izwpAvrx8tJ9yEBrmX8XzToky8GZbOCt6hVMpHuoOAiwb9XlC2nVkCl
   2l1fGuvq8v3FjpLgdAuOek3AGm0LP2GLduAW/MACUT6voP7VJf9cOHBIo
   AkRy5oV96XKyT/PO7uZN11Nzvl3jHZ/PcgxGP7Ua6R9jSr4b6yhdS+wB3
   VW8aIANjYPcYJd1CRWSbCGj7Qsay/6KQDHPwj/UaZMmnY5rVHyPzaPOkJ
   OB7bvPS3IxqlBMkssUw0Q0X/DkuEwBlxsTQ5YnmRw5rPY9ONJE0kOY6xQ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="248071166"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="248071166"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 09:40:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="608097969"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 04 Apr 2022 09:40:21 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nbPka-0002Cm-O8;
        Mon, 04 Apr 2022 16:40:20 +0000
Date:   Tue, 05 Apr 2022 00:40:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     uclinux-h8-devel@lists.sourceforge.jp, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-media@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 696206280c5e5c028caf9fd259999cb72b1f6127
Message-ID: <624b1f6e.ZYNEyw65sSXLO9Ie%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 696206280c5e5c028caf9fd259999cb72b1f6127  Add linux-next specific files for 20220404

Error/Warning reports:

https://lore.kernel.org/linux-media/202203170501.AhqUekoF-lkp@intel.com
https://lore.kernel.org/linux-media/202203171537.sVhYE362-lkp@intel.com
https://lore.kernel.org/linux-media/202203171840.ZXc3IgpZ-lkp@intel.com
https://lore.kernel.org/llvm/202203241958.Uw9bWfMD-lkp@intel.com
https://lore.kernel.org/llvm/202204042148.V5rM3bkT-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

/kbuild/src/includecheck/kernel/sched/sched.h: linux/static_key.h is included more than once.
ERROR: modpost: "__v4l2_async_nf_add_fwnode_remote" [drivers/media/platform/nxp/imx-mipi-csis.ko] undefined!
ERROR: modpost: "v4l2_async_nf_init" [drivers/media/platform/nxp/imx-mipi-csis.ko] undefined!
ERROR: modpost: "v4l2_async_register_subdev" [drivers/media/platform/nxp/imx-mipi-csis.ko] undefined!
ERROR: modpost: "v4l2_async_subdev_nf_register" [drivers/media/platform/nxp/imx-mipi-csis.ko] undefined!
ERROR: modpost: "v4l2_fwnode_endpoint_parse" [drivers/media/platform/nxp/imx-mipi-csis.ko] undefined!
ERROR: modpost: "v4l2_subdev_get_fwnode_pad_1_to_1" [drivers/media/platform/nxp/imx-mipi-csis.ko] undefined!
ERROR: modpost: "v4l2_subdev_init" [drivers/media/platform/nxp/imx-mipi-csis.ko] undefined!
ERROR: modpost: "v4l2_subdev_link_validate" [drivers/media/platform/nxp/imx-mipi-csis.ko] undefined!
drivers/bus/mhi/host/main.c:792:13: warning: parameter 'event_quota' set but not used [-Wunused-but-set-parameter]
imx-mipi-csis.c:(.text+0x1008): undefined reference to `v4l2_subdev_call_wrappers'
imx-mipi-csis.c:(.text+0x3c): undefined reference to `v4l2_create_fwnode_links_to_pad'
imx-mipi-csis.c:(.text+0x47c): undefined reference to `v4l_bound_align_image'
imx-mipi-csis.c:(.text+0x974): undefined reference to `v4l2_subdev_init'
imx-mipi-csis.c:(.text+0x984): undefined reference to `v4l2_async_nf_init'
imx-mipi-csis.c:(.text+0x9c8): undefined reference to `v4l2_async_nf_unregister'
include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior err: false

Unverified Error/Warning (likely false positive, please contact us if interested):

ERROR: modpost: "v4l2_get_link_freq" [drivers/media/platform/nxp/imx-mipi-csis.ko] undefined!
ERROR: modpost: "v4l2_subdev_call_wrappers" [drivers/media/platform/nxp/imx-mipi-csis.ko] undefined!
arch/s390/include/asm/spinlock.h:81:3: error: unexpected token in '.rept' directive
arch/s390/include/asm/spinlock.h:81:3: error: unknown directive
arch/s390/include/asm/spinlock.h:81:3: error: unmatched '.endr' directive
arch/s390/lib/spinlock.c:78:3: error: unexpected token in '.rept' directive
arch/s390/lib/spinlock.c:78:3: error: unknown directive
arch/s390/lib/spinlock.c:78:3: error: unmatched '.endr' directive
arch/x86/kernel/cpu/mce/inject.c:355:6: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/clk/imx/clk-pll14xx.c:166:2: warning: Value stored to 'pll_div_ctl1' is never read [clang-analyzer-deadcode.DeadStores]
drivers/counter/104-quad-8.c:150:9: sparse:    unsigned char
drivers/counter/104-quad-8.c:150:9: sparse:    void
drivers/counter/104-quad-8.c:150:9: sparse: sparse: incompatible types in conditional expression (different base types):
drivers/dma-buf/st-dma-fence-unwrap.c:125:13: warning: variable 'err' set but not used [-Wunused-but-set-variable]
drivers/dma-buf/st-dma-fence-unwrap.c:261:1: internal compiler error: Segmentation fault
drivers/firmware/turris-mox-rwtm.c:146:1: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubp.c:57:6: warning: no previous prototype for 'hubp31_program_extended_blank' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dml/calcs/dce_calcs.c:77:13: warning: stack frame size (5376) exceeds limit (1024) in 'calculate_bandwidth' [-Wframe-larger-than]
drivers/gpu/drm/drm_of.c:292:2-13: ERROR: probable double put.
drivers/gpu/drm/selftests/test-drm_buddy.c:523:7: warning: Value stored to 'err' is never read [clang-analyzer-deadcode.DeadStores]
drivers/hid/hid-core.c:1665:30: warning: Although the value stored to 'field' is used in the enclosing expression, the value is never actually read from 'field' [clang-analyzer-deadcode.DeadStores]
drivers/hwmon/vt8231.c:634:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/leds/trigger/ledtrig-tty.c:33:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/media/platform/st/stm32/dma2d/dma2d-hw.c:109:1: internal compiler error: in extract_insn, at recog.c:2770
drivers/memory/brcmstb_dpfe.c:707:10: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/misc/mei/main.c:1100:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/mmc/host/omap_hsmmc.c:747:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/mtd/maps/amd76xrom.c:204:3: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/mtd/maps/ck804xrom.c:234:3: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/mtd/nand/ecc-mxic.c:523:17: warning: Value stored to 'dev' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/mtd/nand/ecc-mxic.c:595:6: warning: Branch condition evaluates to a garbage value [clang-analyzer-core.uninitialized.Branch]
drivers/net/vxlan/vxlan_core.c:440:34: sparse: sparse: incorrect type in argument 2 (different base types)
drivers/pci/vgaarb.c:213:17: warning: Value stored to 'dev' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/power/supply/ip5xxx_power.c:341 ip5xxx_battery_get_property() error: uninitialized symbol 'raw'.
drivers/usb/typec/altmodes/displayport.c:396:8: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/video/fbdev/matrox/matroxfb_base.c:1094:5: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
kernel/sched/core.c:5268:20: warning: no previous prototype for function 'task_sched_runtime' [-Wmissing-prototypes]
kernel/sched/core.c:8979:6: warning: no previous prototype for 'idle_task_exit' [-Wmissing-prototypes]
kernel/sched/core.c:8979:6: warning: no previous prototype for function 'idle_task_exit' [-Wmissing-prototypes]
kernel/sched/core.c:8994:6: warning: no previous prototype for 'idle_task_exit' [-Wmissing-prototypes]
kernel/sched/core.c:9214:5: warning: no previous prototype for 'sched_cpu_activate' [-Wmissing-prototypes]
kernel/sched/core.c:9214:5: warning: no previous prototype for function 'sched_cpu_activate' [-Wmissing-prototypes]
kernel/sched/core.c:9229:5: warning: no previous prototype for 'sched_cpu_activate' [-Wmissing-prototypes]
kernel/sched/core.c:9259:5: warning: no previous prototype for 'sched_cpu_deactivate' [-Wmissing-prototypes]
kernel/sched/core.c:9259:5: warning: no previous prototype for function 'sched_cpu_deactivate' [-Wmissing-prototypes]
kernel/sched/core.c:9274:5: warning: no previous prototype for 'sched_cpu_deactivate' [-Wmissing-prototypes]
kernel/sched/core.c:9334:5: warning: no previous prototype for 'sched_cpu_starting' [-Wmissing-prototypes]
kernel/sched/core.c:9334:5: warning: no previous prototype for function 'sched_cpu_starting' [-Wmissing-prototypes]
kernel/sched/core.c:9349:5: warning: no previous prototype for 'sched_cpu_starting' [-Wmissing-prototypes]
kernel/sched/core.c:9355:5: warning: no previous prototype for 'sched_cpu_wait_empty' [-Wmissing-prototypes]
kernel/sched/core.c:9355:5: warning: no previous prototype for function 'sched_cpu_wait_empty' [-Wmissing-prototypes]
kernel/sched/core.c:9370:5: warning: no previous prototype for 'sched_cpu_wait_empty' [-Wmissing-prototypes]
kernel/sched/core.c:9397:5: warning: no previous prototype for 'sched_cpu_dying' [-Wmissing-prototypes]
kernel/sched/core.c:9397:5: warning: no previous prototype for function 'sched_cpu_dying' [-Wmissing-prototypes]
kernel/sched/core.c:9412:5: warning: no previous prototype for 'sched_cpu_dying' [-Wmissing-prototypes]
kernel/sched/core.c:9420:13: warning: no previous prototype for function 'sched_init_smp' [-Wmissing-prototypes]
kernel/sched/core.c:9453:13: warning: no previous prototype for function 'sched_init_smp' [-Wmissing-prototypes]
kernel/sched/core.c:9481:13: warning: no previous prototype for function 'sched_init' [-Wmissing-prototypes]
kernel/sched/fair.c:10665:6: warning: no previous prototype for 'nohz_balance_enter_idle' [-Wmissing-prototypes]
kernel/sched/fair.c:10665:6: warning: no previous prototype for function 'nohz_balance_enter_idle' [-Wmissing-prototypes]
kernel/sched/fair.c:10669:6: warning: no previous prototype for 'nohz_balance_enter_idle' [-Wmissing-prototypes]
kernel/sched/loadavg.c:245:6: warning: no previous prototype for 'calc_load_nohz_start' [-Wmissing-prototypes]
kernel/sched/loadavg.c:245:6: warning: no previous prototype for function 'calc_load_nohz_start' [-Wmissing-prototypes]
kernel/sched/loadavg.c:258:6: warning: no previous prototype for 'calc_load_nohz_remote' [-Wmissing-prototypes]
kernel/sched/loadavg.c:258:6: warning: no previous prototype for function 'calc_load_nohz_remote' [-Wmissing-prototypes]
kernel/sched/loadavg.c:263:6: warning: no previous prototype for 'calc_load_nohz_stop' [-Wmissing-prototypes]
kernel/sched/loadavg.c:263:6: warning: no previous prototype for function 'calc_load_nohz_stop' [-Wmissing-prototypes]
sound/spi/at73c213.c:992:2: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
sound/usb/line6/driver.c:770:2: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- alpha-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- alpha-buildonly-randconfig-r003-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- alpha-randconfig-c003-20220403
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- alpha-randconfig-r002-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- alpha-randconfig-r011-20220404
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-axs103_smp_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-buildonly-randconfig-r001-20220403
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-buildonly-randconfig-r006-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-randconfig-r006-20220403
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-randconfig-r012-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-randconfig-r014-20220403
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- arc-randconfig-r031-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-randconfig-r043-20220403
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm-h3600_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm-pxa910_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm-randconfig-c002-20220404
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arm-randconfig-c024-20220404
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm-randconfig-p001-20220403
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arm64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-defconfig
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- csky-defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- h8300-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-media-platform-st-stm32-dma2d-dma2d-hw.c:internal-compiler-error:in-extract_insn-at-recog.c
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- h8300-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-media-platform-st-stm32-dma2d-dma2d-hw.c:internal-compiler-error:in-extract_insn-at-recog.c
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- h8300-randconfig-m031-20220403
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dcn31-dcn31_hubp.c:warning:no-previous-prototype-for-hubp31_program_extended_blank
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-debian-10.3
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-debian-10.3-kselftests
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-a011-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-a012-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-a013-20220404
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-a014-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-a015-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-a016-20220404
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-c001
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-c001-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-m021-20220404
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-p002-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-s002-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-alldefconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- ia64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-buildonly-randconfig-r001-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-buildonly-randconfig-r004-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-randconfig-r001-20220403
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- ia64-randconfig-r023-20220403
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- ia64-randconfig-r036-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-zx1_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- m68k-allmodconfig
|   |-- drivers-counter-quad-.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-counter-quad-.c:sparse:unsigned-char
|   |-- drivers-counter-quad-.c:sparse:void
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   `-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|-- m68k-allyesconfig
|   |-- drivers-counter-quad-.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-counter-quad-.c:sparse:unsigned-char
|   |-- drivers-counter-quad-.c:sparse:void
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   `-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|-- microblaze-randconfig-c024-20220403
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- microblaze-randconfig-r012-20220403
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- mips-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- mips-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- mips-loongson3_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- mips-randconfig-r033-20220404
|   |-- ERROR:__v4l2_async_nf_add_fwnode_remote-drivers-media-platform-nxp-imx-mipi-csis.ko-undefined
|   |-- ERROR:v4l2_async_nf_init-drivers-media-platform-nxp-imx-mipi-csis.ko-undefined
|   |-- ERROR:v4l2_async_register_subdev-drivers-media-platform-nxp-imx-mipi-csis.ko-undefined
|   |-- ERROR:v4l2_async_subdev_nf_register-drivers-media-platform-nxp-imx-mipi-csis.ko-undefined
|   |-- ERROR:v4l2_fwnode_endpoint_parse-drivers-media-platform-nxp-imx-mipi-csis.ko-undefined
|   |-- ERROR:v4l2_get_link_freq-drivers-media-platform-nxp-imx-mipi-csis.ko-undefined
|   |-- ERROR:v4l2_subdev_call_wrappers-drivers-media-platform-nxp-imx-mipi-csis.ko-undefined
|   |-- ERROR:v4l2_subdev_get_fwnode_pad_1_to_1-drivers-media-platform-nxp-imx-mipi-csis.ko-undefined
|   |-- ERROR:v4l2_subdev_init-drivers-media-platform-nxp-imx-mipi-csis.ko-undefined
|   |-- ERROR:v4l2_subdev_link_validate-drivers-media-platform-nxp-imx-mipi-csis.ko-undefined
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- nios2-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-randconfig-r003-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-randconfig-r022-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-randconfig-r026-20220403
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- openrisc-buildonly-randconfig-r002-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- openrisc-or1ksim_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- openrisc-randconfig-p002-20220403
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- openrisc-randconfig-r005-20220404
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- openrisc-randconfig-r006-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- openrisc-randconfig-r024-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- openrisc-randconfig-s031-20220403
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- parisc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- parisc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- parisc-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- parisc-randconfig-r016-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- parisc-randconfig-r023-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- parisc-randconfig-r025-20220403
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- parisc64-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- powerpc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc-buildonly-randconfig-r002-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc-cell_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc-mpc834x_itx_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc-randconfig-r004-20220403
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc-randconfig-s031-20220404
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- powerpc64-alldefconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- powerpc64-randconfig-r014-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- powerpc64-randconfig-r021-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- riscv-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- riscv-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- riscv-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- riscv-nommu_k210_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- riscv-nommu_virt_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- riscv-randconfig-c004-20220403
|   `-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|-- riscv-randconfig-p001-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- riscv-randconfig-r015-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- riscv-randconfig-r022-20220404
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:internal-compiler-error:Segmentation-fault
|-- riscv-randconfig-r042-20220404
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- s390-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- s390-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- s390-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- s390-randconfig-r026-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- s390-randconfig-r044-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sh-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sh-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sh-buildonly-randconfig-r001-20220404
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sh-randconfig-r003-20220404
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc-randconfig-r011-20220403
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc-randconfig-r014-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc64-randconfig-r015-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- sparc64-randconfig-r021-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- um-i386_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- um-x86_64_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-allnoconfig
|   `-- kernel-sched-sched.h:linux-static_key.h-is-included-more-than-once.
|-- x86_64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-kexec
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-a011-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- x86_64-randconfig-a012-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-a013-20220404
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-a014-20220404
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-a015-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-a016-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-c001-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- x86_64-randconfig-c002
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-c022-20220404
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-c023-20220404
|   |-- drivers-gpu-drm-drm_of.c:ERROR:probable-double-put.
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-m001-20220404
|   |-- drivers-power-supply-ip5xxx_power.c-ip5xxx_battery_get_property()-error:uninitialized-symbol-raw-.
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-s021-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- x86_64-randconfig-s022-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-s032-20220404
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-rhel-8.3
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-rhel-8.3-func
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-rhel-8.3-kselftests
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-rhel-8.3-kunit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- xtensa-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
`-- xtensa-randconfig-r011-20220404
    |-- imx-mipi-csis.c:(.text):undefined-reference-to-v4l2_async_nf_init
    |-- imx-mipi-csis.c:(.text):undefined-reference-to-v4l2_async_nf_unregister
    |-- imx-mipi-csis.c:(.text):undefined-reference-to-v4l2_create_fwnode_links_to_pad
    |-- imx-mipi-csis.c:(.text):undefined-reference-to-v4l2_subdev_call_wrappers
    |-- imx-mipi-csis.c:(.text):undefined-reference-to-v4l2_subdev_init
    `-- imx-mipi-csis.c:(.text):undefined-reference-to-v4l_bound_align_image

clang_recent_errors
|-- arm-buildonly-randconfig-r006-20220404
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml-calcs-dce_calcs.c:warning:stack-frame-size-()-exceeds-limit-()-in-calculate_bandwidth
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm-imx_v4_v5_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- arm-magician_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- arm-neponset_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm-omap1_defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- arm-randconfig-c002-20220404
|   |-- drivers-clk-imx-clk-pll14xx.c:warning:Value-stored-to-pll_div_ctl1-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-gpu-drm-selftests-test-drm_buddy.c:warning:Value-stored-to-err-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   |-- drivers-leds-trigger-ledtrig-tty.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-ana
|   |-- drivers-mtd-nand-ecc-mxic.c:warning:Branch-condition-evaluates-to-a-garbage-value-clang-analyzer-core.uninitialized.Branch
|   |-- drivers-mtd-nand-ecc-mxic.c:warning:Value-stored-to-dev-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm64-buildonly-randconfig-r005-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- arm64-randconfig-r004-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- hexagon-buildonly-randconfig-r005-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- hexagon-defconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- hexagon-randconfig-r025-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- i386-allmodconfig
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- i386-randconfig-a001-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- i386-randconfig-a002-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- i386-randconfig-a003-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- i386-randconfig-a004-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- i386-randconfig-a005-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- i386-randconfig-c001-20220404
|   |-- arch-x86-kernel-cpu-mce-inject.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analo
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   |-- drivers-usb-typec-altmodes-displayport.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-wi
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- i386-randconfig-r005-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- mips-randconfig-c004-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- drivers-firmware-turris-mox-rwtm.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-ana
|   |-- drivers-memory-brcmstb_dpfe.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- drivers-mmc-host-omap_hsmmc.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   `-- sound-spi-at73c213.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functio
|-- riscv-allnoconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- riscv-randconfig-c006-20220404
|   `-- include-asm-generic-io.h:warning:performing-pointer-arithmetic-on-a-null-pointer-has-undefined-behavior-err:false
|-- riscv-randconfig-r034-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- s390-randconfig-c005-20220404
|   |-- arch-s390-include-asm-spinlock.h:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unknown-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unmatched-.endr-directive
|   |-- arch-s390-lib-spinlock.c:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-lib-spinlock.c:error:unknown-directive
|   |-- arch-s390-lib-spinlock.c:error:unmatched-.endr-directive
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- x86_64-randconfig-a001-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- x86_64-randconfig-a002-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- x86_64-randconfig-a003-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- x86_64-randconfig-a004-20220404
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
|-- x86_64-randconfig-a005-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|-- x86_64-randconfig-a006-20220404
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
`-- x86_64-randconfig-c007-20220404
    |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
    |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
    |-- drivers-hwmon-vt8231.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-funct
    |-- drivers-misc-mei-main.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-func
    |-- drivers-mtd-maps-amd76xrom.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous
    |-- drivers-mtd-maps-ck804xrom.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous
    |-- drivers-pci-vgaarb.c:warning:Value-stored-to-dev-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
    |-- drivers-video-fbdev-matrox-matroxfb_base.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-idle_task_exit
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_activate
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_deactivate
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_dying
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_starting
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_cpu_wait_empty
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-sched_init_smp
    |-- kernel-sched-core.c:warning:no-previous-prototype-for-function-task_sched_runtime
    |-- kernel-sched-fair.c:warning:no-previous-prototype-for-function-nohz_balance_enter_idle
    |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_remote
    |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_start
    |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-function-calc_load_nohz_stop
    `-- sound-usb-line6-driver.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-fun

elapsed time: 737m

configs tested: 125
configs skipped: 4

gcc tested configs:
arm                              allmodconfig
arm                              allyesconfig
arm                                 defconfig
arm64                            allyesconfig
arm64                               defconfig
um                             i386_defconfig
um                           x86_64_defconfig
riscv                            allmodconfig
s390                             allmodconfig
m68k                             allyesconfig
m68k                             allmodconfig
powerpc                          allyesconfig
powerpc                          allmodconfig
s390                             allyesconfig
i386                          randconfig-c001
arc                              allyesconfig
alpha                            allyesconfig
nios2                            allyesconfig
openrisc                    or1ksim_defconfig
powerpc64                        alldefconfig
sh                        edosk7760_defconfig
sh                     sh7710voipgw_defconfig
sh                   sh7770_generic_defconfig
m68k                          hp300_defconfig
sh                           se7722_defconfig
arm                           h3600_defconfig
arm                        cerfcube_defconfig
sh                        sh7757lcr_defconfig
arc                      axs103_smp_defconfig
ia64                             alldefconfig
sh                  sh7785lcr_32bit_defconfig
mips                      loongson3_defconfig
ia64                            zx1_defconfig
arm                      footbridge_defconfig
powerpc                 mpc834x_itx_defconfig
mips                     decstation_defconfig
sh                           se7343_defconfig
arm                          pxa910_defconfig
m68k                        mvme147_defconfig
powerpc                        cell_defconfig
sh                      rts7751r2d1_defconfig
sh                          rsk7201_defconfig
arm                       multi_v4t_defconfig
arm                          lpd270_defconfig
i386                 randconfig-c001-20220404
arm                  randconfig-c002-20220404
x86_64               randconfig-c001-20220404
arm                  randconfig-c002-20220403
ia64                             allmodconfig
ia64                                defconfig
ia64                             allyesconfig
m68k                                defconfig
nios2                               defconfig
alpha                               defconfig
csky                                defconfig
arc                                 defconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
parisc                              defconfig
parisc64                            defconfig
parisc                           allyesconfig
s390                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
i386                             allyesconfig
sparc                            allyesconfig
sparc                               defconfig
mips                             allyesconfig
mips                             allmodconfig
powerpc                           allnoconfig
x86_64               randconfig-a011-20220404
x86_64               randconfig-a013-20220404
x86_64               randconfig-a015-20220404
x86_64               randconfig-a014-20220404
x86_64               randconfig-a012-20220404
x86_64               randconfig-a016-20220404
i386                 randconfig-a013-20220404
i386                 randconfig-a016-20220404
i386                 randconfig-a011-20220404
i386                 randconfig-a014-20220404
i386                 randconfig-a012-20220404
i386                 randconfig-a015-20220404
riscv                randconfig-r042-20220404
arc                  randconfig-r043-20220403
s390                 randconfig-r044-20220404
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                            allyesconfig
riscv                               defconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                                  kexec
x86_64                          rhel-8.3-func
x86_64                               rhel-8.3
x86_64                         rhel-8.3-kunit

clang tested configs:
powerpc              randconfig-c003-20220404
x86_64               randconfig-c007-20220404
mips                 randconfig-c004-20220404
i386                 randconfig-c001-20220404
riscv                randconfig-c006-20220404
arm                  randconfig-c002-20220404
s390                 randconfig-c005-20220404
powerpc                     mpc5200_defconfig
mips                   sb1250_swarm_defconfig
hexagon                             defconfig
powerpc                  mpc866_ads_defconfig
arm                           omap1_defconfig
arm                        neponset_defconfig
mips                       rbtx49xx_defconfig
arm                        magician_defconfig
mips                           ip28_defconfig
arm                       imx_v4_v5_defconfig
riscv                             allnoconfig
x86_64               randconfig-a002-20220404
x86_64               randconfig-a001-20220404
x86_64               randconfig-a004-20220404
x86_64               randconfig-a003-20220404
x86_64               randconfig-a005-20220404
x86_64               randconfig-a006-20220404
i386                 randconfig-a001-20220404
i386                 randconfig-a005-20220404
i386                 randconfig-a004-20220404
i386                 randconfig-a003-20220404
i386                 randconfig-a002-20220404

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
