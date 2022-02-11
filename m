Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2174B2E24
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 21:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240414AbiBKUDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 15:03:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiBKUDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 15:03:48 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ACECE4;
        Fri, 11 Feb 2022 12:03:44 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id w11so17025424wra.4;
        Fri, 11 Feb 2022 12:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=nS4ftuDG/e5c9ISJ5dAQ041jXo0LPJaIOh3alZGInp4=;
        b=CEkWxrto4353scqRRO5mGrvuasbquLOt7tJ0S9HgvqugMzxQuBUcmq8HOwqDodugdT
         7lqv5pGY38P0K+D7+k6xyDW0bKaaxhm3idoROumdR9SePWS0cf2dxKDLF+8fH6zbIH6c
         Lkx7VGFMmBU11jVStdxY5cXbhzx/vclDI+nMnQI1/be/4vL4r4yGTY6EsS5raVV5ArAz
         HRFr0xoJELY8qUZLlmJqIfNZKnY/AsfSUL9qsQEArHYG6zHnt88F/88d0+n8VZfBQvEn
         3YZ/u5Ba8pXvaFa0DPPHpyckgt0JKfIcuZT1h6D7p34/rnTjEfEtTw6la6XtMtERBeDA
         JBkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nS4ftuDG/e5c9ISJ5dAQ041jXo0LPJaIOh3alZGInp4=;
        b=XB6BsxH0eUojTQnvRbjVdJx3HM5wireNEHPR61pBmlnplZqJmCdW+N/HRJg2098eEg
         P0IsUIMnUtJFRvUVfZ+DEOBrb5CkWRf1kSYxmB2Mbbgu+lsvHeJ4S+vM/ieWaFHvV3z0
         Lw48q2FCsoIxY4PNd2Lf5f8tiYDp1Ka82K3EoiMxsOHHaKO0HP0GRDSFkkWi65b4Qy6w
         f423caNIpyc+TQlsK4fAmOjsewqa9xOg8y/xx4KYCAj7CpsFvRZJlAc84FSsjohnx9z8
         sl6Sai1s3wjAlLqKoat2eJNfERt3t0QkgCFbPsbNu54pGzCjPJ0Ml6/rBNLakTcUQQIW
         DwNg==
X-Gm-Message-State: AOAM530sXt+HGJtEEc7kNoNuxzBqdyxI765Db2qwA00T3aLuuKYHdYEm
        sPSMHx9xe9NFoAY4El4goGMyScP4PTg=
X-Google-Smtp-Source: ABdhPJz3Q2VBr/XISz4hNlzDoD20WIcRwjW275qExWIOlMb2EZx0GESym0EM/SajyMDmgnrNTJEWQg==
X-Received: by 2002:adf:e64f:: with SMTP id b15mr1073800wrn.474.1644609822261;
        Fri, 11 Feb 2022 12:03:42 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id z3sm5905669wmp.42.2022.02.11.12.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 12:03:41 -0800 (PST)
Date:   Fri, 11 Feb 2022 21:03:38 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     swsd@realtek.com, davem@davemloft.net, kuba@kernel.org,
        thierry.reding@gmail.com, jonathanh@nvidia.com,
        linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: NETDEV WATCHDOG: enp1s0 (r8169): transmit queue 0 timed out
Message-ID: <YgbBGm/STwCfuFGM@Red>
References: <YgY7LW8WLtTCZUu0@Red>
 <1e89db6c-f992-e748-0b97-461e23f3c25f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1e89db6c-f992-e748-0b97-461e23f3c25f@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, Feb 11, 2022 at 07:03:15PM +0100, Heiner Kallweit a écrit :
> On 11.02.2022 11:32, Corentin Labbe wrote:
> > Hello
> > 
> > On my tegra124-jetson-tk1, I always got:
> > [ 1311.064826] ------------[ cut here ]------------
> > [ 1311.064880] WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:477 dev_watchdog+0x2fc/0x300
> > [ 1311.064976] NETDEV WATCHDOG: enp1s0 (r8169): transmit queue 0 timed out
> > [ 1311.065011] Modules linked in:
> > [ 1311.065074] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.16.7-dirty #7
> > [ 1311.065116] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
> > [ 1311.065177] [<c01103e4>] (unwind_backtrace) from [<c010ade0>] (show_stack+0x10/0x14)
> > [ 1311.065253] [<c010ade0>] (show_stack) from [<c0bbe884>] (dump_stack_lvl+0x40/0x4c)
> > [ 1311.065322] [<c0bbe884>] (dump_stack_lvl) from [<c0122d6c>] (__warn+0xd0/0x12c)
> > [ 1311.065379] [<c0122d6c>] (__warn) from [<c0bb8c48>] (warn_slowpath_fmt+0x90/0xb4)
> > [ 1311.065434] [<c0bb8c48>] (warn_slowpath_fmt) from [<c0a0f0f0>] (dev_watchdog+0x2fc/0x300)
> > [ 1311.065493] [<c0a0f0f0>] (dev_watchdog) from [<c01a8ab0>] (call_timer_fn+0x34/0x1a8)
> > [ 1311.065554] [<c01a8ab0>] (call_timer_fn) from [<c01a8e50>] (__run_timers.part.0+0x22c/0x328)
> > [ 1311.065599] [<c01a8e50>] (__run_timers.part.0) from [<c01a8f84>] (run_timer_softirq+0x38/0x68)
> > [ 1311.065648] [<c01a8f84>] (run_timer_softirq) from [<c0101394>] (__do_softirq+0x124/0x3cc)
> > [ 1311.065732] [<c0101394>] (__do_softirq) from [<c0129ff4>] (irq_exit+0xa4/0xd4)
> > [ 1311.065818] [<c0129ff4>] (irq_exit) from [<c0100b90>] (__irq_svc+0x50/0x80)
> > [ 1311.065860] Exception stack(0xc1101ed8 to 0xc1101f20)
> > [ 1311.065884] 1ec0:                                                       00000000 00000001
> > [ 1311.065913] 1ee0: c110a800 00000060 00000001 eed889f8 c121eaa0 418a949d 00000001 00000131
> > [ 1311.065940] 1f00: 00000001 00000131 00000000 c1101f28 c08bbe20 c08bbee8 60000113 ffffffff
> > [ 1311.065962] [<c0100b90>] (__irq_svc) from [<c08bbee8>] (cpuidle_enter_state+0x270/0x480)
> > [ 1311.066031] [<c08bbee8>] (cpuidle_enter_state) from [<c08bc15c>] (cpuidle_enter+0x50/0x54)
> > [ 1311.066078] [<c08bc15c>] (cpuidle_enter) from [<c015a658>] (do_idle+0x1e0/0x298)
> > [ 1311.066133] [<c015a658>] (do_idle) from [<c015a9e0>] (cpu_startup_entry+0x18/0x1c)
> > [ 1311.066174] [<c015a9e0>] (cpu_startup_entry) from [<c1000fc8>] (start_kernel+0x678/0x6bc)
> > [ 1311.066242] ---[ end trace 3df1a997f30c7eb8 ]---
> > [ 1311.083269] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [ 2671.118597] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [27521.391461] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [47441.629280] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [49046.691475] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [53081.713430] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [55101.737951] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [59351.771382] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [60491.797371] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [61351.805499] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [69631.911327] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [71246.958267] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [86522.110241] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [88507.174307] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [104612.315286] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > [132797.695339] r8169 0000:01:00.0 enp1s0: rtl_rxtx_empty_cond == 0 (loop: 42, delay: 100).
> > 
> > This happen since at least 5.10.
> > Any idea on how to debug this ?
> > 
> For whatever reason the chip locked up what results in the tx timeout and the following
> rtl_rxtx_empty_cond == 0 message. However the chip soft reset in the timeout handler
> seems to help.
> 
> Typically these timeouts are hard to debug because there's no public datasheets
> and errata information.
> 
> Few questions:
> - Is this a mainline or a downstream kernel?

Hello

It is a mainline kernel 5.16.7 (only hack is a patch to print which firmware is loaded).
I always used only mainline on it.

> - Full dmesg log would help (e.g. to identify exact chip version).

I put it down this mail

> - Does the issue correlate with specific activity or specific types of traffic?

It seems to happen more often when I do some NBD, but not always.
This board is used as a LAVA worker so it do lot of network (NBD, tftp, image download), I believed it happend when some network activity is done.

> - Is the interface operating in promiscuous mode (e.g. part of a bridge)?

No

> 
> At first you could try to disable all hw offloading / ASPM / EEE.
> 

I will try

> There's also a small chance that the issue is linked to a specific link partner.
> So you could test whether issue persists with another switch in between.
> Or with a different link partner.
> 
> Ar you aware of any earlier kernel version where the issue did not happen?
> Then you could bisect.

The oldest kernel I found on it is 5.1.21, but I dont remember if I hit this problem on it (the board is really used only for one year).
Anyway, the problem is too random (aka the need to wait a long time) to be easily bisected.
I tried to do some iperf for triggering it faster, but it do not work.
Some times it happend straigth on the boot, sometime after days.

iThanks for you hints
Regards

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 5.16.9-dirty (compile@Red) (armv7a-unknown-linux-gnueabihf-gcc (Gentoo 11.2.0 p1) 11.2.0, GNU ld (Gentoo 2.37_p1 p0) 2.37) #8 SMP PREEMPT Fri Feb 11 11:06:53 CET 2022
[    0.000000] CPU: ARMv7 Processor [413fc0f3] revision 3 (ARMv7), cr=10c5387d
[    0.000000] CPU: div instructions available: patching division code
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
[    0.000000] OF: fdt: Machine model: NVIDIA Tegra124 Jetson TK1
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] cma: Reserved 64 MiB at 0xfbc00000
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000080000000-0x00000000afffffff]
[    0.000000]   HighMem  [mem 0x00000000b0000000-0x00000000ffefffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000080000000-0x00000000ffefffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000080000000-0x00000000ffefffff]
[    0.000000] percpu: Embedded 17 pages/cpu s36972 r8192 d24468 u69632
[    0.000000] pcpu-alloc: s36972 r8192 d24468 u69632 alloc=17*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 522304
[    0.000000] Kernel command line: console=ttyS0,115200 root=/dev/ram0
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes, linear)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 1977032K/2096128K available (12288K kernel code, 1541K rwdata, 4592K rodata, 1024K init, 7237K bss, 53560K reserved, 65536K cma-reserved, 1244160K highmem)
[    0.000000] trace event string verifier disabled
[    0.000000] Running RCU self tests
[    0.000000] rcu: Preemptible hierarchical RCU implementation.
[    0.000000] rcu: 	RCU event tracing is enabled.
[    0.000000] rcu: 	RCU lockdep checking is enabled.
[    0.000000] 	Trampoline variant of Tasks RCU enabled.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 10 jiffies.
[    0.000000] NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
[    0.000000] /interrupt-controller@60004000: 160 interrupts forwarded to /interrupt-controller@50041000
[    0.000000] random: get_random_bytes called from start_kernel+0x538/0x6e8 with crng_init=0
[    0.000002] sched_clock: 32 bits at 1000kHz, resolution 1000ns, wraps every 2147483647500ns
[    0.000049] clocksource: timer_us: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275 ns
[    0.000099] Switching to timer-based delay loop, resolution 1000ns
[    0.000956] clocksource: tegra_suspend_timer: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 1911260446275000 ns
[    0.001822] arch_timer: cp15 timer(s) running at 12.00MHz (virt).
[    0.001855] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x2c47f4ee7, max_idle_ns: 440795202497 ns
[    0.001887] sched_clock: 56 bits at 12MHz, resolution 83ns, wraps every 4398046511096ns
[    0.001914] Switching to timer-based delay loop, resolution 83ns
[    0.004212] Console: colour dummy device 80x30
[    0.004271] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004292] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.004313] ... MAX_LOCK_DEPTH:          48
[    0.004333] ... MAX_LOCKDEP_KEYS:        8192
[    0.004353] ... CLASSHASH_SIZE:          4096
[    0.004372] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.004393] ... MAX_LOCKDEP_CHAINS:      65536
[    0.004412] ... CHAINHASH_SIZE:          32768
[    0.004432]  memory used by lock dependency info: 4061 kB
[    0.004453]  memory used for stack traces: 2112 kB
[    0.004472]  per task-struct memory footprint: 1536 bytes
[    0.004585] Calibrating delay loop (skipped), value calculated using timer frequency.. 24.00 BogoMIPS (lpj=120000)
[    0.004625] pid_max: default: 32768 minimum: 301
[    0.005363] Mount-cache hash table entries: 2048 (order: 1, 8192 bytes, linear)
[    0.005400] Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes, linear)
[    0.010406] CPU: Testing write buffer coherency: ok
[    0.010667] CPU0: Spectre v2: using ICIALLU workaround
[    0.012273] /cpus/cpu@0 missing clock-frequency property
[    0.012381] /cpus/cpu@1 missing clock-frequency property
[    0.012487] /cpus/cpu@2 missing clock-frequency property
[    0.012599] /cpus/cpu@3 missing clock-frequency property
[    0.012655] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.016749] Running RCU-tasks wait API self tests
[    0.018313] Setting up static identity map for 0x80100000 - 0x801000ac
[    0.019163] rcu: Hierarchical SRCU implementation.
[    0.021641] Tegra Revision: A01 SKU: 129 CPU Process: 1 SoC Process: 1
[    0.024462] smp: Bringing up secondary CPUs ...
[    0.030226] CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
[    0.030245] CPU1: Spectre v2: firmware did not set auxiliary control register IBE bit, system vulnerable
[    0.036611] CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
[    0.036630] CPU2: Spectre v2: firmware did not set auxiliary control register IBE bit, system vulnerable
[    0.042060] CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
[    0.042080] CPU3: Spectre v2: firmware did not set auxiliary control register IBE bit, system vulnerable
[    0.042754] smp: Brought up 1 node, 4 CPUs
[    0.042789] SMP: Total of 4 processors activated (96.00 BogoMIPS).
[    0.042821] CPU: All CPU(s) started in SVC mode.
[    0.046561] devtmpfs: initialized
[    0.175914] VFP support v0.3: implementor 41 architecture 4 part 30 variant f rev 0
[    0.199609] DMA-API: preallocated 65536 debug entries
[    0.199649] DMA-API: debugging enabled by kernel config
[    0.199678] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
[    0.199761] futex hash table entries: 1024 (order: 4, 65536 bytes, linear)
[    0.201905] pinctrl core: initialized pinctrl subsystem
[    0.207533] NET: Registered PF_NETLINK/PF_ROUTE protocol family
[    0.214622] DMA: preallocated 256 KiB pool for atomic coherent allocations
[    0.223466] thermal_sys: Registered thermal governor 'step_wise'
[    0.227650] cpuidle: using governor menu
[    0.233442] Callback from call_rcu_tasks() invoked.
[    0.350750] No ATAGs?
[    0.351337] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4 watchpoint registers.
[    0.351429] hw-breakpoint: maximum watchpoint size is 8 bytes.
[    0.387243] platform 50000000.host1x: Adding to iommu group 0
[    0.387747] platform 57000000.gpu: Adding to iommu group 1
[    0.482354] iommu: Default domain type: Translated 
[    0.482389] iommu: DMA domain TLB invalidation policy: strict mode 
[    0.484129] vgaarb: loaded
[    0.487758] SCSI subsystem initialized
[    0.488614] libata version 3.00 loaded.
[    0.490046] usbcore: registered new interface driver usbfs
[    0.490386] usbcore: registered new interface driver hub
[    0.490638] usbcore: registered new device driver usb
[    0.491247] mc: Linux media interface: v0.10
[    0.491464] videodev: Linux video capture interface: v2.00
[    0.491823] pps_core: LinuxPPS API ver. 1 registered
[    0.491852] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.491972] PTP clock support registered
[    0.494230] Advanced Linux Sound Architecture Driver Initialized.
[    0.501683] clocksource: Switched to clocksource arch_sys_counter
[    1.064555] NET: Registered PF_INET protocol family
[    1.065326] IP idents hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    1.068893] tcp_listen_portaddr_hash hash table entries: 512 (order: 2, 22528 bytes, linear)
[    1.069511] TCP established hash table entries: 8192 (order: 3, 32768 bytes, linear)
[    1.069834] TCP bind hash table entries: 8192 (order: 6, 327680 bytes, linear)
[    1.072133] TCP: Hash tables configured (established 8192 bind 8192)
[    1.073110] UDP hash table entries: 512 (order: 3, 49152 bytes, linear)
[    1.073493] UDP-Lite hash table entries: 512 (order: 3, 49152 bytes, linear)
[    1.074522] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    1.077404] RPC: Registered named UNIX socket transport module.
[    1.077497] RPC: Registered udp transport module.
[    1.077527] RPC: Registered tcp transport module.
[    1.077557] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    1.077592] PCI: CLS 0 bytes, default 64
[    1.080856] Trying to unpack rootfs image as initramfs...
[    1.092098] hw perfevents: enabled with armv7_cortex_a15 PMU driver, 7 counters available
[    1.099572] Initialise system trusted keyrings
[    1.100320] workingset: timestamp_bits=14 max_order=19 bucket_order=5
[    1.104161] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.106223] NFS: Registering the id_resolver key type
[    1.106374] Key type id_resolver registered
[    1.106468] Key type id_legacy registered
[    1.106554] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    1.204436] Key type asymmetric registered
[    1.204538] Asymmetric key parser 'x509' registered
[    1.205487] bounce: pool size: 64 pages
[    1.205789] io scheduler mq-deadline registered
[    1.205823] io scheduler kyber registered
[    1.245302] tegra-apbdma 60020000.dma: Tegra20 APB DMA driver registered 32 channels
[    1.250435] tegra-pmc 7000e400.pmc: emergency thermal reset enabled
[    1.253762] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.269652] printk: console [ttyS0] disabled
[    1.270206] 70006300.serial: ttyS0 at MMIO 0x70006300 (irq = 84, base_baud = 25500000) is a Tegra
[    1.970538] Freeing initrd memory: 6508K
[    1.971426] printk: console [ttyS0] enabled
[    2.141847] 70006000.serial: ttyTHS1 at MMIO 0x70006000 (irq = 82, base_baud = 0) is a TEGRA_UART
[    2.153719] 70006040.serial: ttyTHS2 at MMIO 0x70006040 (irq = 83, base_baud = 0) is a TEGRA_UART
[    2.170773] platform 54200000.dc: Adding to iommu group 2
[    2.179772] platform 54240000.dc: Adding to iommu group 2
[    2.191903] platform 54340000.vic: Adding to iommu group 2
[    2.266385] brd: module loaded
[    2.294072] loop: module loaded
[    2.312252] igb: Intel(R) Gigabit Ethernet Network Driver
[    2.317669] igb: Copyright (c) 2007-2014 Intel Corporation.
[    2.323739] pegasus: Pegasus/Pegasus II USB Ethernet driver
[    2.329527] usbcore: registered new interface driver pegasus
[    2.335536] usbcore: registered new interface driver asix
[    2.341131] usbcore: registered new interface driver ax88179_178a
[    2.347493] usbcore: registered new interface driver cdc_ether
[    2.353694] usbcore: registered new interface driver smsc75xx
[    2.359712] usbcore: registered new interface driver smsc95xx
[    2.365729] usbcore: registered new interface driver net1080
[    2.371652] usbcore: registered new interface driver cdc_subset
[    2.377766] usbcore: registered new interface driver zaurus
[    2.383717] usbcore: registered new interface driver cdc_ncm
[    2.390723] tegra-phy 7d000000.usb-phy: supply vbus not found, using dummy regulator
[    2.400292] tegra-phy 7d004000.usb-phy: supply vbus not found, using dummy regulator
[    2.409454] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.416070] ehci-pci: EHCI PCI platform driver
[    2.421997] usbcore: registered new interface driver cdc_acm
[    2.427671] cdc_acm: USB Abstract Control Model driver for USB modems and ISDN adapters
[    2.435958] usbcore: registered new interface driver cdc_wdm
[    2.441973] usbcore: registered new interface driver usb-storage
[    2.448464] usbcore: registered new interface driver ch341
[    2.454353] usbserial: USB Serial support registered for ch341-uart
[    2.460880] usbcore: registered new interface driver cp210x
[    2.466784] usbserial: USB Serial support registered for cp210x
[    2.472951] usbcore: registered new interface driver ftdi_sio
[    2.478868] usbserial: USB Serial support registered for FTDI USB Serial Device
[    2.486425] usbcore: registered new interface driver pl2303
[    2.492217] usbserial: USB Serial support registered for pl2303
[    2.561321] ci_hdrc ci_hdrc.1: EHCI Host Controller
[    2.566661] ci_hdrc ci_hdrc.1: new USB bus registered, assigned bus number 1
[    2.601775] ci_hdrc ci_hdrc.1: USB 2.0 started, EHCI 1.10
[    2.614047] hub 1-0:1.0: USB hub found
[    2.618259] hub 1-0:1.0: 1 port detected
[    2.639005] tegra_rtc 7000e000.rtc: registered as rtc1
[    2.644279] tegra_rtc 7000e000.rtc: Tegra internal Real Time Clock
[    2.653796] i2c_dev: i2c /dev entries driver
[    2.666308] at24 0-0056: supply vcc not found, using dummy regulator
[    2.676438] at24 0-0056: 256 byte 24c02 EEPROM, writable, 8 bytes/write
[    2.707558] as3722 4-0040: AS3722 with revision 0x1 found
[    2.758609] +VDDIO_SDMMC3: bypassed regulator has no supply!
[    2.764517] as3722-regulator as3722-regulator: regulator 13 register failed -517
[    2.792203] as3722-rtc as3722-rtc: registered as rtc0
[    2.797980] as3722-rtc as3722-rtc: setting system clock to 2022-02-11T10:43:54 UTC (1644576234)
[    2.806827] as3722-rtc as3722-rtc: RTC interrupt 133
[    2.826528] usbcore: registered new interface driver uvcvideo
[    2.832401] gspca_main: v2.14.0 registered
[    2.841054] lm90 0-004c: supply vcc not found, using dummy regulator
[    2.856526] tegra-wdt 60005000.timer: initialized (heartbeat = 120 sec, nowayout = 0)
[    2.869555] sdhci: Secure Digital Host Controller Interface driver
[    2.875827] sdhci: Copyright(c) Pierre Ossman
[    2.880199] VUB300 Driver rom wait states = 1C irqpoll timeout = 0400
[    2.882388] usbcore: registered new interface driver vub300
[    2.894509] sdhci-pltfm: SDHCI platform and OF driver helper
[    2.902747] sdhci-tegra 700b0400.mmc: Got CD GPIO
[    2.904701] usbcore: registered new interface driver usbhid
[    2.907649] sdhci-tegra 700b0400.mmc: Got WP GPIO
[    2.913252] usbhid: USB HID core driver
[    2.918259] mmc1: Invalid maximum block size, assuming 512 bytes
[    2.931027] tegra-emc 7001b000.external-memory-controller: 64bit DRAM bus
[    2.940366] tegra-emc 7001b000.external-memory-controller: OPP HW ver. 0x2, current clock rate 924 MHz
[    2.965069] mmc1: SDHCI controller on 700b0600.mmc [700b0600.mmc] using ADMA 64-bit
[    2.990955] input: tegra-hda HDMI/DP,pcm=3 as /devices/soc0/70030000.hda/sound/card0/input0
[    3.046086] mmc1: new high speed MMC card at address 0001
[    3.056650] mmcblk1: mmc1:0001 SEM16G 14.7 GiB 
[    3.074616] mmcblk1boot0: mmc1:0001 SEM16G 4.00 MiB 
[    3.088449] mmcblk1boot1: mmc1:0001 SEM16G 4.00 MiB 
[    3.100769] mmcblk1rpmb: mmc1:0001 SEM16G 4.00 MiB, chardev (246:0)
[    3.408386] tegra30-i2s 70301100.i2s: DMA channels sourced from device 70300000.ahub
[    3.450488] input: NVIDIA Tegra Jetson TK1 Headphones Jack as /devices/soc0/sound/sound/card1/input1
[    3.471562] NET: Registered PF_INET6 protocol family
[    3.482130] Segment Routing with IPv6
[    3.485926] In-situ OAM (IOAM) with IPv6
[    3.490377] mip6: Mobile IPv6
[    3.493743] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    3.507140] NET: Registered PF_PACKET protocol family
[    3.512403] NET: Registered PF_KEY protocol family
[    3.517665] Bridge firewalling registered
[    3.522602] Key type dns_resolver registered
[    3.532022] Registering SWP/SWPB emulation handler
[    3.537626] Loading compiled-in X.509 certificates
[    3.600034] reg-fixed-voltage regulator@11: nonexclusive access to GPIO for regulator@11
[    3.612432] tegra-pcie 1003000.pcie: host bridge /pcie@1003000 ranges:
[    3.619135] tegra-pcie 1003000.pcie:      MEM 0x0001000000..0x0001001fff -> 0x0001000000
[    3.627447] tegra-pcie 1003000.pcie:       IO 0x0012000000..0x001200ffff -> 0x0000000000
[    3.635958] tegra-pcie 1003000.pcie:      MEM 0x0013000000..0x001fffffff -> 0x0013000000
[    3.644228] tegra-pcie 1003000.pcie:      MEM 0x0020000000..0x003fffffff -> 0x0020000000
[    3.653142] tegra-pcie 1003000.pcie: 2x1, 1x1 configuration
[    3.683308] tegra-hdmi 54280000.hdmi: failed to get PLL regulator: -517
[    3.706377] ci_hdrc ci_hdrc.2: EHCI Host Controller
[    3.711755] ci_hdrc ci_hdrc.2: new USB bus registered, assigned bus number 2
[    3.741952] ci_hdrc ci_hdrc.2: USB 2.0 started, EHCI 1.10
[    3.753585] hub 2-0:1.0: USB hub found
[    3.757745] hub 2-0:1.0: 1 port detected
[    3.761865] random: fast init done
[    3.766834] as3722-regulator as3722-regulator: DMA mask not set
[    3.802562] +VDDIO_SDMMC3: bypassed regulator has no supply!
[    3.831837] sdhci-tegra 700b0400.mmc: Got CD GPIO
[    3.836728] sdhci-tegra 700b0400.mmc: Got WP GPIO
[    3.842399]  usb2-0: supply vbus not found, using dummy regulator
[    3.850220]  usb2-1: supply vbus not found, using dummy regulator
[    3.858715] mmc0: Invalid maximum block size, assuming 512 bytes
[    3.858984]  usb3-0: supply vbus not found, using dummy regulator
[    3.874560] tegra-pcie 1003000.pcie: host bridge /pcie@1003000 ranges:
[    3.881279] tegra-pcie 1003000.pcie:      MEM 0x0001000000..0x0001001fff -> 0x0001000000
[    3.889626] tegra-pcie 1003000.pcie:       IO 0x0012000000..0x001200ffff -> 0x0000000000
[    3.897940] tegra-pcie 1003000.pcie:      MEM 0x0013000000..0x001fffffff -> 0x0013000000
[    3.903824] mmc0: SDHCI controller on 700b0400.mmc [700b0400.mmc] using ADMA 64-bit
[    3.906202] tegra-pcie 1003000.pcie:      MEM 0x0020000000..0x003fffffff -> 0x0020000000
[    3.924314] tegra-pcie 1003000.pcie: 2x1, 1x1 configuration
[    3.939032] tegra-pcie 1003000.pcie: probing port 0, using 2 lanes
[    3.947810] tegra-pcie 1003000.pcie: probing port 1, using 1 lanes
[    3.988295] mmc0: new high speed SDHC card at address 1388
[    3.998143] mmcblk0: mmc0:1388 NCard 7.32 GiB 
[    4.013824]  mmcblk0: p1 p2 p3 < p5 >
[    5.184002] tegra-pcie 1003000.pcie: link 0 down, ignoring
[    5.195101] tegra-pcie 1003000.pcie: PCI host bridge to bus 0000:00
[    5.201409] pci_bus 0000:00: root bus resource [bus 00-ff]
[    5.207046] pci_bus 0000:00: root bus resource [mem 0x01000000-0x01001fff]
[    5.214268] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    5.220493] pci_bus 0000:00: root bus resource [mem 0x13000000-0x1fffffff]
[    5.227506] pci_bus 0000:00: root bus resource [mem 0x20000000-0x3fffffff pref]
[    5.235825] pci 0000:00:02.0: [10de:0e13] type 01 class 0x060400
[    5.242008] pci_bus 0000:00: 2-byte config write to 0000:00:02.0 offset 0x4 may corrupt adjacent RW1C bits
[    5.252056] pci_bus 0000:00: 2-byte config write to 0000:00:02.0 offset 0x4 may corrupt adjacent RW1C bits
[    5.261922] pci 0000:00:02.0: enabling Extended Tags
[    5.266914] pci_bus 0000:00: 2-byte config write to 0000:00:02.0 offset 0x88 may corrupt adjacent RW1C bits
[    5.276762] pci_bus 0000:00: 2-byte config write to 0000:00:02.0 offset 0x3e may corrupt adjacent RW1C bits
[    5.287180] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    5.293901] pci_bus 0000:00: 2-byte config write to 0000:00:02.0 offset 0x4c may corrupt adjacent RW1C bits
[    5.311321] pci_bus 0000:00: 2-byte config write to 0000:00:02.0 offset 0x3e may corrupt adjacent RW1C bits
[    5.321342] pci_bus 0000:00: 2-byte config write to 0000:00:02.0 offset 0x4 may corrupt adjacent RW1C bits
[    5.331090] pci_bus 0000:00: 1-byte config write to 0000:00:02.0 offset 0xc may corrupt adjacent RW1C bits
[    5.340825] PCI: bus0: Fast back to back transfers disabled
[    5.346494] pci 0000:00:02.0: bridge configuration invalid ([bus 00-00]), reconfiguring
[    5.354735] pci_bus 0000:00: 2-byte config write to 0000:00:02.0 offset 0x3e may corrupt adjacent RW1C bits
[    5.364576] pci_bus 0000:00: 2-byte config write to 0000:00:02.0 offset 0x3e may corrupt adjacent RW1C bits
[    5.375274] pci 0000:01:00.0: [10ec:8168] type 00 class 0x020000
[    5.381361] pci 0000:01:00.0: reg 0x10: [io  0x0000-0x00ff]
[    5.387247] pci 0000:01:00.0: reg 0x18: [mem 0x00000000-0x00000fff 64bit]
[    5.394178] pci 0000:01:00.0: reg 0x20: [mem 0x00000000-0x00003fff 64bit pref]
[    5.401937] pci 0000:01:00.0: supports D1 D2
[    5.406228] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    5.419641] PCI: bus1: Fast back to back transfers disabled
[    5.425315] pci_bus 0000:01: busn_res: [bus 01-ff] end is updated to 01
[    5.432246] pci 0000:00:02.0: BAR 8: assigned [mem 0x13000000-0x130fffff]
[    5.439060] pci 0000:00:02.0: BAR 9: assigned [mem 0x20000000-0x200fffff 64bit pref]
[    5.446900] pci 0000:00:02.0: BAR 7: assigned [io  0x1000-0x1fff]
[    5.453120] pci 0000:01:00.0: BAR 4: assigned [mem 0x20000000-0x20003fff 64bit pref]
[    5.460922] pci 0000:01:00.0: BAR 2: assigned [mem 0x13000000-0x13000fff 64bit]
[    5.468360] pci 0000:01:00.0: BAR 0: assigned [io  0x1000-0x10ff]
[    5.474562] pci 0000:00:02.0: PCI bridge to [bus 01]
[    5.479734] pci 0000:00:02.0:   bridge window [io  0x1000-0x1fff]
[    5.485938] pci 0000:00:02.0:   bridge window [mem 0x13000000-0x130fffff]
[    5.492825] pci 0000:00:02.0:   bridge window [mem 0x20000000-0x200fffff 64bit pref]
[    5.500675] pci 0000:00:02.0: nv_msi_ht_cap_quirk didn't locate host bridge
[    5.508377] pcieport 0000:00:02.0: enabling device (0140 -> 0143)
[    5.515546] pcieport 0000:00:02.0: PME: Signaling with IRQ 33
[    5.523776] r8169 0000:01:00.0: enabling device (0140 -> 0143)
[    5.602683] r8169 0000:01:00.0 eth0: RTL8168g/8111g, 00:04:4b:2f:50:23, XID 4c0, IRQ 153
[    5.610809] r8169 0000:01:00.0 eth0: jumbo features [frames: 9194 bytes, tx checksumming: ko]
[    5.782925] drm drm: [drm] Cannot find any crtc or sizes
[    5.790230] drm drm: [drm] Cannot find any crtc or sizes
[    5.801286] [drm] Initialized tegra 1.0.0 20120330 for drm on minor 0
[    5.809907] tegra-ahci 70027000.sata: supply ahci not found, using dummy regulator
[    5.818442] tegra-ahci 70027000.sata: supply phy not found, using dummy regulator
[    5.827178] tegra-ahci 70027000.sata: supply target not found, using dummy regulator
[    5.840550] tegra-ahci 70027000.sata: AHCI 0001.0301 32 slots 2 ports 3 Gbps 0x1 impl platform mode
[    5.849776] tegra-ahci 70027000.sata: flags: 64bit ncq sntf pm led pmp pio slum part sadm sds apst 
[    5.881335] scsi host0: tegra-ahci
[    5.889532] scsi host1: tegra-ahci
[    5.894747] ata1: SATA max UDMA/133 mmio [mem 0x70027000-0x70028fff] port 0x100 irq 94
[    5.902922] ata2: DUMMY
[    5.914153] firmware_class: Loading firmware: nvidia/tegra124/xusb.bin
[    5.922819] firmware_class: _request_firmware end
[    5.936297] tegra-xusb 70090000.usb: Firmware timestamp: 2014-09-16 02:10:07 UTC
[    5.944058] tegra-xusb 70090000.usb: xHCI Host Controller
[    5.949794] tegra-xusb 70090000.usb: new USB bus registered, assigned bus number 3
[    5.964878] tegra-xusb 70090000.usb: hcc params 0x0184f525 hci version 0x100 quirks 0x0000000000010010
[    5.974654] tegra-xusb 70090000.usb: irq 96, io mem 0x70090000
[    5.986834] hub 3-0:1.0: USB hub found
[    5.991150] hub 3-0:1.0: 6 ports detected
[    6.002635] tegra-xusb 70090000.usb: xHCI Host Controller
[    6.008133] tegra-xusb 70090000.usb: new USB bus registered, assigned bus number 4
[    6.015920] tegra-xusb 70090000.usb: Host supports USB 3.0 SuperSpeed
[    6.024699] usb usb4: We don't know the algorithms for LPM for this host, disabling LPM.
[    6.037740] hub 4-0:1.0: USB hub found
[    6.041898] hub 4-0:1.0: 2 ports detected
[    6.056307] cpufreq: cpufreq_online: CPU0: Running at unlisted initial frequency: 696000 KHz, changing to: 714000 KHz
[    6.070127] input: gpio-keys as /devices/soc0/gpio-keys/input/input2
[    6.078502] ALSA device list:
[    6.081472]   #0: tegra-hda at 0x70038000 irq 95
[    6.087228]   #1: NVIDIA Tegra Jetson TK1
[    6.236917] ata1: SATA link down (SStatus 0 SControl 300)
[    6.256584] Freeing unused kernel image (initmem) memory: 1024K
[    6.264679] Run /init as init process
[    6.268439]   with arguments:
[    6.268457]     /init
[    6.268467]   with environment:
[    6.268475]     HOME=/
[    6.268483]     TERM=linux
[    6.301930] usb 3-3: new high-speed USB device number 2 using tegra-xusb
[    6.537083] hub 3-3:1.0: USB hub found
[    6.541852] hub 3-3:1.0: 4 ports detected
[    6.664286] usb 4-1: new SuperSpeed USB device number 2 using tegra-xusb
[    6.710923] hub 4-1:1.0: USB hub found
[    6.715287] hub 4-1:1.0: 4 ports detected
[    6.912760] usb 3-3.2: new full-speed USB device number 3 using tegra-xusb
[    7.107039] ftdi_sio 3-3.2:1.0: FTDI USB Serial Device converter detected
[    7.114442] usb 3-3.2: Detected FT232RL
[    7.120455] usb 3-3.2: FTDI USB Serial Device converter now attached to ttyUSB0
[    7.173227] usb 4-1.4: new SuperSpeed USB device number 3 using tegra-xusb
[    7.232027] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.240230] ata1.00: ATA-8: OCZ-AGILITY3, 2.22, max UDMA/133
[    7.241876] hub 4-1.4:1.0: USB hub found
[    7.246051] ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 32)
[    7.250198] hub 4-1.4:1.0: 4 ports detected
[    7.270162] ata1.00: configured for UDMA/133
[    7.276047] scsi 0:0:0:0: Direct-Access     ATA      OCZ-AGILITY3     2.22 PQ: 0 ANSI: 5
[    7.287270] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    7.287882] sd 0:0:0:0: [sda] 234441648 512-byte logical blocks: (120 GB/112 GiB)
[    7.300304] sd 0:0:0:0: [sda] Write Protect is off
[    7.305173] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    7.305370] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    7.331718] usb 3-3.3: new full-speed USB device number 4 using tegra-xusb
[    7.361488]  sda: sda1
[    7.366534] sd 0:0:0:0: [sda] Attached SCSI disk
[    7.492900] ftdi_sio 3-3.3:1.0: FTDI USB Serial Device converter detected
[    7.500347] usb 3-3.3: Detected FT232RL
[    7.507501] usb 3-3.3: FTDI USB Serial Device converter now attached to ttyUSB1
[    7.612746] usb 3-3.4: new high-speed USB device number 5 using tegra-xusb
[    7.783228] hub 3-3.4:1.0: USB hub found
[    7.787993] hub 3-3.4:1.0: 4 ports detected
[    8.132258] usb 3-3.4.1: new full-speed USB device number 6 using tegra-xusb
[    8.309411] ftdi_sio 3-3.4.1:1.0: FTDI USB Serial Device converter detected
[    8.316990] usb 3-3.4.1: Detected FT232RL
[    8.322963] usb 3-3.4.1: FTDI USB Serial Device converter now attached to ttyUSB2
[    8.432139] usb 3-3.4.2: new full-speed USB device number 7 using tegra-xusb
[    8.530617] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null). Quota mode: disabled.
[    8.577940] pl2303 3-3.4.2:1.0: pl2303 converter detected
[    8.586935] usb 3-3.4.2: pl2303 converter now attached to ttyUSB3
[    8.711662] usb 3-3.4.3: new full-speed USB device number 8 using tegra-xusb
[    8.870627] ftdi_sio 3-3.4.3:1.0: FTDI USB Serial Device converter detected
[    8.878468] usb 3-3.4.3: Detected FT232RL
[    8.884807] usb 3-3.4.3: FTDI USB Serial Device converter now attached to ttyUSB4
[    8.991691] usb 3-3.4.4: new full-speed USB device number 9 using tegra-xusb
[    9.135407] ch341 3-3.4.4:1.0: ch341-uart converter detected
[    9.143248] ch341-uart ttyUSB5: break control not supported, using simulated break
[    9.151257] usb 3-3.4.4: ch341-uart converter now attached to ttyUSB5
[    9.582588] random: apache2: uninitialized urandom read (8 bytes read)
[    9.589189] random: apache2: uninitialized urandom read (8 bytes read)
[    9.596039] random: apache2: uninitialized urandom read (8 bytes read)
[   18.530530] r8169 0000:01:00.0 enp1s0: renamed from eth0
[   19.577122] EXT4-fs (sda1): re-mounted. Opts: (null). Quota mode: disabled.
[   26.701844] random: crng init done
[   26.701871] random: 7 urandom warning(s) missed due to ratelimiting
[   36.323390] +USB0_VBUS_SW: disabling
[   38.407574] firmware_class: Loading firmware: rtl_nic/rtl8168g-2.fw
[   38.417338] firmware_class: _request_firmware end
[   38.451897] Generic FE-GE Realtek PHY r8169-0-100:00: attached PHY driver (mii_bus:phy_addr=r8169-0-100:00, irq=MAC)
[   38.735766] r8169 0000:01:00.0 enp1s0: Link is Down
[   41.379219] r8169 0000:01:00.0 enp1s0: Link is Up - 1Gbps/Full - flow control off
[   41.379301] IPv6: ADDRCONF(NETDEV_CHANGE): enp1s0: link becomes ready
[   46.232171] ------------[ cut here ]------------
[   46.232240] WARNING: CPU: 1 PID: 2144 at kernel/dma/debug.c:1073 check_for_illegal_area+0xec/0x180
[   46.232255] DMA-API: tegra-ahci 70027000.sata: device driver maps memory from kernel text or rodata [addr=3f4026ed] [len=4096]
[   46.232262] Modules linked in:
[   46.232271] CPU: 1 PID: 2144 Comm: containerd Not tainted 5.16.9-dirty #8
[   46.232277] Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
[   46.232283] [<c0110c24>] (unwind_backtrace) from [<c010b4d4>] (show_stack+0x10/0x14)
[   46.232294] [<c010b4d4>] (show_stack) from [<c0ce90b0>] (dump_stack_lvl+0x58/0x70)
[   46.232305] [<c0ce90b0>] (dump_stack_lvl) from [<c0124648>] (__warn+0xd0/0x134)
[   46.232314] [<c0124648>] (__warn) from [<c0ce2b00>] (warn_slowpath_fmt+0x90/0xb4)
[   46.232322] [<c0ce2b00>] (warn_slowpath_fmt) from [<c01cdcd8>] (check_for_illegal_area+0xec/0x180)
[   46.232330] [<c01cdcd8>] (check_for_illegal_area) from [<c01cfab4>] (debug_dma_map_sg+0xa4/0x424)
[   46.232340] [<c01cfab4>] (debug_dma_map_sg) from [<c01ca4d8>] (__dma_map_sg_attrs+0xc4/0x140)
[   46.232349] [<c01ca4d8>] (__dma_map_sg_attrs) from [<c01ca568>] (dma_map_sg_attrs+0x14/0x20)
[   46.232357] [<c01ca568>] (dma_map_sg_attrs) from [<c07cc408>] (ata_qc_issue+0x16c/0x414)
[   46.232366] [<c07cc408>] (ata_qc_issue) from [<c07d64f4>] (__ata_scsi_queuecmd+0x27c/0x4c4)
[   46.232376] [<c07d64f4>] (__ata_scsi_queuecmd) from [<c07d679c>] (ata_scsi_queuecmd+0x60/0x90)
[   46.232385] [<c07d679c>] (ata_scsi_queuecmd) from [<c07b36bc>] (scsi_queue_rq+0x440/0xb98)
[   46.232397] [<c07b36bc>] (scsi_queue_rq) from [<c05808fc>] (blk_mq_dispatch_rq_list+0x1d0/0x87c)
[   46.232406] [<c05808fc>] (blk_mq_dispatch_rq_list) from [<c0586628>] (__blk_mq_do_dispatch_sched+0x14c/0x2dc)
[   46.232415] [<c0586628>] (__blk_mq_do_dispatch_sched) from [<c0586b38>] (__blk_mq_sched_dispatch_requests+0x10c/0x168)
[   46.232423] [<c0586b38>] (__blk_mq_sched_dispatch_requests) from [<c0586c64>] (blk_mq_sched_dispatch_requests+0x34/0x5c)
[   46.232432] [<c0586c64>] (blk_mq_sched_dispatch_requests) from [<c057da8c>] (__blk_mq_run_hw_queue+0x5c/0xcc)
[   46.232442] [<c057da8c>] (__blk_mq_run_hw_queue) from [<c057dc9c>] (__blk_mq_delay_run_hw_queue+0x18c/0x1b4)
[   46.232451] [<c057dc9c>] (__blk_mq_delay_run_hw_queue) from [<c0586f80>] (blk_mq_sched_insert_requests+0xd0/0x320)
[   46.232460] [<c0586f80>] (blk_mq_sched_insert_requests) from [<c0581604>] (blk_mq_flush_plug_list+0x1c4/0x434)
[   46.232468] [<c0581604>] (blk_mq_flush_plug_list) from [<c0573d40>] (blk_flush_plug+0xd4/0x114)
[   46.232475] [<c0573d40>] (blk_flush_plug) from [<c0573f9c>] (blk_finish_plug+0x1c/0x28)
[   46.232482] [<c0573f9c>] (blk_finish_plug) from [<c0285740>] (read_pages+0x190/0x2bc)
[   46.232493] [<c0285740>] (read_pages) from [<c0285c1c>] (page_cache_ra_unbounded+0x164/0x230)
[   46.232501] [<c0285c1c>] (page_cache_ra_unbounded) from [<c027846c>] (filemap_fault+0x6d4/0xd04)
[   46.232509] [<c027846c>] (filemap_fault) from [<c02bacd0>] (__do_fault+0x38/0x104)
[   46.232519] [<c02bacd0>] (__do_fault) from [<c02c0920>] (handle_mm_fault+0xaa0/0xea8)
[   46.232528] [<c02c0920>] (handle_mm_fault) from [<c011563c>] (do_page_fault+0x15c/0x484)
[   46.232537] [<c011563c>] (do_page_fault) from [<c0115b2c>] (do_DataAbort+0x3c/0xb0)
[   46.232544] [<c0115b2c>] (do_DataAbort) from [<c0100e98>] (__dabt_usr+0x58/0x60)
[   46.232552] Exception stack(0xc6bc9fb0 to 0xc6bc9ff8)
[   46.232558] 9fa0:                                     00000001 bea726d8 014d40e0 01911fb8
[   46.232563] 9fc0: 00490000 0004cb15 00523858 006f6b68 00000000 b6f0c9c8 b6f0c9c8 bea72724
[   46.232569] 9fe0: 00000000 bea72678 b6ee2cbc b6ee41ec 200d0010 ffffffff
[   46.232573] irq event stamp: 15628
[   46.232577] hardirqs last  enabled at (15627): [<c01dba64>] ktime_get+0x1a4/0x1c8
[   46.232585] hardirqs last disabled at (15628): [<c0cfbfb0>] _raw_spin_lock_irqsave+0x68/0x6c
[   46.232594] softirqs last  enabled at (15332): [<c01015d8>] __do_softirq+0x328/0x590
[   46.232600] softirqs last disabled at (15327): [<c012cda8>] __irq_exit_rcu+0x128/0x1a8
[   46.232607] ---[ end trace 8655230c4b3626fb ]---
[32852.339559] ext2 filesystem being mounted at /boot supports timestamps until 2038 (0x7fffffff)

