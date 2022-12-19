Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D099C650A3B
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 11:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiLSKhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 05:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbiLSKhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 05:37:52 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C116E0C3
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 02:37:50 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id o16-20020a056602225000b006e032e361ccso3887490ioo.13
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 02:37:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7B2A3LAzKRUV4e9LaRMFQt27MqLLZOh1ssrRfHyxhM8=;
        b=JkBUfDuTd179DIrg06Z1k7iUs3va1Yl1oo0b8ThNYj9wzQtoN5rTFb3aVpi0lgF7sX
         cd4AACl1iIaIWOdFWHuQ/VH5HHiJZJEd/qNLzm98cq8s/YbnOW/iItA4BoBPg9vrblOU
         4Admx/iA33SA+49mqb+QO81dqFu22aeDplcU+V2W4mcEKacMrQwWYOQU9LurT4p7hOEP
         UPMcObtTJTTyXSU4t2IOZ6XFMFbV2RKIsT3QBk0PX5UemsQA+uMSe+VeWrsdC+UDCXXO
         bYr1TI1AOaxXPBpZkZPkLaCdvN8TLXzflQCgfhlcQnpjesUflWARgCDQIBMSIxjdUmTJ
         jijA==
X-Gm-Message-State: ANoB5plrwzY6P8KVNF2Fz63HvLicA/8//ogn/PpvoWPQm2t1Nw2NyDaI
        vL2jRJtbz+ePn+Oko7QA0wmmzsgBH5P6S/A06pGODvkhF215
X-Google-Smtp-Source: AA0mqf4FH0q6MBTKDkJhbb64Atq5DhZJG3MVmi5SJgsNrdM7bMc2xOo5SlggsRG31/+OCTmJrVkl87Y4Ao8gLTrvvKgzXq2qmrzz
MIME-Version: 1.0
X-Received: by 2002:a6b:f015:0:b0:6e2:bed4:c2d5 with SMTP id
 w21-20020a6bf015000000b006e2bed4c2d5mr5218562ioc.177.1671446269922; Mon, 19
 Dec 2022 02:37:49 -0800 (PST)
Date:   Mon, 19 Dec 2022 02:37:49 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002e17d105f02be919@google.com>
Subject: [syzbot] WARNING in print_tainted
From:   syzbot <syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org, pabeni@redhat.com,
        socketcan@hartkopp.net, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    77856d911a8c Merge tag 'arm64-fixes' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15cddf1f880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b3c64cceddc7988
dashboard link: https://syzkaller.appspot.com/bug?extid=5aed6c3aaba661f5b917
compiler:       arm-linux-gnueabi-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at net/can/isotp.c:920 isotp_tx_timer_handler+0xe0/0x148 net/can/isotp.c:920
can-isotp: tx timer state 00000000 cfecho 00000000
Modules linked in:
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.1.0-syzkaller #0
Hardware name: ARM-Versatile Express
Backtrace: frame pointer underflow
[<81764cd8>] (dump_backtrace) from [<81764dcc>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:256)
 r7:81d77dbc r6:824229dc r5:60000193 r4:81d86398
[<81764db4>] (show_stack) from [<817811c0>] (__dump_stack lib/dump_stack.c:88 [inline])
[<81764db4>] (show_stack) from [<817811c0>] (dump_stack_lvl+0x48/0x54 lib/dump_stack.c:106)
[<81781178>] (dump_stack_lvl) from [<817811e4>] (dump_stack+0x18/0x1c lib/dump_stack.c:113)
 r5:00000000 r4:82646d14
[<817811cc>] (dump_stack) from [<81765974>] (panic+0x11c/0x360 kernel/panic.c:315)
[<81765858>] (panic) from [<802416b0>] (print_tainted+0x0/0xa0 kernel/panic.c:236)
 r3:00000001 r2:8240c488 r1:81d7031c r0:81d77dbc
 r7:81611f88
[<80241634>] (check_panic_on_warn) from [<802418a4>] (__warn+0x7c/0x18c kernel/panic.c:661)
[<80241828>] (__warn) from [<81765c54>] (warn_slowpath_fmt+0x9c/0xd4 kernel/panic.c:691)
 r8:00000009 r7:81611f88 r6:00000398 r5:81f315e8 r4:81f315bc
[<81765bbc>] (warn_slowpath_fmt) from [<81611f88>] (isotp_tx_timer_handler+0xe0/0x148 net/can/isotp.c:920)
 r8:dddde3a0 r7:000000a0 r6:dddde300 r5:00000000 r4:85280278
[<81611ea8>] (isotp_tx_timer_handler) from [<802e8efc>] (__run_hrtimer kernel/time/hrtimer.c:1685 [inline])
[<81611ea8>] (isotp_tx_timer_handler) from [<802e8efc>] (__hrtimer_run_queues+0x1b0/0x46c kernel/time/hrtimer.c:1749)
 r5:dddde3e0 r4:85280278
[<802e8d4c>] (__hrtimer_run_queues) from [<802e9244>] (hrtimer_run_softirq+0x8c/0xb8 kernel/time/hrtimer.c:1766)
 r10:828f3980 r9:00000101 r8:00000100 r7:00000000 r6:00000000 r5:20000113
 r4:dddde300
[<802e91b8>] (hrtimer_run_softirq) from [<80201338>] (__do_softirq+0x16c/0x498 kernel/softirq.c:571)
 r7:df85df08 r6:00000008 r5:00000009 r4:824040a0
[<802011cc>] (__do_softirq) from [<8024a3c8>] (invoke_softirq kernel/softirq.c:445 [inline])
[<802011cc>] (__do_softirq) from [<8024a3c8>] (__irq_exit_rcu kernel/softirq.c:650 [inline])
[<802011cc>] (__do_softirq) from [<8024a3c8>] (__irq_exit_rcu kernel/softirq.c:640 [inline])
[<802011cc>] (__do_softirq) from [<8024a3c8>] (irq_exit+0x9c/0xe8 kernel/softirq.c:674)
 r10:825d998e r9:828f3980 r8:00000000 r7:df85df08 r6:81f3b940 r5:81f3b958
 r4:822aac40
[<8024a32c>] (irq_exit) from [<817818b8>] (generic_handle_arch_irq+0x7c/0x80 kernel/irq/handle.c:240)
 r5:81f3b958 r4:822aac1c
[<8178183c>] (generic_handle_arch_irq) from [<817371d4>] (call_with_stack+0x1c/0x20 arch/arm/lib/call_with_stack.S:40)
 r9:828f3980 r8:00000000 r7:df85df3c r6:ffffffff r5:60000013 r4:80208f08
[<817371b8>] (call_with_stack) from [<80200b44>] (__irq_svc+0x84/0xac arch/arm/kernel/entry-armv.S:221)
Exception stack(0xdf85df08 to 0xdf85df50)
df00:                   00000001 00000000 0048bc31 8021c240 828f3980 00000001
df20: 828f3980 8240c5e0 00000000 00000000 825d998e df85df64 df85df68 df85df58
df40: 80208f04 80208f08 60000013 ffffffff
[<80208ec8>] (arch_cpu_idle) from [<8178bb9c>] (default_idle_call+0x38/0x1b4 kernel/sched/idle.c:109)
[<8178bb64>] (default_idle_call) from [<8028f138>] (cpuidle_idle_call kernel/sched/idle.c:191 [inline])
[<8178bb64>] (default_idle_call) from [<8028f138>] (do_idle+0x218/0x2a0 kernel/sched/idle.c:303)
 r7:8240c5e0 r6:828f3980 r5:8240c49c r4:00000001
[<8028ef20>] (do_idle) from [<8028f4dc>] (cpu_startup_entry+0x20/0x24 kernel/sched/idle.c:400)
 r10:00000000 r9:412fc0f1 r8:80003010 r7:82646464 r6:828f3980 r5:00000001
 r4:0000009c
[<8028f4bc>] (cpu_startup_entry) from [<80210b70>] (secondary_start_kernel+0x138/0x194 arch/arm/kernel/smp.c:481)
[<80210a38>] (secondary_start_kernel) from [<80201714>] (__enable_mmu+0x0/0xc arch/arm/kernel/head.S:438)
 r7:82646464 r6:30c0387d r5:00000000 r4:82a0d6c0
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
