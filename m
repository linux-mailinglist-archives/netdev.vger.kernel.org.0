Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086FB6A689A
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 09:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjCAIMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 03:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCAIMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 03:12:43 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86CA37B53
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 00:12:38 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id d20so18302535vsf.11
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 00:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SrXCzWgKViOc+obcAuiHOuChJt/du0RafNof0WvuX5A=;
        b=S9GzA4o27VwGUdjiSHMcq8rX+NB0Yio+5fQzSNjcwkCkfplU1KXT55lWIhpOTAV3h4
         RFbdT99sjVVfsih8todlYCocoUvARH+nAH5kAVO3zkf5Nqopq2uQRkycvIfQjPuSDRKB
         Abi/G25cNU/SNCtPvqOM1W+bPpFyVvTBU+HGDv0WEBPGsOaXhMojffq/ZddlBcHGRCL2
         GqtuLcG5HE7Y+fu39c2bKZqep4bWAjT8FC7HGY5KeSJIzdqYC+9a9DWKWE+/3pYq7tW2
         6FA5dJk+bSX/mhIklw59udLWwKu5S6u2meCu5C/8hyLx55jzGnqq6OgegKO3KwKMFj1n
         02UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SrXCzWgKViOc+obcAuiHOuChJt/du0RafNof0WvuX5A=;
        b=HNMQ5UJVddmPjAL17yZrl14P1sqAE4Sb9dG82bDJEbF6UKo0nL5MEpeB/V6hx3fmJq
         3wxeuBE3Cyrn77YOKVeKYXA28rwut2W0R48MvxiyJ+TwLM/4nKXZ+Htzu2rZNumRdRjq
         sTQl3ou8m2WI0kEhtVdzlMXZpG9yivkjSLAuuYs+hBAkgtqFL8ULa3QnvsiaIEj1c0wF
         n3sHB1Ekk7E62PvSOgqfmJexGtbBlau3Rpx3YaMsCQ64RMI/gvWJF4uosU8S0YOdu5UN
         plUaiTEzYUSN2bywyH+nk1VQ1g4lSyQpKAll+XOStJSkTnV9lgjYBYZLEUp2Tt+V4bnD
         rqlg==
X-Gm-Message-State: AO0yUKVMPFEgfthNjbenTTCGatmB8gtoeBH19kBXevOZfFhojc0mUgd3
        EEdp6TY4SMeGxI4GawtmbAXGlIPgmzuctCEN0C/Pmg==
X-Google-Smtp-Source: AK7set8aQGZSG4rahaPDZYleNRgRlyZdZIda648JOx8T4OgQOcj6vbQkIfTeSt2iNEGyBfrwpdXUW3l5Qjgjcy4dA0A=
X-Received: by 2002:a05:6102:3202:b0:412:2f46:4073 with SMTP id
 r2-20020a056102320200b004122f464073mr3671735vsf.3.1677658357491; Wed, 01 Mar
 2023 00:12:37 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 1 Mar 2023 13:42:26 +0530
Message-ID: <CA+G9fYsbni4_vCObhwux3i+5HrCf119gBL0bm0q9tiS4N==kfg@mail.gmail.com>
Subject: next: qemu-x86_64: RIP: 0010:sched_clock_cpu+0xe/0x1a0 - Kernel panic
 - not syncing: Fatal exception in interrupt
To:     open list <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>, rcu <rcu@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qemu-x86_64 boot fails intermittently with Linux next kernel.
We have been noticing for a couple of weeks since it is intermittent
it is hard to reproduce.

The probability of occurrence is 3% only.
Please find the crash log below.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Booting from ROM...
early console in setup code
<5>[    0.000000] Linux version 6.2.0-next-20230301 (tuxmake@tuxmake)
(x86_64-linux-gnu-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils
for Debian) 2.40) #1 SMP PREEMPT_DYNAMIC @1677632214
<6>[    0.000000] Command line: console=ttyS0,115200 rootwait
root=/dev/sda debug verbose console_msg_format=syslog earlycon
<6>[    0.000000] x86/fpu: x87 FPU will use FXSAVE

...
<6>[    2.374878] NET: Registered PF_INET6 protocol family
<6>[    2.384759] Segment Routing with IPv6
<6>[    2.385399] In-situ OAM (IOAM) with IPv6
<6>[    2.387587] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
<6>[    2.392290] NET: Registered PF_PACKET protocol family
<6>[    2.394353] 9pnet: Installing 9P2000 support
<5>[    2.394871] Key type dns_resolver registered
<6>[    2.399000] IPI shorthand broadcast: enabled
<6>[    2.460526] sched_clock: Marking stable (2133060315,
326814512)->(2478808254, -18933427)
<4>[    2.464162] int3: 0000 [#1] PREEMPT SMP PTI
<4>[    2.464607] CPU: 0 PID: 1 Comm: swapper/0 Not tainted
6.2.0-next-20230301 #1
<4>[    2.464725] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.14.0-2 04/01/2014
<4>[    2.464879] RIP: 0010:sched_clock_cpu+0xe/0x1a0
<4>[    2.465330] Code: 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90
90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 48 89 e5 41 55
41 54 53 66 <90> e8 ec 2f 02 01 48 03 05 dd 6e ea 01 48 89 c2 5b 48 89
d0 41 5c
<4>[    2.465424] RSP: 0000:ffffa138c0003e30 EFLAGS: 00000002
<4>[    2.465488] RAX: 0000000000000004 RBX: ffff98c7fbc2b740 RCX:
0000000000000009
<4>[    2.465506] RDX: 0000000000000001 RSI: ffffffffa698899c RDI:
0000000000000000
<4>[    2.465523] RBP: ffffa138c0003e48 R08: 00000000fffb7477 R09:
0000000000000000
<4>[    2.465541] R10: 0000000000000000 R11: ffffa138c0003ff8 R12:
000000000002b740
<4>[    2.465559] R13: 0000000000000000 R14: 0000000000000000 R15:
ffff98c780808000
<4>[    2.465625] FS:  0000000000000000(0000)
GS:ffff98c7fbc00000(0000) knlGS:0000000000000000
<4>[    2.465650] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[    2.465669] CR2: ffff98c7fffff000 CR3: 0000000128644000 CR4:
00000000000006f0
<4>[    2.465795] Call Trace:
<4>[    2.465983]  <IRQ>
<4>[    2.466323]  update_rq_clock+0x35/0x1a0
<4>[    2.466407]  scheduler_tick+0x99/0x290
<4>[    2.466430]  update_process_times+0x8d/0xb0
<4>[    2.466448]  tick_sched_handle+0x38/0x50
<4>[    2.466463]  tick_sched_timer+0x6e/0x90
<4>[    2.466485]  ? __pfx_tick_sched_timer+0x10/0x10
<4>[    2.466500]  __hrtimer_run_queues+0x88/0x2d0
<4>[    2.466521]  hrtimer_interrupt+0xfa/0x230
<4>[    2.466542]  __sysvec_apic_timer_interrupt+0x66/0x140
<4>[    2.466561]  sysvec_apic_timer_interrupt+0x7b/0xa0
<4>[    2.466620]  </IRQ>
<4>[    2.466636]  <TASK>
<4>[    2.466642]  asm_sysvec_apic_timer_interrupt+0x1f/0x30
<4>[    2.466765] RIP: 0010:_raw_spin_unlock_irqrestore+0x23/0x50
<4>[    2.466786] Code: 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00
00 55 48 89 e5 c6 07 00 f7 c6 00 02 00 00 74 06 e8 93 9a 0a ff fb bf
01 00 00 00 <e8> a8 23 fa fe 65 8b 05 f9 97 f8 59 85 c0 74 06 5d c3 cc
cc cc cc
<4>[    2.466796] RSP: 0000:ffffa138c0013d20 EFLAGS: 00000246
<4>[    2.466810] RAX: 0000000000000000 RBX: ffff98c782611708 RCX:
ffff98c7826114f8
<4>[    2.466818] RDX: 0000000080000001 RSI: ffffffffa527ac60 RDI:
0000000000000001
<4>[    2.466825] RBP: ffffa138c0013d20 R08: 0000000000000000 R09:
ffffa138c0013cc0
<4>[    2.466832] R10: ffffffffa72ff76a R11: 00000005a99185a8 R12:
ffff98c78270e6e0
<4>[    2.466839] R13: ffff98c78270e6e8 R14: ffff98c78054c9c0 R15:
ffff98c78054cc28
<4>[    2.466903]  ? __create_object+0x230/0x440
<4>[    2.466974]  __create_object+0x230/0x440
<4>[    2.466992]  kmemleak_alloc+0x4e/0x80
<4>[    2.467010]  kmem_cache_alloc_lru+0x214/0x490
<4>[    2.467026]  ? __lookup_slow+0x85/0x130
<4>[    2.467043]  ? alloc_inode+0x60/0xc0
<4>[    2.467064]  alloc_inode+0x60/0xc0
<4>[    2.467078]  new_inode+0x1c/0xb0
<4>[    2.467092]  debugfs_get_inode+0xf/0x60
<4>[    2.467110]  debugfs_create_dir+0x60/0x1d0
<4>[    2.467124]  ? __pfx_sched_init_debug+0x10/0x10
<4>[    2.467146]  sched_init_debug+0x1b/0x1e0
<4>[    2.467162]  do_one_initcall+0x62/0x250
<4>[    2.467188]  kernel_init_freeable+0x1c5/0x310
<4>[    2.467204]  ? __pfx_kernel_init+0x10/0x10
<4>[    2.467219]  kernel_init+0x1e/0x1c0
<4>[    2.467232]  ret_from_fork+0x2c/0x50
<4>[    2.467272]  </TASK>
<4>[    2.467333] Modules linked in:
<4>[    2.484825] int3: 0000 [#2] PREEMPT SMP PTI
<4>[    2.484762] ---[ end trace 0000000000000000 ]---
<4>[    2.484997] RIP: 0010:sched_clock_cpu+0xe/0x1a0
<4>[    2.485036] Code: 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90
90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 48 89 e5 41 55
41 54 53 66 <90> e8 ec 2f 02 01 48 03 05 dd 6e ea 01 48 89 c2 5b 48 89
d0 41 5c
<4>[    2.485052] RSP: 0000:ffffa138c0003e30 EFLAGS: 00000002
<4>[    2.485074] RAX: 0000000000000004 RBX: ffff98c7fbc2b740 RCX:
0000000000000009
<4>[    2.485082] RDX: 0000000000000001 RSI: ffffffffa698899c RDI:
0000000000000000
<4>[    2.485073] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D
      6.2.0-next-20230301 #1
<4>[    2.485090] RBP: ffffa138c0003e48 R08: 00000000fffb7477 R09:
0000000000000000
<4>[    2.485095] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.14.0-2 04/01/2014
<4>[    2.485098] R10: 0000000000000000 R11: ffffa138c0003ff8 R12:
000000000002b740
<4>[    2.485105] R13: 0000000000000000 R14: 0000000000000000 R15:
ffff98c780808000
<4>[    2.485116] FS:  0000000000000000(0000)
GS:ffff98c7fbc00000(0000) knlGS:0000000000000000
<4>[    2.485107] RIP: 0010:sched_clock_cpu+0xe/0x1a0
<4>[    2.485127] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[    2.485137] CR2: ffff98c7fffff000 CR3: 0000000128644000 CR4:
00000000000006f0
<4>[    2.485141] Code: 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90
90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 48 89 e5 41 55
41 54 53 66 <90> e8 ec 2f 02 01 48 03 05 dd 6e ea 01 48 89 c2 5b 48 89
d0 41 5c
<4>[    2.485154] RSP: 0000:ffffa138c00c8f88 EFLAGS: 00000006
<4>[    2.485172] RAX: 000000007f5d6b43 RBX: ffff98c7fbd1f840 RCX:
0000000000000018
<4>[    2.485182] RDX: 00000ca5400fe793 RSI: 0000000000001096 RDI:
0000000000000001
<4>[    2.485192] RBP: ffffa138c00c8fa0 R08: 0000000000004504 R09:
0000000000000000
<4>[    2.485201] R10: 0000000000000000 R11: ffffa138c00c8ff8 R12:
0000000000000001
<4>[    2.485210] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
<4>[    2.485219] FS:  0000000000000000(0000)
GS:ffff98c7fbd00000(0000) knlGS:0000000000000000
<4>[    2.485232] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[    2.485242] CR2: 0000000000000000 CR3: 0000000128644000 CR4:
00000000000006e0
<4>[    2.485253] Call Trace:
<4>[    2.485272]  <IRQ>
<0>[    2.485296] Kernel panic - not syncing: Fatal exception in interrupt
<4>[    2.485299]  sched_clock_idle_sleep_event+0x14/0x20
<4>[    2.485326]  tick_nohz_irq_exit+0x3f/0x50
<4>[    2.485346]  __irq_exit_rcu+0x92/0xc0
<4>[    2.485366]  irq_exit_rcu+0x12/0x20
<4>[    2.485384]  sysvec_call_function_single+0x80/0xa0
<4>[    2.485422]  </IRQ>
<4>[    2.485428]  <TASK>
<4>[    2.485435]  asm_sysvec_call_function_single+0x1f/0x30
<4>[    2.486600] RIP: 0010:default_idle+0xf/0x20
<4>[    2.486629] Code: 4c 01 c7 4c 29 c2 e9 72 ff ff ff 90 90 90 90
90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d e3 9b
38 00 fb f4 <fa> c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 90 90
90 90 90
<4>[    2.486643] RSP: 0000:ffffa138c0093eb0 EFLAGS: 00000212
<4>[    2.486661] RAX: ffff98c7fbd28180 RBX: ffff98c780828000 RCX:
4000000000000000
<4>[    2.486682] RDX: 0000000000000001 RSI: ffffffffa69d2df3 RDI:
00000000000044fc
<4>[    2.486692] RBP: ffffa138c0093eb8 R08: 00000000000044fc R09:
000000002c23407c
<4>[    2.486701] R10: 0000000000000001 R11: 0000000000000200 R12:
0000000000000001
<4>[    2.486710] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
<4>[    2.486745]  ? arch_cpu_idle+0xd/0x20
<4>[    2.486764]  default_idle_call+0x3a/0xf0
<4>[    2.486779]  do_idle+0x1e2/0x230
<4>[    2.486798]  ? complete+0x6a/0x80
<4>[    2.486818]  cpu_startup_entry+0x21/0x30
<4>[    2.486836]  start_secondary+0x113/0x130
<4>[    2.486857]  secondary_startup_64_no_verify+0xe0/0xeb
<4>[    2.486891]  </TASK>
<4>[    2.486898] Modules linked in:
<4>[    2.487333] ---[ end trace 0000000000000000 ]---
<4>[    2.487345] RIP: 0010:sched_clock_cpu+0xe/0x1a0
<4>[    2.487365] Code: 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90
90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 48 89 e5 41 55
41 54 53 66 <90> e8 ec 2f 02 01 48 03 05 dd 6e ea 01 48 89 c2 5b 48 89
d0 41 5c
<4>[    2.487377] RSP: 0000:ffffa138c0003e30 EFLAGS: 00000002
<4>[    2.487391] RAX: 0000000000000004 RBX: ffff98c7fbc2b740 RCX:
0000000000000009
<4>[    2.487401] RDX: 0000000000000001 RSI: ffffffffa698899c RDI:
0000000000000000
<4>[    2.487410] RBP: ffffa138c0003e48 R08: 00000000fffb7477 R09:
0000000000000000
<4>[    2.487419] R10: 0000000000000000 R11: ffffa138c0003ff8 R12:
000000000002b740
<4>[    2.487429] R13: 0000000000000000 R14: 0000000000000000 R15:
ffff98c780808000
<4>[    2.487439] FS:  0000000000000000(0000)
GS:ffff98c7fbd00000(0000) knlGS:0000000000000000
<4>[    2.487453] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[    2.487464] CR2: 0000000000000000 CR3: 0000000128644000 CR4:
00000000000006e0
<0>[    4.318996] Shutting down cpus with NMI
<0>[    4.320347] Kernel Offset: 0x23e00000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)


complete boot log,
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230301/testrun/15171566/suite/boot/test/gcc-12-lkftconfig-debug-kmemleak/log

Details for build and boot,
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230301/testrun/15171566/suite/boot/test/gcc-12-lkftconfig-debug-kmemleak/details/
https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2MOIBDPkClbVuC9X04FdCk4t5DJ
https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230301/testrun/15171566/suite/boot/tests/

config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2MOI7CgX5aF1rQFmPoX2ZngGLPN/config

steps to reproduce: (3% only)


# To install tuxrun on your system globally:
# sudo pip3 install -U tuxrun==0.37.2
#
# See https://tuxrun.org/ for complete documentation.

tuxrun --runtime podman --device qemu-x86_64 --kernel
https://storage.tuxsuite.com/public/linaro/lkft/builds/2MOI7CgX5aF1rQFmPoX2ZngGLPN/bzImage
--modules https://storage.tuxsuite.com/public/linaro/lkft/builds/2MOI7CgX5aF1rQFmPoX2ZngGLPN/modules.tar.xz
--rootfs https://storage.tuxsuite.com/public/linaro/lkft/oebuilds/2ME6ZmheiOB5aTdASNelcq3DBhN/images/intel-corei7-64/lkft-tux-image-intel-corei7-64-20230225104837.rootfs.ext4.gz
--parameters SKIPFILE=skipfile-lkft.yaml --parameters SHARD_NUMBER=6
--parameters SHARD_INDEX=5 --image
docker.io/lavasoftware/lava-dispatcher:2023.01.0020.gc1598238f --tests
ltp-mm --timeouts boot=15 ltp-mm=40


--
Linaro LKFT
https://lkft.linaro.org
