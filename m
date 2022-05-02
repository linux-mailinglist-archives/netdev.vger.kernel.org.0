Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E08E516A27
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 06:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383270AbiEBEvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 00:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350459AbiEBEvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 00:51:47 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E3E377DF;
        Sun,  1 May 2022 21:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651466897; x=1683002897;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=97avMXbnH1YXWT85FvPWqGF+FH5iwwxYyMC7uastwlg=;
  b=DXqcmhrLUTAm8GUeQhUqE3jDcpfFrhnYHHkcEXTwOq36bL9kXUOCvSBV
   OdA4CJc26wvcg9TaEy5awmsqhQUFClSQYEBh153kBzfDlM1yodQx8kNHF
   uvKHdxn+R47Ozbyt2lWRCqUYZvuqa++K640pMMZP9Wm99/Kn/R8rix37z
   nxkGEb46m1dgaS6rfD2B0HXZJEKEWVIMWdpz7UeDGq/AGIfns7ppypKn9
   2etfUrYOpd+ZM2GBQh+Npyd8z9jU2cjBgITDBDcSt+qbpymzndfjRmk2w
   HLaQAxTxMV4aLEkNcNu+63j6fCGpL00YfEjKKcSI9e+m9mAQ95N4bRubl
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10334"; a="330103191"
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="330103191"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2022 21:48:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,190,1647327600"; 
   d="scan'208";a="619738978"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 01 May 2022 21:48:12 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nlNyl-0009I7-B9;
        Mon, 02 May 2022 04:48:11 +0000
Date:   Mon, 02 May 2022 12:47:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-media@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, io-uring@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        bpf@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 5469f0c06732a077c70a759a81f2a1f00b277694
Message-ID: <626f627a.zXY9JBY/2okMtjFz%lkp@intel.com>
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
branch HEAD: 5469f0c06732a077c70a759a81f2a1f00b277694  Add linux-next specific files for 20220429

Error/Warning reports:

https://lore.kernel.org/linux-mm/202204081656.6x4pfen4-lkp@intel.com
https://lore.kernel.org/linux-mm/202204231818.yVvV3Oxp-lkp@intel.com
https://lore.kernel.org/linux-mm/202204240458.z2cymyl5-lkp@intel.com
https://lore.kernel.org/linux-mm/202204291904.NCK0h7cY-lkp@intel.com
https://lore.kernel.org/linux-mm/202204291924.vTGZmerI-lkp@intel.com
https://lore.kernel.org/linux-mm/202205010833.D736q4OR-lkp@intel.com
https://lore.kernel.org/linux-mm/202205011336.ppUI1qHN-lkp@intel.com
https://lore.kernel.org/lkml/202204300646.B29EmUql-lkp@intel.com
https://lore.kernel.org/llvm/202205020853.CQCkKyFc-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

ERROR: modpost: "omap_set_dma_priority" [drivers/video/fbdev/omap/omapfb.ko] undefined!
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1348:5: warning: no previous prototype for 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/soc21.c:128:6: warning: no previous prototype for 'soc21_grbm_select' [-Wmissing-prototypes]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:276:20: error: call to undeclared function 'sysfs_gt_attribute_r_max_func'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:327:9: error: call to undeclared function 'sysfs_gt_attribute_w_func'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:416:17: error: call to undeclared function 'sysfs_gt_attribute_r_min_func'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/hwmon/nct6775-platform.c:199:9: sparse:    unsigned char
drivers/hwmon/nct6775-platform.c:199:9: sparse:    void
kernel/printk/printk_ringbuffer.h:337:21: warning: array subscript 0 is outside array bounds of 'char[0]' [-Warray-bounds]
omapfb_main.c:(.text+0x41b4): undefined reference to `omap_set_dma_priority'

Unverified Error/Warning (likely false positive, please contact us if interested):

Error: Section .bss not empty in prom_init.c
Makefile:612: arch/h8300/Makefile: No such file or directory
Makefile:684: arch/h8300/Makefile: No such file or directory
Makefile:691: arch/h8300/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
drivers/dma-buf/st-dma-fence-unwrap.c:125:13: warning: variable 'err' set but not used [-Wunused-but-set-variable]
drivers/edac/edac_device.c:79 edac_device_alloc_ctl_info() warn: Please consider using kcalloc instead
drivers/firmware/arm_scmi/clock.c:242:40: warning: Variable 'msg' is not assigned a value. [unassignedVariable]
drivers/firmware/arm_scmi/driver.c:1214 scmi_iterator_run() warn: variable dereferenced before check 'i' (see line 1210)
drivers/firmware/arm_scmi/perf.c:331:40: warning: Variable 'msg' is not assigned a value. [unassignedVariable]
drivers/firmware/arm_scmi/sensors.c:341:48: warning: Variable 'msg' is not assigned a value. [unassignedVariable]
drivers/firmware/arm_scmi/voltage.c:177:39: warning: Variable 'msg' is not assigned a value. [unassignedVariable]
drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1348:5: warning: no previous prototype for function 'amdgpu_discovery_get_mall_info' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/soc21.c:128:6: warning: no previous prototype for function 'soc21_grbm_select' [-Wmissing-prototypes]
drivers/gpu/drm/display/drm_dp_aux_dev.c:251:76: warning: Parameter 'aux' can be declared with const [constParameter]
drivers/gpu/drm/display/drm_dp_aux_dev.c:263:13: warning: Uninitialized variable: iter->aux [uninitvar]
drivers/gpu/drm/display/drm_dp_helper.c:3677:4: warning: Undefined or garbage value returned to caller [clang-analyzer-core.uninitialized.UndefReturn]
drivers/gpu/drm/display/drm_dp_mst_topology.c:5128:34: warning: Parameter 'branch' can be declared with const [constParameter]
drivers/gpu/drm/drm_mipi_dsi.c:307:73: warning: Parameter 'node' can be declared with const [constParameter]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:275:27: error: implicit declaration of function 'sysfs_gt_attribute_r_max_func' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:326:16: error: implicit declaration of function 'sysfs_gt_attribute_w_func' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/gt/intel_gt_sysfs_pm.c:415:24: error: implicit declaration of function 'sysfs_gt_attribute_r_min_func' [-Werror=implicit-function-declaration]
drivers/gpu/drm/i915/gvt/handlers.c:74:6: error: no previous prototype for 'intel_gvt_match_device' [-Werror=missing-prototypes]
drivers/gpu/drm/solomon/ssd130x.c:515:2: warning: Undefined or garbage value returned to caller [clang-analyzer-core.uninitialized.UndefReturn]
drivers/hid/wacom_wac.c:2411:42: warning: format specifies type 'unsigned short' but the argument has type 'int' [-Wformat]
drivers/net/ethernet/mediatek/mtk_wed.c:813:2-8: ERROR: missing put_device; call of_find_device_by_node on line 806, but without a corresponding object release within this function.
kernel/module/main.c:2189:4: warning: Null pointer passed as 1st argument to memory copy function [clang-analyzer-unix.cstring.NullArg]
kernel/module/main.c:924:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
make[1]: *** No rule to make target 'arch/h8300/Makefile'.
mm/page_io.c:261:15: warning: Value stored to 'page' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
mm/sparse-vmemmap.c:740:17: warning: Value stored to 'next' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
net/ipv4/tcp_cong.c:430:32: warning: Division by zero [clang-analyzer-core.DivideZero]
powerpc64-linux-ld: drivers/char/ipmi/ipmi_si_hardcode.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/char/ipmi/ipmi_si_hotmod.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/char/tpm/tpmrm-dev.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/char/tpm/tpm-dev.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/counter/counter-sysfs.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/counter/counter-core.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/dma-buf/st-dma-fence-chain.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/dma-buf/st-dma-fence.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/gpu/drm/arm/display/komeda/komeda_format_caps.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/gpu/drm/arm/display/komeda/komeda_dev.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/gpu/drm/selftests/test-drm_framebuffer.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/gpu/drm/selftests/test-drm_plane_helper.o:(.bss+0x340): first defined here
powerpc64-linux-ld: drivers/i3c/master.o:(.bss+0x80): multiple definition of `____cacheline_aligned'; drivers/i3c/device.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/media/common/siano/sms-cards.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/media/common/siano/smscoreapi.o:(.bss+0x80): first defined here
powerpc64-linux-ld: drivers/media/dvb-core/dvb_demux.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/media/dvb-core/dmxdev.o:(.bss+0x80): first defined here
powerpc64-linux-ld: drivers/media/dvb-frontends/cxd2880/cxd2880_devio_spi.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/media/dvb-frontends/cxd2880/cxd2880_common.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/media/tuners/tda18271-common.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/media/tuners/tda18271-maps.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/mfd/arizona-irq.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/mfd/arizona-core.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/mfd/mt6397-irq.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/mfd/mt6397-core.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/mfd/rsmu_i2c.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/mfd/rsmu_core.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/mmc/core/host.o:(.bss+0x80): multiple definition of `____cacheline_aligned'; drivers/mmc/core/bus.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/net/can/dev/length.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/net/can/dev/bittiming.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/net/can/flexcan/flexcan-ethtool.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/net/can/flexcan/flexcan-core.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/net/can/m_can/tcan4x5x-regmap.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; drivers/net/can/m_can/tcan4x5x-core.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/net/can/spi/mcp251xfd/mcp251xfd-core.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.o:(.bss+0x0): first defined here
powerpc64-linux-ld: drivers/net/ethernet/samsung/sxgbe/sxgbe_desc.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/net/ethernet/samsung/sxgbe/sxgbe_main.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/peci/request.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/peci/core.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/soundwire/master.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; drivers/soundwire/bus.o:(.bss+0x40): first defined here
powerpc64-linux-ld: drivers/staging/ks7010/ks_wlan_net.o:(.bss+0x80): multiple definition of `____cacheline_aligned'; drivers/staging/ks7010/ks_hostif.o:(.bss+0x80): first defined here
powerpc64-linux-ld: fs/autofs/symlink.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; fs/autofs/inode.o:(.bss+0x40): first defined here
powerpc64-linux-ld: lib/crypto/chacha20poly1305-selftest.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; lib/crypto/chacha20poly1305.o:(.bss+0x0): first defined here
powerpc64-linux-ld: lib/crypto/curve25519-generic.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; lib/crypto/curve25519-fiat32.o:(.bss+0x0): first defined here
powerpc64-linux-ld: lib/kunit/string-stream.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; lib/kunit/test.o:(.bss+0x40): first defined here
powerpc64-linux-ld: net/atm/svc.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; net/atm/pvc.o:(.bss+0x0): first defined here
powerpc64-linux-ld: net/ax25/ax25_dev.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; net/ax25/ax25_addr.o:(.bss+0x0): first defined here
powerpc64-linux-ld: net/bluetooth/hci_conn.o:(.bss+0xc0): multiple definition of `____cacheline_aligned'; net/bluetooth/hci_core.o:(.bss+0x140): first defined here
powerpc64-linux-ld: net/caif/cfmuxl.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; net/caif/cfcnfg.o:(.bss+0x40): first defined here
powerpc64-linux-ld: net/llc/llc_conn.o:(.bss+0x180): multiple definition of `____cacheline_aligned'; net/llc/llc_if.o:(.bss+0x0): first defined here
powerpc64-linux-ld: net/rose/rose_loopback.o:(.bss+0x100): multiple definition of `____cacheline_aligned'; net/rose/rose_link.o:(.bss+0x0): first defined here
powerpc64-linux-ld: net/x25/x25_out.o:(.bss+0x0): multiple definition of `____cacheline_aligned'; net/x25/x25_in.o:(.bss+0x0): first defined here
powerpc64-linux-ld: security/keys/trusted-keys/trusted_tpm1.o:(.bss+0x40): multiple definition of `____cacheline_aligned'; security/keys/trusted-keys/trusted_core.o:(.bss+0x40): first defined here

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-short-usertype-beacon_interval-got-restricted-__le16-usertype
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- alpha-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-short-usertype-beacon_interval-got-restricted-__le16-usertype
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- alpha-buildonly-randconfig-r001-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- alpha-buildonly-randconfig-r003-20220428
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- alpha-randconfig-c024-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- alpha-randconfig-r026-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-short-usertype-beacon_interval-got-restricted-__le16-usertype
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- arc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-short-usertype-beacon_interval-got-restricted-__le16-usertype
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- arc-buildonly-randconfig-r002-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arc-randconfig-r043-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arc-randconfig-r043-20220429
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arc-randconfig-s031-20220429
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- arm-allmodconfig
|   |-- ERROR:omap_set_dma_priority-drivers-video-fbdev-omap-omapfb.ko-undefined
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arm-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   `-- omapfb_main.c:(.text):undefined-reference-to-omap_set_dma_priority
|-- arm-randconfig-c002-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arm64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arm64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- arm64-randconfig-c004-20220428
|   `-- drivers-net-ethernet-mediatek-mtk_wed.c:ERROR:missing-put_device-call-of_find_device_by_node-on-line-but-without-a-corresponding-object-release-within-this-function.
|-- arm64-randconfig-m031-20220429
|   `-- drivers-firmware-arm_scmi-driver.c-scmi_iterator_run()-warn:variable-dereferenced-before-check-i-(see-line-)
|-- csky-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- csky-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- h8300-alldefconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-allmodconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-allyesconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-buildonly-randconfig-r001-20220428
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-buildonly-randconfig-r006-20220428
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r024-20220428
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-randconfig-r033-20220429
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|-- i386-randconfig-m021
|   `-- drivers-edac-edac_device.c-edac_device_alloc_ctl_info()-warn:Please-consider-using-kcalloc-instead
|-- i386-randconfig-s001
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_max_func
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_min_func
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_w_func
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- ia64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- ia64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- m68k-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-short-usertype-beacon_interval-got-restricted-__le16-usertype
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_kptr_xchg_proto-was-not-declared.-Should-it-be-static
|-- m68k-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-hwmon-nct6775-platform.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-hwmon-nct6775-platform.c:sparse:unsigned-char
|   |-- drivers-hwmon-nct6775-platform.c:sparse:void
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-short-usertype-beacon_interval-got-restricted-__le16-usertype
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_kptr_xchg_proto-was-not-declared.-Should-it-be-static
|-- m68k-randconfig-r021-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- m68k-randconfig-r036-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- microblaze-randconfig-p002-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- mips-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-short-usertype-beacon_interval-got-restricted-__le16-usertype
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-mem-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_kptr_xchg_proto-was-not-declared.-Should-it-be-static
|-- mips-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-short-usertype-beacon_interval-got-restricted-__le16-usertype
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-mem-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_kptr_xchg_proto-was-not-declared.-Should-it-be-static
|-- mips-randconfig-p001-20220428
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-firmware-arm_scmi-clock.c:warning:Variable-msg-is-not-assigned-a-value.-unassignedVariable
|   |-- drivers-firmware-arm_scmi-perf.c:warning:Variable-msg-is-not-assigned-a-value.-unassignedVariable
|   |-- drivers-firmware-arm_scmi-sensors.c:warning:Variable-msg-is-not-assigned-a-value.-unassignedVariable
|   `-- drivers-firmware-arm_scmi-voltage.c:warning:Variable-msg-is-not-assigned-a-value.-unassignedVariable
|-- mips-randconfig-r025-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- mips-randconfig-r036-20220429
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- nios2-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-short-usertype-beacon_interval-got-restricted-__le16-usertype
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- nios2-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-short-usertype-beacon_interval-got-restricted-__le16-usertype
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- openrisc-allyesconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- openrisc-randconfig-r001-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- openrisc-randconfig-r022-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- parisc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- parisc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- parisc-randconfig-r011-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- powerpc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-short-usertype-beacon_interval-got-restricted-__le16-usertype
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_kptr_xchg_proto-was-not-declared.-Should-it-be-static
|-- powerpc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:cast-to-restricted-__le16
|   |-- drivers-net-wireless-purelifi-plfxlc-chip.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-short-usertype-beacon_interval-got-restricted-__le16-usertype
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_kptr_xchg_proto-was-not-declared.-Should-it-be-static
|-- powerpc64-randconfig-p001-20220429
|   |-- Error:Section-.bss-not-empty-in-prom_init.c
|   |-- multiple-definition-of-____cacheline_aligned-drivers-char-ipmi-ipmi_si_hotmod.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-char-tpm-tpm-dev.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-counter-counter-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-dma-buf-st-dma-fence.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-gpu-drm-arm-display-komeda-komeda_dev.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-gpu-drm-selftests-test-drm_plane_helper.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-i3c-device.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-media-common-siano-smscoreapi.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-media-dvb-core-dmxdev.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-media-dvb-frontends-cxd2880-cxd2880_common.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-media-tuners-tda18271-maps.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mfd-arizona-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mfd-mt6397-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mfd-rsmu_core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-mmc-core-bus.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-net-can-dev-bittiming.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-net-can-flexcan-flexcan-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-net-can-m_can-tcan4x5x-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-net-can-spi-mcp251xfd-mcp251xfd-chip-fifo.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-net-ethernet-samsung-sxgbe-sxgbe_main.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-peci-core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-soundwire-bus.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-drivers-staging-ks7010-ks_hostif.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-fs-autofs-inode.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-lib-crypto-chacha20poly1305.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-lib-crypto-curve25519-fiat32.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-lib-kunit-test.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-atm-pvc.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-ax25-ax25_addr.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-bluetooth-hci_core.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-caif-cfcnfg.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-llc-llc_if.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-rose-rose_link.o:(.bss):first-defined-here
|   |-- multiple-definition-of-____cacheline_aligned-net-x25-x25_in.o:(.bss):first-defined-here
|   `-- multiple-definition-of-____cacheline_aligned-security-keys-trusted-keys-trusted_core.o:(.bss):first-defined-here
|-- riscv-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- riscv-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- riscv-randconfig-c004-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- riscv-randconfig-r042-20220429
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- s390-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_kptr_xchg_proto-was-not-declared.-Should-it-be-static
|-- s390-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_kptr_xchg_proto-was-not-declared.-Should-it-be-static
|-- s390-randconfig-r003-20220428
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- kernel-printk-printk_ringbuffer.h:warning:array-subscript-is-outside-array-bounds-of-char
|-- s390-randconfig-r044-20220429
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sh-allmodconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sh-allyesconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sh-randconfig-r031-20220429
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sparc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- sparc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- sparc-randconfig-r005-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sparc-randconfig-r033-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sparc-randconfig-r035-20220428
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sparc64-randconfig-p001-20220428
|   |-- drivers-gpu-drm-display-drm_dp_aux_dev.c:warning:Parameter-aux-can-be-declared-with-const-constParameter
|   |-- drivers-gpu-drm-display-drm_dp_aux_dev.c:warning:Uninitialized-variable:iter-aux-uninitvar
|   |-- drivers-gpu-drm-display-drm_dp_mst_topology.c:warning:Parameter-branch-can-be-declared-with-const-constParameter
|   `-- drivers-gpu-drm-drm_mipi_dsi.c:warning:Parameter-node-can-be-declared-with-const-constParameter
|-- um-i386_defconfig
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- um-x86_64_defconfig
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- x86_64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
|-- x86_64-randconfig-a011
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_max_func
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_min_func
|   `-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_w_func
|-- x86_64-randconfig-c002
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_max_func
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_r_min_func
|   `-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:implicit-declaration-of-function-sysfs_gt_attribute_w_func
|-- x86_64-randconfig-m001
|   `-- drivers-edac-edac_device.c-edac_device_alloc_ctl_info()-warn:Please-consider-using-kcalloc-instead
|-- x86_64-randconfig-s021
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- x86_64-randconfig-s022
|   `-- kernel-bpf-helpers.c:sparse:sparse:symbol-bpf_kptr_xchg_proto-was-not-declared.-Should-it-be-static
|-- x86_64-rhel-8.3-kselftests
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- x86_64-rhel-8.3-syz
|   `-- drivers-gpu-drm-i915-gvt-handlers.c:error:no-previous-prototype-for-intel_gvt_match_device
|-- xtensa-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select
`-- xtensa-allyesconfig
    |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-amdgpu_discovery_get_mall_info
    `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-soc21_grbm_select

clang_recent_errors
|-- arm-randconfig-c002-20220428
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-function-amdgpu_discovery_get_mall_info
|   |-- drivers-gpu-drm-display-drm_dp_helper.c:warning:Undefined-or-garbage-value-returned-to-caller-clang-analyzer-core.uninitialized.UndefReturn
|   `-- drivers-gpu-drm-solomon-ssd13.c:warning:Undefined-or-garbage-value-returned-to-caller-clang-analyzer-core.uninitialized.UndefReturn
|-- hexagon-randconfig-r041-20220428
|   `-- drivers-hid-wacom_wac.c:warning:format-specifies-type-unsigned-short-but-the-argument-has-type-int
|-- i386-allmodconfig
|   `-- drivers-hid-wacom_wac.c:warning:format-specifies-type-unsigned-short-but-the-argument-has-type-int
|-- i386-randconfig-a013-20220502
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:call-to-undeclared-function-sysfs_gt_attribute_r_max_func-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   |-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:call-to-undeclared-function-sysfs_gt_attribute_r_min_func-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- drivers-gpu-drm-i915-gt-intel_gt_sysfs_pm.c:error:call-to-undeclared-function-sysfs_gt_attribute_w_func-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-randconfig-a015
|   `-- drivers-hid-wacom_wac.c:warning:format-specifies-type-unsigned-short-but-the-argument-has-type-int
|-- i386-randconfig-c001
|   |-- kernel-module-main.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functio
|   |-- kernel-module-main.c:warning:Null-pointer-passed-as-1st-argument-to-memory-copy-function-clang-analyzer-unix.cstring.NullArg
|   `-- net-ipv4-tcp_cong.c:warning:Division-by-zero-clang-analyzer-core.DivideZero
|-- riscv-buildonly-randconfig-r005-20220428
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_discovery.c:warning:no-previous-prototype-for-function-amdgpu_discovery_get_mall_info
|   `-- drivers-gpu-drm-amd-amdgpu-soc21.c:warning:no-previous-prototype-for-function-soc21_grbm_select
|-- riscv-randconfig-c006-20220501
|   `-- mm-page_io.c:warning:Value-stored-to-page-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
|-- x86_64-randconfig-a003
|   `-- drivers-hid-wacom_wac.c:warning:format-specifies-type-unsigned-short-but-the-argument-has-type-int
|-- x86_64-randconfig-a014
|   `-- drivers-hid-wacom_wac.c:warning:format-specifies-type-unsigned-short-but-the-argument-has-type-int
|-- x86_64-randconfig-a016
|   `-- drivers-hid-wacom_wac.c:warning:format-specifies-type-unsigned-short-but-the-argument-has-type-int
`-- x86_64-randconfig-c007
    |-- kernel-module-main.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functio
    |-- kernel-module-main.c:warning:Null-pointer-passed-as-1st-argument-to-memory-copy-function-clang-analyzer-unix.cstring.NullArg
    |-- mm-sparse-vmemmap.c:warning:Value-stored-to-next-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
    `-- net-ipv4-tcp_cong.c:warning:Division-by-zero-clang-analyzer-core.DivideZero

elapsed time: 4104m

configs tested: 133
configs skipped: 3

gcc tested configs:
arm64                               defconfig
arm                              allmodconfig
arm                              allyesconfig
arm                                 defconfig
arm64                            allyesconfig
mips                             allyesconfig
riscv                            allyesconfig
um                           x86_64_defconfig
riscv                            allmodconfig
um                             i386_defconfig
mips                             allmodconfig
powerpc                          allmodconfig
m68k                             allyesconfig
s390                             allmodconfig
m68k                             allmodconfig
powerpc                          allyesconfig
s390                             allyesconfig
sparc                            allyesconfig
parisc                           allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
arc                              allyesconfig
alpha                            allyesconfig
nios2                            allyesconfig
i386                          randconfig-c001
powerpc                     tqm8541_defconfig
sh                          lboxre2_defconfig
powerpc                 mpc837x_rdb_defconfig
arc                        nsim_700_defconfig
sh                           se7206_defconfig
m68k                         amcore_defconfig
mips                  decstation_64_defconfig
arm                            zeus_defconfig
powerpc                   currituck_defconfig
m68k                       m5208evb_defconfig
xtensa                       common_defconfig
arc                              alldefconfig
sparc                       sparc64_defconfig
powerpc                     pq2fads_defconfig
microblaze                          defconfig
arm                        multi_v7_defconfig
sh                ecovec24-romimage_defconfig
powerpc                      ppc6xx_defconfig
sh                            hp6xx_defconfig
arc                      axs103_smp_defconfig
sparc64                             defconfig
powerpc                 mpc837x_mds_defconfig
arc                         haps_hs_defconfig
sh                          rsk7264_defconfig
x86_64                        randconfig-c001
arm                  randconfig-c002-20220428
ia64                                defconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                                defconfig
alpha                               defconfig
csky                                defconfig
arc                                 defconfig
parisc                              defconfig
s390                                defconfig
parisc64                            defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
i386                             allyesconfig
sparc                               defconfig
nios2                               defconfig
powerpc                           allnoconfig
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
riscv                randconfig-r042-20220429
arc                  randconfig-r043-20220429
arc                  randconfig-r043-20220428
s390                 randconfig-r044-20220429
riscv                             allnoconfig
riscv                    nommu_k210_defconfig
riscv                          rv32_defconfig
riscv                    nommu_virt_defconfig
riscv                               defconfig
x86_64                    rhel-8.3-kselftests
x86_64                              defconfig
x86_64                           allyesconfig
x86_64                                  kexec
x86_64                           rhel-8.3-syz
x86_64                          rhel-8.3-func
x86_64                               rhel-8.3
x86_64                         rhel-8.3-kunit

clang tested configs:
mips                 randconfig-c004-20220428
x86_64                        randconfig-c007
arm                  randconfig-c002-20220428
riscv                randconfig-c006-20220428
i386                          randconfig-c001
powerpc              randconfig-c003-20220428
s390                 randconfig-c005-20220428
arm                       aspeed_g4_defconfig
arm                       spear13xx_defconfig
arm                         shannon_defconfig
mips                   sb1250_swarm_defconfig
powerpc                  mpc885_ads_defconfig
arm                         socfpga_defconfig
arm                       cns3420vb_defconfig
arm                          moxart_defconfig
mips                           mtx1_defconfig
arm                             mxs_defconfig
riscv                          rv32_defconfig
mips                     cu1000-neo_defconfig
mips                      bmips_stb_defconfig
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
i386                          randconfig-a002
i386                          randconfig-a004
i386                          randconfig-a006
x86_64                        randconfig-a016
x86_64                        randconfig-a012
x86_64                        randconfig-a014
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
hexagon              randconfig-r045-20220429
riscv                randconfig-r042-20220428
s390                 randconfig-r044-20220428
hexagon              randconfig-r045-20220428
hexagon              randconfig-r041-20220429
hexagon              randconfig-r041-20220428

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
