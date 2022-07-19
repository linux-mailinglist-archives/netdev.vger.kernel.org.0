Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A40757A283
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbiGSO6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbiGSO6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:58:15 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C914A823;
        Tue, 19 Jul 2022 07:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658242688; x=1689778688;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Yxl7yeSunuqqjpCKPa5j0i9hU+UyEBLJJXojTG2z/1A=;
  b=YcCiyllDSliBjP9XBxK2v7b2B9FF1oFVXs/FBkCXLbXcAmJBUlGby0Bn
   PbVKRWPjZxDadfreILnmQ7DwXkcWuruDWh9ZRA4Q86N6H/yDoNOtk+wL2
   jQxRE0yg6aFsdKR69dW8bhsvxlQbMQc91+nh38yediituMwG9BHUnnh0q
   XMyNemZS8E0EmvFUezXIcrMrC77H6lPhTW14/asuvEgpBSPBhdUzVDov/
   S0WZBzT4RYT6Qr9DcuMf9bnm0xRacszmMm+vAu8Cyc4lINcym9b6zSJaN
   1Xmxa9FYAZYCS9CYZs+kaL19HBsHy+kqPG9a3pGbevwo7fuYxCzXxnvFQ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="350474439"
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="xz'?yaml'?scan'208";a="350474439"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 07:58:07 -0700
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="xz'?yaml'?scan'208";a="572877113"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.143])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 07:58:03 -0700
Date:   Tue, 19 Jul 2022 22:57:59 +0800
From:   kernel test robot <oliver.sang@intel.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com
Subject: [selftests]  e71b7f1f44: kernel-selftests.net.fcnal-test.sh.fail
Message-ID: <YtbGd2sGMCEdZQPj@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HtExJog7ZoUxdI0r"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--HtExJog7ZoUxdI0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



Greeting,

FYI, we noticed the following commit (built with gcc-11):

commit: e71b7f1f44d3d88c677769c85ef0171caf9fc89f ("selftests: add ping test with ping_group_range tuned")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

in testcase: kernel-selftests
version: kernel-selftests-x86_64-cebf67a3-1_20220613
with following parameters:

	group: net
	test: fcnal-test.sh
	atomic_test: ipv6_ping
	ucode: 0xec

test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
test-url: https://www.kernel.org/doc/Documentation/kselftest.txt


on test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz with 28G memory

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):




If you fix the issue, kindly add following tag
Reported-by: kernel test robot <oliver.sang@intel.com>



# selftests: net: fcnal-test.sh
# 
# ###########################################################################
# IPv6 ping
# ###########################################################################
# 
# 
# #################################################################
# No VRF
# 
# SYSCTL: net.ipv4.raw_l3mdev_accept=0
# 
# TEST: ping out - ns-B IPv6                                                    [ OK ]
# TEST: ping out - ns-B loopback IPv6                                           [ OK ]
# TEST: ping out - ns-B IPv6 LLA                                                [ OK ]
# TEST: ping out - multicast IP                                                 [ OK ]
# TEST: ping out, device bind - ns-B IPv6                                       [ OK ]
# TEST: ping out, loopback address bind - ns-B IPv6                             [ OK ]
# TEST: ping out, device bind - ns-B loopback IPv6                              [ OK ]
# TEST: ping out, loopback address bind - ns-B loopback IPv6                    [ OK ]
# TEST: ping in - ns-A IPv6                                                     [ OK ]
# TEST: ping in - ns-A loopback IPv6                                            [ OK ]
# TEST: ping in - ns-A IPv6 LLA                                                 [ OK ]
# TEST: ping in - multicast IP                                                  [ OK ]
# TEST: ping local, no bind - ns-A IPv6                                         [ OK ]
# TEST: ping local, no bind - ns-A loopback IPv6                                [ OK ]
# TEST: ping local, no bind - IPv6 loopback                                     [ OK ]
# TEST: ping local, no bind - ns-A IPv6 LLA                                     [ OK ]
# TEST: ping local, no bind - multicast IP                                      [ OK ]
# TEST: ping local, device bind - ns-A IPv6                                     [ OK ]
# TEST: ping local, device bind - ns-A IPv6 LLA                                 [ OK ]
# TEST: ping local, device bind - multicast IP                                  [ OK ]
# TEST: ping local, device bind - ns-A loopback IPv6                            [ OK ]
# TEST: ping local, device bind - IPv6 loopback                                 [ OK ]
# TEST: ping out, blocked by rule - ns-B loopback IPv6                          [ OK ]
# TEST: ping out, device bind, blocked by rule - ns-B loopback IPv6             [ OK ]
# TEST: ping in, blocked by rule - ns-A loopback IPv6                           [ OK ]
# TEST: ping out, blocked by route - ns-B loopback IPv6                         [ OK ]
# TEST: ping out, device bind, blocked by route - ns-B loopback IPv6            [ OK ]
# TEST: ping in, blocked by route - ns-A loopback IPv6                          [ OK ]
# TEST: ping out, unreachable route - ns-B loopback IPv6                        [ OK ]
# TEST: ping out, device bind, unreachable route - ns-B loopback IPv6           [ OK ]
# SYSCTL: net.ipv4.ping_group_range=0 2147483647
# 
# SYSCTL: net.ipv4.raw_l3mdev_accept=0
# 
# TEST: ping out - ns-B IPv6                                                    [ OK ]
# TEST: ping out - ns-B loopback IPv6                                           [ OK ]
# TEST: ping out - ns-B IPv6 LLA                                                [ OK ]
# TEST: ping out - multicast IP                                                 [ OK ]
# TEST: ping out, device bind - ns-B IPv6                                       [FAIL]
# TEST: ping out, loopback address bind - ns-B IPv6                             [ OK ]
# TEST: ping out, device bind - ns-B loopback IPv6                              [FAIL]
# TEST: ping out, loopback address bind - ns-B loopback IPv6                    [ OK ]
# TEST: ping in - ns-A IPv6                                                     [ OK ]
# TEST: ping in - ns-A loopback IPv6                                            [ OK ]
# TEST: ping in - ns-A IPv6 LLA                                                 [ OK ]
# TEST: ping in - multicast IP                                                  [ OK ]
# TEST: ping local, no bind - ns-A IPv6                                         [ OK ]
# TEST: ping local, no bind - ns-A loopback IPv6                                [ OK ]
# TEST: ping local, no bind - IPv6 loopback                                     [ OK ]
# TEST: ping local, no bind - ns-A IPv6 LLA                                     [ OK ]
# TEST: ping local, no bind - multicast IP                                      [ OK ]
# TEST: ping local, device bind - ns-A IPv6                                     [FAIL]
# TEST: ping local, device bind - ns-A IPv6 LLA                                 [FAIL]
# TEST: ping local, device bind - multicast IP                                  [FAIL]
# TEST: ping local, device bind - ns-A loopback IPv6                            [ OK ]
# TEST: ping local, device bind - IPv6 loopback                                 [ OK ]
# TEST: ping out, blocked by rule - ns-B loopback IPv6                          [ OK ]
# TEST: ping out, device bind, blocked by rule - ns-B loopback IPv6             [ OK ]
# TEST: ping in, blocked by rule - ns-A loopback IPv6                           [ OK ]
# TEST: ping out, blocked by route - ns-B loopback IPv6                         [ OK ]
# TEST: ping out, device bind, blocked by route - ns-B loopback IPv6            [ OK ]
# TEST: ping in, blocked by route - ns-A loopback IPv6                          [ OK ]
# TEST: ping out, unreachable route - ns-B loopback IPv6                        [ OK ]
# TEST: ping out, device bind, unreachable route - ns-B loopback IPv6           [ OK ]
# 
# #################################################################
# With VRF
# 
# SYSCTL: net.ipv4.raw_l3mdev_accept=1
# 
# TEST: ping out, VRF bind - ns-B IPv6                                          [ OK ]
# TEST: ping out, VRF bind - ns-B loopback IPv6                                 [ OK ]
# TEST: ping out, VRF bind - ns-B IPv6 LLA                                      [ OK ]
# TEST: ping out, VRF bind - multicast IP                                       [ OK ]
# TEST: ping out, device bind - ns-B IPv6                                       [ OK ]
# TEST: ping out, device bind - ns-B loopback IPv6                              [ OK ]
# TEST: ping out, device bind - ns-B IPv6 LLA                                   [ OK ]
# TEST: ping out, device bind - multicast IP                                    [ OK ]
# TEST: ping out, vrf device+address bind - ns-B IPv6                           [ OK ]
# TEST: ping out, vrf device+address bind - ns-B loopback IPv6                  [ OK ]
# TEST: ping out, vrf device+address bind - ns-B IPv6 LLA                       [ OK ]
# TEST: ping in - ns-A IPv6                                                     [ OK ]
# TEST: ping in - VRF IPv6                                                      [ OK ]
# TEST: ping in - ns-A IPv6 LLA                                                 [ OK ]
# TEST: ping in - multicast IP                                                  [ OK ]
# TEST: ping in - ns-A loopback IPv6                                            [ OK ]
# TEST: ping local, VRF bind - ns-A IPv6                                        [ OK ]
# TEST: ping local, VRF bind - VRF IPv6                                         [ OK ]
# TEST: ping local, VRF bind - IPv6 loopback                                    [ OK ]
# TEST: ping local, device bind - ns-A IPv6                                     [ OK ]
# TEST: ping local, device bind - ns-A IPv6 LLA                                 [ OK ]
# TEST: ping local, device bind - multicast IP                                  [ OK ]
# TEST: ping in, LLA to GUA - ns-A IPv6                                         [ OK ]
# TEST: ping in, LLA to GUA - VRF IPv6                                          [ OK ]
# TEST: ping out, blocked by rule - ns-B loopback IPv6                          [ OK ]
# TEST: ping out, device bind, blocked by rule - ns-B loopback IPv6             [ OK ]
# TEST: ping in, blocked by rule - ns-A loopback IPv6                           [ OK ]
# TEST: ping out, unreachable route - ns-B loopback IPv6                        [ OK ]
# TEST: ping out, device bind, unreachable route - ns-B loopback IPv6           [ OK ]
# TEST: ping in, unreachable route - ns-A loopback IPv6                         [ OK ]
# SYSCTL: net.ipv4.ping_group_range=0 2147483647
# 
# SYSCTL: net.ipv4.raw_l3mdev_accept=1
# 
# TEST: ping out, VRF bind - ns-B IPv6                                          [FAIL]
# TEST: ping out, VRF bind - ns-B loopback IPv6                                 [FAIL]
# TEST: ping out, VRF bind - ns-B IPv6 LLA                                      [ OK ]
# TEST: ping out, VRF bind - multicast IP                                       [ OK ]
# TEST: ping out, device bind - ns-B IPv6                                       [FAIL]
# TEST: ping out, device bind - ns-B loopback IPv6                              [FAIL]
# TEST: ping out, device bind - ns-B IPv6 LLA                                   [FAIL]
# TEST: ping out, device bind - multicast IP                                    [FAIL]
# TEST: ping out, vrf device+address bind - ns-B IPv6                           [ OK ]
# TEST: ping out, vrf device+address bind - ns-B loopback IPv6                  [ OK ]
# TEST: ping out, vrf device+address bind - ns-B IPv6 LLA                       [FAIL]
# TEST: ping in - ns-A IPv6                                                     [ OK ]
# TEST: ping in - VRF IPv6                                                      [ OK ]
# TEST: ping in - ns-A IPv6 LLA                                                 [ OK ]
# TEST: ping in - multicast IP                                                  [ OK ]
# TEST: ping in - ns-A loopback IPv6                                            [ OK ]
# TEST: ping local, VRF bind - ns-A IPv6                                        [FAIL]
# TEST: ping local, VRF bind - VRF IPv6                                         [FAIL]
# TEST: ping local, VRF bind - IPv6 loopback                                    [FAIL]
# TEST: ping local, device bind - ns-A IPv6                                     [FAIL]
# TEST: ping local, device bind - ns-A IPv6 LLA                                 [FAIL]
# TEST: ping local, device bind - multicast IP                                  [FAIL]
# TEST: ping in, LLA to GUA - ns-A IPv6                                         [ OK ]
# TEST: ping in, LLA to GUA - VRF IPv6                                          [ OK ]
# TEST: ping out, blocked by rule - ns-B loopback IPv6                          [ OK ]
# TEST: ping out, device bind, blocked by rule - ns-B loopback IPv6             [ OK ]
# TEST: ping in, blocked by rule - ns-A loopback IPv6                           [ OK ]
# TEST: ping out, unreachable route - ns-B loopback IPv6                        [ OK ]
# TEST: ping out, device bind, unreachable route - ns-B loopback IPv6           [ OK ]
# TEST: ping in, unreachable route - ns-A loopback IPv6                         [ OK ]
# 
# Tests passed: 102
# Tests failed:  18
not ok 1 selftests: net: fcnal-test.sh # exit=1


To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        sudo bin/lkp install job.yaml           # job file is attached in this email
        bin/lkp split-job --compatible job.yaml # generate the yaml file for lkp run
        sudo bin/lkp run generated-yaml-file

        # if come across any failure that blocks the test,
        # please remove ~/.lkp and /lkp dir to run from a clean state.



-- 
0-DAY CI Kernel Test Service
https://01.org/lkp



--HtExJog7ZoUxdI0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="config-5.18.0-rc5-00105-ge71b7f1f44d3"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.18.0-rc5 Kernel Configuration
#
CONFIG_CC_VERSION_TEXT="gcc-11 (Debian 11.3.0-3) 11.3.0"
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=110300
CONFIG_CLANG_VERSION=0
CONFIG_AS_IS_GNU=y
CONFIG_AS_VERSION=23800
CONFIG_LD_IS_BFD=y
CONFIG_LD_VERSION=23800
CONFIG_LLD_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
CONFIG_PAHOLE_VERSION=123
CONFIG_CONSTRUCTORS=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
# CONFIG_WERROR is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_HAVE_KERNEL_ZSTD=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
# CONFIG_KERNEL_ZSTD is not set
CONFIG_DEFAULT_INIT=""
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_WATCH_QUEUE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_USELIB is not set
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_GENERIC_IRQ_INJECTION=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=100
# end of Timers subsystem

CONFIG_BPF=y
CONFIG_HAVE_EBPF_JIT=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y

#
# BPF subsystem
#
CONFIG_BPF_SYSCALL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
# CONFIG_BPF_PRELOAD is not set
# CONFIG_BPF_LSM is not set
# end of BPF subsystem

CONFIG_PREEMPT_VOLUNTARY_BUILD=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
# CONFIG_PREEMPT_DYNAMIC is not set
# CONFIG_SCHED_CORE is not set

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU_GENERIC=y
CONFIG_TASKS_RUDE_RCU=y
CONFIG_TASKS_TRACE_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
# CONFIG_PRINTK_INDEX is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# CONFIG_UCLAMP_TASK is not set
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_MISC is not set
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_RD_ZSTD=y
# CONFIG_BOOT_CONFIG is not set
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_LD_ORPHAN_WARN=y
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_KCMP=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_GUEST_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
CONFIG_SLAB_FREELIST_RANDOM=y
CONFIG_SLAB_FREELIST_HARDENED=y
CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_NR_GPIO=1024
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_AUDIT_ARCH=y
CONFIG_KASAN_SHADOW_OFFSET=0xdffffc0000000000
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_CC_HAS_SLS=y
# CONFIG_SLS is not set
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_AMD_PLATFORM_DEVICE is not set
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_CLUSTER=y
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=m
CONFIG_PERF_EVENTS_INTEL_RAPL=m
CONFIG_PERF_EVENTS_INTEL_CSTATE=m
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# CONFIG_PERF_EVENTS_AMD_UNCORE is not set
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
# CONFIG_AMD_MEM_ENCRYPT is not set
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
# CONFIG_ARCH_MEMORY_PROBE is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_UMIP=y
CONFIG_CC_HAS_IBT=y
# CONFIG_X86_KERNEL_IBT is not set
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_X86_SGX=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
# CONFIG_STRICT_SIGALTSTACK_SIZE is not set
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_HIBERNATION_SNAPSHOT_DEV=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_ADVANCED_DEBUG is not set
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
# CONFIG_ACPI_FPDT is not set
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_TAD=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_PLATFORM_PROFILE=m
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_ACPI_DPTF is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_ACPI_CONFIGFS is not set
# CONFIG_ACPI_PFRUT is not set
CONFIG_ACPI_PCC=y
CONFIG_PMIC_OPREGION=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_PRMT=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_AMD_PSTATE is not set
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32_ABI is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
# end of Binary Emulations

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_PFNCACHE=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_DIRTY_RING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_KVM_XFER_TO_GUEST_WORK=y
CONFIG_HAVE_KVM_PM_NOTIFIER=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_WERROR is not set
CONFIG_KVM_INTEL=y
# CONFIG_X86_SGX_KVM is not set
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_XEN is not set
CONFIG_AS_AVX512=y
CONFIG_AS_SHA1_NI=y
CONFIG_AS_SHA256_NI=y
CONFIG_AS_TPAUSE=y

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_GENERIC_ENTRY=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
# CONFIG_STATIC_CALL_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_KRETPROBE_ON_RETHOOK=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_ARCH_WANTS_NO_INSTR=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
# CONFIG_SECCOMP_CACHE_DEBUG is not set
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_LTO_NONE=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_CONTEXT_TRACKING_OFFSTACK=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PUD=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_HAVE_ARCH_HUGE_VMALLOC=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET=y
CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y
CONFIG_HAVE_STATIC_CALL=y
CONFIG_HAVE_STATIC_CALL_INLINE=y
CONFIG_HAVE_PREEMPT_DYNAMIC=y
CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SUPPORTS_PAGE_TABLE_CHECK=y
CONFIG_ARCH_HAS_ELFCORE_COMPAT=y
CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
CONFIG_DYNAMIC_SIGFRAME=y
CONFIG_HAVE_ARCH_NODE_DEV_GROUP=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# CONFIG_GCC_PLUGIN_RANDSTRUCT is not set
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
CONFIG_MODULE_COMPRESS_NONE=y
# CONFIG_MODULE_COMPRESS_GZIP is not set
# CONFIG_MODULE_COMPRESS_XZ is not set
# CONFIG_MODULE_COMPRESS_ZSTD is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
CONFIG_MODPROBE_PATH="/sbin/modprobe"
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLOCK_LEGACY_AUTOLOAD=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG_COMMON=y
CONFIG_BLK_ICQ=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
# CONFIG_BLK_DEV_ZONED is not set
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
CONFIG_BLK_WBT=y
CONFIG_BLK_WBT_MQ=y
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
# CONFIG_BLK_CGROUP_IOPRIO is not set
CONFIG_BLK_DEBUG_FS=y
# CONFIG_BLK_SED_OPAL is not set
# CONFIG_BLK_INLINE_ENCRYPTION is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_PM=y
CONFIG_BLOCK_HOLDER_DEPRECATED=y
CONFIG_BLK_MQ_STACKING=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
CONFIG_IOSCHED_BFQ=y
CONFIG_BFQ_GROUP_IOSCHED=y
# CONFIG_BFQ_CGROUP_DEBUG is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SPARSEMEM=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_NUMA_KEEP_MEMINFO=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_EXCLUSIVE_SYSTEM_RAM=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_MHP_MEMMAP_ON_MEMORY=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_PAGE_REPORTING=y
CONFIG_MIGRATION=y
CONFIG_DEVICE_MIGRATION=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_FRONTSWAP=y
# CONFIG_CMA is not set
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSWAP=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_DEFLATE is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZO=y
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_842 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4 is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_LZ4HC is not set
# CONFIG_ZSWAP_COMPRESSOR_DEFAULT_ZSTD is not set
CONFIG_ZSWAP_COMPRESSOR_DEFAULT="lzo"
CONFIG_ZSWAP_ZPOOL_DEFAULT_ZBUD=y
# CONFIG_ZSWAP_ZPOOL_DEFAULT_Z3FOLD is not set
# CONFIG_ZSWAP_ZPOOL_DEFAULT_ZSMALLOC is not set
CONFIG_ZSWAP_ZPOOL_DEFAULT="zbud"
# CONFIG_ZSWAP_DEFAULT_ON is not set
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
CONFIG_ZSMALLOC_STAT=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_PAGE_IDLE_FLAG=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ARCH_HAS_ZONE_DMA_SET=y
CONFIG_ZONE_DMA=y
CONFIG_ZONE_DMA32=y
CONFIG_ZONE_DEVICE=y
CONFIG_HMM_MIRROR=y
CONFIG_DEVICE_PRIVATE=y
CONFIG_VMAP_PFN=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
CONFIG_GUP_TEST=y
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
# CONFIG_ANON_VMA_NAME is not set

#
# Data Access Monitoring
#
CONFIG_DAMON=y
CONFIG_DAMON_VADDR=y
CONFIG_DAMON_PADDR=y
# CONFIG_DAMON_SYSFS is not set
CONFIG_DAMON_DBGFS=y
# CONFIG_DAMON_RECLAIM is not set
# end of Data Access Monitoring
# end of Memory Management options

CONFIG_NET=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_NET_REDIRECT=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_AF_UNIX_OOB=y
CONFIG_UNIX_DIAG=m
CONFIG_TLS=m
CONFIG_TLS_DEVICE=y
# CONFIG_TLS_TOE is not set
CONFIG_XFRM=y
CONFIG_XFRM_OFFLOAD=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_USER_COMPAT is not set
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_AH=m
CONFIG_XFRM_ESP=m
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_XDP_SOCKETS=y
# CONFIG_XDP_SOCKETS_DIAG is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=y
CONFIG_NET_FOU=y
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_ESP_OFFLOAD=m
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
CONFIG_INET_RAW_DIAG=m
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_NV=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
CONFIG_TCP_CONG_BBR=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_ESP_OFFLOAD=m
# CONFIG_INET6_ESPINTCP is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=y
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
CONFIG_IPV6_GRE=y
CONFIG_IPV6_FOU=y
CONFIG_IPV6_FOU_TUNNEL=y
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=y
# CONFIG_IPV6_RPL_LWTUNNEL is not set
CONFIG_IPV6_IOAM6_LWTUNNEL=y
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_INET_MPTCP_DIAG=m
CONFIG_MPTCP_IPV6=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_EGRESS=y
CONFIG_NETFILTER_SKIP_EGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
# CONFIG_NETFILTER_NETLINK_HOOK is not set
# CONFIG_NETFILTER_NETLINK_ACCT is not set
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_SYSLOG=m
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
CONFIG_NF_CT_NETLINK_HELPER=m
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
CONFIG_NF_TABLES_INET=y
CONFIG_NF_TABLES_NETDEV=y
CONFIG_NFT_NUMGEN=m
CONFIG_NFT_CT=m
CONFIG_NFT_FLOW_OFFLOAD=m
CONFIG_NFT_CONNLIMIT=m
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
CONFIG_NFT_NAT=m
# CONFIG_NFT_TUNNEL is not set
CONFIG_NFT_OBJREF=m
CONFIG_NFT_QUEUE=m
CONFIG_NFT_QUOTA=m
CONFIG_NFT_REJECT=m
CONFIG_NFT_REJECT_INET=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
CONFIG_NFT_FIB=m
CONFIG_NFT_FIB_INET=m
# CONFIG_NFT_XFRM is not set
CONFIG_NFT_SOCKET=m
# CONFIG_NFT_OSF is not set
CONFIG_NFT_TPROXY=m
CONFIG_NFT_SYNPROXY=m
CONFIG_NF_DUP_NETDEV=m
CONFIG_NFT_DUP_NETDEV=m
CONFIG_NFT_FWD_NETDEV=m
CONFIG_NFT_FIB_NETDEV=m
# CONFIG_NFT_REJECT_NETDEV is not set
CONFIG_NF_FLOW_TABLE_INET=m
CONFIG_NF_FLOW_TABLE=m
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XTABLES_COMPAT=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
# CONFIG_NETFILTER_XT_TARGET_LED is not set
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
# CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m
# CONFIG_IP_VS_TWOS is not set

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_REJECT_IPV4=m
CONFIG_NFT_DUP_IPV4=m
CONFIG_NFT_FIB_IPV4=m
CONFIG_NF_TABLES_ARP=y
CONFIG_NF_DUP_IPV4=m
CONFIG_NF_LOG_ARP=m
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
# CONFIG_IP_NF_TARGET_CLUSTERIP is not set
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
CONFIG_NF_TABLES_IPV6=y
CONFIG_NFT_REJECT_IPV6=m
CONFIG_NFT_DUP_IPV6=m
CONFIG_NFT_FIB_IPV6=m
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
# CONFIG_IP6_NF_TARGET_HL is not set
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_TABLES_BRIDGE=m
# CONFIG_NFT_BRIDGE_META is not set
CONFIG_NFT_BRIDGE_REJECT=m
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
CONFIG_TIPC=m
CONFIG_TIPC_MEDIA_UDP=y
CONFIG_TIPC_CRYPTO=y
CONFIG_TIPC_DIAG=m
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=y
CONFIG_GARP=y
CONFIG_MRP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
# CONFIG_BRIDGE_MRP is not set
# CONFIG_BRIDGE_CFM is not set
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=y
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
# CONFIG_6LOWPAN_NHC is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
CONFIG_NET_SCH_ETF=m
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=y
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
CONFIG_NET_SCH_HHF=m
CONFIG_NET_SCH_PIE=m
CONFIG_NET_SCH_FQ_PIE=m
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=m
CONFIG_NET_SCH_ETS=m
CONFIG_NET_SCH_DEFAULT=y
# CONFIG_DEFAULT_FQ is not set
# CONFIG_DEFAULT_CODEL is not set
CONFIG_DEFAULT_FQ_CODEL=y
# CONFIG_DEFAULT_FQ_PIE is not set
# CONFIG_DEFAULT_SFQ is not set
# CONFIG_DEFAULT_PFIFO_FAST is not set
CONFIG_DEFAULT_NET_SCH="fq_codel"

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_EMATCH_CANID=m
CONFIG_NET_EMATCH_IPSET=m
CONFIG_NET_EMATCH_IPT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_ACT_MPLS=m
CONFIG_NET_ACT_VLAN=m
CONFIG_NET_ACT_BPF=m
CONFIG_NET_ACT_CONNMARK=m
CONFIG_NET_ACT_CTINFO=m
CONFIG_NET_ACT_SKBMOD=m
CONFIG_NET_ACT_IFE=m
CONFIG_NET_ACT_TUNNEL_KEY=m
CONFIG_NET_ACT_CT=m
# CONFIG_NET_ACT_GATE is not set
CONFIG_NET_IFE_SKBMARK=m
CONFIG_NET_IFE_SKBPRIO=m
CONFIG_NET_IFE_SKBTCINDEX=m
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_OPENVSWITCH_GENEVE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=m
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=y
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_QRTR is not set
# CONFIG_NET_NCSI is not set
CONFIG_PCPU_DEV_REFCNT=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_SOCK_RX_QUEUE_MAPPING=y
CONFIG_XPS=y
CONFIG_CGROUP_NET_PRIO=y
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set
# CONFIG_CAN_ISOTP is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# CONFIG_CAN_MCP251XFD is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
# CONFIG_CAN_8DEV_USB is not set
# CONFIG_CAN_EMS_USB is not set
# CONFIG_CAN_ESD_USB2 is not set
# CONFIG_CAN_ETAS_ES58X is not set
# CONFIG_CAN_GS_USB is not set
# CONFIG_CAN_KVASER_USB is not set
# CONFIG_CAN_MCBA_USB is not set
# CONFIG_CAN_PEAK_USB is not set
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
# CONFIG_MCTP is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
# CONFIG_CFG80211_WEXT is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_FD=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
CONFIG_NFC=m
# CONFIG_NFC_DIGITAL is not set
CONFIG_NFC_NCI=m
# CONFIG_NFC_NCI_SPI is not set
# CONFIG_NFC_NCI_UART is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
CONFIG_NFC_VIRTUAL_NCI=m
# CONFIG_NFC_FDP is not set
# CONFIG_NFC_PN533_USB is not set
# CONFIG_NFC_PN533_I2C is not set
# CONFIG_NFC_MRVL_USB is not set
# CONFIG_NFC_ST_NCI_I2C is not set
# CONFIG_NFC_ST_NCI_SPI is not set
# CONFIG_NFC_NXP_NCI is not set
# CONFIG_NFC_S3FWRN5_I2C is not set
# end of Near Field Communication (NFC) devices

CONFIG_PSAMPLE=m
CONFIG_NET_IFE=m
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_SOCK_VALIDATE_XMIT=y
CONFIG_NET_SELFTESTS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
# CONFIG_PAGE_POOL_STATS is not set
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCIE_DPC=y
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_EDR is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
CONFIG_PCI_PF_STUB=m
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
# CONFIG_PCIE_BUS_TUNE_OFF is not set
CONFIG_PCIE_BUS_DEFAULT=y
# CONFIG_PCIE_BUS_SAFE is not set
# CONFIG_PCIE_BUS_PERFORMANCE is not set
# CONFIG_PCIE_BUS_PEER2PEER is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support

#
# Mobiveil PCIe Core Support
#
# end of Mobiveil PCIe Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

# CONFIG_CXL_BUS is not set
# CONFIG_PCCARD is not set
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_AUXILIARY_BUS=y
# CONFIG_UEVENT_HELPER is not set
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
# CONFIG_DEVTMPFS_SAFE is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# end of Firmware loader

CONFIG_ALLOW_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# CONFIG_MHI_BUS is not set
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y

#
# Firmware Drivers
#

#
# ARM System Control and Management Interface Protocol
#
# end of ARM System Control and Management Interface Protocol

CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT is not set
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
CONFIG_SYSFB=y
# CONFIG_SYSFB_SIMPLEFB is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_EFI_GENERIC_STUB_INITRD_CMDLINE_LOADER=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
# CONFIG_APPLE_PROPERTIES is not set
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_EARLYCON=y
CONFIG_EFI_CUSTOM_SSDT_OVERLAYS=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

# CONFIG_GNSS is not set
# CONFIG_MTD is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
# CONFIG_BLK_DEV_FD is not set
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
CONFIG_ZRAM=m
CONFIG_ZRAM_DEF_COMP_LZORLE=y
# CONFIG_ZRAM_DEF_COMP_LZO is not set
CONFIG_ZRAM_DEF_COMP="lzo-rle"
CONFIG_ZRAM_WRITEBACK=y
# CONFIG_ZRAM_MEMORY_TRACKING is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=m
CONFIG_BLK_DEV_RBD=m

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_VERBOSE_ERRORS is not set
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_FC is not set
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=m
# CONFIG_NVME_TARGET_PASSTHRU is not set
CONFIG_NVME_TARGET_LOOP=m
CONFIG_NVME_TARGET_FC=m
# CONFIG_NVME_TARGET_TCP is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_DW_XDATA_PCIE is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_MISC_RTSX=m
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_HDCP is not set
# CONFIG_INTEL_MEI_PXP is not set
CONFIG_VMWARE_VMCI=m
# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_BCM_VK is not set
# CONFIG_MISC_ALCOR_PCI is not set
CONFIG_MISC_RTSX_PCI=m
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# CONFIG_UACCE is not set
CONFIG_PVPANIC=y
# CONFIG_PVPANIC_MMIO is not set
# CONFIG_PVPANIC_PCI is not set
# end of Misc devices

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI_COMMON=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_CHR_DEV_SG=m
CONFIG_BLK_DEV_BSG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS is not set
# CONFIG_SCSI_MPI3MR is not set
# CONFIG_SCSI_SMARTPQI is not set
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_EFCT is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_BFA_FC is not set
# CONFIG_SCSI_VIRTIO is not set
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_SATA_HOST=y
CONFIG_PATA_TIMINGS=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_FORCE=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
CONFIG_MD_FAULTY=m
CONFIG_MD_CLUSTER=m
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
CONFIG_DM_WRITECACHE=m
# CONFIG_DM_EBS is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
# CONFIG_DM_MULTIPATH_HST is not set
# CONFIG_DM_MULTIPATH_IOA is not set
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
CONFIG_DM_INTEGRITY=m
CONFIG_DM_AUDIT=y
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_ISCSI_TARGET=m
# CONFIG_SBP_TARGET is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=y
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
CONFIG_IFB=m
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=y
CONFIG_GENEVE=y
CONFIG_BAREUDP=m
# CONFIG_GTP is not set
CONFIG_AMT=m
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_TUN=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=y
CONFIG_VIRTIO_NET=m
# CONFIG_NLMON is not set
CONFIG_NET_VRF=y
# CONFIG_VSOCKMON is not set
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
# CONFIG_ATM_TCP is not set
# CONFIG_ATM_LANAI is not set
# CONFIG_ATM_ENI is not set
# CONFIG_ATM_FIRESTREAM is not set
# CONFIG_ATM_ZATM is not set
# CONFIG_ATM_NICSTAR is not set
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
# CONFIG_ATM_FORE200E is not set
# CONFIG_ATM_HE is not set
# CONFIG_ATM_SOLOS is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
CONFIG_NET_VENDOR_ALTEON=y
# CONFIG_ACENIC is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
# CONFIG_ENA_ETHERNET is not set
# CONFIG_NET_VENDOR_AMD is not set
CONFIG_NET_VENDOR_AQUANTIA=y
# CONFIG_AQTION is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ASIX=y
# CONFIG_SPI_AX88796C is not set
CONFIG_NET_VENDOR_ATHEROS=y
# CONFIG_ATL2 is not set
# CONFIG_ATL1 is not set
# CONFIG_ATL1E is not set
# CONFIG_ATL1C is not set
# CONFIG_ALX is not set
# CONFIG_CX_ECAT is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
# CONFIG_BCMGENET is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2X is not set
# CONFIG_SYSTEMPORT is not set
# CONFIG_BNXT is not set
CONFIG_NET_VENDOR_CADENCE=y
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
# CONFIG_LIQUIDIO is not set
# CONFIG_LIQUIDIO_VF is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
CONFIG_NET_VENDOR_CORTINA=y
CONFIG_NET_VENDOR_DAVICOM=y
# CONFIG_DM9051 is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_ENGLEDER=y
# CONFIG_TSNEP is not set
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_FUNGIBLE=y
# CONFIG_FUN_ETH is not set
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBE_DCB is not set
CONFIG_IXGBE_IPSEC=y
# CONFIG_IXGBEVF is not set
CONFIG_I40E=y
# CONFIG_I40E_DCB is not set
# CONFIG_I40EVF is not set
# CONFIG_ICE is not set
# CONFIG_FM10K is not set
CONFIG_IGC=y
# CONFIG_JME is not set
CONFIG_NET_VENDOR_LITEX=y
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_PRESTERA is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8842 is not set
# CONFIG_KS8851 is not set
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MICROCHIP=y
# CONFIG_ENC28J60 is not set
# CONFIG_ENCX24J600 is not set
# CONFIG_LAN743X is not set
CONFIG_NET_VENDOR_MICROSEMI=y
CONFIG_NET_VENDOR_MICROSOFT=y
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
# CONFIG_NFP is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_NE2K_PCI is not set
CONFIG_NET_VENDOR_NVIDIA=y
# CONFIG_FORCEDETH is not set
CONFIG_NET_VENDOR_OKI=y
# CONFIG_ETHOC is not set
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_NETXEN_NIC is not set
# CONFIG_QED is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
# CONFIG_8139CP is not set
# CONFIG_8139TOO is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
# CONFIG_ROCKER is not set
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
# CONFIG_SIS900 is not set
# CONFIG_SIS190 is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
# CONFIG_SFC is not set
# CONFIG_SFC_FALCON is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_SOCIONEXT=y
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VERTEXCOM=y
# CONFIG_MSE102X is not set
CONFIG_NET_VENDOR_VIA=y
# CONFIG_VIA_RHINE is not set
# CONFIG_VIA_VELOCITY is not set
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_EMACLITE is not set
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set
CONFIG_FIXED_PHY=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
# CONFIG_ADIN_PHY is not set
# CONFIG_AQUANTIA_PHY is not set
CONFIG_AX88796B_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM54140_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
# CONFIG_BCM84881_PHY is not set
# CONFIG_BCM87XX_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_CORTINA_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_INTEL_XWAY_PHY is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_MARVELL_88X2222_PHY is not set
# CONFIG_MAXLINEAR_GPHY is not set
# CONFIG_MEDIATEK_GE_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
# CONFIG_MOTORCOMM_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_NXP_C45_TJA11XX_PHY is not set
# CONFIG_NXP_TJA11XX_PHY is not set
# CONFIG_QSEMI_PHY is not set
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
# CONFIG_SMSC_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_TERANETICS_PHY is not set
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
CONFIG_FWNODE_MDIO=y
CONFIG_ACPI_MDIO=y
CONFIG_MDIO_DEVRES=y
# CONFIG_MDIO_BITBANG is not set
# CONFIG_MDIO_BCM_UNIMAC is not set
# CONFIG_MDIO_MVUSB is not set
# CONFIG_MDIO_THUNDER is not set

#
# MDIO Multiplexers
#

#
# PCS device drivers
#
# CONFIG_PCS_XPCS is not set
# end of PCS device drivers

# CONFIG_PLIP is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
CONFIG_USB_NET_DRIVERS=y
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_RTL8152=y
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
# CONFIG_USB_NET_CDCETHER is not set
# CONFIG_USB_NET_CDC_EEM is not set
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_HUAWEI_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
# CONFIG_USB_NET_DM9601 is not set
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
# CONFIG_USB_NET_SMSC75XX is not set
# CONFIG_USB_NET_SMSC95XX is not set
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
# CONFIG_USB_NET_MCS7830 is not set
# CONFIG_USB_NET_RNDIS_HOST is not set
# CONFIG_USB_NET_CDC_SUBSET is not set
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
# CONFIG_USB_HSO is not set
# CONFIG_USB_NET_INT51X1 is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_USB_SIERRA_NET is not set
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
# CONFIG_ATH9K is not set
# CONFIG_ATH9K_HTC is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
# CONFIG_ATH11K is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_IWLMEI is not set
CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
CONFIG_WLAN_VENDOR_MICROCHIP=y
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
CONFIG_RTL_CARDS=m
# CONFIG_RTL8192CE is not set
# CONFIG_RTL8192SE is not set
# CONFIG_RTL8192DE is not set
# CONFIG_RTL8723AE is not set
# CONFIG_RTL8723BE is not set
# CONFIG_RTL8188EE is not set
# CONFIG_RTL8192EE is not set
# CONFIG_RTL8821AE is not set
# CONFIG_RTL8192CU is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
# CONFIG_RTW89 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set
# CONFIG_WAN is not set
CONFIG_IEEE802154_DRIVERS=m
# CONFIG_IEEE802154_FAKELB is not set
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set

#
# Wireless WAN
#
# CONFIG_WWAN is not set
# end of Wireless WAN

# CONFIG_VMXNET3 is not set
# CONFIG_FUJITSU_ES is not set
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set
CONFIG_INPUT_VIVALDIFMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CYPRESS_SF is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=m
CONFIG_MOUSE_ELAN_I2C=m
CONFIG_MOUSE_ELAN_I2C_I2C=y
CONFIG_MOUSE_ELAN_I2C_SMBUS=y
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set
CONFIG_RMI4_CORE=m
CONFIG_RMI4_I2C=m
CONFIG_RMI4_SPI=m
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
CONFIG_RMI4_F34=y
# CONFIG_RMI4_F3A is not set
CONFIG_RMI4_F55=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_LDISC_AUTOLOAD=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=64
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y
CONFIG_SERIAL_8250_PERICOM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_LANTIQ is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# CONFIG_SERIAL_SPRD is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_NOZOMI=m
# CONFIG_NULL_TTY is not set
CONFIG_HVC_DRIVER=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_BA431 is not set
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
# CONFIG_HW_RANDOM_XIPHERA is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_DEVMEM=y
CONFIG_NVRAM=y
CONFIG_DEVPORT=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
# CONFIG_TCG_TIS_I2C_CR50 is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
# CONFIG_XILLYBUS is not set
# CONFIG_XILLYUSB is not set
# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set
# end of Character devices

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
CONFIG_I2C_MUX_MLXCPLD=m
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_AMDPSP is not set
CONFIG_I2C_DESIGNWARE_BAYTRAIL=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_CP2615 is not set
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_MLXCPLD=m
# CONFIG_I2C_VIRTIO is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_LANTIQ_SSC is not set
# CONFIG_SPI_OC_TINY is not set
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set
# CONFIG_SPI_AMD is not set

#
# SPI Multiplexer support
#
# CONFIG_SPI_MUX is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
CONFIG_SPI_DYNAMIC=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_PTP_1588_CLOCK_OPTIONAL=y
# CONFIG_DP83640_PHY is not set
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDT82P33 is not set
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# CONFIG_PTP_1588_CLOCK_VMW is not set
# end of PTP clock support

CONFIG_PINCTRL=y
# CONFIG_DEBUG_PINCTRL is not set
# CONFIG_PINCTRL_AMD is not set
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set

#
# Intel pinctrl drivers
#
# CONFIG_PINCTRL_BAYTRAIL is not set
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
# CONFIG_PINCTRL_ALDERLAKE is not set
# CONFIG_PINCTRL_BROXTON is not set
# CONFIG_PINCTRL_CANNONLAKE is not set
# CONFIG_PINCTRL_CEDARFORK is not set
# CONFIG_PINCTRL_DENVERTON is not set
# CONFIG_PINCTRL_ELKHARTLAKE is not set
# CONFIG_PINCTRL_EMMITSBURG is not set
# CONFIG_PINCTRL_GEMINILAKE is not set
# CONFIG_PINCTRL_ICELAKE is not set
# CONFIG_PINCTRL_JASPERLAKE is not set
# CONFIG_PINCTRL_LAKEFIELD is not set
# CONFIG_PINCTRL_LEWISBURG is not set
# CONFIG_PINCTRL_SUNRISEPOINT is not set
# CONFIG_PINCTRL_TIGERLAKE is not set
# end of Intel pinctrl drivers

#
# Renesas pinctrl drivers
#
# end of Renesas pinctrl drivers

CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_CDEV=y
CONFIG_GPIO_CDEV_V1=y

#
# Memory mapped GPIO drivers
#
# CONFIG_GPIO_AMDPT is not set
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCA9570 is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
# end of USB GPIO expanders

#
# Virtual GPIO drivers
#
# CONFIG_GPIO_AGGREGATOR is not set
CONFIG_GPIO_MOCKUP=m
# CONFIG_GPIO_VIRTIO is not set
CONFIG_GPIO_SIM=m
# end of Virtual GPIO drivers

# CONFIG_W1 is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_IP5XXX_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_CW2015 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SAMSUNG_SDI is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_LTC4162L is not set
# CONFIG_CHARGER_MAX77976 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ2515X is not set
# CONFIG_CHARGER_BQ25890 is not set
# CONFIG_CHARGER_BQ25980 is not set
# CONFIG_CHARGER_BQ256XX is not set
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_BATTERY_GOLDFISH is not set
# CONFIG_BATTERY_RT5033 is not set
# CONFIG_CHARGER_RT9455 is not set
# CONFIG_CHARGER_BD99954 is not set
# CONFIG_BATTERY_UG3105 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AHT10 is not set
# CONFIG_SENSORS_AQUACOMPUTER_D5NEXT is not set
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
# CONFIG_SENSORS_AXI_FAN_CONTROL is not set
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_CORSAIR_CPRO is not set
# CONFIG_SENSORS_CORSAIR_PSU is not set
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
# CONFIG_SENSORS_DELL_SMM is not set
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_I5500=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
# CONFIG_SENSORS_LTC2992 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
# CONFIG_SENSORS_MAX127 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6620 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_MLXREG_FAN is not set
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_TPS23861 is not set
# CONFIG_SENSORS_MR75203 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
# CONFIG_SENSORS_NZXT_KRAKEN2 is not set
# CONFIG_SENSORS_NZXT_SMART2 is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
# CONFIG_SENSORS_ADM1266 is not set
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_BPA_RS600 is not set
# CONFIG_SENSORS_DELTA_AHE50DC_FAN is not set
# CONFIG_SENSORS_FSP_3Y is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_DPS920AB is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR36021 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
# CONFIG_SENSORS_MAX15301 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX16601 is not set
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_MP2888 is not set
# CONFIG_SENSORS_MP2975 is not set
# CONFIG_SENSORS_MP5023 is not set
# CONFIG_SENSORS_PIM4328 is not set
# CONFIG_SENSORS_PLI1209BC is not set
# CONFIG_SENSORS_PM6764TR is not set
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_Q54SJ108A2 is not set
# CONFIG_SENSORS_STPDDC60 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
# CONFIG_SENSORS_SBTSI is not set
# CONFIG_SENSORS_SBRMI is not set
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHT4x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
# CONFIG_SENSORS_SY7636A is not set
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA238 is not set
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP464 is not set
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
# CONFIG_SENSORS_ASUS_WMI is not set
# CONFIG_SENSORS_ASUS_WMI_EC is not set
# CONFIG_SENSORS_ASUS_EC is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_NETLINK is not set
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_X86_PKG_TEMP_THERMAL=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
# CONFIG_INT340X_THERMAL is not set
# end of ACPI INT340X thermal drivers

CONFIG_INTEL_PCH_THERMAL=m
# CONFIG_INTEL_TCC_COOLING is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_INTEL_HFI_THERMAL is not set
# end of Intel thermal drivers

CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y
# CONFIG_WATCHDOG_HRTIMER_PRETIMEOUT is not set

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_MLX_WDT is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
# CONFIG_SP5100_TCO is not set
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_MFD_MP2629 is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_INTEL_PMC_BXT is not set
# CONFIG_MFD_IQS62X is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6360 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT4831 is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SIMPLE_MFD_I2C is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_MFD_ATC260X_I2C is not set
# CONFIG_MFD_INTEL_M10_BMC is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_LIRC=y
CONFIG_RC_MAP=m
CONFIG_RC_DECODERS=y
CONFIG_IR_IMON_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_SONY_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_RC_DEVICES=y
CONFIG_IR_ENE=m
CONFIG_IR_FINTEK=m
# CONFIG_IR_IGORPLUGUSB is not set
# CONFIG_IR_IGUANA is not set
# CONFIG_IR_IMON is not set
# CONFIG_IR_IMON_RAW is not set
CONFIG_IR_ITE_CIR=m
# CONFIG_IR_MCEUSB is not set
CONFIG_IR_NUVOTON=m
# CONFIG_IR_REDRAT3 is not set
CONFIG_IR_SERIAL=m
CONFIG_IR_SERIAL_TRANSMITTER=y
# CONFIG_IR_STREAMZAP is not set
# CONFIG_IR_TOY is not set
# CONFIG_IR_TTUSBIR is not set
CONFIG_IR_WINBOND_CIR=m
# CONFIG_RC_ATI_REMOTE is not set
CONFIG_RC_LOOPBACK=m
# CONFIG_RC_XBOX_DVD is not set

#
# CEC support
#
# CONFIG_MEDIA_CEC_SUPPORT is not set
# end of CEC support

CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_SUPPORT_FILTER=y
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y

#
# Media device types
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_PLATFORM_SUPPORT is not set
# CONFIG_MEDIA_TEST_SUPPORT is not set
# end of Media device types

#
# Media drivers
#

#
# Drivers filtered as selected at 'Filter media drivers'
#

#
# Media drivers
#
# CONFIG_MEDIA_USB_SUPPORT is not set
# CONFIG_MEDIA_PCI_SUPPORT is not set
# end of Media drivers

#
# Media ancillary drivers
#
# end of Media ancillary drivers

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_INTEL_GTT=m
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
# CONFIG_DRM_DEBUG_MM is not set
CONFIG_DRM_DEBUG_SELFTEST=m
CONFIG_DRM_DP_HELPER=m
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
CONFIG_DRM_DEBUG_MODESET_LOCK=y
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_BUDDY=m
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set
# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
CONFIG_DRM_I915_GVT=y
# CONFIG_DRM_I915_GVT_KVMGT is not set

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_REQUEST_TIMEOUT=20000
CONFIG_DRM_I915_FENCE_TIMEOUT=10000
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_MAX_REQUEST_BUSYWAIT=8000
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

CONFIG_DRM_VGEM=y
# CONFIG_DRM_VKMS is not set
# CONFIG_DRM_VMWGFX is not set
CONFIG_DRM_GMA500=m
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=m
# CONFIG_DRM_MGAG200 is not set
CONFIG_DRM_QXL=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# CONFIG_DRM_PANEL_WIDECHIPS_WS2401 is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
CONFIG_DRM_BOCHS=m
CONFIG_DRM_CIRRUS_QEMU=m
# CONFIG_DRM_GM12U320 is not set
# CONFIG_DRM_PANEL_MIPI_DBI is not set
# CONFIG_DRM_SIMPLEDRM is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9163 is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_ILI9486 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_GUD is not set
# CONFIG_DRM_SSD130X is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_EXPORT_FOR_TESTS=y
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_NOMODESET=y
CONFIG_DRM_LIB_RANDOM=y
CONFIG_DRM_PRIVACY_SCREEN=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SSD1307 is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_KTD253 is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION is not set
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=m
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_APPLEIR is not set
CONFIG_HID_ASUS=m
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=m
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=m
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_CMEDIA=m
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=m
# CONFIG_HID_FT260 is not set
CONFIG_HID_GEMBIRD=m
CONFIG_HID_GFRM=m
# CONFIG_HID_GLORIOUS is not set
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_VIVALDI is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
# CONFIG_HID_UCLOGIC is not set
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
# CONFIG_HID_XIAOMI is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=m
CONFIG_HID_JABRA=m
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=m
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
CONFIG_HID_LENOVO=m
# CONFIG_HID_LETSKETCH is not set
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
# CONFIG_HID_REDRAGON is not set
CONFIG_HID_MICROSOFT=m
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NINTENDO is not set
CONFIG_HID_NTI=m
# CONFIG_HID_NTRIG is not set
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=m
# CONFIG_HID_RAZER is not set
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SEMITEK is not set
# CONFIG_HID_SIGMAMICRO is not set
# CONFIG_HID_SONY is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
# CONFIG_HID_WACOM is not set
CONFIG_HID_WIIMOTE=m
CONFIG_HID_XINMO=m
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=y
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# CONFIG_HID_MCP2221 is not set
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
# CONFIG_USB_HIDDEV is not set
# end of USB HID support

#
# I2C HID support
#
# CONFIG_I2C_HID_ACPI is not set
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=m
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support

#
# AMD SFH HID Support
#
# CONFIG_AMD_SFH_HID is not set
# end of AMD SFH HID Support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_FEW_INIT_RETRIES is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_PRODUCTLIST is not set
# CONFIG_USB_OTG_DISABLE_EXTERNAL_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=y
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PCI_RENESAS is not set
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USBIP_CORE is not set
# CONFIG_USB_CDNS_SUPPORT is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
# CONFIG_USB_USS720 is not set
CONFIG_USB_SERIAL=m
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_METRO is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MXUPORT is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_OPTION is not set
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_XSENS_MT is not set
# CONFIG_USB_SERIAL_WISHBONE is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_QT2 is not set
# CONFIG_USB_SERIAL_UPD78F0730 is not set
# CONFIG_USB_SERIAL_XR is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_APPLE_MFI_FASTCHARGE is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HUB_USB251XB is not set
# CONFIG_USB_HSIC_USB3503 is not set
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
# CONFIG_USB_ATM is not set

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_TYPEC_TPS6598X is not set
# CONFIG_TYPEC_RT1719 is not set
# CONFIG_TYPEC_STUSB160X is not set
# CONFIG_TYPEC_WUSB3801 is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
# CONFIG_MMC_TIFM_SD is not set
# CONFIG_MMC_SPI is not set
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
# CONFIG_MMC_VUB300 is not set
# CONFIG_MMC_USHC is not set
# CONFIG_MMC_USDHI6ROL0 is not set
# CONFIG_MMC_REALTEK_PCI is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_HSQ is not set
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_CLASS_MULTICOLOR is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
# CONFIG_LEDS_LP50XX is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
CONFIG_LEDS_MLXCPLD=m
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# Flash and Torch LED drivers
#

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_LEDS_TRIGGER_TTY is not set

#
# Simple LED drivers
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_GHES=y
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
# CONFIG_EDAC_IGEN6 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV3032 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
# CONFIG_RTC_DRV_RV3029_HWMON is not set
# CONFIG_RTC_DRV_RX6110 is not set

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_GOLDFISH is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
CONFIG_INTEL_IDMA64=m
# CONFIG_INTEL_IDXD is not set
# CONFIG_INTEL_IDXD_COMPAT is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_AMD_PTDMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set
# CONFIG_INTEL_LDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=m
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
CONFIG_UDMABUF=y
# CONFIG_DMABUF_MOVE_NOTIFY is not set
# CONFIG_DMABUF_DEBUG is not set
# CONFIG_DMABUF_SELFTESTS is not set
CONFIG_DMABUF_HEAPS=y
# CONFIG_DMABUF_SYSFS_STATS is not set
CONFIG_DMABUF_HEAPS_SYSTEM=y
# end of DMABUF options

CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_VFIO=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI_CORE=m
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_IRQ_BYPASS_MANAGER=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_PCI_LIB=y
CONFIG_VIRTIO_PCI_LIB_LEGACY=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=m
# CONFIG_VIRTIO_MEM is not set
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set
CONFIG_VIRTIO_DMA_SHARED_BUFFER=m
# CONFIG_VDPA is not set
CONFIG_VHOST_IOTLB=m
CONFIG_VHOST=m
CONFIG_VHOST_MENU=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# end of Microsoft Hyper-V guest support

# CONFIG_GREYBUS is not set
# CONFIG_COMEDI is not set
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
# CONFIG_RTL8192U is not set
# CONFIG_RTLLIB is not set
# CONFIG_RTL8723BS is not set
# CONFIG_R8712U is not set
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set
# CONFIG_FB_SM750 is not set
# CONFIG_STAGING_MEDIA is not set
# CONFIG_LTE_GDM724X is not set
# CONFIG_FIREWIRE_SERIAL is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_FB_TFT is not set
# CONFIG_KS7010 is not set
# CONFIG_PI433 is not set
# CONFIG_FIELDBUS_DEV is not set
# CONFIG_QLGE is not set
# CONFIG_WFX is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
# CONFIG_HUAWEI_WMI is not set
# CONFIG_UV_SYSFS is not set
CONFIG_MXM_WMI=m
# CONFIG_PEAQ_WMI is not set
# CONFIG_NVIDIA_WMI_EC_BACKLIGHT is not set
# CONFIG_XIAOMI_WMI is not set
# CONFIG_GIGABYTE_WMI is not set
# CONFIG_YOGABOOK_WMI is not set
CONFIG_ACERHDF=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACER_WMI=m
# CONFIG_AMD_PMC is not set
# CONFIG_AMD_HSMP is not set
# CONFIG_ADV_SWBUTTON is not set
CONFIG_APPLE_GMUX=m
CONFIG_ASUS_LAPTOP=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
# CONFIG_ASUS_TF103C_DOCK is not set
# CONFIG_MERAKI_MX100 is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_EEEPC_WMI=m
# CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
CONFIG_AMILO_RFKILL=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
# CONFIG_WIRELESS_HOTKEY is not set
CONFIG_HP_WMI=m
# CONFIG_IBM_RTL is not set
CONFIG_IDEAPAD_LAPTOP=m
CONFIG_SENSORS_HDAPS=m
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_THINKPAD_LMI is not set
# CONFIG_INTEL_ATOMISP2_PM is not set
# CONFIG_INTEL_SAR_INT1092 is not set
CONFIG_INTEL_PMC_CORE=m

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

CONFIG_INTEL_WMI=y
# CONFIG_INTEL_WMI_SBL_FW_UPDATE is not set
CONFIG_INTEL_WMI_THUNDERBOLT=m

#
# Intel Uncore Frequency Control
#
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
# end of Intel Uncore Frequency Control

CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_OAKTRAIL=m
# CONFIG_INTEL_ISHTP_ECLITE is not set
# CONFIG_INTEL_PUNIT_IPC is not set
CONFIG_INTEL_RST=m
# CONFIG_INTEL_SMARTCONNECT is not set
CONFIG_INTEL_TURBO_MAX_3=y
# CONFIG_INTEL_VSEC is not set
CONFIG_MSI_LAPTOP=m
CONFIG_MSI_WMI=m
# CONFIG_PCENGINES_APU2 is not set
# CONFIG_BARCO_P50_GPIO is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_SAMSUNG_Q10=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
CONFIG_COMPAL_LAPTOP=m
# CONFIG_LG_LAPTOP is not set
CONFIG_PANASONIC_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
# CONFIG_SYSTEM76_ACPI is not set
CONFIG_TOPSTAR_LAPTOP=m
# CONFIG_SERIAL_MULTI_INSTANTIATE is not set
CONFIG_MLX_PLATFORM=m
CONFIG_INTEL_IPS=m
# CONFIG_INTEL_SCU_PCI is not set
# CONFIG_INTEL_SCU_PLATFORM is not set
# CONFIG_SIEMENS_SIMATIC_IPC is not set
CONFIG_PMC_ATOM=y
# CONFIG_CHROME_PLATFORMS is not set
CONFIG_MELLANOX_PLATFORM=y
CONFIG_MLXREG_HOTPLUG=m
# CONFIG_MLXREG_IO is not set
# CONFIG_MLXREG_LC is not set
CONFIG_SURFACE_PLATFORMS=y
# CONFIG_SURFACE3_WMI is not set
# CONFIG_SURFACE_3_POWER_OPREGION is not set
# CONFIG_SURFACE_GPE is not set
# CONFIG_SURFACE_HOTPLUG is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
CONFIG_HAVE_CLK=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y
# CONFIG_LMK04832 is not set
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# CONFIG_XILINX_VCU is not set
CONFIG_HWSPINLOCK=y

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOASID=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_DMA_STRICT is not set
CONFIG_IOMMU_DEFAULT_DMA_LAZY=y
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
# CONFIG_AMD_IOMMU is not set
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON=y
CONFIG_IRQ_REMAP=y
# CONFIG_VIRTIO_IOMMU is not set

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Enable LiteX SoC Builder specific drivers
#
# end of Enable LiteX SoC Builder specific drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
# CONFIG_NTB_AMD is not set
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_EPF is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
# CONFIG_NTB_PERF is not set
# CONFIG_NTB_TRANSPORT is not set
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_DEBUG is not set
# CONFIG_PWM_DWC is not set
CONFIG_PWM_LPSS=m
CONFIG_PWM_LPSS_PCI=m
CONFIG_PWM_LPSS_PLATFORM=m
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
# CONFIG_GENERIC_PHY is not set
# CONFIG_USB_LGM_PHY is not set
# CONFIG_PHY_CAN_TRANSCEIVER is not set

#
# PHY drivers for Broadcom platforms
#
# CONFIG_BCM_KONA_USB2_PHY is not set
# end of PHY drivers for Broadcom platforms

# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_INTEL_LGM_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y
# CONFIG_NVMEM_RMEM is not set

#
# HW tracing support
#
CONFIG_STM=m
# CONFIG_STM_PROTO_BASIC is not set
# CONFIG_STM_PROTO_SYS_T is not set
CONFIG_STM_DUMMY=m
CONFIG_STM_SOURCE_CONSOLE=m
CONFIG_STM_SOURCE_HEARTBEAT=m
CONFIG_STM_SOURCE_FTRACE=m
CONFIG_INTEL_TH=m
CONFIG_INTEL_TH_PCI=m
CONFIG_INTEL_TH_ACPI=m
CONFIG_INTEL_TH_GTH=m
CONFIG_INTEL_TH_STH=m
CONFIG_INTEL_TH_MSU=m
CONFIG_INTEL_TH_PTI=m
# CONFIG_INTEL_TH_DEBUG is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# CONFIG_MOST is not set
# CONFIG_PECI is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_SUPPORT_V4=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
# CONFIG_XFS_ONLINE_REPAIR is not set
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
# CONFIG_F2FS_FS_SECURITY is not set
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
CONFIG_F2FS_IOSTAT=y
# CONFIG_F2FS_UNFAIR_RWSEM is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=y
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_NETFS_SUPPORT=m
CONFIG_NETFS_STATS=y
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_ERROR_INJECTION is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/EXFAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_EXFAT_FS is not set
# CONFIG_NTFS_FS is not set
# CONFIG_NTFS3_FS is not set
# end of DOS/FAT/EXFAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_VMCORE_DEVICE_DUMP=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_TMPFS_INODE64 is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_HUGETLB_PAGE_FREE_VMEMMAP=y
# CONFIG_HUGETLB_PAGE_FREE_VMEMMAP_DEFAULT_ON is not set
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
CONFIG_SQUASHFS=m
# CONFIG_SQUASHFS_FILE_CACHE is not set
CONFIG_SQUASHFS_FILE_DIRECT=y
# CONFIG_SQUASHFS_DECOMP_SINGLE is not set
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFAULT_KMSG_BYTES=10240
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_PSTORE_BLK is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
# CONFIG_NFS_V4_2_READ_PLUS is not set
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_NFS_V4_2_SSC_HELPER=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SWN_UPCALL is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_SMB_SERVER is not set
CONFIG_SMBFS_COMMON=m
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_USER_DECRYPTED_DATA is not set
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_FORTIFY_SOURCE=y
# CONFIG_STATIC_USERMODEHELPER is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
CONFIG_SECURITY_LANDLOCK=y
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
CONFIG_IMA_WRITE_POLICY=y
CONFIG_IMA_READ_POLICY=y
CONFIG_IMA_APPRAISE=y
CONFIG_IMA_ARCH_POLICY=y
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
CONFIG_IMA_SECURE_AND_OR_TRUSTED_BOOT=y
# CONFIG_IMA_DISABLE_HTABLE is not set
# CONFIG_EVM is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,bpf"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
CONFIG_INIT_ON_ALLOC_DEFAULT_ON=y
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
# CONFIG_ZERO_CALL_USED_REGS is not set
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=m
# CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_SIMD=y

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
# CONFIG_CRYPTO_DH_RFC7919_GROUPS is not set
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECDSA is not set
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_SM2 is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_CHACHA20POLY1305=m
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CFB=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S is not set
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_CRC64_ROCKSOFT=m
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_POLY1305=m
CONFIG_CRYPTO_POLY1305_X86_64=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_SHA3=m
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_SM3_AVX_X86_64 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_CHACHA20=m
CONFIG_CRYPTO_CHACHA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
CONFIG_CRYPTO_SM4=y
# CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64 is not set
# CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
# CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE=y
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
# CONFIG_CRYPTO_DEV_QAT_4XXX is not set
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
CONFIG_CRYPTO_DEV_NITROX=m
CONFIG_CRYPTO_DEV_NITROX_CNN55XX=m
# CONFIG_CRYPTO_DEV_VIRTIO is not set
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_MODULE_SIG_KEY_TYPE_RSA=y
# CONFIG_MODULE_SIG_KEY_TYPE_ECDSA is not set
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# CONFIG_SYSTEM_REVOCATION_LIST is not set
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_CORDIC=m
CONFIG_PRIME_NUMBERS=m
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_ARCH_USE_SYM_ANNOTATIONS=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA=m
CONFIG_CRYPTO_LIB_CHACHA_GENERIC=m
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
CONFIG_CRYPTO_ARCH_HAVE_LIB_POLY1305=m
CONFIG_CRYPTO_LIB_POLY1305_GENERIC=m
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_LIB_SM4=y
# end of Crypto library routines

CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC64_ROCKSOFT=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC64=m
# CONFIG_CRC4 is not set
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
# CONFIG_XZ_DEC_MICROLZMA is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_DECOMPRESS_ZSTD=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_DMA_OPS=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_SWIOTLB=y
# CONFIG_DMA_API_DEBUG is not set
CONFIG_DMA_MAP_BENCHMARK=y
CONFIG_SGL_ALLOC=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_COPY_MC=y
CONFIG_ARCH_STACKWALK=y
CONFIG_STACKDEPOT=y
CONFIG_STACKDEPOT_ALWAYS_INIT=y
CONFIG_STACK_HASH_ORDER=20
CONFIG_SBITMAP=y
# end of Library routines

CONFIG_ASN1_ENCODER=y

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_PRINTK_CALLER=y
# CONFIG_STACKTRACE_BUILD_ID is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DYNAMIC_DEBUG_CORE=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_INFO_NONE is not set
# CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
CONFIG_DEBUG_INFO_DWARF4=y
# CONFIG_DEBUG_INFO_DWARF5 is not set
# CONFIG_DEBUG_INFO_REDUCED is not set
# CONFIG_DEBUG_INFO_COMPRESSED is not set
# CONFIG_DEBUG_INFO_SPLIT is not set
CONFIG_DEBUG_INFO_BTF=y
CONFIG_PAHOLE_HAS_SPLIT_BTF=y
CONFIG_DEBUG_INFO_BTF_MODULES=y
# CONFIG_MODULE_ALLOW_BTF_MISMATCH is not set
# CONFIG_GDB_SCRIPTS is not set
CONFIG_FRAME_WARN=8192
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
# CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B is not set
CONFIG_STACK_VALIDATION=y
# CONFIG_VMLINUX_MAP is not set
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_FS_ALLOW_ALL=y
# CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
# CONFIG_DEBUG_FS_ALLOW_NONE is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
CONFIG_UBSAN=y
# CONFIG_UBSAN_TRAP is not set
CONFIG_CC_HAS_UBSAN_BOUNDS=y
CONFIG_UBSAN_BOUNDS=y
CONFIG_UBSAN_ONLY_BOUNDS=y
CONFIG_UBSAN_SHIFT=y
# CONFIG_UBSAN_DIV_ZERO is not set
# CONFIG_UBSAN_BOOL is not set
# CONFIG_UBSAN_ENUM is not set
# CONFIG_UBSAN_ALIGNMENT is not set
CONFIG_UBSAN_SANITIZE_ALL=y
# CONFIG_TEST_UBSAN is not set
CONFIG_HAVE_ARCH_KCSAN=y
CONFIG_HAVE_KCSAN_COMPILER=y
# end of Generic Kernel Debugging Instruments

#
# Networking Debugging
#
# CONFIG_NET_DEV_REFCNT_TRACKER is not set
# CONFIG_NET_NS_REFCNT_TRACKER is not set
# end of Networking Debugging

#
# Memory Debugging
#
CONFIG_PAGE_EXTENSION=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_PAGE_OWNER=y
# CONFIG_PAGE_TABLE_CHECK is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
# CONFIG_DEBUG_RODATA_TEST is not set
CONFIG_ARCH_HAS_DEBUG_WX=y
# CONFIG_DEBUG_WX is not set
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VM_PGTABLE is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
# CONFIG_KASAN_MODULE_TEST is not set
CONFIG_HAVE_ARCH_KFENCE=y
# CONFIG_KFENCE is not set
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=480
# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
CONFIG_WQ_WATCHDOG=y
# CONFIG_TEST_LOCKUP is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RAW_LOCK_NESTING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_RWSEMS=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_LOCKDEP=y
CONFIG_LOCKDEP_BITS=15
CONFIG_LOCKDEP_CHAINS_BITS=16
CONFIG_LOCKDEP_STACK_TRACE_BITS=19
CONFIG_LOCKDEP_STACK_TRACE_HASH_BITS=14
CONFIG_LOCKDEP_CIRCULAR_QUEUE_BITS=12
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_LOCK_TORTURE_TEST is not set
CONFIG_WW_MUTEX_SELFTEST=m
# CONFIG_SCF_TORTURE_TEST is not set
# CONFIG_CSD_LOCK_WAIT_DEBUG is not set
CONFIG_PROVE_NVDIMM_LOCKING=y
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_TRACE_IRQFLAGS=y
CONFIG_TRACE_IRQFLAGS_NMI=y
# CONFIG_DEBUG_IRQFLAGS is not set
CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
CONFIG_DEBUG_PLIST=y
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_BUG_ON_DATA_CORRUPTION=y
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_RCU_SCALE_TEST is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_RCU_REF_SCALE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_RETHOOK=y
CONFIG_RETHOOK=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_OBJTOOL_MCOUNT=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
CONFIG_BUILDTIME_MCOUNT_SORT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_PREEMPTIRQ_TRACEPOINTS=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_BOOTTIME_TRACING is not set
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_DYNAMIC_FTRACE_WITH_ARGS=y
# CONFIG_FPROBE is not set
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_OSNOISE_TRACER is not set
# CONFIG_TIMERLAT_TRACER is not set
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_MCOUNT_USE_CC=y
CONFIG_TRACING_MAP=y
CONFIG_SYNTH_EVENTS=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_RECORD_RECURSION is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_FTRACE_SORT_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
CONFIG_PREEMPTIRQ_DELAY_TEST=m
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
# CONFIG_HIST_TRIGGERS_DEBUG is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_SAMPLES=y
# CONFIG_SAMPLE_AUXDISPLAY is not set
# CONFIG_SAMPLE_TRACE_EVENTS is not set
# CONFIG_SAMPLE_TRACE_CUSTOM_EVENTS is not set
CONFIG_SAMPLE_TRACE_PRINTK=m
CONFIG_SAMPLE_FTRACE_DIRECT=m
# CONFIG_SAMPLE_FTRACE_DIRECT_MULTI is not set
# CONFIG_SAMPLE_TRACE_ARRAY is not set
# CONFIG_SAMPLE_KOBJECT is not set
# CONFIG_SAMPLE_KPROBES is not set
# CONFIG_SAMPLE_HW_BREAKPOINT is not set
# CONFIG_SAMPLE_KFIFO is not set
# CONFIG_SAMPLE_LIVEPATCH is not set
# CONFIG_SAMPLE_CONFIGFS is not set
# CONFIG_SAMPLE_VFIO_MDEV_MTTY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY is not set
# CONFIG_SAMPLE_VFIO_MDEV_MDPY_FB is not set
# CONFIG_SAMPLE_VFIO_MDEV_MBOCHS is not set
# CONFIG_SAMPLE_WATCHDOG is not set
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_EARLY_PRINTK_USB_XDBC=y
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_FPU is not set
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
# CONFIG_FAULT_INJECTION is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
CONFIG_LKDTM=y
# CONFIG_TEST_MIN_HEAP is not set
# CONFIG_TEST_DIV64 is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_TEST_REF_TRACKER is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_STRING_SELFTEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=m
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=m
CONFIG_TEST_SCANF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_SIPHASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_BITOPS=m
CONFIG_TEST_VMALLOC=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_BLACKHOLE_DEV=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=y
CONFIG_TEST_SYSCTL=y
# CONFIG_TEST_UDELAY is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_TEST_MEMCAT_P is not set
CONFIG_TEST_LIVEPATCH=m
# CONFIG_TEST_MEMINIT is not set
CONFIG_TEST_HMM=m
# CONFIG_TEST_FREE_PAGES is not set
CONFIG_TEST_FPU=m
# CONFIG_TEST_CLOCKSOURCE_WATCHDOG is not set
CONFIG_ARCH_USE_MEMTEST=y
# CONFIG_MEMTEST is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--HtExJog7ZoUxdI0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='kernel-selftests'
	export testcase='kernel-selftests'
	export category='functional'
	export job_origin='kernel-selftests-bm.yaml'
	export queue='validate'
	export testbox='lkp-skl-d01'
	export commit='e71b7f1f44d3d88c677769c85ef0171caf9fc89f'
	export branch='linus/master'
	export kconfig='x86_64-rhel-8.3-kselftests'
	export name='/cephfs/tmp/d20220521-5384-ccft40/kernel-selftests-bm.yaml'
	export kernel_cmdline=
	export tbox_group='lkp-skl-d01'
	export submit_id='62b6c2a315cd473c27497089'
	export job_file='/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-ipv6_ping-net-fcnal-test.sh-ucode=0xec-debian-11.1-x86_64-20220510.cgz-e71b7f1f44d3d88c677769c85ef0171caf9fc89f-20220625-15399-r2euz5-4.yaml'
	export id='01665367bd526afe852eecef80e5ca28331df8be'
	export queuer_version='/zday/lkp'
	export model='Skylake'
	export nr_cpu=8
	export memory='28G'
	export nr_ssd_partitions=1
	export nr_hdd_partitions=4
	export hdd_partitions='/dev/disk/by-id/wwn-0x50014ee20d26b072-part*'
	export ssd_partitions='/dev/disk/by-id/wwn-0x55cd2e404c39bfc5-part1'
	export swap_partitions='/dev/disk/by-id/wwn-0x55cd2e404c39bfc5-part3'
	export rootfs_partition='/dev/disk/by-id/wwn-0x55cd2e404c39bfc5-part2'
	export brand='Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz'
	export cpu_info='skylake i7-6700'
	export bios_version='1.2.8'
	export need_kconfig_hw='{"E1000E"=>"y"}
SATA_AHCI
DRM_I915'
	export ucode='0xec'
	export bisect_dmesg=true
	export need_kconfig='{"PACKET"=>"y"}
{"USER_NS"=>"y"}
{"BPF_SYSCALL"=>"y"}
{"TEST_BPF"=>"m"}
{"NUMA"=>"y, v5.6-rc1"}
{"NET_VRF"=>"y, v4.3-rc1"}
{"NET_L3_MASTER_DEV"=>"y, v4.4-rc1"}
{"IPV6"=>"y"}
{"IPV6_MULTIPLE_TABLES"=>"y"}
{"VETH"=>"y"}
{"NET_IPVTI"=>"m"}
{"IPV6_VTI"=>"m"}
{"DUMMY"=>"y"}
{"BRIDGE"=>"y"}
{"VLAN_8021Q"=>"y"}
IFB
{"NETFILTER"=>"y"}
{"NETFILTER_ADVANCED"=>"y"}
{"NF_CONNTRACK"=>"m"}
{"NF_NAT"=>"m, v5.1-rc1"}
{"IP6_NF_IPTABLES"=>"m"}
{"IP_NF_IPTABLES"=>"m"}
{"IP6_NF_NAT"=>"m"}
{"IP_NF_NAT"=>"m"}
{"NF_TABLES"=>"m"}
{"NF_TABLES_IPV6"=>"y, v4.17-rc1"}
{"NF_TABLES_IPV4"=>"y, v4.17-rc1"}
{"NFT_CHAIN_NAT_IPV6"=>"m, <= v5.0"}
{"NFT_TPROXY"=>"m, v4.19-rc1"}
{"NFT_COUNTER"=>"m, <= v5.16-rc4"}
{"NFT_CHAIN_NAT_IPV4"=>"m, <= v5.0"}
{"NET_SCH_FQ"=>"m"}
{"NET_SCH_ETF"=>"m, v4.19-rc1"}
{"NET_SCH_NETEM"=>"y"}
{"TEST_BLACKHOLE_DEV"=>"m, v5.3-rc1"}
{"KALLSYMS"=>"y"}
{"BAREUDP"=>"m, v5.7-rc1"}
{"MPLS_ROUTING"=>"m, v4.1-rc1"}
{"MPLS_IPTUNNEL"=>"m, v4.3-rc1"}
{"NET_SCH_INGRESS"=>"y, v4.19-rc1"}
{"NET_CLS_FLOWER"=>"m, v4.2-rc1"}
{"NET_ACT_TUNNEL_KEY"=>"m, v4.9-rc1"}
{"NET_ACT_MIRRED"=>"m, v5.11-rc1"}
{"CRYPTO_SM4"=>"y"}
NET_DROP_MONITOR
TRACEPOINTS
{"AMT"=>"m, v5.16-rc1"}
{"IPV6_IOAM6_LWTUNNEL"=>"y, v5.15"}'
	export rootfs='debian-11.1-x86_64-20220510.cgz'
	export initrds='linux_headers
linux_selftests'
	export enqueue_time='2022-06-25 16:09:07 +0800'
	export compiler='gcc-11'
	export _id='62b6c2a315cd473c2749708a'
	export _rt='/result/kernel-selftests/ipv6_ping-net-fcnal-test.sh-ucode=0xec/lkp-skl-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f'
	export user='lkp'
	export LKP_SERVER='internal-lkp-server'
	export result_root='/result/kernel-selftests/ipv6_ping-net-fcnal-test.sh-ucode=0xec/lkp-skl-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/3'
	export scheduler_version='/lkp/lkp/src'
	export arch='x86_64'
	export max_uptime=2100
	export initrd='/osimage/debian/debian-11.1-x86_64-20220510.cgz'
	export bootloader_append='root=/dev/ram0
RESULT_ROOT=/result/kernel-selftests/ipv6_ping-net-fcnal-test.sh-ucode=0xec/lkp-skl-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/3
BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/vmlinuz-5.18.0-rc5-00105-ge71b7f1f44d3
branch=linus/master
job=/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-ipv6_ping-net-fcnal-test.sh-ucode=0xec-debian-11.1-x86_64-20220510.cgz-e71b7f1f44d3d88c677769c85ef0171caf9fc89f-20220625-15399-r2euz5-4.yaml
user=lkp
ARCH=x86_64
kconfig=x86_64-rhel-8.3-kselftests
commit=e71b7f1f44d3d88c677769c85ef0171caf9fc89f
max_uptime=2100
LKP_SERVER=internal-lkp-server
nokaslr
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/modules.cgz'
	export linux_headers_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/linux-headers.cgz'
	export linux_selftests_initrd='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/linux-selftests.cgz'
	export bm_initrd='/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/kernel-selftests_20220614.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/kernel-selftests-x86_64-cebf67a3-1_20220613.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hw_20220526.cgz'
	export ucode_initrd='/osimage/ucode/intel-ucode-20220216.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='lkp-wsx01'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='5.18.0-rc2-00615-g2794cdb0b97b'
	export queue_cmdline_keys='branch
commit
kbuild_queue_analysis'
	export repeat_to=6
	export schedule_notify_address=
	export stop_repeat_if_found='kernel-selftests.net.fcnal-test.sh.fail'
	export kbuild_queue_analysis=1
	export kernel='/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/vmlinuz-5.18.0-rc5-00105-ge71b7f1f44d3'
	export dequeue_time='2022-06-25 16:17:50 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-ipv6_ping-net-fcnal-test.sh-ucode=0xec-debian-11.1-x86_64-20220510.cgz-e71b7f1f44d3d88c677769c85ef0171caf9fc89f-20220625-15399-r2euz5-4.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test group='net' test='fcnal-test.sh' atomic_test='ipv6_ping' $LKP_SRC/tests/wrapper kernel-selftests
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	env group='net' test='fcnal-test.sh' atomic_test='ipv6_ping' $LKP_SRC/stats/wrapper kernel-selftests
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time kernel-selftests.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--HtExJog7ZoUxdI0r
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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
n/lMAQAB/NMC8ZISikCRwbHEZ/sCAAAAAARZWg==

--HtExJog7ZoUxdI0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kernel-selftests
Content-Transfer-Encoding: quoted-printable

KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-8=
=2E3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f
2022-06-25 08:22:02 mount --bind /lib/modules/5.18.0-rc5-00105-ge71b7f1f44d=
3/kernel/lib /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d=
3d88c677769c85ef0171caf9fc89f/lib
2022-06-25 08:22:02 sed -i s/default_timeout=3D45/default_timeout=3D300/ ks=
elftest/runner.sh
2022-06-25 08:22:02 make -C bpf
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftest=
s-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf'
  MKDIR    libbpf
  HOSTCC  /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/f=
ixdep.o
  HOSTLD  /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/f=
ixdep-in.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/f=
ixdep
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/b=
pf_helper_defs.h
  MKDIR   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/libbpf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/bpf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/nlattr.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/btf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/libbpf_errno.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/str_error.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/netlink.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/bpf_prog_linfo.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/libbpf_probes.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/xsk.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/hashmap.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/btf_dump.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/ringbuf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/strset.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/linker.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/gen_loader.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/relo_core.o
  LD      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
taticobjs/libbpf-in.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/l=
ibbpf.a
  MKDIR   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/libbpf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/bpf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/nlattr.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/btf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/libbpf_errno.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/str_error.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/netlink.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/bpf_prog_linfo.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/libbpf_probes.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/xsk.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/hashmap.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/btf_dump.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/ringbuf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/strset.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/linker.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/gen_loader.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/relo_core.o
  LD      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/s=
haredobjs/libbpf-in.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/l=
ibbpf.so.0.8.0
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/libbpf/l=
ibbpf.pc
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/bp=
f.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/li=
bbpf.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/bt=
f.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/li=
bbpf_common.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/li=
bbpf_legacy.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/xs=
k.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/bp=
f_helpers.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/bp=
f_tracing.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/bp=
f_endian.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/bp=
f_core_read.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/sk=
el_internal.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/li=
bbpf_version.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/bp=
f_helper_defs.h
  TEST-HDR [test_progs] tests.h
  EXT-OBJ  [test_progs] testing_helpers.o
  EXT-OBJ  [test_progs] cap_helpers.o
  BINARY   test_verifier
  BINARY   test_tag
  MKDIR    bpftool

Auto-detecting system features:
=2E..                        libbfd: [ =1B[32mon=1B[m  ]
=2E..        disassembler-four-args: [ =1B[32mon=1B[m  ]
=2E..                          zlib: [ =1B[32mon=1B[m  ]
=2E..                        libcap: [ =1B[32mon=1B[m  ]
=2E..               clang-bpf-co-re: [ =1B[32mon=1B[m  ]

=2E..                      /tmp/lkp: [ =1B[31mOFF=1B[m ]

  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/ha=
shmap.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/nl=
attr.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/re=
lo_core.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include/bpf/li=
bbpf_internal.h
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
btf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
btf_dumper.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
cfg.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
cgroup.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
common.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
feature.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
gen.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
iter.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
json_writer.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
link.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
main.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
map.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
map_perf_ring.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
net.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
netlink_dumper.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
perf.o
  MKDIR   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/hashmap.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/relo_core.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/libbpf_internal.h
  MKDIR   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/
  MKDIR   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/bpf_helper_defs.h
  MKDIR   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/libbpf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/bpf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/nlattr.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/btf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/libbpf_errno.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/str_error.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/netlink.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/bpf_prog_linfo.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/libbpf_probes.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/xsk.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/hashmap.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/btf_dump.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/ringbuf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/strset.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/linker.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/gen_loader.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/relo_core.o
  LD      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/staticobjs/libbpf-in.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/libbpf.a
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/bpf.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/libbpf.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/btf.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/libbpf_common.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/libbpf_legacy.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/xsk.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/bpf_helpers.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/bpf_tracing.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/bpf_endian.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/bpf_core_read.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/skel_internal.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/libbpf_version.h
  INSTALL /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/libbpf/include/bpf/bpf_helper_defs.h
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/main.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/common.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/json_writer.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/gen.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/btf.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/xlated_dumper.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/btf_dumper.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/disasm.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bootstrap/bpftool
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
vmlinux.h
  CLANG   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
pid_iter.bpf.o
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
pid_iter.skel.h
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
pids.o
  CLANG   /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
profiler.bpf.o
  GEN     /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
profiler.skel.h
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
prog.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
struct_ops.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
tracelog.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
xlated_dumper.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
jit_disasm.o
  CC      /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
disasm.o
  LINK    /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/build/bpftool/=
bpftool
  INSTALL bpftool
  GEN      vmlinux.h
  CLNG-BPF [test_maps] atomic_bounds.o
  CLNG-BPF [test_maps] atomics.o
  CLNG-BPF [test_maps] bind4_prog.o
  CLNG-BPF [test_maps] bind6_prog.o
  CLNG-BPF [test_maps] bind_perm.o
  CLNG-BPF [test_maps] bloom_filter_bench.o
  CLNG-BPF [test_maps] bloom_filter_map.o
  CLNG-BPF [test_maps] bpf_cubic.o
  CLNG-BPF [test_maps] bpf_dctcp.o
  CLNG-BPF [test_maps] bpf_dctcp_release.o
  CLNG-BPF [test_maps] bpf_flow.o
  CLNG-BPF [test_maps] bpf_iter_bpf_array_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_hash_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_percpu_array_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_percpu_hash_map.o
  CLNG-BPF [test_maps] bpf_iter_bpf_sk_storage_helpers.o
  CLNG-BPF [test_maps] bpf_iter_bpf_sk_storage_map.o
  CLNG-BPF [test_maps] bpf_iter_ipv6_route.o
  CLNG-BPF [test_maps] bpf_iter_netlink.o
  CLNG-BPF [test_maps] bpf_iter_setsockopt.o
  CLNG-BPF [test_maps] bpf_iter_setsockopt_unix.o
  CLNG-BPF [test_maps] bpf_iter_sockmap.o
  CLNG-BPF [test_maps] bpf_iter_task.o
  CLNG-BPF [test_maps] bpf_iter_task_btf.o
  CLNG-BPF [test_maps] bpf_iter_task_file.o
  CLNG-BPF [test_maps] bpf_iter_task_stack.o
  CLNG-BPF [test_maps] bpf_iter_task_vma.o
  CLNG-BPF [test_maps] bpf_iter_tcp4.o
  CLNG-BPF [test_maps] bpf_iter_tcp6.o
  CLNG-BPF [test_maps] bpf_iter_test_kern1.o
  CLNG-BPF [test_maps] bpf_iter_test_kern2.o
  CLNG-BPF [test_maps] bpf_iter_test_kern3.o
  CLNG-BPF [test_maps] bpf_iter_test_kern4.o
  CLNG-BPF [test_maps] bpf_iter_test_kern5.o
  CLNG-BPF [test_maps] bpf_iter_test_kern6.o
  CLNG-BPF [test_maps] bpf_iter_udp4.o
  CLNG-BPF [test_maps] bpf_iter_udp6.o
  CLNG-BPF [test_maps] bpf_iter_unix.o
  CLNG-BPF [test_maps] bpf_loop.o
  CLNG-BPF [test_maps] bpf_loop_bench.o
  CLNG-BPF [test_maps] bpf_mod_race.o
  CLNG-BPF [test_maps] bpf_syscall_macro.o
  CLNG-BPF [test_maps] bpf_tcp_nogpl.o
  CLNG-BPF [test_maps] bprm_opts.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___diff_arr_dim.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___diff_arr_val_sz.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___equiv_zero_sz_arr.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_bad_zero_sz_arr.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_non_array.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_too_shallow.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_too_small.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___err_wrong_val_type.o
  CLNG-BPF [test_maps] btf__core_reloc_arrays___fixed_arr.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields___bit_sz_change.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields___bitfield_vs_int.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields___err_too_big_bitfield.o
  CLNG-BPF [test_maps] btf__core_reloc_bitfields___just_big_enough.o
  CLNG-BPF [test_maps] btf__core_reloc_enumval.o
  CLNG-BPF [test_maps] btf__core_reloc_enumval___diff.o
  CLNG-BPF [test_maps] btf__core_reloc_enumval___err_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_enumval___val3_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_existence.o
  CLNG-BPF [test_maps] btf__core_reloc_existence___minimal.o
  CLNG-BPF [test_maps] btf__core_reloc_existence___wrong_field_defs.o
  CLNG-BPF [test_maps] btf__core_reloc_flavors.o
  CLNG-BPF [test_maps] btf__core_reloc_flavors__err_wrong_name.o
  CLNG-BPF [test_maps] btf__core_reloc_ints.o
  CLNG-BPF [test_maps] btf__core_reloc_ints___bool.o
  CLNG-BPF [test_maps] btf__core_reloc_ints___reverse_sign.o
  CLNG-BPF [test_maps] btf__core_reloc_misc.o
  CLNG-BPF [test_maps] btf__core_reloc_mods.o
  CLNG-BPF [test_maps] btf__core_reloc_mods___mod_swap.o
  CLNG-BPF [test_maps] btf__core_reloc_mods___typedefs.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___anon_embed.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___dup_compat_types.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_array_container.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_array_field.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_dup_incompat_types.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_missing_container.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_missing_field.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_nonstruct_container.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_partial_match_dups.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___err_too_deep.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___extra_nesting.o
  CLNG-BPF [test_maps] btf__core_reloc_nesting___struct_union_mixup.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___diff_enum_def.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___diff_func_proto.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___diff_ptr_type.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___err_non_enum.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___err_non_int.o
  CLNG-BPF [test_maps] btf__core_reloc_primitives___err_non_ptr.o
  CLNG-BPF [test_maps] btf__core_reloc_ptr_as_arr.o
  CLNG-BPF [test_maps] btf__core_reloc_ptr_as_arr___diff_sz.o
  CLNG-BPF [test_maps] btf__core_reloc_size.o
  CLNG-BPF [test_maps] btf__core_reloc_size___diff_sz.o
  CLNG-BPF [test_maps] btf__core_reloc_size___err_ambiguous.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___all_missing.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___diff_sz.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___fn_wrong_args.o
  CLNG-BPF [test_maps] btf__core_reloc_type_based___incompat.o
  CLNG-BPF [test_maps] btf__core_reloc_type_id.o
  CLNG-BPF [test_maps] btf__core_reloc_type_id___missing_targets.o
  CLNG-BPF [test_maps] btf_data.o
  CLNG-BPF [test_maps] btf_dump_test_case_bitfields.o
  CLNG-BPF [test_maps] btf_dump_test_case_multidim.o
  CLNG-BPF [test_maps] btf_dump_test_case_namespacing.o
  CLNG-BPF [test_maps] btf_dump_test_case_ordering.o
  CLNG-BPF [test_maps] btf_dump_test_case_packing.o
  CLNG-BPF [test_maps] btf_dump_test_case_padding.o
  CLNG-BPF [test_maps] btf_dump_test_case_syntax.o
  CLNG-BPF [test_maps] btf_type_tag.o
  CLNG-BPF [test_maps] btf_type_tag_percpu.o
  CLNG-BPF [test_maps] btf_type_tag_user.o
  CLNG-BPF [test_maps] cg_storage_multi_egress_only.o
  CLNG-BPF [test_maps] cg_storage_multi_isolated.o
  CLNG-BPF [test_maps] cg_storage_multi_shared.o
  CLNG-BPF [test_maps] cgroup_getset_retval_getsockopt.o
  CLNG-BPF [test_maps] cgroup_getset_retval_setsockopt.o
  CLNG-BPF [test_maps] cgroup_skb_sk_lookup_kern.o
  CLNG-BPF [test_maps] connect4_dropper.o
  CLNG-BPF [test_maps] connect4_prog.o
  CLNG-BPF [test_maps] connect6_prog.o
  CLNG-BPF [test_maps] connect_force_port4.o
  CLNG-BPF [test_maps] connect_force_port6.o
  CLNG-BPF [test_maps] core_kern.o
  CLNG-BPF [test_maps] core_kern_overflow.o
  CLNG-BPF [test_maps] dev_cgroup.o
  CLNG-BPF [test_maps] dummy_st_ops.o
  CLNG-BPF [test_maps] exhandler_kern.o
  CLNG-BPF [test_maps] fentry_test.o
  CLNG-BPF [test_maps] fexit_bpf2bpf.o
  CLNG-BPF [test_maps] fexit_bpf2bpf_simple.o
  CLNG-BPF [test_maps] fexit_sleep.o
  CLNG-BPF [test_maps] fexit_test.o
  CLNG-BPF [test_maps] find_vma.o
  CLNG-BPF [test_maps] find_vma_fail1.o
  CLNG-BPF [test_maps] find_vma_fail2.o
  CLNG-BPF [test_maps] fmod_ret_freplace.o
  CLNG-BPF [test_maps] for_each_array_map_elem.o
  CLNG-BPF [test_maps] for_each_hash_map_elem.o
  CLNG-BPF [test_maps] freplace_attach_probe.o
  CLNG-BPF [test_maps] freplace_cls_redirect.o
  CLNG-BPF [test_maps] freplace_connect4.o
  CLNG-BPF [test_maps] freplace_connect_v4_prog.o
  CLNG-BPF [test_maps] freplace_get_constant.o
  CLNG-BPF [test_maps] get_branch_snapshot.o
  CLNG-BPF [test_maps] get_cgroup_id_kern.o
  CLNG-BPF [test_maps] get_func_args_test.o
  CLNG-BPF [test_maps] get_func_ip_test.o
  CLNG-BPF [test_maps] ima.o
  CLNG-BPF [test_maps] kfree_skb.o
  CLNG-BPF [test_maps] kfunc_call_race.o
  CLNG-BPF [test_maps] kfunc_call_test.o
  CLNG-BPF [test_maps] kfunc_call_test_subprog.o
  CLNG-BPF [test_maps] kprobe_multi.o
  CLNG-BPF [test_maps] ksym_race.o
  CLNG-BPF [test_maps] linked_funcs1.o
  CLNG-BPF [test_maps] linked_funcs2.o
  CLNG-BPF [test_maps] linked_maps1.o
  CLNG-BPF [test_maps] linked_maps2.o
  CLNG-BPF [test_maps] linked_vars1.o
  CLNG-BPF [test_maps] linked_vars2.o
  CLNG-BPF [test_maps] load_bytes_relative.o
  CLNG-BPF [test_maps] local_storage.o
  CLNG-BPF [test_maps] loop1.o
  CLNG-BPF [test_maps] loop2.o
  CLNG-BPF [test_maps] loop3.o
  CLNG-BPF [test_maps] loop4.o
  CLNG-BPF [test_maps] loop5.o
  CLNG-BPF [test_maps] loop6.o
  CLNG-BPF [test_maps] lsm.o
  CLNG-BPF [test_maps] map_ptr_kern.o
  CLNG-BPF [test_maps] metadata_unused.o
  CLNG-BPF [test_maps] metadata_used.o
  CLNG-BPF [test_maps] modify_return.o
  CLNG-BPF [test_maps] netcnt_prog.o
  CLNG-BPF [test_maps] netif_receive_skb.o
  CLNG-BPF [test_maps] netns_cookie_prog.o
  CLNG-BPF [test_maps] perf_event_stackmap.o
  CLNG-BPF [test_maps] perfbuf_bench.o
  CLNG-BPF [test_maps] profiler1.o
  CLNG-BPF [test_maps] profiler2.o
  CLNG-BPF [test_maps] profiler3.o
  CLNG-BPF [test_maps] pyperf100.o
  CLNG-BPF [test_maps] pyperf180.o
  CLNG-BPF [test_maps] pyperf50.o
  CLNG-BPF [test_maps] pyperf600.o
fatal error: error in backend: Branch target out of insn range
PLEASE submit a bug report to https://github.com/llvm/llvm-project/issues/ =
and include the crash backtrace, preprocessed source, and associated run sc=
ript.
Stack dump:
0.	Program arguments: clang -g -Werror -D__TARGET_ARCH_x86 -mlittle-endian =
-I/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769=
c85ef0171caf9fc89f/tools/testing/selftests/bpf/tools/include -I/usr/src/per=
f_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9f=
c89f/tools/testing/selftests/bpf -I/usr/src/perf_selftests-x86_64-rhel-8.3-=
kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/include/uapi -I/u=
sr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85e=
f0171caf9fc89f/tools/testing/selftests/usr/include -idirafter /lib/clang/15=
=2E0.0/include -idirafter /usr/local/include -idirafter /usr/lib/gcc/x86_64=
-linux-gnu/10/../../../../x86_64-linux-gnu/include -idirafter /usr/include/=
x86_64-linux-gnu -idirafter /include -idirafter /usr/include -Wno-compare-d=
istinct-pointer-types -DENABLE_ATOMICS_TESTS -O2 -target bpf -c progs/pyper=
f600.c -mcpu=3Dv3 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71=
b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/pyperf600=
=2Eo
1.	<eof> parser at end of file
2.	Code generation
 #0 0x000055c75e99aab0 PrintStackTraceSignalHandler(void*) Signals.cpp:0:0
 #1 0x000055c75e998914 llvm::sys::CleanupOnSignal(unsigned long) (/bin/clan=
g-15+0x3740914)
 #2 0x000055c75e8dd224 llvm::CrashRecoveryContext::HandleExit(int) (/bin/cl=
ang-15+0x3685224)
 #3 0x000055c75e990d6e llvm::sys::Process::Exit(int, bool) (/bin/clang-15+0=
x3738d6e)
 #4 0x000055c75c36bfa3 (/bin/clang-15+0x1113fa3)
 #5 0x000055c75e8e3c83 llvm::report_fatal_error(llvm::Twine const&, bool) (=
/bin/clang-15+0x368bc83)
 #6 0x000055c75e8e3df8 (/bin/clang-15+0x368bdf8)
 #7 0x000055c75ccab020 (anonymous namespace)::BPFAsmBackend::createObjectTa=
rgetWriter() const BPFAsmBackend.cpp:0:0
 #8 0x000055c75e51155d llvm::MCAssembler::layout(llvm::MCAsmLayout&) (/bin/=
clang-15+0x32b955d)
 #9 0x000055c75e511676 llvm::MCAssembler::Finish() (/bin/clang-15+0x32b9676)
#10 0x000055c75f73f63f llvm::AsmPrinter::doFinalization(llvm::Module&) (/bi=
n/clang-15+0x44e763f)
#11 0x000055c75e0b686d llvm::FPPassManager::doFinalization(llvm::Module&) (=
/bin/clang-15+0x2e5e86d)
#12 0x000055c75e0c1f88 llvm::legacy::PassManagerImpl::run(llvm::Module&) (/=
bin/clang-15+0x2e69f88)
#13 0x000055c75ed19830 clang::EmitBackendOutput(clang::DiagnosticsEngine&, =
clang::HeaderSearchOptions const&, clang::CodeGenOptions const&, clang::Tar=
getOptions const&, clang::LangOptions const&, llvm::StringRef, llvm::Module=
*, clang::BackendAction, std::unique_ptr<llvm::raw_pwrite_stream, std::defa=
ult_delete<llvm::raw_pwrite_stream>>) (/bin/clang-15+0x3ac1830)
#14 0x000055c75fab69cc clang::BackendConsumer::HandleTranslationUnit(clang:=
:ASTContext&) (/bin/clang-15+0x485e9cc)
#15 0x000055c760532409 clang::ParseAST(clang::Sema&, bool, bool) (/bin/clan=
g-15+0x52da409)
#16 0x000055c75f41f399 clang::FrontendAction::Execute() (/bin/clang-15+0x41=
c7399)
#17 0x000055c75f3aab5b clang::CompilerInstance::ExecuteAction(clang::Fronte=
ndAction&) (/bin/clang-15+0x4152b5b)
#18 0x000055c75f4d5950 clang::ExecuteCompilerInvocation(clang::CompilerInst=
ance*) (/bin/clang-15+0x427d950)
#19 0x000055c75c36d40c cc1_main(llvm::ArrayRef<char const*>, char const*, v=
oid*) (/bin/clang-15+0x111540c)
#20 0x000055c75c366a09 ExecuteCC1Tool(llvm::SmallVectorImpl<char const*>&) =
driver.cpp:0:0
#21 0x000055c75f221525 void llvm::function_ref<void ()>::callback_fn<clang:=
:driver::CC1Command::Execute(llvm::ArrayRef<llvm::Optional<llvm::StringRef>=
>, std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<=
char>>*, bool*) const::'lambda'()>(long) Job.cpp:0:0
#22 0x000055c75e8dd0b3 llvm::CrashRecoveryContext::RunSafely(llvm::function=
_ref<void ()>) (/bin/clang-15+0x36850b3)
#23 0x000055c75f221884 clang::driver::CC1Command::Execute(llvm::ArrayRef<ll=
vm::Optional<llvm::StringRef>>, std::__cxx11::basic_string<char, std::char_=
traits<char>, std::allocator<char>>*, bool*) const (.part.0) Job.cpp:0:0
#24 0x000055c75f1ee616 clang::driver::Compilation::ExecuteCommand(clang::dr=
iver::Command const&, clang::driver::Command const*&, bool) const (/bin/cla=
ng-15+0x3f96616)
#25 0x000055c75f1eefbd clang::driver::Compilation::ExecuteJobs(clang::drive=
r::JobList const&, llvm::SmallVectorImpl<std::pair<int, clang::driver::Comm=
and const*>>&, bool) const (/bin/clang-15+0x3f96fbd)
#26 0x000055c75f1fd3fc clang::driver::Driver::ExecuteCompilation(clang::dri=
ver::Compilation&, llvm::SmallVectorImpl<std::pair<int, clang::driver::Comm=
and const*>>&) (/bin/clang-15+0x3fa53fc)
#27 0x000055c75c36b2ca clang_main(int, char**) (/bin/clang-15+0x11132ca)
#28 0x00007f1cee820d0a __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0=
x26d0a)
#29 0x000055c75c3664ea _start (/bin/clang-15+0x110e4ea)
clang-15: error: clang frontend command failed with exit code 70 (use -v to=
 see invocation)
clang version 15.0.0 (git://gitmirror/llvm_project 42a7ddb428c999229491b0ef=
fbb1a4059149fba8)
Target: bpf
Thread model: posix
InstalledDir: /bin
clang-15: note: diagnostic msg:=20
********************

PLEASE ATTACH THE FOLLOWING FILES TO THE BUG REPORT:
Preprocessed source(s) and associated run script(s) are located at:
clang-15: note: diagnostic msg: /tmp/lkp/pyperf600-daf9b4.c
clang-15: note: diagnostic msg: /tmp/lkp/pyperf600-daf9b4.sh
clang-15: note: diagnostic msg:=20

********************
make: *** [Makefile:498: /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf/pyper=
f600.o] Error 1
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/bpf'
2022-06-25 08:23:32 make -C ../../../tools/testing/selftests/net
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftest=
s-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net'
make --no-builtin-rules ARCH=3Dx86 -C ../../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselft=
ests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f'
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/unifdef
  WRAP    arch/x86/include/generated/uapi/asm/bpf_perf_event.h
  WRAP    arch/x86/include/generated/uapi/asm/errno.h
  WRAP    arch/x86/include/generated/uapi/asm/fcntl.h
  WRAP    arch/x86/include/generated/uapi/asm/ioctl.h
  WRAP    arch/x86/include/generated/uapi/asm/ioctls.h
  WRAP    arch/x86/include/generated/uapi/asm/ipcbuf.h
  WRAP    arch/x86/include/generated/uapi/asm/param.h
  WRAP    arch/x86/include/generated/uapi/asm/poll.h
  WRAP    arch/x86/include/generated/uapi/asm/resource.h
  WRAP    arch/x86/include/generated/uapi/asm/socket.h
  WRAP    arch/x86/include/generated/uapi/asm/sockios.h
  WRAP    arch/x86/include/generated/uapi/asm/termbits.h
  WRAP    arch/x86/include/generated/uapi/asm/termios.h
  WRAP    arch/x86/include/generated/uapi/asm/types.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_32.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_64.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_x32.h
  SYSTBL  arch/x86/include/generated/asm/syscalls_32.h
  HOSTCC  arch/x86/tools/relocs_32.o
  HOSTCC  arch/x86/tools/relocs_64.o
  HOSTCC  arch/x86/tools/relocs_common.o
  HOSTLD  arch/x86/tools/relocs
  UPD     include/generated/uapi/linux/version.h
  HDRINST usr/include/asm-generic/posix_types.h
  HDRINST usr/include/asm-generic/ioctl.h
  HDRINST usr/include/asm-generic/fcntl.h
  HDRINST usr/include/asm-generic/bpf_perf_event.h
  HDRINST usr/include/asm-generic/statfs.h
  HDRINST usr/include/asm-generic/int-l64.h
  HDRINST usr/include/asm-generic/mman.h
  HDRINST usr/include/asm-generic/signal-defs.h
  HDRINST usr/include/asm-generic/bitsperlong.h
  HDRINST usr/include/asm-generic/mman-common.h
  HDRINST usr/include/asm-generic/sembuf.h
  HDRINST usr/include/asm-generic/types.h
  HDRINST usr/include/asm-generic/resource.h
  HDRINST usr/include/asm-generic/auxvec.h
  HDRINST usr/include/asm-generic/int-ll64.h
  HDRINST usr/include/asm-generic/swab.h
  HDRINST usr/include/asm-generic/signal.h
  HDRINST usr/include/asm-generic/ucontext.h
  HDRINST usr/include/asm-generic/hugetlb_encode.h
  HDRINST usr/include/asm-generic/termios.h
  HDRINST usr/include/asm-generic/errno-base.h
  HDRINST usr/include/asm-generic/unistd.h
  HDRINST usr/include/asm-generic/errno.h
  HDRINST usr/include/asm-generic/shmbuf.h
  HDRINST usr/include/asm-generic/siginfo.h
  HDRINST usr/include/asm-generic/kvm_para.h
  HDRINST usr/include/asm-generic/stat.h
  HDRINST usr/include/asm-generic/msgbuf.h
  HDRINST usr/include/asm-generic/param.h
  HDRINST usr/include/asm-generic/termbits.h
  HDRINST usr/include/asm-generic/ipcbuf.h
  HDRINST usr/include/asm-generic/socket.h
  HDRINST usr/include/asm-generic/ioctls.h
  HDRINST usr/include/asm-generic/setup.h
  HDRINST usr/include/asm-generic/poll.h
  HDRINST usr/include/asm-generic/sockios.h
  HDRINST usr/include/drm/savage_drm.h
  HDRINST usr/include/drm/via_drm.h
  HDRINST usr/include/drm/drm_sarea.h
  HDRINST usr/include/drm/omap_drm.h
  HDRINST usr/include/drm/qxl_drm.h
  HDRINST usr/include/drm/nouveau_drm.h
  HDRINST usr/include/drm/radeon_drm.h
  HDRINST usr/include/drm/drm.h
  HDRINST usr/include/drm/lima_drm.h
  HDRINST usr/include/drm/msm_drm.h
  HDRINST usr/include/drm/exynos_drm.h
  HDRINST usr/include/drm/mga_drm.h
  HDRINST usr/include/drm/panfrost_drm.h
  HDRINST usr/include/drm/armada_drm.h
  HDRINST usr/include/drm/i915_drm.h
  HDRINST usr/include/drm/drm_mode.h
  HDRINST usr/include/drm/vgem_drm.h
  HDRINST usr/include/drm/r128_drm.h
  HDRINST usr/include/drm/i810_drm.h
  HDRINST usr/include/drm/v3d_drm.h
  HDRINST usr/include/drm/virtgpu_drm.h
  HDRINST usr/include/drm/sis_drm.h
  HDRINST usr/include/drm/vmwgfx_drm.h
  HDRINST usr/include/drm/drm_fourcc.h
  HDRINST usr/include/drm/tegra_drm.h
  HDRINST usr/include/drm/vc4_drm.h
  HDRINST usr/include/drm/etnaviv_drm.h
  HDRINST usr/include/drm/amdgpu_drm.h
  HDRINST usr/include/linux/kexec.h
  HDRINST usr/include/linux/virtio_scsi.h
  HDRINST usr/include/linux/gfs2_ondisk.h
  HDRINST usr/include/linux/mount.h
  HDRINST usr/include/linux/in.h
  HDRINST usr/include/linux/reiserfs_fs.h
  HDRINST usr/include/linux/reboot.h
  HDRINST usr/include/linux/landlock.h
  HDRINST usr/include/linux/wmi.h
  HDRINST usr/include/linux/sound.h
  HDRINST usr/include/linux/mtio.h
  HDRINST usr/include/linux/vfio_ccw.h
  HDRINST usr/include/linux/zorro_ids.h
  HDRINST usr/include/linux/auto_fs4.h
  HDRINST usr/include/linux/patchkey.h
  HDRINST usr/include/linux/btf.h
  HDRINST usr/include/linux/ipmi_bmc.h
  HDRINST usr/include/linux/string.h
  HDRINST usr/include/linux/atmdev.h
  HDRINST usr/include/linux/ip.h
  HDRINST usr/include/linux/sysinfo.h
  HDRINST usr/include/linux/uhid.h
  HDRINST usr/include/linux/vm_sockets_diag.h
  HDRINST usr/include/linux/dlm_device.h
  HDRINST usr/include/linux/atmppp.h
  HDRINST usr/include/linux/posix_types.h
  HDRINST usr/include/linux/capi.h
  HDRINST usr/include/linux/vbox_err.h
  HDRINST usr/include/linux/random.h
  HDRINST usr/include/linux/atmclip.h
  HDRINST usr/include/linux/tiocl.h
  HDRINST usr/include/linux/ioctl.h
  HDRINST usr/include/linux/sem.h
  HDRINST usr/include/linux/sonypi.h
  HDRINST usr/include/linux/joystick.h
  HDRINST usr/include/linux/fadvise.h
  HDRINST usr/include/linux/tipc_sockets_diag.h
  HDRINST usr/include/linux/fcntl.h
  HDRINST usr/include/linux/vhost_types.h
  HDRINST usr/include/linux/tls.h
  HDRINST usr/include/linux/fscrypt.h
  HDRINST usr/include/linux/if_plip.h
  HDRINST usr/include/linux/chio.h
  HDRINST usr/include/linux/sched.h
  HDRINST usr/include/linux/map_to_7segment.h
  HDRINST usr/include/linux/if_tunnel.h
  HDRINST usr/include/linux/nfs3.h
  HDRINST usr/include/linux/dlm_netlink.h
  HDRINST usr/include/linux/bsg.h
  HDRINST usr/include/linux/input-event-codes.h
  HDRINST usr/include/linux/netfilter_decnet.h
  HDRINST usr/include/linux/thermal.h
  HDRINST usr/include/linux/fsl_hypervisor.h
  HDRINST usr/include/linux/cyclades.h
  HDRINST usr/include/linux/hsr_netlink.h
  HDRINST usr/include/linux/max2175.h
  HDRINST usr/include/linux/dma-buf.h
  HDRINST usr/include/linux/xilinx-v4l2-controls.h
  HDRINST usr/include/linux/aspeed-p2a-ctrl.h
  HDRINST usr/include/linux/futex.h
  HDRINST usr/include/linux/phantom.h
  HDRINST usr/include/linux/ioam6.h
  HDRINST usr/include/linux/vdpa.h
  HDRINST usr/include/linux/virtio_9p.h
  HDRINST usr/include/linux/mdio.h
  HDRINST usr/include/linux/virtio_mmio.h
  HDRINST usr/include/linux/sed-opal.h
  HDRINST usr/include/linux/ioprio.h
  HDRINST usr/include/linux/atmbr2684.h
  HDRINST usr/include/linux/hdlc.h
  HDRINST usr/include/linux/bpf_perf_event.h
  HDRINST usr/include/linux/hdreg.h
  HDRINST usr/include/linux/minix_fs.h
  HDRINST usr/include/linux/errqueue.h
  HDRINST usr/include/linux/prctl.h
  HDRINST usr/include/linux/posix_acl.h
  HDRINST usr/include/linux/tty_flags.h
  HDRINST usr/include/linux/mroute6.h
  HDRINST usr/include/linux/comedi.h
  HDRINST usr/include/linux/gpio.h
  HDRINST usr/include/linux/v4l2-subdev.h
  HDRINST usr/include/linux/ivtv.h
  HDRINST usr/include/linux/xattr.h
  HDRINST usr/include/linux/fanotify.h
  HDRINST usr/include/linux/virtio_balloon.h
  HDRINST usr/include/linux/hid.h
  HDRINST usr/include/linux/iommu.h
  HDRINST usr/include/linux/bt-bmc.h
  HDRINST usr/include/linux/virtio_ids.h
  HDRINST usr/include/linux/psci.h
  HDRINST usr/include/linux/neighbour.h
  HDRINST usr/include/linux/pkt_sched.h
  HDRINST usr/include/linux/pkt_cls.h
  HDRINST usr/include/linux/mman.h
  HDRINST usr/include/linux/toshiba.h
  HDRINST usr/include/linux/nfs_idmap.h
  HDRINST usr/include/linux/if_x25.h
  HDRINST usr/include/linux/virtio_blk.h
  HDRINST usr/include/linux/pg.h
  HDRINST usr/include/linux/atmsvc.h
  HDRINST usr/include/linux/fuse.h
  HDRINST usr/include/linux/baycom.h
  HDRINST usr/include/linux/nfc.h
  HDRINST usr/include/linux/sctp.h
  HDRINST usr/include/linux/if_infiniband.h
  HDRINST usr/include/linux/arcfb.h
  HDRINST usr/include/linux/cgroupstats.h
  HDRINST usr/include/linux/if.h
  HDRINST usr/include/linux/if_ltalk.h
  HDRINST usr/include/linux/inotify.h
  HDRINST usr/include/linux/nfs2.h
  HDRINST usr/include/linux/atmlec.h
  HDRINST usr/include/linux/mroute.h
  HDRINST usr/include/linux/ccs.h
  HDRINST usr/include/linux/dm-log-userspace.h
  HDRINST usr/include/linux/zorro.h
  HDRINST usr/include/linux/vfio_zdev.h
  HDRINST usr/include/linux/nbd.h
  HDRINST usr/include/linux/cec.h
  HDRINST usr/include/linux/lwtunnel.h
  HDRINST usr/include/linux/if_vlan.h
  HDRINST usr/include/linux/v4l2-common.h
  HDRINST usr/include/linux/v4l2-dv-timings.h
  HDRINST usr/include/linux/videodev2.h
  HDRINST usr/include/linux/nl80211.h
  HDRINST usr/include/linux/capability.h
  HDRINST usr/include/linux/misc/bcm_vk.h
  HDRINST usr/include/linux/gen_stats.h
  HDRINST usr/include/linux/irqnr.h
  HDRINST usr/include/linux/netfilter_arp.h
  HDRINST usr/include/linux/timerfd.h
  HDRINST usr/include/linux/if_macsec.h
  HDRINST usr/include/linux/netfilter_arp/arp_tables.h
  HDRINST usr/include/linux/netfilter_arp/arpt_mangle.h
  HDRINST usr/include/linux/elf-fdpic.h
  HDRINST usr/include/linux/tc_act/tc_pedit.h
  HDRINST usr/include/linux/tc_act/tc_vlan.h
  HDRINST usr/include/linux/tc_act/tc_bpf.h
  HDRINST usr/include/linux/tc_act/tc_ctinfo.h
  HDRINST usr/include/linux/tc_act/tc_gact.h
  HDRINST usr/include/linux/tc_act/tc_mirred.h
  HDRINST usr/include/linux/tc_act/tc_mpls.h
  HDRINST usr/include/linux/tc_act/tc_ct.h
  HDRINST usr/include/linux/tc_act/tc_csum.h
  HDRINST usr/include/linux/tc_act/tc_nat.h
  HDRINST usr/include/linux/tc_act/tc_connmark.h
  HDRINST usr/include/linux/tc_act/tc_tunnel_key.h
  HDRINST usr/include/linux/tc_act/tc_gate.h
  HDRINST usr/include/linux/tc_act/tc_sample.h
  HDRINST usr/include/linux/tc_act/tc_defact.h
  HDRINST usr/include/linux/tc_act/tc_skbmod.h
  HDRINST usr/include/linux/tc_act/tc_ife.h
  HDRINST usr/include/linux/tc_act/tc_skbedit.h
  HDRINST usr/include/linux/tc_act/tc_ipt.h
  HDRINST usr/include/linux/isdn/capicmd.h
  HDRINST usr/include/linux/rio_cm_cdev.h
  HDRINST usr/include/linux/stm.h
  HDRINST usr/include/linux/bpf.h
  HDRINST usr/include/linux/vduse.h
  HDRINST usr/include/linux/byteorder/big_endian.h
  HDRINST usr/include/linux/byteorder/little_endian.h
  HDRINST usr/include/linux/hdlcdrv.h
  HDRINST usr/include/linux/target_core_user.h
  HDRINST usr/include/linux/virtio_ring.h
  HDRINST usr/include/linux/i8k.h
  HDRINST usr/include/linux/atmapi.h
  HDRINST usr/include/linux/qnxtypes.h
  HDRINST usr/include/linux/if_fddi.h
  HDRINST usr/include/linux/pps.h
  HDRINST usr/include/linux/parport.h
  HDRINST usr/include/linux/idxd.h
  HDRINST usr/include/linux/net_tstamp.h
  HDRINST usr/include/linux/batman_adv.h
  HDRINST usr/include/linux/ppp_defs.h
  HDRINST usr/include/linux/taskstats.h
  HDRINST usr/include/linux/virtio_rng.h
  HDRINST usr/include/linux/batadv_packet.h
  HDRINST usr/include/linux/sunrpc/debug.h
  HDRINST usr/include/linux/seg6.h
  HDRINST usr/include/linux/agpgart.h
  HDRINST usr/include/linux/netlink.h
  HDRINST usr/include/linux/dm-ioctl.h
  HDRINST usr/include/linux/usbdevice_fs.h
  HDRINST usr/include/linux/llc.h
  HDRINST usr/include/linux/x25.h
  HDRINST usr/include/linux/auto_fs.h
  HDRINST usr/include/linux/selinux_netlink.h
  HDRINST usr/include/linux/virtio_gpu.h
  HDRINST usr/include/linux/dvb/version.h
  HDRINST usr/include/linux/dvb/osd.h
  HDRINST usr/include/linux/dvb/audio.h
  HDRINST usr/include/linux/dvb/dmx.h
  HDRINST usr/include/linux/dvb/video.h
  HDRINST usr/include/linux/dvb/frontend.h
  HDRINST usr/include/linux/dvb/ca.h
  HDRINST usr/include/linux/dvb/net.h
  HDRINST usr/include/linux/efs_fs_sb.h
  HDRINST usr/include/linux/atm_tcp.h
  HDRINST usr/include/linux/kernel.h
  HDRINST usr/include/linux/dlm_plock.h
  HDRINST usr/include/linux/shm.h
  HDRINST usr/include/linux/if_team.h
  HDRINST usr/include/linux/watch_queue.h
  HDRINST usr/include/linux/blkpg.h
  HDRINST usr/include/linux/netfilter_bridge.h
  HDRINST usr/include/linux/serial_reg.h
  HDRINST usr/include/linux/mmc/ioctl.h
  HDRINST usr/include/linux/wireguard.h
  HDRINST usr/include/linux/qemu_fw_cfg.h
  HDRINST usr/include/linux/tee.h
  HDRINST usr/include/linux/types.h
  HDRINST usr/include/linux/vtpm_proxy.h
  HDRINST usr/include/linux/a.out.h
  HDRINST usr/include/linux/rpl_iptunnel.h
  HDRINST usr/include/linux/if_eql.h
  HDRINST usr/include/linux/hdlc/ioctl.h
  HDRINST usr/include/linux/in_route.h
  HDRINST usr/include/linux/ipc.h
  HDRINST usr/include/linux/virtio_mem.h
  HDRINST usr/include/linux/time_types.h
  HDRINST usr/include/linux/affs_hardblocks.h
  HDRINST usr/include/linux/uleds.h
  HDRINST usr/include/linux/atm_nicstar.h
  HDRINST usr/include/linux/ipsec.h
  HDRINST usr/include/linux/dns_resolver.h
  HDRINST usr/include/linux/dqblk_xfs.h
  HDRINST usr/include/linux/securebits.h
  HDRINST usr/include/linux/virtio_iommu.h
  HDRINST usr/include/linux/virtio_types.h
  HDRINST usr/include/linux/netfilter_ipv6.h
  HDRINST usr/include/linux/raid/md_u.h
  HDRINST usr/include/linux/raid/md_p.h
  HDRINST usr/include/linux/if_packet.h
  HDRINST usr/include/linux/pktcdvd.h
  HDRINST usr/include/linux/auto_dev-ioctl.h
  HDRINST usr/include/linux/radeonfb.h
  HDRINST usr/include/linux/seg6_hmac.h
  HDRINST usr/include/linux/unix_diag.h
  HDRINST usr/include/linux/reiserfs_xattr.h
  HDRINST usr/include/linux/pci.h
  HDRINST usr/include/linux/firewire-cdev.h
  HDRINST usr/include/linux/romfs_fs.h
  HDRINST usr/include/linux/const.h
  HDRINST usr/include/linux/tipc_netlink.h
  HDRINST usr/include/linux/pmu.h
  HDRINST usr/include/linux/perf_event.h
  HDRINST usr/include/linux/virtio_i2c.h
  HDRINST usr/include/linux/in6.h
  HDRINST usr/include/linux/mmtimer.h
  HDRINST usr/include/linux/wait.h
  HDRINST usr/include/linux/rpmsg_types.h
  HDRINST usr/include/linux/dccp.h
  HDRINST usr/include/linux/kdev_t.h
  HDRINST usr/include/linux/resource.h
  HDRINST usr/include/linux/seg6_genl.h
  HDRINST usr/include/linux/ipv6_route.h
  HDRINST usr/include/linux/auxvec.h
  HDRINST usr/include/linux/smc_diag.h
  HDRINST usr/include/linux/acct.h
  HDRINST usr/include/linux/btrfs.h
  HDRINST usr/include/linux/cuda.h
  HDRINST usr/include/linux/udmabuf.h
  HDRINST usr/include/linux/seccomp.h
  HDRINST usr/include/linux/loop.h
  HDRINST usr/include/linux/virtio_pmem.h
  HDRINST usr/include/linux/virtio_pci.h
  HDRINST usr/include/linux/qrtr.h
  HDRINST usr/include/linux/atmsap.h
  HDRINST usr/include/linux/fd.h
  HDRINST usr/include/linux/nubus.h
  HDRINST usr/include/linux/dn.h
  HDRINST usr/include/linux/pfrut.h
  HDRINST usr/include/linux/ipv6.h
  HDRINST usr/include/linux/ethtool.h
  HDRINST usr/include/linux/swab.h
  HDRINST usr/include/linux/mpls_iptunnel.h
  HDRINST usr/include/linux/nexthop.h
  HDRINST usr/include/linux/openat2.h
  HDRINST usr/include/linux/pidfd.h
  HDRINST usr/include/linux/watchdog.h
  HDRINST usr/include/linux/switchtec_ioctl.h
  HDRINST usr/include/linux/arm_sdei.h
  HDRINST usr/include/linux/media-bus-format.h
  HDRINST usr/include/linux/mctp.h
  HDRINST usr/include/linux/uvcvideo.h
  HDRINST usr/include/linux/wwan.h
  HDRINST usr/include/linux/signal.h
  HDRINST usr/include/linux/fou.h
  HDRINST usr/include/linux/magic.h
  HDRINST usr/include/linux/surface_aggregator/cdev.h
  HDRINST usr/include/linux/surface_aggregator/dtx.h
  HDRINST usr/include/linux/fsmap.h
  HDRINST usr/include/linux/keyboard.h
  HDRINST usr/include/linux/genwqe/genwqe_card.h
  HDRINST usr/include/linux/mqueue.h
  HDRINST usr/include/linux/virtio_scmi.h
  HDRINST usr/include/linux/posix_acl_xattr.h
  HDRINST usr/include/linux/nvram.h
  HDRINST usr/include/linux/kvm.h
  HDRINST usr/include/linux/ivtvfb.h
  HDRINST usr/include/linux/hyperv.h
  HDRINST usr/include/linux/openvswitch.h
  HDRINST usr/include/linux/iso_fs.h
  HDRINST usr/include/linux/virtio_snd.h
  HDRINST usr/include/linux/cycx_cfm.h
  HDRINST usr/include/linux/termios.h
  HDRINST usr/include/linux/netfilter_ipv4.h
  HDRINST usr/include/linux/bcm933xx_hcs.h
  HDRINST usr/include/linux/remoteproc_cdev.h
  HDRINST usr/include/linux/eventpoll.h
  HDRINST usr/include/linux/limits.h
  HDRINST usr/include/linux/virtio_bt.h
  HDRINST usr/include/linux/v4l2-controls.h
  HDRINST usr/include/linux/smc.h
  HDRINST usr/include/linux/pr.h
  HDRINST usr/include/linux/rpl.h
  HDRINST usr/include/linux/if_hippi.h
  HDRINST usr/include/linux/atalk.h
  HDRINST usr/include/linux/unistd.h
  HDRINST usr/include/linux/ultrasound.h
  HDRINST usr/include/linux/quota.h
  HDRINST usr/include/linux/virtio_gpio.h
  HDRINST usr/include/linux/if_slip.h
  HDRINST usr/include/linux/vhost.h
  HDRINST usr/include/linux/suspend_ioctls.h
  HDRINST usr/include/linux/rfkill.h
  HDRINST usr/include/linux/aspeed-lpc-ctrl.h
  HDRINST usr/include/linux/kfd_sysfs.h
  HDRINST usr/include/linux/devlink.h
  HDRINST usr/include/linux/ptrace.h
  HDRINST usr/include/linux/errno.h
  HDRINST usr/include/linux/ioam6_iptunnel.h
  HDRINST usr/include/linux/mempolicy.h
  HDRINST usr/include/linux/phonet.h
  HDRINST usr/include/linux/cciss_ioctl.h
  HDRINST usr/include/linux/fs.h
  HDRINST usr/include/linux/kd.h
  HDRINST usr/include/linux/nfs.h
  HDRINST usr/include/linux/if_pppox.h
  HDRINST usr/include/linux/if_ppp.h
  HDRINST usr/include/linux/cxl_mem.h
  HDRINST usr/include/linux/android/binderfs.h
  HDRINST usr/include/linux/android/binder.h
  HDRINST usr/include/linux/if_xdp.h
  HDRINST usr/include/linux/hidraw.h
  HDRINST usr/include/linux/major.h
  HDRINST usr/include/linux/tipc.h
  HDRINST usr/include/linux/v4l2-mediabus.h
  HDRINST usr/include/linux/atmioc.h
  HDRINST usr/include/linux/cdrom.h
  HDRINST usr/include/linux/io_uring.h
  HDRINST usr/include/linux/ioam6_genl.h
  HDRINST usr/include/linux/if_bridge.h
  HDRINST usr/include/linux/synclink.h
  HDRINST usr/include/linux/netlink_diag.h
  HDRINST usr/include/linux/mii.h
  HDRINST usr/include/linux/if_addr.h
  HDRINST usr/include/linux/counter.h
  HDRINST usr/include/linux/dcbnl.h
  HDRINST usr/include/linux/inet_diag.h
  HDRINST usr/include/linux/nbd-netlink.h
  HDRINST usr/include/linux/uinput.h
  HDRINST usr/include/linux/kvm_para.h
  HDRINST usr/include/linux/rtc.h
  HDRINST usr/include/linux/lp.h
  HDRINST usr/include/linux/serial_core.h
  HDRINST usr/include/linux/can.h
  HDRINST usr/include/linux/ax25.h
  HDRINST usr/include/linux/virtio_pcidev.h
  HDRINST usr/include/linux/usb/ch11.h
  HDRINST usr/include/linux/usb/charger.h
  HDRINST usr/include/linux/usb/audio.h
  HDRINST usr/include/linux/usb/video.h
  HDRINST usr/include/linux/usb/cdc-wdm.h
  HDRINST usr/include/linux/usb/raw_gadget.h
  HDRINST usr/include/linux/usb/functionfs.h
  HDRINST usr/include/linux/usb/g_uvc.h
  HDRINST usr/include/linux/usb/g_printer.h
  HDRINST usr/include/linux/usb/gadgetfs.h
  HDRINST usr/include/linux/usb/midi.h
  HDRINST usr/include/linux/usb/ch9.h
  HDRINST usr/include/linux/usb/cdc.h
  HDRINST usr/include/linux/usb/tmc.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_REJECT.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_LOG.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ah.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ecn.h
  HDRINST usr/include/linux/netfilter_ipv4/ip_tables.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ECN.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_TTL.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ttl.h
  HDRINST usr/include/linux/nfs4.h
  HDRINST usr/include/linux/hiddev.h
  HDRINST usr/include/linux/screen_info.h
  HDRINST usr/include/linux/icmpv6.h
  HDRINST usr/include/linux/kcov.h
  HDRINST usr/include/linux/vboxguest.h
  HDRINST usr/include/linux/rtnetlink.h
  HDRINST usr/include/linux/nilfs2_ondisk.h
  HDRINST usr/include/linux/spi/spidev.h
  HDRINST usr/include/linux/spi/spi.h
  HDRINST usr/include/linux/coda.h
  HDRINST usr/include/linux/serial.h
  HDRINST usr/include/linux/adb.h
  HDRINST usr/include/linux/dlm.h
  HDRINST usr/include/linux/connector.h
  HDRINST usr/include/linux/utime.h
  HDRINST usr/include/linux/memfd.h
  HDRINST usr/include/linux/lirc.h
  HDRINST usr/include/linux/omapfb.h
  HDRINST usr/include/linux/membarrier.h
  HDRINST usr/include/linux/pfkeyv2.h
  HDRINST usr/include/linux/ila.h
  HDRINST usr/include/linux/usbip.h
  HDRINST usr/include/linux/qnx4_fs.h
  HDRINST usr/include/linux/if_tun.h
  HDRINST usr/include/linux/stat.h
  HDRINST usr/include/linux/tipc_config.h
  HDRINST usr/include/linux/map_to_14segment.h
  HDRINST usr/include/linux/dlmconstants.h
  HDRINST usr/include/linux/coresight-stm.h
  HDRINST usr/include/linux/falloc.h
  HDRINST usr/include/linux/fsl_mc.h
  HDRINST usr/include/linux/i2c.h
  HDRINST usr/include/linux/if_fc.h
  HDRINST usr/include/linux/timex.h
  HDRINST usr/include/linux/netfilter/xt_cluster.h
  HDRINST usr/include/linux/netfilter/xt_sctp.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_sctp.h
  HDRINST usr/include/linux/netfilter/nf_synproxy.h
  HDRINST usr/include/linux/netfilter/nfnetlink_log.h
  HDRINST usr/include/linux/netfilter/xt_LOG.h
  HDRINST usr/include/linux/netfilter/xt_policy.h
  HDRINST usr/include/linux/netfilter/xt_RATEEST.h
  HDRINST usr/include/linux/netfilter/xt_cpu.h
  HDRINST usr/include/linux/netfilter/xt_rpfilter.h
  HDRINST usr/include/linux/netfilter/xt_devgroup.h
  HDRINST usr/include/linux/netfilter/xt_quota.h
  HDRINST usr/include/linux/netfilter/xt_CHECKSUM.h
  HDRINST usr/include/linux/netfilter/xt_set.h
  HDRINST usr/include/linux/netfilter/xt_state.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_list.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_hash.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_bitmap.h
  HDRINST usr/include/linux/netfilter/xt_LED.h
  HDRINST usr/include/linux/netfilter/nfnetlink_osf.h
  HDRINST usr/include/linux/netfilter/xt_mark.h
  HDRINST usr/include/linux/netfilter/xt_multiport.h
  HDRINST usr/include/linux/netfilter/nf_tables_compat.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_ftp.h
  HDRINST usr/include/linux/netfilter/xt_HMARK.h
  HDRINST usr/include/linux/netfilter/xt_ecn.h
  HDRINST usr/include/linux/netfilter/xt_owner.h
  HDRINST usr/include/linux/netfilter/nfnetlink_cttimeout.h
  HDRINST usr/include/linux/netfilter/xt_ipcomp.h
  HDRINST usr/include/linux/netfilter/nfnetlink_acct.h
  HDRINST usr/include/linux/netfilter/xt_IDLETIMER.h
  HDRINST usr/include/linux/netfilter/xt_MARK.h
  HDRINST usr/include/linux/netfilter/xt_length.h
  HDRINST usr/include/linux/netfilter/xt_esp.h
  HDRINST usr/include/linux/netfilter/xt_connlimit.h
  HDRINST usr/include/linux/netfilter/xt_SECMARK.h
  HDRINST usr/include/linux/netfilter/xt_comment.h
  HDRINST usr/include/linux/netfilter/nfnetlink_queue.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_tuple_common.h
  HDRINST usr/include/linux/netfilter/xt_iprange.h
  HDRINST usr/include/linux/netfilter/nf_nat.h
  HDRINST usr/include/linux/netfilter/xt_conntrack.h
  HDRINST usr/include/linux/netfilter/xt_bpf.h
  HDRINST usr/include/linux/netfilter/xt_statistic.h
  HDRINST usr/include/linux/netfilter/nfnetlink.h
  HDRINST usr/include/linux/netfilter/xt_addrtype.h
  HDRINST usr/include/linux/netfilter/xt_CT.h
  HDRINST usr/include/linux/netfilter/xt_NFQUEUE.h
  HDRINST usr/include/linux/netfilter/nfnetlink_conntrack.h
  HDRINST usr/include/linux/netfilter/xt_pkttype.h
  HDRINST usr/include/linux/netfilter/xt_nfacct.h
  HDRINST usr/include/linux/netfilter/xt_TCPOPTSTRIP.h
  HDRINST usr/include/linux/netfilter/xt_connbytes.h
  HDRINST usr/include/linux/netfilter/xt_hashlimit.h
  HDRINST usr/include/linux/netfilter/xt_l2tp.h
  HDRINST usr/include/linux/netfilter/xt_socket.h
  HDRINST usr/include/linux/netfilter/nf_tables.h
  HDRINST usr/include/linux/netfilter/xt_tcpmss.h
  HDRINST usr/include/linux/netfilter/xt_SYNPROXY.h
  HDRINST usr/include/linux/netfilter/xt_physdev.h
  HDRINST usr/include/linux/netfilter/nfnetlink_hook.h
  HDRINST usr/include/linux/netfilter/xt_helper.h
  HDRINST usr/include/linux/netfilter/xt_limit.h
  HDRINST usr/include/linux/netfilter/xt_TCPMSS.h
  HDRINST usr/include/linux/netfilter/xt_u32.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_tcp.h
  HDRINST usr/include/linux/netfilter/xt_string.h
  HDRINST usr/include/linux/netfilter/xt_NFLOG.h
  HDRINST usr/include/linux/netfilter/xt_CLASSIFY.h
  HDRINST usr/include/linux/netfilter/xt_rateest.h
  HDRINST usr/include/linux/netfilter/nfnetlink_cthelper.h
  HDRINST usr/include/linux/netfilter/xt_ipvs.h
  HDRINST usr/include/linux/netfilter/nf_log.h
  HDRINST usr/include/linux/netfilter/xt_dscp.h
  HDRINST usr/include/linux/netfilter/xt_tcpudp.h
  HDRINST usr/include/linux/netfilter/xt_recent.h
  HDRINST usr/include/linux/netfilter/xt_DSCP.h
  HDRINST usr/include/linux/netfilter/xt_CONNMARK.h
  HDRINST usr/include/linux/netfilter/xt_CONNSECMARK.h
  HDRINST usr/include/linux/netfilter/xt_TEE.h
  HDRINST usr/include/linux/netfilter/xt_connlabel.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_common.h
  HDRINST usr/include/linux/netfilter/nfnetlink_compat.h
  HDRINST usr/include/linux/netfilter/xt_mac.h
  HDRINST usr/include/linux/netfilter/xt_cgroup.h
  HDRINST usr/include/linux/netfilter/xt_realm.h
  HDRINST usr/include/linux/netfilter/xt_AUDIT.h
  HDRINST usr/include/linux/netfilter/xt_TPROXY.h
  HDRINST usr/include/linux/netfilter/xt_time.h
  HDRINST usr/include/linux/netfilter/x_tables.h
  HDRINST usr/include/linux/netfilter/xt_osf.h
  HDRINST usr/include/linux/netfilter/xt_dccp.h
  HDRINST usr/include/linux/netfilter/xt_connmark.h
  HDRINST usr/include/linux/rseq.h
  HDRINST usr/include/linux/atmmpc.h
  HDRINST usr/include/linux/ip_vs.h
  HDRINST usr/include/linux/adfs_fs.h
  HDRINST usr/include/linux/gtp.h
  HDRINST usr/include/linux/if_pppol2tp.h
  HDRINST usr/include/linux/audit.h
  HDRINST usr/include/linux/cm4000_cs.h
  HDRINST usr/include/linux/if_arcnet.h
  HDRINST usr/include/linux/atm_he.h
  HDRINST usr/include/linux/netfilter.h
  HDRINST usr/include/linux/ethtool_netlink.h
  HDRINST usr/include/linux/atm_eni.h
  HDRINST usr/include/linux/ppp-comp.h
  HDRINST usr/include/linux/ptp_clock.h
  HDRINST usr/include/linux/binfmts.h
  HDRINST usr/include/linux/apm_bios.h
  HDRINST usr/include/linux/wireless.h
  HDRINST usr/include/linux/psp-sev.h
  HDRINST usr/include/linux/uio.h
  HDRINST usr/include/linux/vbox_vmmdev_types.h
  HDRINST usr/include/linux/ppdev.h
  HDRINST usr/include/linux/userio.h
  HDRINST usr/include/linux/if_addrlabel.h
  HDRINST usr/include/linux/utsname.h
  HDRINST usr/include/linux/sysctl.h
  HDRINST usr/include/linux/cramfs_fs.h
  HDRINST usr/include/linux/hw_breakpoint.h
  HDRINST usr/include/linux/nfs4_mount.h
  HDRINST usr/include/linux/close_range.h
  HDRINST usr/include/linux/i2o-dev.h
  HDRINST usr/include/linux/uuid.h
  HDRINST usr/include/linux/mrp_bridge.h
  HDRINST usr/include/linux/if_link.h
  HDRINST usr/include/linux/net_namespace.h
  HDRINST usr/include/linux/cfm_bridge.h
  HDRINST usr/include/linux/blktrace_api.h
  HDRINST usr/include/linux/can/j1939.h
  HDRINST usr/include/linux/can/gw.h
  HDRINST usr/include/linux/can/netlink.h
  HDRINST usr/include/linux/can/bcm.h
  HDRINST usr/include/linux/can/vxcan.h
  HDRINST usr/include/linux/can/error.h
  HDRINST usr/include/linux/can/isotp.h
  HDRINST usr/include/linux/can/raw.h
  HDRINST usr/include/linux/netrom.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_hl.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_mh.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_REJECT.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_LOG.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_ah.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_HL.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_NPT.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6_tables.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_ipv6header.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_frag.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_opts.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_srh.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_rt.h
  HDRINST usr/include/linux/edd.h
  HDRINST usr/include/linux/packet_diag.h
  HDRINST usr/include/linux/param.h
  HDRINST usr/include/linux/nitro_enclaves.h
  HDRINST usr/include/linux/virtio_crypto.h
  HDRINST usr/include/linux/vm_sockets.h
  HDRINST usr/include/linux/snmp.h
  HDRINST usr/include/linux/kernel-page-flags.h
  HDRINST usr/include/linux/scc.h
  HDRINST usr/include/linux/ipmi_msgdefs.h
  HDRINST usr/include/linux/tcp_metrics.h
  HDRINST usr/include/linux/amt.h
  HDRINST usr/include/linux/virtio_input.h
  HDRINST usr/include/linux/udf_fs_i.h
  HDRINST usr/include/linux/un.h
  HDRINST usr/include/linux/vfio.h
  HDRINST usr/include/linux/virtio_net.h
  HDRINST usr/include/linux/fb.h
  HDRINST usr/include/linux/acrn.h
  HDRINST usr/include/linux/atmarp.h
  HDRINST usr/include/linux/cryptouser.h
  HDRINST usr/include/linux/pci_regs.h
  HDRINST usr/include/linux/nfsd/debug.h
  HDRINST usr/include/linux/nfsd/export.h
  HDRINST usr/include/linux/nfsd/cld.h
  HDRINST usr/include/linux/nfsd/stats.h
  HDRINST usr/include/linux/mpls.h
  HDRINST usr/include/linux/filter.h
  HDRINST usr/include/linux/nl80211-vnd-intel.h
  HDRINST usr/include/linux/rds.h
  HDRINST usr/include/linux/smiapp.h
  HDRINST usr/include/linux/veth.h
  HDRINST usr/include/linux/elf.h
  HDRINST usr/include/linux/bpfilter.h
  HDRINST usr/include/linux/firewire-constants.h
  HDRINST usr/include/linux/module.h
  HDRINST usr/include/linux/kcm.h
  HDRINST usr/include/linux/net.h
  HDRINST usr/include/linux/input.h
  HDRINST usr/include/linux/socket.h
  HDRINST usr/include/linux/gsmmux.h
  HDRINST usr/include/linux/mptcp.h
  HDRINST usr/include/linux/kcmp.h
  HDRINST usr/include/linux/isst_if.h
  HDRINST usr/include/linux/kernelcapi.h
  HDRINST usr/include/linux/sonet.h
  HDRINST usr/include/linux/fpga-dfl.h
  HDRINST usr/include/linux/tty.h
  HDRINST usr/include/linux/ncsi.h
  HDRINST usr/include/linux/um_timetravel.h
  HDRINST usr/include/linux/atm_zatm.h
  HDRINST usr/include/linux/sched/types.h
  HDRINST usr/include/linux/cciss_defs.h
  HDRINST usr/include/linux/rxrpc.h
  HDRINST usr/include/linux/netconf.h
  HDRINST usr/include/linux/virtio_console.h
  HDRINST usr/include/linux/l2tp.h
  HDRINST usr/include/linux/if_ether.h
  HDRINST usr/include/linux/hash_info.h
  HDRINST usr/include/linux/bpqether.h
  HDRINST usr/include/linux/icmp.h
  HDRINST usr/include/linux/msg.h
  HDRINST usr/include/linux/if_phonet.h
  HDRINST usr/include/linux/if_cablemodem.h
  HDRINST usr/include/linux/times.h
  HDRINST usr/include/linux/if_arp.h
  HDRINST usr/include/linux/igmp.h
  HDRINST usr/include/linux/oom.h
  HDRINST usr/include/linux/tcp.h
  HDRINST usr/include/linux/gameport.h
  HDRINST usr/include/linux/fiemap.h
  HDRINST usr/include/linux/vmcore.h
  HDRINST usr/include/linux/caif/caif_socket.h
  HDRINST usr/include/linux/caif/if_caif.h
  HDRINST usr/include/linux/xfrm.h
  HDRINST usr/include/linux/i2c-dev.h
  HDRINST usr/include/linux/f2fs.h
  HDRINST usr/include/linux/blkzoned.h
  HDRINST usr/include/linux/genetlink.h
  HDRINST usr/include/linux/rio_mport_cdev.h
  HDRINST usr/include/linux/rkisp1-config.h
  HDRINST usr/include/linux/ppp-ioctl.h
  HDRINST usr/include/linux/btrfs_tree.h
  HDRINST usr/include/linux/fsi.h
  HDRINST usr/include/linux/xdp_diag.h
  HDRINST usr/include/linux/nfsacl.h
  HDRINST usr/include/linux/rpmsg.h
  HDRINST usr/include/linux/elf-em.h
  HDRINST usr/include/linux/atm_idt77105.h
  HDRINST usr/include/linux/nvme_ioctl.h
  HDRINST usr/include/linux/hpet.h
  HDRINST usr/include/linux/cec-funcs.h
  HDRINST usr/include/linux/stddef.h
  HDRINST usr/include/linux/media.h
  HDRINST usr/include/linux/omap3isp.h
  HDRINST usr/include/linux/signalfd.h
  HDRINST usr/include/linux/fib_rules.h
  HDRINST usr/include/linux/vsockmon.h
  HDRINST usr/include/linux/keyctl.h
  HDRINST usr/include/linux/meye.h
  HDRINST usr/include/linux/ipmi.h
  HDRINST usr/include/linux/sock_diag.h
  HDRINST usr/include/linux/if_bonding.h
  HDRINST usr/include/linux/time.h
  HDRINST usr/include/linux/mei.h
  HDRINST usr/include/linux/psample.h
  HDRINST usr/include/linux/ndctl.h
  HDRINST usr/include/linux/route.h
  HDRINST usr/include/linux/netdevice.h
  HDRINST usr/include/linux/udp.h
  HDRINST usr/include/linux/tc_ematch/tc_em_ipt.h
  HDRINST usr/include/linux/tc_ematch/tc_em_nbyte.h
  HDRINST usr/include/linux/tc_ematch/tc_em_text.h
  HDRINST usr/include/linux/tc_ematch/tc_em_cmp.h
  HDRINST usr/include/linux/tc_ematch/tc_em_meta.h
  HDRINST usr/include/linux/iio/events.h
  HDRINST usr/include/linux/iio/types.h
  HDRINST usr/include/linux/iio/buffer.h
  HDRINST usr/include/linux/fdreg.h
  HDRINST usr/include/linux/sync_file.h
  HDRINST usr/include/linux/ip6_tunnel.h
  HDRINST usr/include/linux/userfaultfd.h
  HDRINST usr/include/linux/seg6_iptunnel.h
  HDRINST usr/include/linux/atm.h
  HDRINST usr/include/linux/vt.h
  HDRINST usr/include/linux/nsfs.h
  HDRINST usr/include/linux/kfd_ioctl.h
  HDRINST usr/include/linux/nfs_mount.h
  HDRINST usr/include/linux/am437x-vpfe.h
  HDRINST usr/include/linux/msdos_fs.h
  HDRINST usr/include/linux/scif_ioctl.h
  HDRINST usr/include/linux/virtio_config.h
  HDRINST usr/include/linux/poll.h
  HDRINST usr/include/linux/dma-heap.h
  HDRINST usr/include/linux/virtio_vsock.h
  HDRINST usr/include/linux/if_alg.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_log.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_pkttype.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_among.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_mark_t.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_nat.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_arp.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_802_3.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_stp.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_ip6.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_arpreply.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_limit.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_vlan.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_ip.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_nflog.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_mark_m.h
  HDRINST usr/include/linux/netfilter_bridge/ebtables.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_redirect.h
  HDRINST usr/include/linux/soundcard.h
  HDRINST usr/include/linux/hsi/cs-protocol.h
  HDRINST usr/include/linux/hsi/hsi_char.h
  HDRINST usr/include/linux/seg6_local.h
  HDRINST usr/include/linux/ife.h
  HDRINST usr/include/linux/serio.h
  HDRINST usr/include/linux/aio_abi.h
  HDRINST usr/include/linux/cifs/cifs_mount.h
  HDRINST usr/include/linux/cifs/cifs_netlink.h
  HDRINST usr/include/linux/nilfs2_api.h
  HDRINST usr/include/linux/sockios.h
  HDRINST usr/include/linux/bfs_fs.h
  HDRINST usr/include/linux/net_dropmon.h
  HDRINST usr/include/linux/pcitest.h
  HDRINST usr/include/linux/jffs2.h
  HDRINST usr/include/linux/nfs_fs.h
  HDRINST usr/include/linux/libc-compat.h
  HDRINST usr/include/linux/rose.h
  HDRINST usr/include/linux/fsverity.h
  HDRINST usr/include/linux/bpf_common.h
  HDRINST usr/include/linux/erspan.h
  HDRINST usr/include/linux/personality.h
  HDRINST usr/include/linux/matroxfb.h
  HDRINST usr/include/linux/virtio_fs.h
  HDRINST usr/include/linux/cn_proc.h
  HDRINST usr/include/linux/coff.h
  HDRINST usr/include/misc/ocxl.h
  HDRINST usr/include/misc/pvpanic.h
  HDRINST usr/include/misc/uacce/hisi_qm.h
  HDRINST usr/include/misc/uacce/uacce.h
  HDRINST usr/include/misc/cxl.h
  HDRINST usr/include/misc/fastrpc.h
  HDRINST usr/include/misc/habanalabs.h
  HDRINST usr/include/misc/xilinx_sdfec.h
  HDRINST usr/include/mtd/mtd-abi.h
  HDRINST usr/include/mtd/nftl-user.h
  HDRINST usr/include/mtd/mtd-user.h
  HDRINST usr/include/mtd/inftl-user.h
  HDRINST usr/include/mtd/ubi-user.h
  HDRINST usr/include/rdma/hfi/hfi1_user.h
  HDRINST usr/include/rdma/hfi/hfi1_ioctl.h
  HDRINST usr/include/rdma/ib_user_ioctl_verbs.h
  HDRINST usr/include/rdma/ocrdma-abi.h
  HDRINST usr/include/rdma/ib_user_ioctl_cmds.h
  HDRINST usr/include/rdma/cxgb4-abi.h
  HDRINST usr/include/rdma/mlx5-abi.h
  HDRINST usr/include/rdma/irdma-abi.h
  HDRINST usr/include/rdma/rdma_netlink.h
  HDRINST usr/include/rdma/mlx5_user_ioctl_cmds.h
  HDRINST usr/include/rdma/mlx4-abi.h
  HDRINST usr/include/rdma/vmw_pvrdma-abi.h
  HDRINST usr/include/rdma/rdma_user_cm.h
  HDRINST usr/include/rdma/siw-abi.h
  HDRINST usr/include/rdma/rdma_user_ioctl.h
  HDRINST usr/include/rdma/ib_user_mad.h
  HDRINST usr/include/rdma/hns-abi.h
  HDRINST usr/include/rdma/rvt-abi.h
  HDRINST usr/include/rdma/bnxt_re-abi.h
  HDRINST usr/include/rdma/mthca-abi.h
  HDRINST usr/include/rdma/rdma_user_ioctl_cmds.h
  HDRINST usr/include/rdma/ib_user_sa.h
  HDRINST usr/include/rdma/rdma_user_rxe.h
  HDRINST usr/include/rdma/mlx5_user_ioctl_verbs.h
  HDRINST usr/include/rdma/efa-abi.h
  HDRINST usr/include/rdma/qedr-abi.h
  HDRINST usr/include/rdma/ib_user_verbs.h
  HDRINST usr/include/scsi/scsi_bsg_ufs.h
  HDRINST usr/include/scsi/scsi_netlink_fc.h
  HDRINST usr/include/scsi/scsi_netlink.h
  HDRINST usr/include/scsi/fc/fc_ns.h
  HDRINST usr/include/scsi/fc/fc_fs.h
  HDRINST usr/include/scsi/fc/fc_els.h
  HDRINST usr/include/scsi/fc/fc_gs.h
  HDRINST usr/include/scsi/scsi_bsg_fc.h
  HDRINST usr/include/scsi/cxlflash_ioctl.h
  HDRINST usr/include/sound/sfnt_info.h
  HDRINST usr/include/sound/asequencer.h
  HDRINST usr/include/sound/compress_offload.h
  HDRINST usr/include/sound/asoc.h
  HDRINST usr/include/sound/sb16_csp.h
  HDRINST usr/include/sound/emu10k1.h
  HDRINST usr/include/sound/firewire.h
  HDRINST usr/include/sound/asound_fm.h
  HDRINST usr/include/sound/usb_stream.h
  HDRINST usr/include/sound/snd_sst_tokens.h
  HDRINST usr/include/sound/hdsp.h
  HDRINST usr/include/sound/snd_ar_tokens.h
  HDRINST usr/include/sound/sof/fw.h
  HDRINST usr/include/sound/sof/tokens.h
  HDRINST usr/include/sound/sof/abi.h
  HDRINST usr/include/sound/sof/header.h
  HDRINST usr/include/sound/hdspm.h
  HDRINST usr/include/sound/compress_params.h
  HDRINST usr/include/sound/tlv.h
  HDRINST usr/include/sound/asound.h
  HDRINST usr/include/sound/skl-tplg-interface.h
  HDRINST usr/include/video/edid.h
  HDRINST usr/include/video/uvesafb.h
  HDRINST usr/include/video/sisfb.h
  HDRINST usr/include/xen/gntdev.h
  HDRINST usr/include/xen/evtchn.h
  HDRINST usr/include/xen/privcmd.h
  HDRINST usr/include/xen/gntalloc.h
  HDRINST usr/include/linux/version.h
  HDRINST usr/include/asm/posix_types.h
  HDRINST usr/include/asm/sgx.h
  HDRINST usr/include/asm/vsyscall.h
  HDRINST usr/include/asm/prctl.h
  HDRINST usr/include/asm/statfs.h
  HDRINST usr/include/asm/mman.h
  HDRINST usr/include/asm/bitsperlong.h
  HDRINST usr/include/asm/boot.h
  HDRINST usr/include/asm/bootparam.h
  HDRINST usr/include/asm/debugreg.h
  HDRINST usr/include/asm/perf_regs.h
  HDRINST usr/include/asm/sembuf.h
  HDRINST usr/include/asm/kvm_perf.h
  HDRINST usr/include/asm/a.out.h
  HDRINST usr/include/asm/vm86.h
  HDRINST usr/include/asm/sigcontext.h
  HDRINST usr/include/asm/auxvec.h
  HDRINST usr/include/asm/msr.h
  HDRINST usr/include/asm/e820.h
  HDRINST usr/include/asm/swab.h
  HDRINST usr/include/asm/mce.h
  HDRINST usr/include/asm/signal.h
  HDRINST usr/include/asm/ucontext.h
  HDRINST usr/include/asm/ist.h
  HDRINST usr/include/asm/kvm.h
  HDRINST usr/include/asm/posix_types_64.h
  HDRINST usr/include/asm/unistd.h
  HDRINST usr/include/asm/processor-flags.h
  HDRINST usr/include/asm/ptrace.h
  HDRINST usr/include/asm/shmbuf.h
  HDRINST usr/include/asm/mtrr.h
  HDRINST usr/include/asm/siginfo.h
  HDRINST usr/include/asm/kvm_para.h
  HDRINST usr/include/asm/ptrace-abi.h
  HDRINST usr/include/asm/stat.h
  HDRINST usr/include/asm/posix_types_32.h
  HDRINST usr/include/asm/hw_breakpoint.h
  HDRINST usr/include/asm/sigcontext32.h
  HDRINST usr/include/asm/msgbuf.h
  HDRINST usr/include/asm/svm.h
  HDRINST usr/include/asm/hwcap2.h
  HDRINST usr/include/asm/posix_types_x32.h
  HDRINST usr/include/asm/byteorder.h
  HDRINST usr/include/asm/vmx.h
  HDRINST usr/include/asm/amd_hsmp.h
  HDRINST usr/include/asm/setup.h
  HDRINST usr/include/asm/ldt.h
  HDRINST usr/include/asm/unistd_x32.h
  HDRINST usr/include/asm/unistd_64.h
  HDRINST usr/include/asm/unistd_32.h
  HDRINST usr/include/asm/types.h
  HDRINST usr/include/asm/termios.h
  HDRINST usr/include/asm/termbits.h
  HDRINST usr/include/asm/sockios.h
  HDRINST usr/include/asm/socket.h
  HDRINST usr/include/asm/resource.h
  HDRINST usr/include/asm/poll.h
  HDRINST usr/include/asm/param.h
  HDRINST usr/include/asm/ipcbuf.h
  HDRINST usr/include/asm/ioctls.h
  HDRINST usr/include/asm/ioctl.h
  HDRINST usr/include/asm/fcntl.h
  HDRINST usr/include/asm/errno.h
  HDRINST usr/include/asm/bpf_perf_event.h
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselfte=
sts-e71b7f1f44d3d88c677769c85ef0171caf9fc89f'
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reusepor=
t_bpf.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3=
d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/reuseport_bpf
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reusepor=
t_bpf_cpu.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f=
44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/reuseport_bpf_=
cpu
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reusepor=
t_bpf_numa.c -lnuma -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e=
71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/reusepo=
rt_bpf_numa
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reusepor=
t_dualstack.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f=
1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/reuseport_du=
alstack
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reuseadd=
r_conflict.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1=
f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/reuseaddr_con=
flict
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     tls.c  -=
o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769=
c85ef0171caf9fc89f/tools/testing/selftests/net/tls
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     socket.c=
  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677=
769c85ef0171caf9fc89f/tools/testing/selftests/net/socket
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     nettest.=
c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c67=
7769c85ef0171caf9fc89f/tools/testing/selftests/net/nettest
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     psock_fa=
nout.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d=
88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/psock_fanout
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     psock_tp=
acket.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3=
d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/psock_tpacket
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     msg_zero=
copy.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d=
88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/msg_zerocopy
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reusepor=
t_addr_any.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1=
f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/reuseport_add=
r_any
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     tcp_mmap=
=2Ec -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f=
1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/tcp_mmap
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     tcp_inq.=
c -lpthread -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f4=
4d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/tcp_inq
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     psock_sn=
d.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c=
677769c85ef0171caf9fc89f/tools/testing/selftests/net/psock_snd
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     txring_o=
verwrite.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f4=
4d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/txring_overwrite
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     udpgso.c=
  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677=
769c85ef0171caf9fc89f/tools/testing/selftests/net/udpgso
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     udpgso_b=
ench_tx.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44=
d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/udpgso_bench_tx
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     udpgso_b=
ench_rx.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44=
d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/udpgso_bench_rx
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     ip_defra=
g.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c=
677769c85ef0171caf9fc89f/tools/testing/selftests/net/ip_defrag
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     so_txtim=
e.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c=
677769c85ef0171caf9fc89f/tools/testing/selftests/net/so_txtime
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     ipv6_flo=
wlabel.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d=
3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/ipv6_flowlabel
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     ipv6_flo=
wlabel_mgr.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1=
f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/ipv6_flowlabe=
l_mgr
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     so_netns=
_cookie.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44=
d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/so_netns_cookie
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     tcp_fast=
open_backup_key.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e7=
1b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/tcp_fast=
open_backup_key
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     fin_ack_=
lat.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/net/fin_ack_lat
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     reuseadd=
r_ports_exhausted.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-=
e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/reusea=
ddr_ports_exhausted
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     hwtstamp=
_config.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44=
d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/hwtstamp_config
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     rxtimest=
amp.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/net/rxtimestamp
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     timestam=
ping.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d=
88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/timestamping
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     txtimest=
amp.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/net/txtimestamp
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     ipsec.c =
 -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c6777=
69c85ef0171caf9fc89f/tools/testing/selftests/net/ipsec
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     ioam6_pa=
rser.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d=
88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/ioam6_parser
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     gro.c  -=
o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769=
c85ef0171caf9fc89f/tools/testing/selftests/net/gro
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     toeplitz=
=2Ec  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88=
c677769c85ef0171caf9fc89f/tools/testing/selftests/net/toeplitz
gcc -Wall -Wl,--no-as-needed -O2 -g -I../../../../usr/include/     cmsg_sen=
der.c  -o /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/net/cmsg_sender
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net'
2022-06-25 08:24:25 make install INSTALL_PATH=3D/usr/bin/ -C ../../../tools=
/testing/selftests/net
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftest=
s-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net'
make --no-builtin-rules ARCH=3Dx86 -C ../../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselft=
ests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f'
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselfte=
sts-e71b7f1f44d3d88c677769c85ef0171caf9fc89f'
rsync -a run_netsocktests run_afpackettests test_bpf.sh netdevice.sh rtnetl=
ink.sh xfrm_policy.sh test_blackhole_dev.sh fib_tests.sh fib-onlink-tests.s=
h pmtu.sh udpgso.sh ip_defrag.sh udpgso_bench.sh fib_rule_tests.sh msg_zero=
copy.sh psock_snd.sh udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reus=
eport_addr_any.sh test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.=
sh tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh traceroute.sh fin_ack_l=
at.sh fib_nexthop_multiprefix.sh fib_nexthops.sh altnames.sh icmp.sh icmp_r=
edirect.sh ip6_gre_headroom.sh route_localnet.sh reuseaddr_ports_exhausted.=
sh txtimestamp.sh vrf-xfrm-tests.sh rxtimestamp.sh devlink_port_split.py dr=
op_monitor_tests.sh vrf_route_leaking.sh bareudp.sh amt.sh unicast_extensio=
ns.sh udpgro_fwd.sh veth.sh ioam6.sh gro.sh gre_gso.sh cmsg_so_mark.sh cmsg=
_time.sh cmsg_ipv6.sh srv6_end_dt46_l3vpn_test.sh srv6_end_dt4_l3vpn_test.s=
h srv6_end_dt6_l3vpn_test.sh vrf_strict_mode_test.sh arp_ndisc_evict_nocarr=
ier.sh test_vxlan_vnifiltering.sh /usr/bin//
rsync -a in_netns.sh setup_loopback.sh setup_veth.sh toeplitz_client.sh toe=
plitz.sh /usr/bin//
rsync -a settings /usr/bin//
rsync -a /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88=
c677769c85ef0171caf9fc89f/tools/testing/selftests/net/reuseport_bpf /usr/sr=
c/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171=
caf9fc89f/tools/testing/selftests/net/reuseport_bpf_cpu /usr/src/perf_selft=
ests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/to=
ols/testing/selftests/net/reuseport_bpf_numa /usr/src/perf_selftests-x86_64=
-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing=
/selftests/net/reuseport_dualstack /usr/src/perf_selftests-x86_64-rhel-8.3-=
kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests=
/net/reuseaddr_conflict /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-=
e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/tls /u=
sr/bin//
rsync -a /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88=
c677769c85ef0171caf9fc89f/tools/testing/selftests/net/socket /usr/src/perf_=
selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc8=
9f/tools/testing/selftests/net/nettest /usr/src/perf_selftests-x86_64-rhel-=
8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selft=
ests/net/psock_fanout /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e7=
1b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/psock_tp=
acket /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c67=
7769c85ef0171caf9fc89f/tools/testing/selftests/net/msg_zerocopy /usr/src/pe=
rf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9=
fc89f/tools/testing/selftests/net/reuseport_addr_any /usr/src/perf_selftest=
s-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools=
/testing/selftests/net/tcp_mmap /usr/src/perf_selftests-x86_64-rhel-8.3-kse=
lftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/ne=
t/tcp_inq /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/net/psock_snd /usr/src/p=
erf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf=
9fc89f/tools/testing/selftests/net/txring_overwrite /usr/src/perf_selftests=
-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/=
testing/selftests/net/udpgso /usr/src/perf_selftests-x86_64-rhel-8.3-kselft=
ests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/u=
dpgso_bench_tx /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f4=
4d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/udpgso_bench_rx=
 /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c=
85ef0171caf9fc89f/tools/testing/selftests/net/ip_defrag /usr/src/perf_selft=
ests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/to=
ols/testing/selftests/net/so_txtime /usr/src/perf_selftests-x86_64-rhel-8.3=
-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftest=
s/net/ipv6_flowlabel /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71=
b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/ipv6_flow=
label_mgr /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/net/so_netns_cookie /usr=
/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0=
171caf9fc89f/tools/testing/selftests/net/tcp_fastopen_backup_key /usr/src/p=
erf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf=
9fc89f/tools/testing/selftests/net/fin_ack_lat /usr/src/perf_selftests-x86_=
64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testi=
ng/selftests/net/reuseaddr_ports_exhausted /usr/src/perf_selftests-x86_64-r=
hel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/s=
elftests/net/hwtstamp_config /usr/src/perf_selftests-x86_64-rhel-8.3-kselft=
ests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/r=
xtimestamp /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d=
88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/timestamping /usr/s=
rc/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef017=
1caf9fc89f/tools/testing/selftests/net/txtimestamp /usr/src/perf_selftests-=
x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/t=
esting/selftests/net/ipsec /usr/src/perf_selftests-x86_64-rhel-8.3-kselftes=
ts-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net/ioa=
m6_parser /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d8=
8c677769c85ef0171caf9fc89f/tools/testing/selftests/net/gro /usr/src/perf_se=
lftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f=
/tools/testing/selftests/net/toeplitz /usr/src/perf_selftests-x86_64-rhel-8=
=2E3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/self=
tests/net/cmsg_sender /usr/bin//
rsync -a config settings /usr/bin//
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net'
2022-06-25 08:24:27 make -C net
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftest=
s-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net'
make --no-builtin-rules ARCH=3Dx86 -C ../../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselft=
ests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f'
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselfte=
sts-e71b7f1f44d3d88c677769c85ef0171caf9fc89f'
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net'
2022-06-25 08:24:27 make run_tests -C net
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftest=
s-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net'
make --no-builtin-rules ARCH=3Dx86 -C ../../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselft=
ests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f'
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselfte=
sts-e71b7f1f44d3d88c677769c85ef0171caf9fc89f'
TAP version 13
1..1
# selftests: net: fcnal-test.sh
#=20
# #########################################################################=
##
# IPv6 ping
# #########################################################################=
##
#=20
#=20
# #################################################################
# No VRF
#=20
# SYSCTL: net.ipv4.raw_l3mdev_accept=3D0
#=20
# TEST: ping out - ns-B IPv6                                               =
     [ OK ]
# TEST: ping out - ns-B loopback IPv6                                      =
     [ OK ]
# TEST: ping out - ns-B IPv6 LLA                                           =
     [ OK ]
# TEST: ping out - multicast IP                                            =
     [ OK ]
# TEST: ping out, device bind - ns-B IPv6                                  =
     [ OK ]
# TEST: ping out, loopback address bind - ns-B IPv6                        =
     [ OK ]
# TEST: ping out, device bind - ns-B loopback IPv6                         =
     [ OK ]
# TEST: ping out, loopback address bind - ns-B loopback IPv6               =
     [ OK ]
# TEST: ping in - ns-A IPv6                                                =
     [ OK ]
# TEST: ping in - ns-A loopback IPv6                                       =
     [ OK ]
# TEST: ping in - ns-A IPv6 LLA                                            =
     [ OK ]
# TEST: ping in - multicast IP                                             =
     [ OK ]
# TEST: ping local, no bind - ns-A IPv6                                    =
     [ OK ]
# TEST: ping local, no bind - ns-A loopback IPv6                           =
     [ OK ]
# TEST: ping local, no bind - IPv6 loopback                                =
     [ OK ]
# TEST: ping local, no bind - ns-A IPv6 LLA                                =
     [ OK ]
# TEST: ping local, no bind - multicast IP                                 =
     [ OK ]
# TEST: ping local, device bind - ns-A IPv6                                =
     [ OK ]
# TEST: ping local, device bind - ns-A IPv6 LLA                            =
     [ OK ]
# TEST: ping local, device bind - multicast IP                             =
     [ OK ]
# TEST: ping local, device bind - ns-A loopback IPv6                       =
     [ OK ]
# TEST: ping local, device bind - IPv6 loopback                            =
     [ OK ]
# TEST: ping out, blocked by rule - ns-B loopback IPv6                     =
     [ OK ]
# TEST: ping out, device bind, blocked by rule - ns-B loopback IPv6        =
     [ OK ]
# TEST: ping in, blocked by rule - ns-A loopback IPv6                      =
     [ OK ]
# TEST: ping out, blocked by route - ns-B loopback IPv6                    =
     [ OK ]
# TEST: ping out, device bind, blocked by route - ns-B loopback IPv6       =
     [ OK ]
# TEST: ping in, blocked by route - ns-A loopback IPv6                     =
     [ OK ]
# TEST: ping out, unreachable route - ns-B loopback IPv6                   =
     [ OK ]
# TEST: ping out, device bind, unreachable route - ns-B loopback IPv6      =
     [ OK ]
# SYSCTL: net.ipv4.ping_group_range=3D0 2147483647
#=20
# SYSCTL: net.ipv4.raw_l3mdev_accept=3D0
#=20
# TEST: ping out - ns-B IPv6                                               =
     [ OK ]
# TEST: ping out - ns-B loopback IPv6                                      =
     [ OK ]
# TEST: ping out - ns-B IPv6 LLA                                           =
     [ OK ]
# TEST: ping out - multicast IP                                            =
     [ OK ]
# TEST: ping out, device bind - ns-B IPv6                                  =
     [FAIL]
# TEST: ping out, loopback address bind - ns-B IPv6                        =
     [ OK ]
# TEST: ping out, device bind - ns-B loopback IPv6                         =
     [FAIL]
# TEST: ping out, loopback address bind - ns-B loopback IPv6               =
     [ OK ]
# TEST: ping in - ns-A IPv6                                                =
     [ OK ]
# TEST: ping in - ns-A loopback IPv6                                       =
     [ OK ]
# TEST: ping in - ns-A IPv6 LLA                                            =
     [ OK ]
# TEST: ping in - multicast IP                                             =
     [ OK ]
# TEST: ping local, no bind - ns-A IPv6                                    =
     [ OK ]
# TEST: ping local, no bind - ns-A loopback IPv6                           =
     [ OK ]
# TEST: ping local, no bind - IPv6 loopback                                =
     [ OK ]
# TEST: ping local, no bind - ns-A IPv6 LLA                                =
     [ OK ]
# TEST: ping local, no bind - multicast IP                                 =
     [ OK ]
# TEST: ping local, device bind - ns-A IPv6                                =
     [FAIL]
# TEST: ping local, device bind - ns-A IPv6 LLA                            =
     [FAIL]
# TEST: ping local, device bind - multicast IP                             =
     [FAIL]
# TEST: ping local, device bind - ns-A loopback IPv6                       =
     [ OK ]
# TEST: ping local, device bind - IPv6 loopback                            =
     [ OK ]
# TEST: ping out, blocked by rule - ns-B loopback IPv6                     =
     [ OK ]
# TEST: ping out, device bind, blocked by rule - ns-B loopback IPv6        =
     [ OK ]
# TEST: ping in, blocked by rule - ns-A loopback IPv6                      =
     [ OK ]
# TEST: ping out, blocked by route - ns-B loopback IPv6                    =
     [ OK ]
# TEST: ping out, device bind, blocked by route - ns-B loopback IPv6       =
     [ OK ]
# TEST: ping in, blocked by route - ns-A loopback IPv6                     =
     [ OK ]
# TEST: ping out, unreachable route - ns-B loopback IPv6                   =
     [ OK ]
# TEST: ping out, device bind, unreachable route - ns-B loopback IPv6      =
     [ OK ]
#=20
# #################################################################
# With VRF
#=20
# SYSCTL: net.ipv4.raw_l3mdev_accept=3D1
#=20
# TEST: ping out, VRF bind - ns-B IPv6                                     =
     [ OK ]
# TEST: ping out, VRF bind - ns-B loopback IPv6                            =
     [ OK ]
# TEST: ping out, VRF bind - ns-B IPv6 LLA                                 =
     [ OK ]
# TEST: ping out, VRF bind - multicast IP                                  =
     [ OK ]
# TEST: ping out, device bind - ns-B IPv6                                  =
     [ OK ]
# TEST: ping out, device bind - ns-B loopback IPv6                         =
     [ OK ]
# TEST: ping out, device bind - ns-B IPv6 LLA                              =
     [ OK ]
# TEST: ping out, device bind - multicast IP                               =
     [ OK ]
# TEST: ping out, vrf device+address bind - ns-B IPv6                      =
     [ OK ]
# TEST: ping out, vrf device+address bind - ns-B loopback IPv6             =
     [ OK ]
# TEST: ping out, vrf device+address bind - ns-B IPv6 LLA                  =
     [ OK ]
# TEST: ping in - ns-A IPv6                                                =
     [ OK ]
# TEST: ping in - VRF IPv6                                                 =
     [ OK ]
# TEST: ping in - ns-A IPv6 LLA                                            =
     [ OK ]
# TEST: ping in - multicast IP                                             =
     [ OK ]
# TEST: ping in - ns-A loopback IPv6                                       =
     [ OK ]
# TEST: ping local, VRF bind - ns-A IPv6                                   =
     [ OK ]
# TEST: ping local, VRF bind - VRF IPv6                                    =
     [ OK ]
# TEST: ping local, VRF bind - IPv6 loopback                               =
     [ OK ]
# TEST: ping local, device bind - ns-A IPv6                                =
     [ OK ]
# TEST: ping local, device bind - ns-A IPv6 LLA                            =
     [ OK ]
# TEST: ping local, device bind - multicast IP                             =
     [ OK ]
# TEST: ping in, LLA to GUA - ns-A IPv6                                    =
     [ OK ]
# TEST: ping in, LLA to GUA - VRF IPv6                                     =
     [ OK ]
# TEST: ping out, blocked by rule - ns-B loopback IPv6                     =
     [ OK ]
# TEST: ping out, device bind, blocked by rule - ns-B loopback IPv6        =
     [ OK ]
# TEST: ping in, blocked by rule - ns-A loopback IPv6                      =
     [ OK ]
# TEST: ping out, unreachable route - ns-B loopback IPv6                   =
     [ OK ]
# TEST: ping out, device bind, unreachable route - ns-B loopback IPv6      =
     [ OK ]
# TEST: ping in, unreachable route - ns-A loopback IPv6                    =
     [ OK ]
# SYSCTL: net.ipv4.ping_group_range=3D0 2147483647
#=20
# SYSCTL: net.ipv4.raw_l3mdev_accept=3D1
#=20
# TEST: ping out, VRF bind - ns-B IPv6                                     =
     [FAIL]
# TEST: ping out, VRF bind - ns-B loopback IPv6                            =
     [FAIL]
# TEST: ping out, VRF bind - ns-B IPv6 LLA                                 =
     [ OK ]
# TEST: ping out, VRF bind - multicast IP                                  =
     [ OK ]
# TEST: ping out, device bind - ns-B IPv6                                  =
     [FAIL]
# TEST: ping out, device bind - ns-B loopback IPv6                         =
     [FAIL]
# TEST: ping out, device bind - ns-B IPv6 LLA                              =
     [FAIL]
# TEST: ping out, device bind - multicast IP                               =
     [FAIL]
# TEST: ping out, vrf device+address bind - ns-B IPv6                      =
     [ OK ]
# TEST: ping out, vrf device+address bind - ns-B loopback IPv6             =
     [ OK ]
# TEST: ping out, vrf device+address bind - ns-B IPv6 LLA                  =
     [FAIL]
# TEST: ping in - ns-A IPv6                                                =
     [ OK ]
# TEST: ping in - VRF IPv6                                                 =
     [ OK ]
# TEST: ping in - ns-A IPv6 LLA                                            =
     [ OK ]
# TEST: ping in - multicast IP                                             =
     [ OK ]
# TEST: ping in - ns-A loopback IPv6                                       =
     [ OK ]
# TEST: ping local, VRF bind - ns-A IPv6                                   =
     [FAIL]
# TEST: ping local, VRF bind - VRF IPv6                                    =
     [FAIL]
# TEST: ping local, VRF bind - IPv6 loopback                               =
     [FAIL]
# TEST: ping local, device bind - ns-A IPv6                                =
     [FAIL]
# TEST: ping local, device bind - ns-A IPv6 LLA                            =
     [FAIL]
# TEST: ping local, device bind - multicast IP                             =
     [FAIL]
# TEST: ping in, LLA to GUA - ns-A IPv6                                    =
     [ OK ]
# TEST: ping in, LLA to GUA - VRF IPv6                                     =
     [ OK ]
# TEST: ping out, blocked by rule - ns-B loopback IPv6                     =
     [ OK ]
# TEST: ping out, device bind, blocked by rule - ns-B loopback IPv6        =
     [ OK ]
# TEST: ping in, blocked by rule - ns-A loopback IPv6                      =
     [ OK ]
# TEST: ping out, unreachable route - ns-B loopback IPv6                   =
     [ OK ]
# TEST: ping out, device bind, unreachable route - ns-B loopback IPv6      =
     [ OK ]
# TEST: ping in, unreachable route - ns-A loopback IPv6                    =
     [ OK ]
#=20
# Tests passed: 102
# Tests failed:  18
not ok 1 selftests: net: fcnal-test.sh # exit=3D1
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-8.3-kselftests=
-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/tools/testing/selftests/net'

--HtExJog7ZoUxdI0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---
:#! /cephfs/tmp/d20220521-5384-ccft40/kernel-selftests-bm.yaml:
suite: kernel-selftests
testcase: kernel-selftests
category: functional
kernel-selftests:
  group: net
  test: fcnal-test.sh
  atomic_test: ipv6_ping
job_origin: kernel-selftests-bm.yaml
queue: bisect
testbox: lkp-skl-d01
commit: e71b7f1f44d3d88c677769c85ef0171caf9fc89f
branch: linus/master
kconfig: x86_64-rhel-8.3-kselftests
name: "/cephfs/tmp/d20220521-5384-ccft40/kernel-selftests-bm.yaml"
kernel_cmdline:
tbox_group: lkp-skl-d01
submit_id: 62b02487bf716ae813c7c35f
job_file: "/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-ipv6_ping-net-fcnal-test.sh-ucode=0xec-debian-11.1-x86_64-20220510.cgz-e71b7f1f44d3d88c677769c85ef0171caf9fc89f-20220620-59411-1pq1u39-0.yaml"
id: 96edd58fc37a1c68a0d4780e26ba0000aad41e90
queuer_version: "/zday/lkp"
:#! hosts/lkp-skl-d01:
model: Skylake
nr_cpu: 8
memory: 28G
nr_ssd_partitions: 1
nr_hdd_partitions: 4
hdd_partitions: "/dev/disk/by-id/wwn-0x50014ee20d26b072-part*"
ssd_partitions: "/dev/disk/by-id/wwn-0x55cd2e404c39bfc5-part1"
swap_partitions: "/dev/disk/by-id/wwn-0x55cd2e404c39bfc5-part3"
rootfs_partition: "/dev/disk/by-id/wwn-0x55cd2e404c39bfc5-part2"
brand: Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz
cpu_info: skylake i7-6700
bios_version: 1.2.8
:#! include/category/functional:
kmsg:
heartbeat:
meminfo:
:#! include/testbox/lkp-skl-d01:
need_kconfig_hw:
- E1000E: y
- SATA_AHCI
- DRM_I915
ucode: '0xec'
bisect_dmesg: true
:#! include/kernel-selftests:
need_kconfig:
- PACKET: y
- USER_NS: y
- BPF_SYSCALL: y
- TEST_BPF: m
- NUMA: y, v5.6-rc1
- NET_VRF: y, v4.3-rc1
- NET_L3_MASTER_DEV: y, v4.4-rc1
- IPV6: y
- IPV6_MULTIPLE_TABLES: y
- VETH: y
- NET_IPVTI: m
- IPV6_VTI: m
- DUMMY: y
- BRIDGE: y
- VLAN_8021Q: y
- IFB
- NETFILTER: y
- NETFILTER_ADVANCED: y
- NF_CONNTRACK: m
- NF_NAT: m, v5.1-rc1
- IP6_NF_IPTABLES: m
- IP_NF_IPTABLES: m
- IP6_NF_NAT: m
- IP_NF_NAT: m
- NF_TABLES: m
- NF_TABLES_IPV6: y, v4.17-rc1
- NF_TABLES_IPV4: y, v4.17-rc1
- NFT_CHAIN_NAT_IPV6: m, <= v5.0
- NFT_TPROXY: m, v4.19-rc1
- NFT_COUNTER: m, <= v5.16-rc4
- NFT_CHAIN_NAT_IPV4: m, <= v5.0
- NET_SCH_FQ: m
- NET_SCH_ETF: m, v4.19-rc1
- NET_SCH_NETEM: y
- TEST_BLACKHOLE_DEV: m, v5.3-rc1
- KALLSYMS: y
- BAREUDP: m, v5.7-rc1
- MPLS_ROUTING: m, v4.1-rc1
- MPLS_IPTUNNEL: m, v4.3-rc1
- NET_SCH_INGRESS: y, v4.19-rc1
- NET_CLS_FLOWER: m, v4.2-rc1
- NET_ACT_TUNNEL_KEY: m, v4.9-rc1
- NET_ACT_MIRRED: m, v5.11-rc1
- CRYPTO_SM4: y
- NET_DROP_MONITOR
- TRACEPOINTS
- AMT: m, v5.16-rc1
- IPV6_IOAM6_LWTUNNEL: y, v5.15
rootfs: debian-11.1-x86_64-20220510.cgz
initrds:
- linux_headers
- linux_selftests
enqueue_time: 2022-06-20 15:40:55.274002500 +08:00
compiler: gcc-11
_id: 62b02487bf716ae813c7c35f
_rt: "/result/kernel-selftests/ipv6_ping-net-fcnal-test.sh-ucode=0xec/lkp-skl-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f"
:#! schedule options:
user: lkp
LKP_SERVER: internal-lkp-server
result_root: "/result/kernel-selftests/ipv6_ping-net-fcnal-test.sh-ucode=0xec/lkp-skl-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/0"
scheduler_version: "/lkp/lkp/src"
arch: x86_64
max_uptime: 2100
initrd: "/osimage/debian/debian-11.1-x86_64-20220510.cgz"
bootloader_append:
- root=/dev/ram0
- RESULT_ROOT=/result/kernel-selftests/ipv6_ping-net-fcnal-test.sh-ucode=0xec/lkp-skl-d01/debian-11.1-x86_64-20220510.cgz/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/0
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/vmlinuz-5.18.0-rc5-00105-ge71b7f1f44d3
- branch=linus/master
- job=/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-ipv6_ping-net-fcnal-test.sh-ucode=0xec-debian-11.1-x86_64-20220510.cgz-e71b7f1f44d3d88c677769c85ef0171caf9fc89f-20220620-59411-1pq1u39-0.yaml
- user=lkp
- ARCH=x86_64
- kconfig=x86_64-rhel-8.3-kselftests
- commit=e71b7f1f44d3d88c677769c85ef0171caf9fc89f
- max_uptime=2100
- LKP_SERVER=internal-lkp-server
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw
modules_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/modules.cgz"
linux_headers_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/linux-headers.cgz"
linux_selftests_initrd: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/linux-selftests.cgz"
bm_initrd: "/osimage/deps/debian-11.1-x86_64-20220510.cgz/lkp_20220513.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/run-ipconfig_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/rsync-rootfs_20220515.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/kernel-selftests_20220614.cgz,/osimage/pkg/debian-11.1-x86_64-20220510.cgz/kernel-selftests-x86_64-cebf67a3-1_20220613.cgz,/osimage/deps/debian-11.1-x86_64-20220510.cgz/hw_20220526.cgz"
ucode_initrd: "/osimage/ucode/intel-ucode-20220216.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: lkp-wsx01
:#! /db/releases/20220520222415/lkp-src/include/site/lkp-wsx01:
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer:
watchdog:
:#! runtime status:
last_kernel: 5.18.0-rc2-00615-g2794cdb0b97b
:#! queue options:
queue_cmdline_keys:
- branch
- commit
:#! /db/releases/20220530193311/lkp-src/include/site/lkp-wsx01:
schedule_notify_address:
:#! user overrides:
kernel: "/pkg/linux/x86_64-rhel-8.3-kselftests/gcc-11/e71b7f1f44d3d88c677769c85ef0171caf9fc89f/vmlinuz-5.18.0-rc5-00105-ge71b7f1f44d3"
dequeue_time: 2022-06-20 17:10:18.851880273 +08:00
:#! /db/releases/20220620170342/lkp-src/include/site/lkp-wsx01:
job_state: finished
loadavg: 0.25 0.55 0.45 1/170 13398
start_time: '1655716372'
end_time: '1655716926'
version: "/lkp/lkp/.src-20220617-160254:ef021ff17:6da2be96c"

--HtExJog7ZoUxdI0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

mount --bind /lib/modules/5.18.0-rc5-00105-ge71b7f1f44d3/kernel/lib /usr/src/perf_selftests-x86_64-rhel-8.3-kselftests-e71b7f1f44d3d88c677769c85ef0171caf9fc89f/lib
sed -i s/default_timeout=45/default_timeout=300/ kselftest/runner.sh
make -C bpf
make -C ../../../tools/testing/selftests/net
make install INSTALL_PATH=/usr/bin/ -C ../../../tools/testing/selftests/net
make -C net
make run_tests -C net

--HtExJog7ZoUxdI0r--
