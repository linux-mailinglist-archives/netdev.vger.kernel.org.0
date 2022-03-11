Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A6C4D5766
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 02:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345390AbiCKBe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 20:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345378AbiCKBeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 20:34:23 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0280D14A23C;
        Thu, 10 Mar 2022 17:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646962399; x=1678498399;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=/0AchJsSPcyXXLGbm88A0Nr737QnqNGNSn0+6AZ3Qq0=;
  b=CHDY/clLWjDlTh72r6kRGUYXJHfdScivBr4VuM499OHVW5vM3rKIW+io
   SIP6sUXth45VOjCIXpNUA0Uoify4k6CyG2ELz6VaHlS4ExH1QuQvbPhcU
   ZJaLBtxZcrRHfCFnyrUMuNW6f0762jgDZyfsye2ELVFTVEvUzXDED2gBE
   xsWcELr/MV9VjZJNyFtwq+hqeMNHudBd2v0gKUgo2sjT8ac+SVoW89DH8
   82Opx9ANv5s9Ll7nykYbhBxEEkw5BdDRIF/VVk6LZuWRI/iUN6L+v/Ls2
   Z2v6d+XcegogDjQo9bcVyQh3nhBCCW1GTgBwckdRlZlAYQMNNBJJKEtt/
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="341893617"
X-IronPort-AV: E=Sophos;i="5.90,172,1643702400"; 
   d="scan'208";a="341893617"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 17:33:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,172,1643702400"; 
   d="scan'208";a="496575546"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 10 Mar 2022 17:33:12 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSU9X-0005f4-Ux; Fri, 11 Mar 2022 01:33:11 +0000
Date:   Fri, 11 Mar 2022 09:32:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-alpha@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 71941773e143369a73c9c4a3b62fbb60736a1182
Message-ID: <622aa69f.XI8McBWG4GX/YDab%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 71941773e143369a73c9c4a3b62fbb60736a1182  Add linux-next specific files for 20220310

Error/Warning reports:

https://lore.kernel.org/linux-doc/202202240704.pQD40A9L-lkp@intel.com
https://lore.kernel.org/linux-doc/202202240705.t3QbMnlt-lkp@intel.com
https://lore.kernel.org/linux-mm/202202110552.DxobMxL7-lkp@intel.com
https://lore.kernel.org/llvm/202202141809.zCYU3Uhb-lkp@intel.com
https://lore.kernel.org/llvm/202202241039.g8GKEE4O-lkp@intel.com
https://lore.kernel.org/llvm/202203020913.I6LbmH7l-lkp@intel.com
https://lore.kernel.org/llvm/202203032008.iQvFvs6z-lkp@intel.com

Error/Warning:

arch/arm/kernel/ftrace.c:229:6: warning: no previous prototype for function 'prepare_ftrace_return' [-Wmissing-prototypes]
arch/arm/mach-iop32x/cp6.c:10:6: warning: no previous prototype for 'iop_enable_cp6' [-Wmissing-prototypes]
arch/arm/mach-iop32x/cp6.c:10:6: warning: no previous prototype for function 'iop_enable_cp6' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/amdgpu_mmhub.c:27:6: warning: no previous prototype for function 'amdgpu_mmhub_ras_fini' [-Wmissing-prototypes]
drivers/spi/spi-amd.c:296:21: warning: cast to smaller integer type 'enum amd_spi_versions' from 'const void *' [-Wvoid-pointer-to-enum-cast]
fs/btrfs/ordered-data.c:168: warning: expecting prototype for Add an ordered extent to the per(). Prototype was for btrfs_add_ordered_extent() instead
fs/btrfs/tree-log.c:6934: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Unverified Error/Warning (likely false positive, please contact us if interested):

arch/alpha/include/asm/string.h:22:16: warning: '__builtin_memcpy' forming offset [40, 2051] is out of the bounds [0, 40] of object 'tag_buf' with type 'unsigned char[40]' [-Warray-bounds]
arch/arm/crypto/poly1305-glue.c:192:3: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
arch/arm/crypto/poly1305-glue.c:91:3: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
arch/arm/mm/proc-v7-bugs.c:177: undefined reference to `spectre_v2_update_state'
arch/riscv/kernel/ptrace.c:62:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
arch/s390/kernel/machine_kexec.c:57:9: warning: 'memcpy' offset [0, 511] is out of the bounds [0, 0] [-Warray-bounds]
arch/sh/kernel/machvec.c:105:33: warning: array subscript 'struct sh_machine_vector[0]' is partly outside array bounds of 'long int[1]' [-Warray-bounds]
block/bfq-cgroup.c:1069:6: warning: Call to function 'sscanf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sscanf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
block/blk-iocost.c:3060:8: warning: Call to function 'sscanf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sscanf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
block/blk-iocost.c:922:3: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
clang-15: error: linker command failed with exit code 1 (use -v to see invocation)
drivers/bluetooth/bfusb.c:472:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/crypto/atmel-ecc.c:124:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_resource.c:1633:6: warning: no previous prototype for 'is_timing_changed' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_resource.c:1633:6: warning: no previous prototype for function 'is_timing_changed' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/../display/dc/dml/calcs/dce_calcs.c:77:13: warning: stack frame size (5496) exceeds limit (1024) in 'calculate_bandwidth' [-Wframe-larger-than]
drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c:210 amdgpu_ctx_init_entity() warn: missing error code 'r'
drivers/gpu/drm/amd/amdgpu/amdgpu_hdp.c:27:6: warning: no previous prototype for 'amdgpu_hdp_ras_fini' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/amdgpu_hdp.c:27:6: warning: no previous prototype for function 'amdgpu_hdp_ras_fini' [-Wmissing-prototypes]
drivers/gpu/drm/amd/amdgpu/amdgpu_mmhub.c:27:6: warning: no previous prototype for 'amdgpu_mmhub_ras_fini' [-Wmissing-prototypes]
drivers/hid/hid-core.c:1665:30: warning: Although the value stored to 'field' is used in the enclosing expression, the value is never actually read from 'field' [clang-analyzer-deadcode.DeadStores]
drivers/hid/usbhid/usbkbd.c:143:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/hid/usbhid/usbkbd.c:306:3: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/i2c/busses/i2c-cp2615.c:301:2: warning: Call to function 'strncpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'strncpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/i2c/busses/i2c-cp2615.c:92:3: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/iio/adc/ad7192.c:436:9: warning: Call to function 'sprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/iio/adc/ti-ads8688.c:123:9: warning: Call to function 'sprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/iio/common/ssp_sensors/ssp_iio.c:83:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/iio/common/ssp_sensors/ssp_spi.c:99:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/iio/frequency/admv1014.c:703:22: sparse: sparse: dubious: x & !y
drivers/infiniband/core/cma.c:1436:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/infiniband/core/cma.c:623:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/infiniband/core/ucma.c:234:3: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/infiniband/core/ucma.c:837:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/input/joystick/iforce/iforce-usb.c:50:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/input/joystick/xpad.c:1465:2: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/input/joystick/xpad.c:999:3: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/input/misc/keyspan_remote.c:132:3: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/input/misc/keyspan_remote.c:194:4: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/input/serio/ps2-gpio.c:223:4: warning: Value stored to 'rxflags' is never read [clang-analyzer-deadcode.DeadStores]
drivers/input/touchscreen/usbtouchscreen.c:1435:4: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/input/touchscreen/usbtouchscreen.c:1717:3: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/media/dvb-frontends/mb86a20s.c:2067:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/media/dvb-frontends/mb86a20s.c:738:3: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/media/tuners/it913x.c:402:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/media/tuners/it913x.c:429:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/mmc/host/sdhci-s3c.c:512:3: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/mmc/host/sdhci-s3c.c:537:3: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:347:43: warning: array subscript 255 is above array bounds of 'struct pps_pin[4]' [-Warray-bounds]
drivers/net/ethernet/intel/ice/ice_switch.c:5594:23: warning: array subscript 'struct ice_aqc_sw_rules_elem[0]' is partly outside array bounds of 'unsigned char[16]' [-Warray-bounds]
drivers/net/vxlan/vxlan_core.c:440:34: sparse: sparse: incorrect type in argument 2 (different base types)
drivers/nvmem/sunplus-ocotp.c:74:29: sparse: sparse: symbol 'sp_otp_v0' was not declared. Should it be static?
drivers/regulator/da9055-regulator.c:436:3: warning: Call to function 'sprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/spi/spi-dw-dma.c:274:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/staging/greybus/light.c:556:2: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/tty/serial/sunplus-uart.c:501:26: sparse: sparse: symbol 'sunplus_console_ports' was not declared. Should it be static?
drivers/usb/c67x00/c67x00-hcd.c:216:3: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/function/f_printer.c:1010:4: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/function/f_printer.c:1271:11: warning: Call to function 'sprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/function/f_tcm.c:1084:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/function/f_tcm.c:1126:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/function/f_tcm.c:1472:2: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/function/f_tcm.c:1488:9: warning: Call to function 'sprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/dummy_hcd.c:2068:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/dummy_hcd.c:728:3: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/m66592-udc.c:1603:3: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/r8a66597-udc.c:1880:3: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/snps_udc_core.c:1154:6: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/snps_udc_core.c:2763:3: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/snps_udc_core.c:3146:2: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/udc-xilinx.c:1311:4: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/udc-xilinx.c:502:4: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/host/max3421-hcd.c:354:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/video/fbdev/efifb.c:323:1: warning: Call to function 'sprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
fs/crypto/inline_crypt.c:221:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
include/linux/fortify-string.h:336:4: warning: call to __read_overflow2_field declared with 'warning' attribute: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
kernel/seccomp.c:1321 __secure_computing() warn: ignoring unreachable code.
lib/test_firmware.c:1044:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
lib/test_firmware.c:310:8: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
lib/test_stackinit.c:374:1: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
lib/test_stackinit.c:374:1: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bluetooth/6lowpan.c:162:3: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bluetooth/6lowpan.c:443:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bluetooth/6lowpan.c:960:6: warning: Call to function 'sscanf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sscanf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bluetooth/a2mp.c:37:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bluetooth/a2mp.c:57:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bluetooth/amp.c:196:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bluetooth/amp.c:279:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bluetooth/bnep/core.c:134:4: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bluetooth/bnep/core.c:180:4: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bluetooth/hidp/core.c:212:3: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bluetooth/hidp/core.c:75:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bluetooth/hidp/core.c:785:2: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bridge/netfilter/ebtables.c:732:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/bridge/netfilter/ebtables.c:994:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/ipv4/cipso_ipv4.c:1731:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/ipv4/cipso_ipv4.c:1872:2: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/ipv4/cipso_ipv4.c:2006:3: warning: Call to function 'memmove' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memmove_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/ipv4/tcp_input.c:5012:2: warning: Value stored to 'reason' is never read [clang-analyzer-deadcode.DeadStores]
net/ipv6/calipso.c:1336:3: warning: Call to function 'memmove' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memmove_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/ipv6/calipso.c:703:4: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
net/ipv6/calipso.c:933:3: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/smack/smack_access.c:472:2: warning: Call to function 'strncpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'strncpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/smack/smackfs.c:1186:7: warning: Call to function 'sscanf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sscanf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/smack/smackfs.c:1579:2: warning: Call to function 'sprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/smack/smackfs.c:887:8: warning: Call to function 'sscanf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sscanf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/smack/smackfs.c:905:2: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/audit.c:290:2: warning: Call to function 'vsnprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'vsnprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/audit.c:38:8: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/audit.c:41:3: warning: Call to function 'memmove' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memmove_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/common.c:202:2: warning: Call to function 'vsnprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'vsnprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/common.c:2034:2: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/common.c:2623:3: warning: Call to function 'memmove' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memmove_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/common.c:510:3: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/common.c:582:3: warning: Call to function 'sscanf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sscanf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/condition.c:123:3: warning: Call to function 'memset' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memset_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/domain.c:484:3: warning: Call to function 'memmove' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memmove_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/domain.c:567:3: warning: Call to function 'memcpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memcpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/domain.c:787:4: warning: Call to function 'strncpy' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'strncpy_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/domain.c:795:4: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/network.c:71:4: warning: Call to function 'memmove' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memmove_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/network.c:93:2: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/realpath.c:172:4: warning: Call to function 'memmove' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'memmove_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
security/tomoyo/realpath.c:196:3: warning: Call to function 'snprintf' is insecure as it does not provide security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'snprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
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
|-- alpha-randconfig-r025-20220310
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|-- alpha-randconfig-r034-20220310
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
|-- arc-buildonly-randconfig-r002-20220310
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
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
|-- arm-buildonly-randconfig-r003-20220310
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arm-iop32x_defconfig
|   `-- arch-arm-mach-iop32x-cp6.c:warning:no-previous-prototype-for-iop_enable_cp6
|-- arm-randconfig-r022-20220310
|   `-- arch-arm-mm-proc-v7-bugs.c:undefined-reference-to-spectre_v2_update_state
|-- arm64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arm64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- arm64-defconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- csky-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- csky-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- h8300-allmodconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- h8300-allyesconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-gpu-drm-gma500-intel_bios.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-unsigned-char-noderef-usertype-__iomem
|   |-- drivers-gpu-drm-gma500-opregion.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-void-noderef-__iomem-assigned-base
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-gpu-drm-gma500-intel_bios.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-unsigned-char-noderef-usertype-__iomem
|   |-- drivers-gpu-drm-gma500-opregion.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-void-noderef-__iomem-assigned-base
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-debian-10.3
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-debian-10.3-kselftests
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a003
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a005
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a014
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a016
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-c021
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
|   |-- drivers-iio-frequency-admv1014.c:sparse:sparse:dubious:x-y
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-scsi-hisi_sas-hisi_sas_v3_hw.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- ia64-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-iio-frequency-admv1014.c:sparse:sparse:dubious:x-y
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-scsi-hisi_sas-hisi_sas_v3_hw.c:sparse:sparse:restricted-__le32-degrades-to-integer
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- ia64-randconfig-r035-20220310
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- ia64-randconfig-r036-20220310
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|-- m68k-allmodconfig
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-allyesconfig
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-defconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- m68k-mvme147_defconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- microblaze-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- microblaze-randconfig-p002-20220310
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- microblaze-randconfig-r011-20220310
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|-- microblaze-randconfig-s031-20220310
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
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
|-- mips-randconfig-r014-20220310
|   `-- drivers-net-ethernet-broadcom-bnxt-bnxt_ptp.c:warning:array-subscript-is-above-array-bounds-of-struct-pps_pin
|-- mips-randconfig-r023-20220310
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
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
|-- parisc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- parisc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- parisc-generic-64bit_defconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- parisc-randconfig-m031-20220310
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_ctx.c-amdgpu_ctx_init_entity()-warn:missing-error-code-r
|-- parisc-randconfig-r021-20220310
|   `-- drivers-net-ethernet-intel-ice-ice_switch.c:warning:array-subscript-struct-ice_aqc_sw_rules_elem-is-partly-outside-array-bounds-of-unsigned-char
|-- parisc64-defconfig
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- powerpc-allmodconfig
|   |-- arch-powerpc-platforms-powermac-nvram.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-unsigned-char-noderef-usertype-__iomem-base
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- powerpc-allyesconfig
|   |-- arch-powerpc-platforms-powermac-nvram.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-const-p-got-unsigned-char-noderef-usertype-__iomem-base
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
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
|-- riscv-randconfig-r001-20220310
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- s390-allmodconfig
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- s390-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-iio-frequency-admv1014.c:sparse:sparse:dubious:x-y
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-nvmem-sunplus-ocotp.c:sparse:sparse:symbol-sp_otp_v0-was-not-declared.-Should-it-be-static
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- s390-defconfig
|   |-- arch-s390-kernel-machine_kexec.c:warning:memcpy-offset-is-out-of-the-bounds
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- s390-randconfig-r005-20220310
|   |-- arch-s390-kernel-machine_kexec.c:warning:memcpy-offset-is-out-of-the-bounds
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- sh-allmodconfig
|   |-- arch-sh-kernel-machvec.c:warning:array-subscript-struct-sh_machine_vector-is-partly-outside-array-bounds-of-long-int
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- standard-input:Error:unknown-pseudo-op:sec
|-- sh-allyesconfig
|   |-- arch-sh-kernel-machvec.c:warning:array-subscript-struct-sh_machine_vector-is-partly-outside-array-bounds-of-long-int
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- standard-input:Error:unknown-pseudo-op:sec
|-- sparc-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- sparc-allyesconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- sparc64-randconfig-r032-20220310
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- drivers-iio-frequency-admv1014.c:sparse:sparse:dubious:x-y
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- drivers-tty-serial-sunplus-uart.c:sparse:sparse:symbol-sunplus_console_ports-was-not-declared.-Should-it-be-static
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
|-- x86_64-randconfig-a011
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-a015
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-randconfig-m001
|   `-- kernel-seccomp.c-__secure_computing()-warn:ignoring-unreachable-code.
|-- x86_64-rhel-8.3
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-rhel-8.3-func
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- x86_64-rhel-8.3-kselftests
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- kernel-seccomp.c-__secure_computing()-warn:ignoring-unreachable-code.
|-- x86_64-rhel-8.3-kunit
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- xtensa-allmodconfig
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
`-- xtensa-allyesconfig
    |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-is_timing_changed
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-amdgpu_hdp_ras_fini
    |-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-amdgpu_mmhub_ras_fini
    |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
    `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst

clang_recent_errors
|-- arm-bcm2835_defconfig
|   `-- arch-arm-kernel-ftrace.c:warning:no-previous-prototype-for-function-prepare_ftrace_return
|-- arm-randconfig-c002-20220310
|   |-- arch-arm-crypto-poly1305-glue.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-
|   |-- arch-arm-crypto-poly1305-glue.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-
|   |-- drivers-bluetooth-bfusb.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argume
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   |-- drivers-i2c-busses-i2c-cp2615.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-
|   |-- drivers-i2c-busses-i2c-cp2615.c:warning:Call-to-function-strncpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length
|   |-- drivers-infiniband-core-cma.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-ar
|   |-- drivers-infiniband-core-cma.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-ar
|   |-- drivers-infiniband-core-ucma.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-a
|   |-- drivers-infiniband-core-ucma.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-a
|   |-- drivers-input-serio-ps2-gpio.c:warning:Value-stored-to-rxflags-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-input-touchscreen-usbtouchscreen.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-supp
|   |-- drivers-input-touchscreen-usbtouchscreen.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-su
|   |-- drivers-media-dvb-frontends-mb86a20s.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-
|   |-- drivers-media-dvb-frontends-mb86a20s.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-
|   |-- drivers-media-tuners-it913x.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-ar
|   |-- drivers-media-tuners-it913x.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-ar
|   |-- drivers-mmc-host-sdhci-s3c.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arg
|   |-- drivers-mmc-host-sdhci-s3c.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-a
|   |-- drivers-staging-greybus-light.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-lengt
|   |-- drivers-video-fbdev-efifb.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arg
|   |-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|   |-- net-bluetooth-6lowpan.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argument
|   |-- net-bluetooth-6lowpan.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argument
|   |-- net-bluetooth-6lowpan.c:warning:Call-to-function-sscanf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argument
|   |-- net-bluetooth-a2mp.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-o
|   |-- net-bluetooth-a2mp.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-o
|   |-- net-bluetooth-amp.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-or
|   |-- net-bluetooth-amp.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-or
|   |-- net-bluetooth-bnep-core.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argume
|   |-- net-bluetooth-bnep-core.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argume
|   |-- net-bluetooth-hidp-core.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argume
|   |-- net-bluetooth-hidp-core.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argume
|   |-- net-bluetooth-hidp-core.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argu
|   |-- net-bridge-netfilter-ebtables.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-
|   |-- net-bridge-netfilter-ebtables.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-
|   |-- net-ipv4-cipso_ipv4.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-
|   |-- net-ipv4-cipso_ipv4.c:warning:Call-to-function-memmove-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments
|   |-- net-ipv4-cipso_ipv4.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-
|   |-- net-ipv4-tcp_input.c:warning:Value-stored-to-reason-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- net-ipv6-calipso.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-or-
|   |-- net-ipv6-calipso.c:warning:Call-to-function-memmove-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-or
|   |-- net-ipv6-calipso.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-or-
|   |-- security-smack-smack_access.c:warning:Call-to-function-strncpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-a
|   |-- security-smack-smackfs.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argumen
|   |-- security-smack-smackfs.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argume
|   |-- security-smack-smackfs.c:warning:Call-to-function-sscanf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-func
|   |-- security-smack-smackfs.c:warning:Call-to-function-sscanf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argumen
|   |-- security-tomoyo-audit.c:warning:Call-to-function-memmove-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argumen
|   |-- security-tomoyo-audit.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argume
|   |-- security-tomoyo-audit.c:warning:Call-to-function-vsnprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argum
|   |-- security-tomoyo-common.c:warning:Call-to-function-memmove-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argume
|   |-- security-tomoyo-common.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argumen
|   |-- security-tomoyo-common.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argum
|   |-- security-tomoyo-common.c:warning:Call-to-function-sscanf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argumen
|   |-- security-tomoyo-common.c:warning:Call-to-function-vsnprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argu
|   |-- security-tomoyo-condition.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argu
|   |-- security-tomoyo-domain.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argumen
|   |-- security-tomoyo-domain.c:warning:Call-to-function-memmove-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argume
|   |-- security-tomoyo-domain.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argum
|   |-- security-tomoyo-domain.c:warning:Call-to-function-strncpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argume
|   |-- security-tomoyo-network.c:warning:Call-to-function-memmove-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argum
|   |-- security-tomoyo-network.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argu
|   |-- security-tomoyo-realpath.c:warning:Call-to-function-memmove-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argu
|   `-- security-tomoyo-realpath.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arg
|-- arm-randconfig-r031-20220310
|   |-- arch-arm-mach-iop32x-cp6.c:warning:no-previous-prototype-for-function-iop_enable_cp6
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-core-dc_resource.c:warning:no-previous-prototype-for-function-is_timing_changed
|   |-- drivers-gpu-drm-amd-amdgpu-..-display-dc-dml-calcs-dce_calcs.c:warning:stack-frame-size-()-exceeds-limit-()-in-calculate_bandwidth
|   |-- drivers-gpu-drm-amd-amdgpu-amdgpu_hdp.c:warning:no-previous-prototype-for-function-amdgpu_hdp_ras_fini
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_mmhub.c:warning:no-previous-prototype-for-function-amdgpu_mmhub_ras_fini
|-- hexagon-randconfig-r041-20220310
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-a011
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- i386-randconfig-c001
|   |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
|   `-- net-ipv4-tcp_input.c:warning:Value-stored-to-reason-is-never-read-clang-analyzer-deadcode.DeadStores
|-- mips-randconfig-c004-20220310
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|-- powerpc-randconfig-c003-20220310
|   `-- clang:error:linker-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- riscv-randconfig-c006-20220309
|   |-- arch-riscv-kernel-ptrace.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argum
|   |-- block-bfq-cgroup.c:warning:Call-to-function-sscanf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-or-
|   |-- block-blk-iocost.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-or-
|   |-- block-blk-iocost.c:warning:Call-to-function-sscanf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-or-
|   |-- drivers-crypto-atmel-ecc.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argum
|   |-- drivers-hid-usbhid-usbkbd.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argu
|   |-- drivers-hid-usbhid-usbkbd.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-ar
|   |-- drivers-iio-adc-ad7192.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argume
|   |-- drivers-iio-adc-ti-ads8688.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-ar
|   |-- drivers-iio-common-ssp_sensors-ssp_iio.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-suppor
|   |-- drivers-iio-common-ssp_sensors-ssp_spi.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-suppor
|   |-- drivers-input-joystick-iforce-iforce-usb.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-supp
|   |-- drivers-input-joystick-xpad.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-ar
|   |-- drivers-input-joystick-xpad.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-
|   |-- drivers-input-misc-keyspan_remote.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-len
|   |-- drivers-input-misc-keyspan_remote.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-l
|   |-- drivers-regulator-da9055-regulator.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-l
|   |-- drivers-spi-spi-dw-dma.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argumen
|   |-- drivers-usb-c67x00-c67x00-hcd.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-
|   |-- drivers-usb-gadget-function-f_printer.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support
|   |-- drivers-usb-gadget-function-f_printer.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-suppor
|   |-- drivers-usb-gadget-function-f_tcm.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-len
|   |-- drivers-usb-gadget-function-f_tcm.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-len
|   |-- drivers-usb-gadget-function-f_tcm.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-l
|   |-- drivers-usb-gadget-function-f_tcm.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-le
|   |-- drivers-usb-gadget-udc-dummy_hcd.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-leng
|   |-- drivers-usb-gadget-udc-dummy_hcd.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-leng
|   |-- drivers-usb-gadget-udc-m66592-udc.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-l
|   |-- drivers-usb-gadget-udc-r8a66597-udc.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support
|   |-- drivers-usb-gadget-udc-snps_udc_core.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-
|   |-- drivers-usb-gadget-udc-snps_udc_core.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-
|   |-- drivers-usb-gadget-udc-snps_udc_core.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-suppor
|   |-- drivers-usb-gadget-udc-udc-xilinx.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-len
|   |-- drivers-usb-gadget-udc-udc-xilinx.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-l
|   |-- drivers-usb-host-max3421-hcd.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-a
|   |-- fs-crypto-inline_crypt.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-argumen
|   |-- lib-test_firmware.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-or
|   |-- lib-test_firmware.c:warning:Call-to-function-snprintf-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-
|   |-- lib-test_stackinit.c:warning:Call-to-function-memcpy-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-o
|   `-- lib-test_stackinit.c:warning:Call-to-function-memset-is-insecure-as-it-does-not-provide-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functions-that-support-length-arguments-o
|-- riscv-randconfig-r042-20220310
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- s390-randconfig-c005-20220310
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   `-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
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
|-- x86_64-randconfig-a012
|   |-- fs-btrfs-ordered-data.c:warning:expecting-prototype-for-Add-an-ordered-extent-to-the-per().-Prototype-was-for-btrfs_add_ordered_extent()-instead
|   |-- fs-btrfs-tree-log.c:warning:This-comment-starts-with-but-isn-t-a-kernel-doc-comment.-Refer-Documentation-doc-guide-kernel-doc.rst
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- x86_64-randconfig-a014
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
|-- x86_64-randconfig-a016
|   `-- include-linux-fortify-string.h:warning:call-to-__read_overflow2_field-declared-with-warning-attribute:detected-read-beyond-size-of-field-(2nd-parameter)-maybe-use-struct_group()
`-- x86_64-randconfig-c007
    |-- drivers-hid-hid-core.c:warning:Although-the-value-stored-to-field-is-used-in-the-enclosing-expression-the-value-is-never-actually-read-from-field-clang-analyzer-deadcode.DeadStores
    `-- net-ipv4-tcp_input.c:warning:Value-stored-to-reason-is-never-read-clang-analyzer-deadcode.DeadStores

elapsed time: 722m

configs tested: 125
configs skipped: 4

gcc tested configs:
arm                                 defconfig
arm                              allmodconfig
arm                              allyesconfig
arm64                            allyesconfig
arm64                               defconfig
um                             i386_defconfig
um                           x86_64_defconfig
mips                             allyesconfig
riscv                            allyesconfig
mips                             allmodconfig
powerpc                          allmodconfig
m68k                             allyesconfig
powerpc                          allyesconfig
s390                             allmodconfig
m68k                             allmodconfig
s390                             allyesconfig
sparc                            allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
parisc                           allyesconfig
xtensa                           allyesconfig
alpha                            allyesconfig
arc                              allyesconfig
nios2                            allyesconfig
i386                          randconfig-c001
sh                           se7343_defconfig
h8300                       h8s-sim_defconfig
arm                        realview_defconfig
mips                         bigsur_defconfig
sh                        sh7785lcr_defconfig
sh                        sh7757lcr_defconfig
powerpc                       maple_defconfig
powerpc                   currituck_defconfig
arm                        clps711x_defconfig
xtensa                         virt_defconfig
powerpc                        warp_defconfig
sh                            titan_defconfig
arm                          iop32x_defconfig
m68k                        mvme147_defconfig
um                               alldefconfig
i386                                defconfig
powerpc                 mpc8540_ads_defconfig
powerpc                    klondike_defconfig
nios2                            alldefconfig
parisc                generic-64bit_defconfig
powerpc                       eiger_defconfig
arc                          axs101_defconfig
arm                           u8500_defconfig
arm                        cerfcube_defconfig
m68k                        m5307c3_defconfig
arm                  randconfig-c002-20220310
ia64                                defconfig
ia64                             allmodconfig
ia64                             allyesconfig
m68k                                defconfig
nds32                             allnoconfig
nios2                               defconfig
csky                                defconfig
alpha                               defconfig
nds32                               defconfig
arc                                 defconfig
parisc                              defconfig
parisc64                            defconfig
s390                                defconfig
i386                              debian-10.3
i386                   debian-10.3-kselftests
sparc                               defconfig
i386                             allyesconfig
powerpc                           allnoconfig
i386                          randconfig-a003
i386                          randconfig-a001
i386                          randconfig-a005
x86_64                        randconfig-a015
x86_64                        randconfig-a013
x86_64                        randconfig-a011
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
x86_64                        randconfig-a006
x86_64                        randconfig-a002
x86_64                        randconfig-a004
arc                  randconfig-r043-20220310
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                               defconfig
riscv                          rv32_defconfig
riscv                            allmodconfig
x86_64                    rhel-8.3-kselftests
x86_64                           allyesconfig
x86_64                              defconfig
x86_64                                  kexec
x86_64                               rhel-8.3
x86_64                          rhel-8.3-func
x86_64                         rhel-8.3-kunit

clang tested configs:
mips                 randconfig-c004-20220310
x86_64                        randconfig-c007
s390                 randconfig-c005-20220310
powerpc              randconfig-c003-20220310
i386                          randconfig-c001
riscv                randconfig-c006-20220310
arm                  randconfig-c002-20220310
arm                    vt8500_v6_v7_defconfig
arm                        multi_v5_defconfig
arm                  colibri_pxa270_defconfig
riscv                          rv32_defconfig
powerpc                     ppa8548_defconfig
arm                          ixp4xx_defconfig
arm                              alldefconfig
arm                         s5pv210_defconfig
riscv                    nommu_virt_defconfig
arm                     am200epdkit_defconfig
arm                         bcm2835_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a012
x86_64                        randconfig-a016
x86_64                        randconfig-a014
i386                          randconfig-a013
i386                          randconfig-a015
i386                          randconfig-a011
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005
hexagon              randconfig-r041-20220310
hexagon              randconfig-r045-20220310
s390                 randconfig-r044-20220310
riscv                randconfig-r042-20220310

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
