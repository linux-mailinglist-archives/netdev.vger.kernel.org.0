Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314A74EE014
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 20:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbiCaSFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 14:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiCaSE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 14:04:58 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2CB231ACD;
        Thu, 31 Mar 2022 11:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648749788; x=1680285788;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=6Mp8tgCs+Sw7UzRhZXs8EqtUszHTh4hvOUxjztwbqD8=;
  b=BCCuighDyhUbLsXeE0iovj7wU/kl8IL/odkg4Czi5nB8sWwppdscpkAe
   LvI229pdwn0E5/iHtb6nlxaHfvGU+gVF7eslJygHkNhAL5UYOQ4u5Sf94
   AinrOwQj1XAFYb9qr1hzazxH6JXNH0D0D0FhM3UL6rO37jbUv61IJDr0I
   BWr71dSSfFk61Jmed88jf/Q2/tTbQlNpgj2bojHgL0JQ5z7Q46SAOeB8N
   e+9wt5gb4+qO2w0aP6oG1lEBwnArp99VxltaS3Aae0v4uE0Gzhc9srU/u
   915EGsdcd/SnEUC4Q4bnydqptfooLAXheLuiMlqDmSNI9FASYGSfXoW/o
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="242062659"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="242062659"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 11:03:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="695578958"
Received: from lkp-server02.sh.intel.com (HELO 3231c491b0e2) ([10.239.97.151])
  by fmsmga001.fm.intel.com with ESMTP; 31 Mar 2022 11:03:04 -0700
Received: from kbuild by 3231c491b0e2 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nZz8R-0000WZ-Sw;
        Thu, 31 Mar 2022 18:03:03 +0000
Date:   Fri, 01 Apr 2022 02:02:05 +0800
From:   kernel test robot <lkp@intel.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     uclinux-h8-devel@lists.sourceforge.jp, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, linux-iio@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        amd-gfx@lists.freedesktop.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 fdcbcd1348f4ef713668bae1b0fa9774e1811205
Message-ID: <6245ec9d.QXwZAWMWX6laXDtu%lkp@intel.com>
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: fdcbcd1348f4ef713668bae1b0fa9774e1811205  Add linux-next specific files for 20220331

Error/Warning reports:

https://lore.kernel.org/lkml/202204010033.oeIla4qb-lkp@intel.com
https://lore.kernel.org/llvm/202203241958.Uw9bWfMD-lkp@intel.com

Error/Warning: (recently discovered and may have been fixed)

/kbuild/src/includecheck/kernel/sched/sched.h: linux/static_key.h is included more than once.
arch/powerpc/kvm/powerpc.c:716:29: error: implicit declaration of function 'kvmhv_on_pseries' [-Werror=implicit-function-declaration]
drivers/bus/mhi/host/main.c:792:13: warning: parameter 'event_quota' set but not used [-Wunused-but-set-parameter]
drivers/dma-buf/st-dma-fence-unwrap.c:25:4: warning: unused function 'to_mock_fence'

Unverified Error/Warning (likely false positive, please contact us if interested):

/tmp/ccAL2rBd.s:62: Error: invalid operands (*UND* and .data..percpu sections) for `+'
/tmp/ccDDS7v2.s:59: Error: invalid operands (*UND* and .data..percpu sections) for `+'
<inline asm>:40:208: error: expected relocatable expression
arch/s390/include/asm/spinlock.h:81:3: error: unexpected token in '.rept' directive
arch/s390/include/asm/spinlock.h:81:3: error: unknown directive
arch/s390/include/asm/spinlock.h:81:3: error: unmatched '.endr' directive
arch/s390/lib/spinlock.c:78:3: error: unexpected token in '.rept' directive
arch/s390/lib/spinlock.c:78:3: error: unknown directive
arch/s390/lib/spinlock.c:78:3: error: unmatched '.endr' directive
drivers/clk/imx/clk-pll14xx.c:166:2: warning: Value stored to 'pll_div_ctl1' is never read [clang-analyzer-deadcode.DeadStores]
drivers/counter/104-quad-8.c:150:9: sparse:    unsigned char
drivers/counter/104-quad-8.c:150:9: sparse:    void
drivers/counter/104-quad-8.c:150:9: sparse: sparse: incompatible types in conditional expression (different base types):
drivers/firmware/turris-mox-rwtm.c:146:1: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/gpu/drm/amd/amdgpu/../display/dc/dcn31/dcn31_hubp.c:57:6: warning: no previous prototype for 'hubp31_program_extended_blank' [-Wmissing-prototypes]
drivers/gpu/drm/msm/hdmi/hdmi.c:565:8: warning: Call to function 'sscanf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sscanf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/gpu/drm/selftests/test-drm_buddy.c:523:7: warning: Value stored to 'err' is never read [clang-analyzer-deadcode.DeadStores]
drivers/hid/hid-core.c:1665:30: warning: Although the value stored to 'field' is used in the enclosing expression, the value is never actually read from 'field' [clang-analyzer-deadcode.DeadStores]
drivers/hwmon/nsa320-hwmon.c:114:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/hwmon/scpi-hwmon.c:121:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/hwmon/vt8231.c:634:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/leds/trigger/ledtrig-tty.c:33:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/media/platform/st/stm32/dma2d/dma2d-hw.c:109:1: internal compiler error: in extract_insn, at recog.c:2770
drivers/memory/brcmstb_dpfe.c:707:10: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/message/fusion/mptbase.c:6820:6: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/net/vxlan/vxlan_core.c:440:34: sparse: sparse: incorrect type in argument 2 (different base types)
drivers/pci/vgaarb.c:213:17: warning: Value stored to 'dev' during its initialization is never read [clang-analyzer-deadcode.DeadStores]
drivers/phy/broadcom/phy-brcm-usb.c:233:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/power/supply/ip5xxx_power.c:341 ip5xxx_battery_get_property() error: uninitialized symbol 'raw'.
drivers/usb/gadget/configfs.c:237:8: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/gadget/udc/core.c:1664:9: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/typec/altmodes/displayport.c:396:8: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/usb/typec/rt1719.c:604:18: warning: Assigned value is garbage or undefined [clang-analyzer-core.uninitialized.Assign]
drivers/video/fbdev/matrox/matroxfb_base.c:1094:5: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
drivers/vme/bridges/vme_tsi148.c:754:2: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
kernel/sched/core.c:5268:20: warning: no previous prototype for function 'task_sched_runtime' [-Wmissing-prototypes]
kernel/sched/core.c:8979:6: warning: no previous prototype for 'idle_task_exit' [-Wmissing-prototypes]
kernel/sched/core.c:8979:6: warning: no previous prototype for function 'idle_task_exit' [-Wmissing-prototypes]
kernel/sched/core.c:9214:5: warning: no previous prototype for 'sched_cpu_activate' [-Wmissing-prototypes]
kernel/sched/core.c:9214:5: warning: no previous prototype for function 'sched_cpu_activate' [-Wmissing-prototypes]
kernel/sched/core.c:9259:5: warning: no previous prototype for 'sched_cpu_deactivate' [-Wmissing-prototypes]
kernel/sched/core.c:9259:5: warning: no previous prototype for function 'sched_cpu_deactivate' [-Wmissing-prototypes]
kernel/sched/core.c:9334:5: warning: no previous prototype for 'sched_cpu_starting' [-Wmissing-prototypes]
kernel/sched/core.c:9334:5: warning: no previous prototype for function 'sched_cpu_starting' [-Wmissing-prototypes]
kernel/sched/core.c:9355:5: warning: no previous prototype for 'sched_cpu_wait_empty' [-Wmissing-prototypes]
kernel/sched/core.c:9355:5: warning: no previous prototype for function 'sched_cpu_wait_empty' [-Wmissing-prototypes]
kernel/sched/core.c:9397:5: warning: no previous prototype for 'sched_cpu_dying' [-Wmissing-prototypes]
kernel/sched/core.c:9397:5: warning: no previous prototype for function 'sched_cpu_dying' [-Wmissing-prototypes]
kernel/sched/core.c:9420:13: warning: no previous prototype for function 'sched_init_smp' [-Wmissing-prototypes]
kernel/sched/core.c:9453:13: warning: no previous prototype for function 'sched_init_smp' [-Wmissing-prototypes]
kernel/sched/core.c:9481:13: warning: no previous prototype for function 'sched_init' [-Wmissing-prototypes]
kernel/sched/fair.c:10665:6: warning: no previous prototype for 'nohz_balance_enter_idle' [-Wmissing-prototypes]
kernel/sched/fair.c:10665:6: warning: no previous prototype for function 'nohz_balance_enter_idle' [-Wmissing-prototypes]
kernel/sched/loadavg.c:245:6: warning: no previous prototype for 'calc_load_nohz_start' [-Wmissing-prototypes]
kernel/sched/loadavg.c:245:6: warning: no previous prototype for function 'calc_load_nohz_start' [-Wmissing-prototypes]
kernel/sched/loadavg.c:258:6: warning: no previous prototype for 'calc_load_nohz_remote' [-Wmissing-prototypes]
kernel/sched/loadavg.c:258:6: warning: no previous prototype for function 'calc_load_nohz_remote' [-Wmissing-prototypes]
kernel/sched/loadavg.c:263:6: warning: no previous prototype for 'calc_load_nohz_stop' [-Wmissing-prototypes]
kernel/sched/loadavg.c:263:6: warning: no previous prototype for function 'calc_load_nohz_stop' [-Wmissing-prototypes]
lib/vsprintf.c:2781:5: warning: Null pointer passed as 1st argument to memory copy function [clang-analyzer-unix.cstring.NullArg]
lib/vsprintf.c:2801:12: warning: Dereference of null pointer (loaded from variable 'str') [clang-analyzer-core.NullDereference]
sound/spi/at73c213.c:992:2: warning: Call to function 'sprintf' is insecure as it does not provide bounding of the memory buffer or security checks introduced in the C11 standard. Replace with analogous functions that support length arguments or provides boundary checks such as 'sprintf_s' in case of C11 [clang-analyzer-security.insecureAPI.DeprecatedOrUnsafeBufferHandling]
{standard input}:1989: Error: unknown pseudo-op: `.sec'

Error/Warning ids grouped by kconfigs:

gcc_recent_errors
|-- alpha-allmodconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- alpha-allyesconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-allmodconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-allyesconfig
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
|-- arc-randconfig-m031-20220331
|   |-- drivers-power-supply-ip5xxx_power.c-ip5xxx_battery_get_property()-error:uninitialized-symbol-raw-.
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-randconfig-r031-20220331
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arc-randconfig-r043-20220331
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm-allmodconfig
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
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-PersistentFid-got-restricted-__le64-usertype
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-VolatileFid-got-restricted-__le64-usertype
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
|-- arm64-allmodconfig
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- arm64-allyesconfig
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
|-- h8300-allyesconfig
|   |-- drivers-media-platform-st-stm32-dma2d-dma2d-hw.c:internal-compiler-error:in-extract_insn-at-recog.c
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-allyesconfig
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
|-- i386-randconfig-a003
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-a005
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-a012
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-a014
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-a016
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-c001
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-m021
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- i386-randconfig-s001
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- i386-randconfig-s002
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|   `-- mm-secretmem.c:sparse:sparse:symbol-secretmem_iops-was-not-declared.-Should-it-be-static
|-- ia64-allmodconfig
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-allyesconfig
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
|-- ia64-randconfig-p002-20220331
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- ia64-randconfig-r025-20220331
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- ia64-randconfig-r032-20220331
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|-- m68k-allyesconfig
|   |-- drivers-counter-quad-.c:sparse:sparse:incompatible-types-in-conditional-expression-(different-base-types):
|   |-- drivers-counter-quad-.c:sparse:unsigned-char
|   |-- drivers-counter-quad-.c:sparse:void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-PersistentFid-got-restricted-__le64-usertype
|   `-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-VolatileFid-got-restricted-__le64-usertype
|-- microblaze-buildonly-randconfig-r003-20220331
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- microblaze-randconfig-r003-20220331
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- microblaze-randconfig-s031-20220331
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- mips-allmodconfig
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-PersistentFid-got-restricted-__le64-usertype
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-VolatileFid-got-restricted-__le64-usertype
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
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-PersistentFid-got-restricted-__le64-usertype
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-VolatileFid-got-restricted-__le64-usertype
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
|-- mips-randconfig-c024-20220331
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-10m50_defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-allmodconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-allyesconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- nios2-defconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- openrisc-randconfig-r005-20220331
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- parisc-allyesconfig
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
|-- parisc-generic-32bit_defconfig
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
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-PersistentFid-got-restricted-__le64-usertype
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-VolatileFid-got-restricted-__le64-usertype
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
|-- powerpc-ppc64_defconfig
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
|-- powerpc-randconfig-c003-20220331
|   `-- arch-powerpc-kvm-powerpc.c:error:implicit-declaration-of-function-kvmhv_on_pseries
|-- powerpc-randconfig-r036-20220331
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
|-- powerpc64-randconfig-r006-20220331
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- powerpc64-randconfig-r033-20220331
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_dying
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   `-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_wait_empty
|-- riscv-allmodconfig
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-PersistentFid-got-restricted-__le64-usertype
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-VolatileFid-got-restricted-__le64-usertype
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
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-PersistentFid-got-restricted-__le64-usertype
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-VolatileFid-got-restricted-__le64-usertype
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
|-- riscv-rv32_defconfig
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
|-- s390-allmodconfig
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-PersistentFid-got-restricted-__le64-usertype
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-VolatileFid-got-restricted-__le64-usertype
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
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|   |-- drivers-net-vxlan-vxlan_core.c:sparse:sparse:incorrect-type-in-argument-(different-base-types)-expected-unsigned-int-usertype-b-got-restricted-__be32-usertype-vni
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-PersistentFid-got-restricted-__le64-usertype
|   |-- fs-ksmbd-oplock.c:sparse:sparse:incorrect-type-in-assignment-(different-base-types)-expected-unsigned-long-long-usertype-VolatileFid-got-restricted-__le64-usertype
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
|-- sh-allmodconfig
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|   `-- standard-input:Error:unknown-pseudo-op:sec
|-- sparc-allmodconfig
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
|-- sparc-allyesconfig
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
|-- sparc-randconfig-r013-20220331
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc-randconfig-r015-20220331
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_activate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_deactivate
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-sched_cpu_starting
|   |-- kernel-sched-fair.c:warning:no-previous-prototype-for-nohz_balance_enter_idle
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc-randconfig-r022-20220331
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- sparc64-randconfig-s032-20220331
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-argument-(different-address-spaces)-expected-void-const-volatile-noderef-__iomem-addr-got-void
|   |-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-icr_base-got-void-noderef-__iomem
|   `-- drivers-irqchip-irq-renesas-h8s.c:sparse:sparse:incorrect-type-in-assignment-(different-address-spaces)-expected-void-static-toplevel-ipr_base-got-void-noderef-__iomem
|-- um-defconfig
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
|   |-- :Error:invalid-operands-(-UND-and-.data..percpu-sections)-for
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
|   |-- :Error:invalid-operands-(-UND-and-.data..percpu-sections)-for
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
|-- x86_64-randconfig-a002
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_remote
|   |-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_start
|   `-- kernel-sched-loadavg.c:warning:no-previous-prototype-for-calc_load_nohz_stop
|-- x86_64-randconfig-a004
|   |-- kernel-sched-core.c:warning:no-previous-prototype-for-idle_task_exit
|   |-- kernel-sched-core.c:warning:no-pr
