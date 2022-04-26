Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB7850F06E
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 07:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237637AbiDZFp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 01:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbiDZFpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 01:45:53 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9589E2C104;
        Mon, 25 Apr 2022 22:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650951764; x=1682487764;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=ALBaSwqRZhkpzhIwROzHvqZY8s+vIra6wfKbbUAx7ww=;
  b=I0vRTdUMw/G/d8k0vzpbxuZWI4MVg77uJR4dfGMAOrdUAcIIHPuf84TT
   amc6N8AaSUxmQnIdlc8YNjOGuIWwXzBiA+IUJbtEeSQGy/XUOHGkLoW9a
   PdxSGYzfZMGBZ/lXu7H1TxDxiIcq8qP0UzBoN7o6ETWqzVCf8X/GozvK1
   yUY4/5MZZDjJcTSD4RWh3Hl2PuQvBLqlqNOT5FMdd8xhRjKxIsVNyR8I5
   oxUvy2d+R9B31axCLYEzSZ36N7x3P1DJIBYTD5vb4sRptJkSSsMqKzMCy
   fkeZoUYjGn37Ui2Iqn4WBD1xBcO5pfo/gZ96wXYkxKLYkxniVYm+vsjtI
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="265266467"
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="265266467"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 22:42:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,290,1643702400"; 
   d="scan'208";a="650031008"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Apr 2022 22:42:39 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njDyA-0003G6-RK;
        Tue, 26 Apr 2022 05:42:38 +0000
Date:   Tue, 26 Apr 2022 13:42:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-mm@kvack.org, linux-mips@vger.kernel.org,
        linux-media@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, io-uring@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        ath11k@lists.infradead.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 e7d6987e09a328d4a949701db40ef63fbb970670
Message-ID: <6267862c.xuehJN2IUHn8WMof%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: e7d6987e09a328d4a949701db40ef63fbb970670  Add linux-next specific files for 20220422

Error/Warning reports:

https://lore.kernel.org/linux-mm/202204081656.6x4pfen4-lkp@intel.com
https://lore.kernel.org/linux-mm/202204231818.yVvV3Oxp-lkp@intel.com
https://lore.kernel.org/linux-mm/202204240458.z2cymyl5-lkp@intel.com
https://lore.kernel.org/linux-mm/202204241527.n36cr1e5-lkp@intel.com
https://lore.kernel.org/llvm/202204230717.gJP3yZ5j-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

ERROR: modpost: "omap_set_dma_priority" [drivers/video/fbdev/omap/omapfb.ko] undefined!
arch/sh/include/asm/io.h:274:33: error: expected expression before 'do'
drivers/bus/mhi/host/main.c:787:13: warning: parameter 'event_quota' set but not used [-Wunused-but-set-parameter]
drivers/char/hw_random/mpfs-rng.c:49:9: error: call to undeclared function 'mpfs_blocking_transaction'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/char/hw_random/mpfs-rng.c:74:27: warning: incompatible integer to pointer conversion assigning to 'struct mpfs_sys_controller *' from 'int' [-Wint-conversion]
drivers/char/hw_random/mpfs-rng.c:74:30: error: call to undeclared function 'mpfs_sys_controller_get'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/gpu/drm/solomon/ssd130x-spi.c:154:35: warning: unused variable 'ssd130x_spi_table' [-Wunused-const-variable]
drivers/usb/atm/cxacru.c:259:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/atm/usbatm.c:739:10: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/chipidea/core.c:956:10: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/core.c:1664:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
mpfs-rng.c:(.data.rel.ro+0x20): undefined reference to `mpfs_sys_controller_get'
mpfs-rng.c:(.data.rel.ro+0x8): undefined reference to `mpfs_blocking_transaction'
omapfb_main.c:(.text+0x41ec): undefined reference to `omap_set_dma_priority'

Unverified Error/Warning (likely false positive, please contact us if interested):

Makefile:684: arch/h8300/Makefile: No such file or directory
arch/Kconfig:10: can't open file "arch/h8300/Kconfig"
arch/s390/include/asm/spinlock.h:81:3: error: unexpected token in '.rept' directive
arch/s390/include/asm/spinlock.h:81:3: error: unknown directive
arch/s390/include/asm/spinlock.h:81:3: error: unmatched '.endr' directive
arch/s390/lib/spinlock.c:78:3: error: unexpected token in '.rept' directive
arch/s390/lib/spinlock.c:78:3: error: unknown directive
arch/s390/lib/spinlock.c:78:3: error: unmatched '.endr' directive
crypto/sm3.c:246:1: internal compiler error: Segmentation fault
csky-linux-ld: mpfs-rng.c:(.text+0x10c): undefined reference to `mpfs_sys_controller_get'
csky-linux-ld: mpfs-rng.c:(.text+0x70): undefined reference to `mpfs_blocking_transaction'
drivers/base/topology.c:158:17: warning: Value stored to 'dev' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/char/hw_random/mpfs-rng.c:49:23: error: implicit declaration of function 'mpfs_blocking_transaction' [-Werror=implicit-function-declaration]
drivers/char/hw_random/mpfs-rng.c:74:34: warning: assignment to 'struct mpfs_sys_controller *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
drivers/char/hw_random/mpfs-rng.c:74:37: error: implicit declaration of function 'mpfs_sys_controller_get' [-Werror=implicit-function-declaration]
drivers/dma-buf/st-dma-fence-unwrap.c:125:13: warning: variable 'err' set but not used [-Wunused-but-set-variable]
drivers/edac/edac_device.c:79 edac_device_alloc_ctl_info() warn: Please consider using kcalloc instead
drivers/edac/edac_mc.c:396:24: warning: Variable 'layer' is not assigned a value. [unassignedVariable]
drivers/hid/wacom_wac.c:2411:42: warning: format specifies type 'unsigned short' but the argument has type 'int' [-Wformat]
drivers/net/ethernet/mellanox/mlxsw/core_linecards.c:851:8: warning: Use of memory after it is freed [clang-analyzer-unix.Malloc]
drivers/net/wireless/ath/ath11k/peer.c:520 ath11k_peer_rhash_id_tbl_init() warn: missing error code 'ret'
drivers/net/wireless/ath/ath11k/peer.c:575 ath11k_peer_rhash_addr_tbl_init() warn: missing error code 'ret'
drivers/pinctrl/pinctrl-ingenic.c:162 is_soc_or_above() warn: bitwise AND condition is false here
fs/btrfs/ctree.c:1412:7: warning: Local variable 'unlock_up' shadows outer function [shadowFunction]
fs/btrfs/send.c:6857:13: warning: Either the condition '*level==0' is redundant or the array 'path->nodes[8]' is accessed at index -1, which is out of bounds. [negativeIndex]
fs/btrfs/send.c:6858:13: warning: Either the condition '*level==0' is redundant or the array 'path->slots[8]' is accessed at index -1, which is out of bounds. [negativeIndex]
kernel/bpf/core.c:1667:3: warning: Syntax Error: AST broken, binary operator '=' doesn't have two operands. [internalAstError]
kernel/bpf/syscall.c:4944:13: warning: no previous prototype for function 'unpriv_ebpf_notify' [-Wmissing-prototypes]
kernel/module/kallsyms.c:157:24: warning: Redundant assignment of 'mod->init_layout.size' to itself. [selfAssignment]
kernel/module/kallsyms.c:424:3: warning: Assignment of function parameter has no effect outside the function. [uselessAssignmentArg]
kernel/module/main.c:2113:26: warning: Redundant assignment of 'mod->core_layout.size' to itself. [selfAssignment]
kernel/module/main.c:2147:26: warning: Redundant assignment of 'mod->init_layout.size' to itself. [selfAssignment]
kernel/module/main.c:2189:4: warning: Null pointer passed as 1st argument to memory copy function [clang-analyzer-unix.cstring.NullArg]
kernel/module/main.c:2261:70: warning: Parameter 'debug' can be declared with const [constParameter]
kernel/module/main.c:357:20: warning: Local variable 'arr' shadows outer variable [shadowVariable]
kernel/module/main.c:924:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
lib/iov_iter.c:1837:61: warning: Parameter 'old' can be declared with const [constParameter]
lib/iov_iter.c:1884:6: warning: Redundant initialization for 'ret'. The initialized value is overwritten before it is read. [redundantInitialization]
lib/vsprintf.c:588:41: warning: Parameter 'end' can be declared with const [constParameter]
make[1]: *** No rule to make target 'arch/h8300/Makefile'.
mm/memory.c: linux/mm_inline.h is included more than once.
mm/sparse-vmemmap.c:740:17: warning: Value stored to 'next' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
mpfs-rng.c:(.text+0x3c): undefined reference to `mpfs_blocking_transaction'
mpfs-rng.c:(.text+0x98): undefined reference to `mpfs_sys_controller_get'
net/ipv4/tcp_cong.c:430:32: warning: Division by zero [clang-analyzer-core.DivideZero]
{standard input}:1628: Error: operands mismatch -- statement `mulu.l 4(%a0),%d3:%d0' ignored
{standard input}:1628: Error: operands mismatch -- statement `mulu.l 8(%a0),%d2:%d4' ignored
{standard input}:2648: Error: operands mismatch -- statement `divu.l %d0,%d3:%d7' ignored
{standard input}:2677: Error: operands mismatch -- statement `mulu.l %d3,%d2:%d7' ignored

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- alpha-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- alpha-buildonly-randconfig-r004-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- alpha-randconfig-r033-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- arc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- arc-randconfig-p001-20220422
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arc-randconfig-r043-20220424
|   |-- drivers-char-hw_random-mpfs-rng.c:error:implicit-declaration-of-function-mpfs_blocking_transaction
|   |-- drivers-char-hw_random-mpfs-rng.c:error:implicit-declaration-of-function-mpfs_sys_controller_get
|   `-- drivers-char-hw_random-mpfs-rng.c:warning:assignment-to-struct-mpfs_sys_controller-from-int-makes-pointer-from-integer-without-a-cast
|-- arc-randconfig-s031-20220421
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- arm-allmodconfig
|   |-- ERROR:omap_set_dma_priority-drivers-video-fbdev-omap-omapfb.ko-undefined
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- arm-allyesconfig
|   |-- arch-arm-mach-omap2-sram.c:sparse:sparse:cast-removes-address-space-__iomem-of-expression
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   |-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|   `-- omapfb_main.c:(.text):undefined-reference-to-omap_set_dma_priority
|-- arm-randconfig-c002-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- arm64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- arm64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- arm64-randconfig-c003-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- csky-allmodconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- csky-allyesconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- csky-randconfig-r003-20220424
|   |-- csky-linux-ld:mpfs-rng.c:(.text):undefined-reference-to-mpfs_blocking_transaction
|   |-- csky-linux-ld:mpfs-rng.c:(.text):undefined-reference-to-mpfs_sys_controller_get
|   |-- mpfs-rng.c:(.text):undefined-reference-to-mpfs_blocking_transaction
|   `-- mpfs-rng.c:(.text):undefined-reference-to-mpfs_sys_controller_get
|-- h8300-allmodconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-allyesconfig
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- h8300-buildonly-randconfig-r006-20220421
|   |-- Makefile:arch-h8300-Makefile:No-such-file-or-directory
|   |-- arch-Kconfig:can-t-open-file-arch-h8300-Kconfig
|   `-- make:No-rule-to-make-target-arch-h8300-Makefile-.
|-- i386-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- i386-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- i386-randconfig-m021
|   `-- drivers-edac-edac_device.c-edac_device_alloc_ctl_info()-warn:Please-consider-using-kcalloc-instead
|-- i386-randconfig-s001
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- ia64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- ia64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- ia64-randconfig-r032-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- m68k-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- m68k-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- m68k-buildonly-randconfig-r005-20220422
|   |-- drivers-char-hw_random-mpfs-rng.c:error:implicit-declaration-of-function-mpfs_blocking_transaction
|   |-- drivers-char-hw_random-mpfs-rng.c:error:implicit-declaration-of-function-mpfs_sys_controller_get
|   |-- drivers-char-hw_random-mpfs-rng.c:warning:assignment-to-struct-mpfs_sys_controller-from-int-makes-pointer-from-integer-without-a-cast
|   |-- standard-input:Error:operands-mismatch-statement-divu.l-d0-d3:d7-ignored
|   |-- standard-input:Error:operands-mismatch-statement-mulu.l-(-a0)-d2:d4-ignored
|   |-- standard-input:Error:operands-mismatch-statement-mulu.l-(-a0)-d3:d0-ignored
|   `-- standard-input:Error:operands-mismatch-statement-mulu.l-d3-d2:d7-ignored
|-- m68k-randconfig-r011-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- m68k-randconfig-r013-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- m68k-randconfig-r026-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- microblaze-randconfig-p002-20220422
|   |-- fs-btrfs-ctree.c:warning:Local-variable-unlock_up-shadows-outer-function-shadowFunction
|   |-- fs-btrfs-send.c:warning:Either-the-condition-level-is-redundant-or-the-array-path-nodes-is-accessed-at-index-which-is-out-of-bounds.-negativeIndex
|   `-- fs-btrfs-send.c:warning:Either-the-condition-level-is-redundant-or-the-array-path-slots-is-accessed-at-index-which-is-out-of-bounds.-negativeIndex
|-- mips-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-mem-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- mips-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-mem-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- nios2-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- nios2-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- nios2-randconfig-r005-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- parisc-allmodconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- parisc-allyesconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- parisc-buildonly-randconfig-r004-20220422
|   |-- mpfs-rng.c:(.data.rel.ro):undefined-reference-to-mpfs_blocking_transaction
|   `-- mpfs-rng.c:(.data.rel.ro):undefined-reference-to-mpfs_sys_controller_get
|-- powerpc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- powerpc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- powerpc-buildonly-randconfig-r005-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- powerpc64-randconfig-p001-20220422
|   |-- drivers-edac-edac_mc.c:warning:Variable-layer-is-not-assigned-a-value.-unassignedVariable
|   |-- kernel-bpf-core.c:warning:Syntax-Error:AST-broken-binary-operator-doesn-t-have-two-operands.-internalAstError
|   |-- kernel-module-kallsyms.c:warning:Assignment-of-function-parameter-has-no-effect-outside-the-function.-uselessAssignmentArg
|   |-- kernel-module-kallsyms.c:warning:Redundant-assignment-of-mod-init_layout.size-to-itself.-selfAssignment
|   |-- kernel-module-main.c:warning:Local-variable-arr-shadows-outer-variable-shadowVariable
|   |-- kernel-module-main.c:warning:Parameter-debug-can-be-declared-with-const-constParameter
|   |-- kernel-module-main.c:warning:Redundant-assignment-of-mod-core_layout.size-to-itself.-selfAssignment
|   |-- kernel-module-main.c:warning:Redundant-assignment-of-mod-data_layout.size-to-itself.-selfAssignment
|   |-- kernel-module-main.c:warning:Redundant-assignment-of-mod-init_layout.size-to-itself.-selfAssignment
|   |-- lib-iov_iter.c:warning:Parameter-old-can-be-declared-with-const-constParameter
|   |-- lib-iov_iter.c:warning:Redundant-initialization-for-ret-.-The-initialized-value-is-overwritten-before-it-is-read.-redundantInitialization
|   `-- lib-vsprintf.c:warning:Parameter-end-can-be-declared-with-const-constParameter
|-- powerpc64-randconfig-r021-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- riscv-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- riscv-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- riscv-buildonly-randconfig-r001-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- riscv-buildonly-randconfig-r003-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- riscv-randconfig-r035-20220422
|   `-- crypto-sm3.c:internal-compiler-error:Segmentation-fault
|-- s390-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- s390-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- s390-randconfig-r025-20220421
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sh-allmodconfig
|   |-- arch-sh-include-asm-io.h:error:expected-expression-before-do
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sh-allyesconfig
|   |-- arch-sh-include-asm-io.h:error:expected-expression-before-do
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- sh-randconfig-c004-20220421
|   `-- arch-sh-include-asm-io.h:error:expected-expression-before-do
|-- sparc-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- sparc-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:cast-to-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-restricted-__le32
|   |-- drivers-soc-qcom-smem.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-struct-smem_partition_header-phdr-got-void-noderef-__iomem-virt_base
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- um-i386_defconfig
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- um-x86_64_defconfig
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- x86_64-allmodconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- x86_64-allnoconfig
|   `-- mm-memory.c:linux-mm_inline.h-is-included-more-than-once.
|-- x86_64-allyesconfig
|   |-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- x86_64-randconfig-m001
|   `-- drivers-edac-edac_device.c-edac_device_alloc_ctl_info()-warn:Please-consider-using-kcalloc-instead
|-- x86_64-randconfig-m001-20220418
|   |-- drivers-net-wireless-ath-ath11k-peer.c-ath11k_peer_rhash_addr_tbl_init()-warn:missing-error-code-ret
|   `-- drivers-net-wireless-ath-ath11k-peer.c-ath11k_peer_rhash_id_tbl_init()-warn:missing-error-code-ret
|-- x86_64-randconfig-s021
|   `-- fs-io_uring.c:sparse:sparse:marked-inline-but-without-a-definition
|-- xtensa-allmodconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- xtensa-allyesconfig
|   `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used
|-- xtensa-randconfig-m031-20220422
|   `-- drivers-pinctrl-pinctrl-ingenic.c-is_soc_or_above()-warn:bitwise-AND-condition-is-false-here
`-- xtensa-randconfig-r002-20220421
    `-- drivers-dma-buf-st-dma-fence-unwrap.c:warning:variable-err-set-but-not-used

clang_recent_errors
|-- arm-randconfig-c002-20220422
|   |-- drivers-usb-atm-cxacru.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-fun
|   |-- drivers-usb-atm-usbatm.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-fun
|   |-- drivers-usb-chipidea-core.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-
|   |-- drivers-usb-gadget-udc-core.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogou
|   |-- kernel-module-main.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functio
|   `-- kernel-module-main.c:warning:Null-pointer-passed-as-1st-argument-to-memory-copy-function-clang-analyzer-unix.cstring.NullArg
|-- arm-randconfig-r015-20220421
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- arm64-buildonly-randconfig-r002-20220421
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|-- arm64-randconfig-r021-20220422
|   |-- drivers-char-hw_random-mpfs-rng.c:error:call-to-undeclared-function-mpfs_blocking_transaction-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   |-- drivers-char-hw_random-mpfs-rng.c:error:call-to-undeclared-function-mpfs_sys_controller_get-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- drivers-char-hw_random-mpfs-rng.c:warning:incompatible-integer-to-pointer-conversion-assigning-to-struct-mpfs_sys_controller-from-int
|-- arm64-randconfig-r035-20220421
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- hexagon-randconfig-r034-20220421
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- hexagon-randconfig-r041-20220421
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|-- hexagon-randconfig-r045-20220421
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|-- hexagon-randconfig-r045-20220424
|   |-- drivers-char-hw_random-mpfs-rng.c:error:call-to-undeclared-function-mpfs_blocking_transaction-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   |-- drivers-char-hw_random-mpfs-rng.c:error:call-to-undeclared-function-mpfs_sys_controller_get-ISO-C99-and-later-do-not-support-implicit-function-declarations
|   `-- drivers-char-hw_random-mpfs-rng.c:warning:incompatible-integer-to-pointer-conversion-assigning-to-struct-mpfs_sys_controller-from-int
|-- i386-randconfig-a002
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- i386-randconfig-a004
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- i386-randconfig-a011
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- i386-randconfig-a013
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- i386-randconfig-a015
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- i386-randconfig-c001
|   |-- drivers-base-topology.c:warning:Value-stored-to-dev-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   |-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|   |-- kernel-module-main.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functio
|   |-- kernel-module-main.c:warning:Null-pointer-passed-as-1st-argument-to-memory-copy-function-clang-analyzer-unix.cstring.NullArg
|   `-- net-ipv4-tcp_cong.c:warning:Division-by-zero-clang-analyzer-core.DivideZero
|-- riscv-randconfig-c006-20220422
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- riscv-randconfig-c006-20220424
|   `-- drivers-net-ethernet-mellanox-mlxsw-core_linecards.c:warning:Use-of-memory-after-it-is-freed-clang-analyzer-unix.Malloc
|-- riscv-randconfig-r004-20220421
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|-- riscv-randconfig-r026-20220420
|   `-- drivers-hid-wacom_wac.c:warning:format-specifies-type-unsigned-short-but-the-argument-has-type-int
|-- s390-alldefconfig
|   |-- arch-s390-include-asm-spinlock.h:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unknown-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unmatched-.endr-directive
|   |-- arch-s390-lib-spinlock.c:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-lib-spinlock.c:error:unknown-directive
|   `-- arch-s390-lib-spinlock.c:error:unmatched-.endr-directive
|-- s390-randconfig-c005-20220422
|   |-- arch-s390-include-asm-spinlock.h:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unknown-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unmatched-.endr-directive
|   |-- arch-s390-lib-spinlock.c:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-lib-spinlock.c:error:unknown-directive
|   `-- arch-s390-lib-spinlock.c:error:unmatched-.endr-directive
|-- s390-randconfig-r003-20220421
|   |-- arch-s390-include-asm-spinlock.h:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unknown-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unmatched-.endr-directive
|   |-- arch-s390-lib-spinlock.c:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-lib-spinlock.c:error:unknown-directive
|   |-- arch-s390-lib-spinlock.c:error:unmatched-.endr-directive
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|-- s390-randconfig-r006-20220421
|   |-- arch-s390-include-asm-spinlock.h:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unknown-directive
|   |-- arch-s390-include-asm-spinlock.h:error:unmatched-.endr-directive
|   |-- arch-s390-lib-spinlock.c:error:unexpected-token-in-.rept-directive
|   |-- arch-s390-lib-spinlock.c:error:unknown-directive
|   |-- arch-s390-lib-spinlock.c:error:unmatched-.endr-directive
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|-- x86_64-allyesconfig
|   `-- drivers-gpu-drm-solomon-ssd13-spi.c:warning:unused-variable-ssd13_spi_table
|-- x86_64-randconfig-a001
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- x86_64-randconfig-a005
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|-- x86_64-randconfig-a012
|   |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|   `-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
|-- x86_64-randconfig-a014
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
|-- x86_64-randconfig-a016
|   `-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
`-- x86_64-randconfig-c007
    |-- drivers-bus-mhi-host-main.c:warning:parameter-event_quota-set-but-not-used
    |-- kernel-bpf-syscall.c:warning:no-previous-prototype-for-function-unpriv_ebpf_notify
    |-- kernel-module-main.c:warning:Call-to-function-sprintf-is-insecure-as-it-does-not-provide-bounding-of-the-memory-buffer-or-security-checks-introduced-in-the-C11-standard.-Replace-with-analogous-functio
    |-- kernel-module-main.c:warning:Null-pointer-passed-as-1st-argument-to-memory-copy-function-clang-analyzer-unix.cstring.NullArg
    |-- mm-sparse-vmemmap.c:warning:Value-stored-to-next-during-its-initialization-is-never-read-clang-analyzer-deadcode.DeadStores
    `-- net-ipv4-tcp_cong.c:warning:Division-by-zero-clang-analyzer-core.DivideZero

elapsed time: 5684m

configs tested: 130
configs skipped: 3

gcc tested configs:
arm                              allmodconfig
arm                              allyesconfig
arm                                 defconfig
arm64                               defconfig
arm64                            allyesconfig
ia64                             allmodconfig
i386                             allyesconfig
ia64                             allyesconfig
x86_64                           allyesconfig
mips                             allyesconfig
riscv                            allyesconfig
um                           x86_64_defconfig
riscv                            allmodconfig
um                             i386_defconfig
mips                             allmodconfig
powerpc                          allmodconfig
m68k                             allyesconfig
s390                             allmodconfig
s390                             allyesconfig
m68k                             allmodconfig
powerpc                          allyesconfig
i386                          randconfig-c001
sparc                            allyesconfig
parisc                           allyesconfig
sh                               allmodconfig
h8300                            allyesconfig
xtensa                           allyesconfig
arc                              allyesconfig
alpha                            allyesconfig
nios2                            allyesconfig
mips                 decstation_r4k_defconfig
powerpc                 mpc834x_mds_defconfig
ia64                            zx1_defconfig
mips                     decstation_defconfig
arm                          exynos_defconfig
arm                          simpad_defconfig
mips                            gpr_defconfig
m68k                        mvme147_defconfig
sh                           se7722_defconfig
sh                            hp6xx_defconfig
xtensa                    xip_kc705_defconfig
arm                          iop32x_defconfig
parisc64                            defconfig
sh                   rts7751r2dplus_defconfig
arm                        mini2440_defconfig
sparc                       sparc32_defconfig
powerpc                  storcenter_defconfig
arm                        keystone_defconfig
sh                           se7343_defconfig
powerpc                     sequoia_defconfig
arc                                 defconfig
xtensa                       common_defconfig
sh                            shmin_defconfig
sh                               alldefconfig
powerpc                      ppc6xx_defconfig
sh                     sh7710voipgw_defconfig
sh                          rsk7269_defconfig
sh                           se7750_defconfig
arm                  randconfig-c002-20220421
x86_64                        randconfig-c001
ia64                                defconfig
m68k                                defconfig
alpha                               defconfig
csky                                defconfig
nios2                               defconfig
parisc                              defconfig
s390                                defconfig
i386                   debian-10.3-kselftests
i386                              debian-10.3
i386                                defconfig
sparc                               defconfig
powerpc                           allnoconfig
i386                          randconfig-a001
i386                          randconfig-a003
i386                          randconfig-a005
x86_64                        randconfig-a013
x86_64                        randconfig-a011
x86_64                        randconfig-a015
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
x86_64                        randconfig-a004
x86_64                        randconfig-a002
x86_64                        randconfig-a006
arc                  randconfig-r043-20220421
riscv                randconfig-r042-20220421
s390                 randconfig-r044-20220421
riscv                    nommu_k210_defconfig
riscv                    nommu_virt_defconfig
riscv                             allnoconfig
riscv                          rv32_defconfig
riscv                               defconfig
x86_64                          rhel-8.3-func
x86_64                              defconfig
x86_64                                  kexec
x86_64                               rhel-8.3
x86_64                         rhel-8.3-kunit
x86_64                    rhel-8.3-kselftests

clang tested configs:
arm                  randconfig-c002-20220422
powerpc              randconfig-c003-20220422
s390                 randconfig-c005-20220422
mips                 randconfig-c004-20220422
x86_64                        randconfig-c007
i386                          randconfig-c001
riscv                randconfig-c006-20220422
s390                             alldefconfig
powerpc                      ppc64e_defconfig
mips                           rs90_defconfig
mips                        workpad_defconfig
arm                           spitz_defconfig
powerpc                 mpc8313_rdb_defconfig
powerpc                 mpc836x_mds_defconfig
powerpc                      obs600_defconfig
powerpc                        fsp2_defconfig
powerpc                     tqm8560_defconfig
hexagon                          alldefconfig
arm                     davinci_all_defconfig
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a016
x86_64                        randconfig-a012
x86_64                        randconfig-a014
i386                          randconfig-a013
i386                          randconfig-a011
i386                          randconfig-a015
x86_64                        randconfig-a005
x86_64                        randconfig-a001
x86_64                        randconfig-a003
hexagon              randconfig-r041-20220421
hexagon              randconfig-r045-20220421

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
