Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2392E22F3
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 01:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgLXAVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 19:21:00 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:50346 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgLXAVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 19:21:00 -0500
Received: by mail-il1-f199.google.com with SMTP id t8so594509ils.17
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 16:20:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=2RC5DLvezgKsgVsXyDXIsInJoOl9BE3a8XEZljvMLKA=;
        b=NhaaKI0c0/eEpAFqN5BC42e3JtmKbm07NlhVCS4aA4XFPHOMuImYcoO71xTWT9l43N
         4/yOpVrVMk0B6/SgH5I6/OcZ5vmVF2e3SpOxzC4H6kDlOZwb9uOJ6xkdrbIxNQG8vfte
         e5iO1LQ3ln7AsCnWmkBPj0vszbbc9dmCrJzc0Wow5FbZNmIbuSQayX8vDgmLsDLMruzP
         aOlqJpl1oz6jYoGQRSijAakoHdapKeZa69/MDvd8vkCYx+BPJZ+ZNJZEsUptGwtzHxaP
         8ZBL0R/UNHC2KL+Nr3A8y0rx0ylAAwe/KhJczD+SlWBEsvZ0PeFZ4C5zapr+3JcL7A5/
         kthQ==
X-Gm-Message-State: AOAM532ecBl+1xzp8n7EBbvSJeri823B4UMSJSZhVBzKQ8H/I3u6IVe5
        uwo/PGH30ZietWGmK2W6oD2ADSgS9I2cVs1l2hlXji2lG9YB
X-Google-Smtp-Source: ABdhPJwjrPKiGzumv7cD1DTmDHR6RVzgAPDnEzkpNmIgVIAIg+Zy0wmYL/AZ/GY4TKdbaxUlrbW8VSvMF+IoPrisjbSI6zIPaUvq
MIME-Version: 1.0
X-Received: by 2002:a02:cc54:: with SMTP id i20mr25224327jaq.136.1608769219217;
 Wed, 23 Dec 2020 16:20:19 -0800 (PST)
Date:   Wed, 23 Dec 2020 16:20:19 -0800
In-Reply-To: <0000000000005fe14605b6ea4958@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d64c7a05b72ac56e@google.com>
Subject: Re: WARNING in isotp_tx_timer_handler
From:   syzbot <syzbot+78bab6958a614b0c80b9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hdanton@sina.com, kuba@kernel.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        mkl@pengutronix.de, netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    614cb589 Merge tag 'acpi-5.11-rc1-2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=151d558f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3e7e34a83d606100
dashboard link: https://syzkaller.appspot.com/bug?extid=78bab6958a614b0c80b9
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1196822b500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c75f97500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78bab6958a614b0c80b9@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at net/can/isotp.c:835 isotp_tx_timer_handler+0x65f/0xba0 net/can/isotp.c:835
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:isotp_tx_timer_handler+0x65f/0xba0 net/can/isotp.c:835
Code: c1 e8 03 83 e1 07 0f b6 04 28 38 c8 7f 08 84 c0 0f 85 b8 04 00 00 41 88 54 24 05 e9 07 fb ff ff 40 84 ed 75 21 e8 c1 64 7e f9 <0f> 0b 45 31 e4 e8 b7 64 7e f9 44 89 e0 48 83 c4 48 5b 5d 41 5c 41
RSP: 0018:ffffc90000007dc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88802a288518 RCX: 0000000000000100
RDX: ffffffff8b49bc00 RSI: ffffffff87f4e3ff RDI: 0000000000000003
RBP: 0000000000000000 R08: ffffffff8a7baf80 R09: ffffffff87f4ddfe
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880b9c26c80 R14: ffff8880b9c26a00 R15: ffff88802a288000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd91884b10 CR3: 000000001b5d4000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __run_hrtimer kernel/time/hrtimer.c:1519 [inline]
 __hrtimer_run_queues+0x609/0xea0 kernel/time/hrtimer.c:1583
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1600
 __do_softirq+0x2bc/0xa77 kernel/softirq.c:343
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:226 [inline]
 __irq_exit_rcu+0x17f/0x200 kernel/softirq.c:420
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:79 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:169 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:516
Code: ed 26 57 f8 84 db 75 ac e8 64 20 57 f8 e8 3f f6 5c f8 e9 0c 00 00 00 e8 55 20 57 f8 0f 00 2d ae 57 ae 00 e8 49 20 57 f8 fb f4 <9c> 5b 81 e3 00 02 00 00 fa 31 ff 48 89 de e8 24 28 57 f8 48 85 db
RSP: 0018:ffffffff8b407d60 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffff8b49bc00 RSI: ffffffff891c2877 RDI: 0000000000000000
RBP: ffff888141653064 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff81791ed8 R11: 0000000000000000 R12: 0000000000000001
R13: ffff888141653000 R14: ffff888141653064 R15: ffff888017f65004
 acpi_idle_enter+0x361/0x500 drivers/acpi/processor_idle.c:647
 cpuidle_enter_state+0x1b1/0xc80 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x4a/0xa0 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x3eb/0x590 kernel/sched/idle.c:299
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:396
 start_kernel+0x496/0x4b7 init/main.c:1061
 secondary_startup_64_no_verify+0xb0/0xbb

