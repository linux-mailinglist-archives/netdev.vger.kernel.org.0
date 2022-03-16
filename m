Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B9F4DA990
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 06:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353592AbiCPFLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 01:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353591AbiCPFLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 01:11:36 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C75449CB7;
        Tue, 15 Mar 2022 22:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647407419; x=1678943419;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=akUzU4SSsfmk1H/LqX5DhhMgoti8j786JnJosdMDf2g=;
  b=GaMjhNpw7C0V/EQ21syLF0UruYPgvhDuOpDQqnTT8ZiJfzPlLkim/eK+
   Y55DPzqRlSy7vhiuc299ApvdlAxS0lK26HrW1P7xm+x+Kn0Sl1fJYFpH3
   IkBWhVzb8fWu+jbzPP0qd2ozhRMxm6Di46ZbXmwoX187ddTNgCO1tOajQ
   5SUSBiI5YeavX0W9H9ASCoTTs+0xERq0tiEAriBx95OxRFKLIXbU0NWlA
   EHD+Qm7bNM0hQpRysk+kOBcw/aP/R/XXZChg4fcMdpiUDU73jZg1iOlns
   oz4wlMtEBbu+vNSepubGiOu5tANc4c4uY1l8R8f1bxPiOFdACKKeGjqkc
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="317216012"
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="317216012"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 22:10:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,185,1643702400"; 
   d="scan'208";a="690451711"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 15 Mar 2022 22:10:14 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nULvK-000C0k-9c; Wed, 16 Mar 2022 05:10:14 +0000
Date:   Wed, 16 Mar 2022 13:09:56 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-alpha@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 a32cd981a6da2373c093d471ee4405a915e217d5
Message-ID: <62317124.YBQFU33+s/wdvWGj%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: a32cd981a6da2373c093d471ee4405a915e217d5  Add linux-next specific files for 20220315

Error/Warning reports:

https://lore.kernel.org/linux-doc/202202240704.pQD40A9L-lkp@intel.com
https://lore.kernel.org/linux-doc/202202240705.t3QbMnlt-lkp@intel.com
https://lore.kernel.org/linux-media/202203160306.SfWO9QWV-lkp@intel.com
https://lore.kernel.org/linux-mm/202203160358.yulPl6b4-lkp@intel.com
https://lore.kernel.org/llvm/202202241039.g8GKEE4O-lkp@intel.com
https://lore.kernel.org/llvm/202203032008.iQvFvs6z-lkp@intel.com

Error/Warning:

ERROR: dtschema minimum version is v2022.3
ERROR: modpost: "perf_pmu_migrate_context" [drivers/nvdimm/libnvdimm.ko] undefined!
ERROR: modpost: "perf_pmu_register" [drivers/nvdimm/libnvdimm.ko] undefined!
ERROR: modpost: "perf_pmu_unregister" [drivers/nvdimm/libnvdimm.ko] undefined!
clk-imx93.c:(.text+0x72): undefined reference to `imx_obtain_fixed_clk_hw'
csky-linux-ld: clk-imx93.c:(.text+0x1c2): undefined reference to `imx_clk_fracn_gppll'
csky-linux-ld: clk-imx93.c:(.text+0x234): undefined reference to `imx93_clk_composite_flags'
csky-linux-ld: clk-imx93.c:(.text+0x2b8): undefined reference to `imx_fracn_gppll'
csky-linux-ld: clk-imx93.c:(.text+0x2e8): undefined reference to `imx_ccm_lock'
csky-linux-ld: clk-imx93.c:(.text+0x326): undefined reference to `clk_hw_register_gate2'
csky-linux-ld: clk-imx93.c:(.text+0x348): undefined reference to `imx_check_clk_hws'
csky-linux-ld: clk-imx93.c:(.text+0x368): undefined reference to `imx_unregister_hw_clocks'
csky-linux-ld: clk-imx93.c:(.text+0x84): undefined reference to `imx_obtain_fixed_clk_hw'
drivers/gpu/drm/amd/amdgpu/amdgpu_mmhub.c:27:6: warning: no previous prototype for function 'amdgpu_mmhub_ras_fini' [-Wmissing-prototypes]
drivers/media/platform/samsung/exynos4-is/fimc-isp-video.h:35:6: warning: no previous prototype for 'fimc_isp_video_device_unregister' [-Wmissing-prototypes]
drivers/spi/spi-amd.c:296:21: warning: cast to smaller integer type 'enum amd_spi_versions' from 'const void *' [-Wvoid-pointer-to-enum-cast]
fs/btrfs/ordered-data.c:168: warning: expecting prototype for Add an ordered extent to the per(). Prototype was for btrfs_add_ordered_extent() instead
fs/btrfs/tree-log.c:6934: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
kernel/trace/trace_events_synth.c:65:9: warning: 'strncpy' specified bound depends on the length of the source argument [-Wstringop-truncation]

Unverified Error/Warning (likely false positive, please contact us if interested):

Makefile:662: arch/nds32/Makefile: No such file or directory
WARNING: modpost: vmlinux.o(.text+0x144e892): Section mismatch in reference from the function tcp4_proc_exit() to the function .init.text:set_reset_devices()
WARNING: modpost: vmlinux.o(__ex_table+0x2034): Section mismatch in reference from the (unknown reference) (unknown) to the (unknown reference) .debug_str:(unknown)
arch/Kconfig:10: can't open file "arch/nds32/Kconfig"
arch/alpha/include/asm/string.h:22:16: warning: '__builtin_memcpy' forming offset [40, 2051] is out of the bounds [0, 40] of object 'tag_buf' with type 'unsigned char[40]' [-Warray-bounds]
arch/s390/kernel/machine_kexec.c:57:9: warning: 'memcpy' offset [0, 511] is out of the bounds [0, 0] [-Warray-bounds]
arch/sh/kernel/machvec.c:105:33: warning: array subscript 'struct sh_machine_vector[0]' is partly outside array bounds of 'long int[1]' [-Warray-bounds]
drivers/clk/imx/clk-pll14xx.c:166:2: warning: Value stored to 'pll_div_ctl1' is never read [clang-analyzer-deadcode.DeadStores]
drivers/firmware/turris-mox-rwtm.c:146:1: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_resource.c:1633:6: warning: no previous prototype for 'is_timing_changed' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_resource.c:1633:6: warning: no previous prototype for function 'is_timing_changed' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dml/calcs/dce_calcs.c:77:13: warning: stack frame size (4824) exceeds limit (2048) in 'calculate_bandwidth' [-Wframe-larger-than]
drivers/gpu/drm/amd/amdgpu/../display/dc/dml/calcs/dce_calcs.c:77:13: warning: stack frame size (5280) exceeds limit (2048) in 'calculate_bandwidth' [-Wframe-larger-than]
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:718:4: warning: Value stored to 'res' is never read [clang-analyzer-deadcode.DeadStores]
drivers/gpu/drm/amd/amdgpu/amdgpu_hdp.c:27:6: warning: no previous prototype for 'amdgpu_hdp_ras_fini' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/amdgpu_hdp.c:27:6: warning: no previous prototype for function 'amdgpu_hdp_ras_fini' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/amdgpu_mmhub.c:27:6: warning: no previous prototype for 'amdgpu_mmhub_ras_fini' [-Wmissing-prototypes]
drivers/hid/hid-core.c:1665:30: warning: Although the value stored to 'field' is used in the enclosing expression, the value is never actually read from 'field' [clang-analyzer-deadcode.DeadStores]
drivers/hwmon/nsa320-hwmon.c:114:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/iio/frequency/admv1014.c:703:22: sparse: sparse: dubious: x & !y
drivers/infiniband/core/user_mad.c:564:50: warning: array subscript 'struct ib_rmpp_mad[0]' is partly outside array bounds of 'unsigned char[124]' [-Warray-bounds]
drivers/input/serio/ps2-gpio.c:223:4: warning: Value stored to 'rxflags' is never read [clang-analyzer-deadcode.DeadStores]
drivers/leds/trigger/ledtrig-tty.c:33:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/memory/brcmstb_dpfe.c:707:10: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/memory/tegra/tegra30-emc.c:1164:3: warning: Value stored to 'dram_type_str' is never read [clang-analyzer-deadcode.DeadStores]
drivers/mmc/host/omap_hsmmc.c:747:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:400:22: warning: array subscript 255 is above array bounds of 'struct pps_pin[4]' [-Warray-bounds]
drivers/net/vxlan/vxlan_core.c:440:34: sparse: sparse: incorrect type in argument 2 (different base types)
drivers/nvmem/sunplus-ocotp.c:74:29: sparse: sparse: symbol 'sp_otp_v0' was not declared. Should it be static?
drivers/pci/vgaarb.c:235:17: warning: Value stored to 'dev' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/phy/broadcom/phy-brcm-usb.c:233:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/staging/greybus/arche-apb-ctrl.c:302:10: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/tty/serial/sunplus-uart.c:501:26: sparse: sparse: symbol 'sunplus_console_ports' was not declared. Should it be static?
drm_gem_shmem_helper.c:(.text+0x1dc): undefined reference to `vmf_insert_pfn'
fs/reiserfs/lbalance.o: warning: objtool: leaf_copy_boundary_item()+0x30ae: stack state mismatch: cfa1=4+232 cfa2=4+224
fs/reiserfs/lbalance.o: warning: objtool: leaf_copy_boundary_item()+0x30e6: stack state mismatch: cfa1=4+232 cfa2=4+224
fs/reiserfs/lbalance.o: warning: objtool: leaf_copy_boundary_item()+0x30eb: stack state mismatch: cfa1=4+232 cfa2=4+224
include/linux/fortify-string.h:336:4: warning: call to __read_overflow2_field declared with 'warning' attribute: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
include/linux/fortify-string.h:45:33: warning: '__builtin_memcpy' offset [0, 1023] is out of the bounds [0, 0] [-Warray-bounds]
include/linux/fortify-string.h:45:33: warning: '__builtin_memcpy' offset [0, 127] is out of the bounds [0, 0] [-Warray-bounds]
include/linux/fortify-string.h:45:33: warning: '__builtin_memcpy' offset [0, 511] is out of the bounds [0, 0] [-Warray-bounds]
make[1]: *** No rule to make target 'arch/nds32/Makefile'.
nd_perf.c:(.text+0x21e): undefined reference to `perf_pmu_migrate_context'
nd_perf.c:(.text+0x434): undefined reference to `perf_pmu_register'
nd_perf.c:(.text+0x57c): undefined reference to `perf_pmu_unregister'
net.c:(.text+0xe2): undefined reference to `ieee80211_hdrlen'
net/core/pktgen.c:1312:4: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/ipv4/tcp_input.c:5012:2: warning: Value stored to 'reason' is never read [clang-analyzer-deadcode.DeadStores]
net/smc/smc_llc.c:787:9: warning: 'memcpy' forming offset [49, 59] is out of the bounds [0, 49] of object 'delllc' with type 'struct smc_llc_msg_del_link' [-Warray-bounds]
{standard input}:1989: Error: unknown pseudo-op: `.sec'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- arch-alpha-include-asm-string.h:warning:__builtin_memcpy-forming-offset-is-out-of-the-bounds-of-object-tag_buf-with-type-unsigned-char
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-iio-frequency-admv1014.c:sparse:sparse:dubious:x-y
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- alpha-allyesconfig
|   |-- arch-alpha-include-asm-string.h:warning:__builtin_memcpy-forming-offset-is-out-of-the-bounds-of-object-tag_buf-with-type-unsigned-char
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-iio-frequency-admv1014.c:sparse:sparse:dubious:x-y
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- alpha-buildonly-randconfig-r003-20220314
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arc-randconfig-c023-20220314
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arc-randconfig-r021-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arc-randconfig-r036-20220313
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arc-randconfig-r043-20220313
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arm-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arm-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arm-buildonly-randconfig-r002-20220314
|   `-- include-linux-fortify-string.h:warning:__builtin_memcpy-offset-is-out-of-the-bounds
|-- arm-defconfig
|   `-- ERROR:dtschema-minimum-version-is-v2022.
|-- arm-randconfig-c002-20220314
|   |-- drm_gem_shmem_helper.c:(.text):undefined-reference-to-vmf_insert_pfn
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- kernel-trace-trace_events_synth.c:warning:strncpy-specified-bound-depends-on-the-length-of-the-source-argument
|-- arm-randconfig-r026-20220314
|   |-- drivers-infiniband-core-user_mad.c:warning:array-subscript-struct-ib_rmpp_mad-is-partly-outside-array-bounds-of-unsigned-char
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- net-smc-smc_llc.c:warning:memcpy-forming-offset-is-out-of-the-bounds-of-object-delllc-with-type-struct-smc_llc_msg_del_link
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arm64-defconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arm64-randconfig-r032-20220314
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- csky-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- csky-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- csky-buildonly-randconfig-r006-20220314
|   |-- clk-imx93.c:(.text):undefined-reference-to-imx_obtain_fixed_clk_hw
|   |-- csky-linux-ld:clk-imx93.c:(.text):undefined-reference-to-clk_hw_register_gate2
|   |-- csky-linux-ld:clk-imx93.c:(.text):undefined-reference-to-imx93_clk_composite_flags
|   |-- csky-linux-ld:clk-imx93.c:(.text):undefined-reference-to-imx_ccm_lock
|   |-- csky-linux-ld:clk-imx93.c:(.text):undefined-reference-to-imx_check_clk_hws
|   |-- csky-linux-ld:clk-imx93.c:(.text):undefined-reference-to-imx_clk_fracn_gppll
|   |-- csky-linux-ld:clk-imx93.c:(.text):undefined-reference-to-imx_fracn_gppll
|   |-- csky-linux-ld:clk-imx93.c:(.text):undefined-reference-to-imx_obtain_fixed_clk_hw
|   `-- csky-linux-ld:clk-imx93.c:(.text):undefined-reference-to-imx_unregister_hw_clocks
|-- csky-randconfig-c023-20220313
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- h8300-allmodconfig
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- h8300-allyesconfig
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-debian-10.3
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-debian-10.3-kselftests
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a001-20220314
|   |-- drivers-net-ethernet-broadcom-bnxt-bnxt_ptp.c:warning:array-subscript-is-above-array-bounds-of-struct-pps_pin
|   `-- net.c:(.text):undefined-reference-to-ieee80211_hdrlen
|-- i386-randconfig-a002-20220314
|   |-- drivers-net-ethernet-broadcom-bnxt-bnxt_ptp.c:warning:array-subscript-is-above-array-bounds-of-struct-pps_pin
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a004-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-c021-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-s001
|   |-- drivers-gpu-drm-gma500-intel_bios.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-unsigned-char-noderef-usertype-__iomem
|   `-- drivers-gpu-drm-gma500-opregion.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-void-noderef-__iomem-assigned-base
|-- i386-randconfig-s002
|   |-- drivers-gpu-drm-gma500-intel_bios.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-unsigned-char-noderef-usertype-__iomem
|   |-- drivers-gpu-drm-gma500-opregion.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-void-noderef-__iomem-assigned-base
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- ia64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- ia64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- ia64-randconfig-r001-20220313
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|-- ia64-randconfig-r001-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-allmodconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-allyesconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-defconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-randconfig-r031-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- microblaze-randconfig-p002-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- microblaze-randconfig-r022-20220314
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|-- mips-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- mips-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- mips-buildonly-randconfig-r004-20220313
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   `-- include-linux-fortify-string.h:warning:__builtin_memcpy-offset-is-out-of-the-bounds
|-- nds32-allmodconfig
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-allnoconfig
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-allyesconfig
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-defconfig
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-randconfig-c004-20220313
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-randconfig-c024-20220313
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-randconfig-r011-20220313
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nds32-randconfig-r013-20220314
|   |-- Makefile:arch-nds32-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-nds32-Kconfig
|   `-- make:No-rule-to-make-target-arch-nds32-Makefile-.
|-- nios2-allmodconfig
|   |-- arch-nios2-kernel-misaligned.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-noderef-__user-to-got-unsigned-char-usertype-__pu_ptr
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- nios2-allyesconfig
|   |-- arch-nios2-kernel-misaligned.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-noderef-__user-to-got-unsigned-char-usertype-__pu_ptr
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- nios2-randconfig-r004-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- nios2-randconfig-r006-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- parisc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- parisc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- parisc-randconfig-r012-20220314
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- parisc64-defconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- powerpc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- powerpc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- powerpc64-randconfig-m031-20220313
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- powerpc64-randconfig-r021-20220313
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- powerpc64-randconfig-r035-20220314
|   `-- drivers-media-platform-samsung-exynos4-is-fimc-isp-video.h:warning:no-previous-prototype-for-fimc_isp_video_device_unregister
|-- powerpc64-randconfig-r036-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- powerpc64-randconfig-s032-20220313
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|-- riscv-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- riscv-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- riscv-randconfig-r042-20220313
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- s390-allmodconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- s390-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- s390-defconfig
|   |-- arch-s390-kernel-machine_kexec.c:warning:memcpy-offset-is-out-of-the-bounds
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- s390-randconfig-r002-20220314
|   |-- ERROR:perf_pmu_migrate_context-drivers-nvdimm-libnvdimm.ko-undefined
|   |-- ERROR:perf_pmu_register-drivers-nvdimm-libnvdimm.ko-undefined
|   |-- ERROR:perf_pmu_unregister-drivers-nvdimm-libnvdimm.ko-undefined
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- s390-randconfig-r044-20220313
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- include-linux-fortify-string.h:warning:__builtin_memcpy-offset-is-out-of-the-bounds
|   |-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_migrate_context
|   |-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_register
|   `-- nd_perf.c:(.text):undefined-reference-to-perf_pmu_unregister
|-- sh-allmodconfig
|   |-- arch-sh-kernel-machvec.c:warning:array-subscript-struct-sh_machine_vector-is-partly-outside-array-bounds-of-long-int
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- standard-input:Error:unknown-pseudo-op:sec
|-- sh-allnoconfig
|   `-- arch-sh-kernel-machvec.c:warning:array-subscript-struct-sh_machine_vector-is-partly-outside-array-bounds-of-long-int
|-- sh-allyesconfig
|   |-- arch-sh-kernel-machvec.c:warning:array-subscript-struct-sh_machine_vector-is-partly-outside-array-bounds-of-long-int
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- standard-input:Error:unknown-pseudo-op:sec
|-- sparc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- sparc64-randconfig-m031-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-iio-frequency-admv1014.c:sparse:sparse:dubious:x-y
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-kexec
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-a006
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-m001-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-rhel-8.3
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-rhel-8.3-func
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-rhel-8.3-kselftests
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-rhel-8.3-kunit
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- xtensa-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- xtensa-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- xtensa-randconfig-r005-20220314
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
`-- xtensa-randconfig-r014-20220314
    |-- drivers-infiniband-core-user_mad.c:warning:array-subscript-struct-ib_rmpp_mad-is-partly-outside-array-bounds-of-unsigned-char
    |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
    `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst

clang_recent_errors
|-- arm-randconfig-c002-20220313
|   |-- drivers-clk-imx-clk-pll14xx.c:warning:Value-stored-to-pll_div_ctl1-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-firmware-turris-mox-rwtm.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-ana
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   |-- drivers-hwmon-nsa320-hwmon.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous
|   |-- drivers-input-serio-ps2-gpio.c:warning:Value-stored-to-rxflags-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-leds-trigger-ledtrig-tty.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-ana
|   |-- drivers-memory-brcmstb_dpfe.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- drivers-memory-tegra-tegra30-emc.c:warning:Value-stored-to-dram_type_str-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-mmc-host-omap_hsmmc.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- drivers-phy-broadcom-phy-brcm-usb.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-an
|   |-- drivers-staging-greybus-arche-apb-ctrl.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-wi
|   |-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|   |-- net-core-pktgen.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-
|   `-- net-ipv4-tcp_input.c:warning:Value-stored-to-reason-is-never-read-clang-analyzer-deadcode.DeadStores
|-- arm-randconfig-r025-20220313
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- arm64-randconfig-r005-20220313
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-function-amdgpu_hdp_ras_fini
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-function-amdgpu_mmhub_ras_fini
|-- hexagon-randconfig-r041-20220313
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- hexagon-randconfig-r045-20220313
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a011-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a012-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a013-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a014-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a015-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a016-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-c001
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   `-- net-ipv4-tcp_input.c:warning:Value-stored-to-reason-is-never-read-clang-analyzer-deadcode.DeadStores
|-- riscv-randconfig-c006-20220310
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:Value-stored-to-res-is-never-read-clang-analyzer-deadcode.DeadStores
|-- riscv-randconfig-c006-20220313
|   |-- drivers-clk-imx-clk-pll14xx.c:warning:Value-stored-to-pll_div_ctl1-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   |-- drivers-phy-broadcom-phy-brcm-usb.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-an
|   |-- drivers-staging-greybus-arche-apb-ctrl.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-wi
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- riscv-randconfig-r042-20220314
|   |-- Section-mismatch-in-reference-from-the-(unknown-reference)-(unknown)-to-the-(unknown-reference)-.debug_str:(unknown)
|   |-- Section-mismatch-in-reference-from-the-function-tcp4_proc_exit()-to-the-function-.init.text:set_reset_devices()
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- s390-randconfig-c005-20220313
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-function-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml-calcs-dce_calcs.c:warning:stack-frame-size-()-exceeds-limit-()-in-calculate_bandwidth
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-function-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-function-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- s390-randconfig-r033-20220313
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-function-amdgpu_hdp_ras_fini
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-function-amdgpu_mmhub_ras_fini
|-- s390-randconfig-r044-20220314
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-function-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml-calcs-dce_calcs.c:warning:stack-frame-size-()-exceeds-limit-()-in-calculate_bandwidth
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-function-amdgpu_hdp_ras_fini
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-function-amdgpu_mmhub_ras_fini
|-- x86_64-randconfig-a001
|   |-- drivers-spi-spi-amd.c:warning:cast-to-smaller-integer-type-enum-amd_spi_versions-from-const-void
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- x86_64-randconfig-a003
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- x86_64-randconfig-a005
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- x86_64-randconfig-a011-20220314
|   |-- drivers-spi-spi-amd.c:warning:cast-to-smaller-integer-type-enum-amd_spi_versions-from-const-void
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- x86_64-randconfig-a012-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- x86_64-randconfig-a013-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   |-- fs-reiserfs-lbalance.o:warning:objtool:leaf_copy_boundary_item():stack-state-mismatch:cfa1-cfa2
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- x86_64-randconfig-a014-20220314
|   |-- drivers-spi-spi-amd.c:warning:cast-to-smaller-integer-type-enum-amd_spi_versions-from-const-void
|   |-- fs-reiserfs-lbalance.o:warning:objtool:leaf_copy_boundary_item():stack-state-mismatch:cfa1-cfa2
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- x86_64-randconfig-a015-20220314
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- x86_64-randconfig-a016-20220314
|   |-- drivers-spi-spi-amd.c:warning:cast-to-smaller-integer-type-enum-amd_spi_versions-from-const-void
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- x86_64-randconfig-c007
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   |-- drivers-pci-vgaarb.c:warning:Value-stored-to-dev-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
|   `-- net-ipv4-tcp_input.c:warning:Value-stored-to-reason-is-never-read-clang-analyzer-deadcode.DeadStores
`-- x86_64-randconfig-r023-20220314
    |-- fs-reiserfs-lbalance.o:warning:objtool:leaf_copy_boundary_item():stack-state-mismatch:cfa1-cfa2
    `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()

elapsed time: 730m

configs tested: 115
configs skipped: 3

gcc tested configs:
arm                                 defconfig
arm                              allmodconfig
arm                              allyesconfig
arm64                               defconfig
arm64                            allyesconfig
um                             i386_defconfig
mips                             allmodconfig
riscv                            allmodconfig
um                           x86_64_defconfig
mips                             allyesconfig
riscv                            allyesconfig
sh                               allmodconfig
xtensa                           allyesconfig
h8300                            allyesconfig
parisc                           allyesconfig
i386                          randconfig-c001
alpha                            allyesconfig
arc                              allyesconfig
nios2                            allyesconfig
arm                      footbridge_defconfig
mips                        vocore2_defconfig
arm                     eseries_pxa_defconfig
powerpc                 mpc834x_itx_defconfig
ia64                         bigsur_defconfig
xtensa                              defconfig
arm                          exynos_defconfig
x86_64                           alldefconfig
arm                           sama5_defconfig
ia64                            zx1_defconfig
arm                  randconfig-c002-20220314
ia64                                defconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                             allyesconfig
m68k                             allmodconfig
m68k                                defconfig
nds32                             allnoconfig
nios2                               defconfig
csky                                defconfig
alpha                               defconfig
nds32                               defconfig
arc                                 defconfig
parisc                              defconfig
parisc64                            defconfig
s390                             allmodconfig
s390                             allyesconfig
s390                                defconfig
i386                             allyesconfig
i386                              debian-10.3
i386                   debian-10.3-kselftests
i386                                defconfig
sparc                            allyesconfig
sparc                               defconfig
powerpc                           allnoconfig
powerpc                          allmodconfig
powerpc                          allyesconfig
x86_64                        randconfig-a006
x86_64                        randconfig-a002
x86_64                        randconfig-a004
i386                 randconfig-a001-20220314
i386                 randconfig-a002-20220314
i386                 randconfig-a004-20220314
i386                 randconfig-a003-20220314
s390                 randconfig-r044-20220313
arc                  randconfig-r043-20220313
riscv                randconfig-r042-20220313
arc                  randconfig-r043-20220314
riscv                             allnoconfig
riscv                               defconfig
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                          rv32_defconfig
x86_64                    rhel-8.3-kselftests
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                                  kexec
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit

clang tested configs:
x86_64                        randconfig-c007
mips                 randconfig-c004-20220313
arm                  randconfig-c002-20220313
i386                          randconfig-c001
powerpc              randconfig-c003-20220313
s390                 randconfig-c005-20220313
riscv                randconfig-c006-20220313
arm                       cns3420vb_defconfig
mips                           ip28_defconfig
arm                            mmp2_defconfig
mips                          ath79_defconfig
arm                           sama7_defconfig
mips                     loongson2k_defconfig
powerpc                 mpc836x_rdk_defconfig
powerpc                     ppa8548_defconfig
arm                      pxa255-idp_defconfig
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
x86_64               randconfig-a011-20220314
x86_64               randconfig-a014-20220314
x86_64               randconfig-a013-20220314
x86_64               randconfig-a012-20220314
x86_64               randconfig-a015-20220314
x86_64               randconfig-a016-20220314
i386                 randconfig-a012-20220314
i386                 randconfig-a011-20220314
i386                 randconfig-a013-20220314
i386                 randconfig-a014-20220314
i386                 randconfig-a015-20220314
i386                 randconfig-a016-20220314
hexagon              randconfig-r045-20220313
hexagon              randconfig-r045-20220314
hexagon              randconfig-r041-20220313
s390                 randconfig-r044-20220314
hexagon              randconfig-r041-20220314
riscv                randconfig-r042-20220314

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
