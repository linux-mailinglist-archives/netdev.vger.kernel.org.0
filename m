Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD4910B6C2
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 20:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfK0TaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 14:30:11 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:47094 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbfK0TaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 14:30:10 -0500
Received: by mail-il1-f198.google.com with SMTP id i74so20238895ild.13
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 11:30:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=bG2RrafpjJ6FDsfKN8Y+xO+P47qZbFGyCGPl+U7++Xs=;
        b=MZ0mgsn6yOY25jQMz0N5qQZD7uR6CCvXMCoJPkhEV1KEePCsd85Op/GQO9UcIs/IFL
         f0Lp9+WTturV49Goc3CQldYDhPdYLivQWusLJAoZNCoqVvTdUJa2XsBr7j+ZLxAvHFHU
         7uNwc5te+zMz76mz6D8y6SLsVrpJd47k/TnTy0YaU8zTNg/HH950Pyy/hFqPBQdujPyJ
         RSPsypLzNw8PJjquUDOPNPdeFy9hpiguJH+GqhK+n3Mlwb7N8lwiiS8Y5mIyQCWF6jNg
         REOvsmV61LtzDEzB8Cd39OpkgcFnmzrd2R+tmhGVWl/+dOkm17yGncL3vUIyewekd/2H
         5APQ==
X-Gm-Message-State: APjAAAWf1Ocr/iEZZF+eIAKOER+ECQenyUFMOfNin02/rlABQSff/X1y
        bruPyZd4NNeLSCuwPtnBFkeZNjNRWud3Qcj/joh9D28616iU
X-Google-Smtp-Source: APXvYqzqWhjAaOL17jKCZLWJajcrkAV9cJYr6DLFM3fo2+mHh7x35IPK7rx30OVzJQu/sjFGH4hnAzoUgrWywylZP4dnA4cXGIFl
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:60f:: with SMTP id t15mr21705024ils.277.1574883007785;
 Wed, 27 Nov 2019 11:30:07 -0800 (PST)
Date:   Wed, 27 Nov 2019 11:30:07 -0800
In-Reply-To: <00000000000038b5c205983c2df4@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003dfed805985906b6@google.com>
Subject: Re: WARNING in mark_lock (3)
From:   syzbot <syzbot+a229d8d995b74f8c4b6c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    89d57ddd Merge tag 'media/v5.5-1' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=117804dae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=595c15c951695d1b
dashboard link: https://syzkaller.appspot.com/bug?extid=a229d8d995b74f8c4b6c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1511af5ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e0f17ae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a229d8d995b74f8c4b6c@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 0 at kernel/locking/lockdep.c:167 hlock_class  
kernel/locking/lockdep.c:167 [inline]
WARNING: CPU: 0 PID: 0 at kernel/locking/lockdep.c:167 hlock_class  
kernel/locking/lockdep.c:156 [inline]
WARNING: CPU: 0 PID: 0 at kernel/locking/lockdep.c:167  
mark_lock+0x22b/0x1220 kernel/locking/lockdep.c:3643
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  panic+0x2e3/0x75c kernel/panic.c:221
  __warn.cold+0x2f/0x3e kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:hlock_class kernel/locking/lockdep.c:167 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:156 [inline]
RIP: 0010:mark_lock+0x22b/0x1220 kernel/locking/lockdep.c:3643
Code: d0 7c 08 84 d2 0f 85 a8 0e 00 00 44 8b 1d ed e6 8d 08 45 85 db 75 b6  
48 c7 c6 00 19 cc 87 48 c7 c7 40 19 cc 87 e8 e4 2d eb ff <0f> 0b 31 db e9  
aa fe ff ff 48 c7 c7 a0 08 d0 8a e8 f0 fb 56 00 e9
RSP: 0018:ffff8880ae809308 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000100 RSI: ffffffff815dc196 RDI: ffffed1015d01253
RBP: ffff8880ae809358 R08: ffffffff8907a1c0 R09: fffffbfff1234161
R10: fffffbfff1234160 R11: ffffffff891a0b03 R12: 0000000000000004
R13: ffffffff8907ab48 R14: 0000000000000001 R15: 00000000000425c6
  mark_usage kernel/locking/lockdep.c:3566 [inline]
  __lock_acquire+0x1e8e/0x4a00 kernel/locking/lockdep.c:3909
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  __netif_tx_lock include/linux/netdevice.h:3925 [inline]
  sch_direct_xmit+0x2e0/0xd30 net/sched/sch_generic.c:311
  __dev_xmit_skb net/core/dev.c:3621 [inline]
  __dev_queue_xmit+0x270a/0x35c0 net/core/dev.c:3982
  dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  neigh_resolve_output net/core/neighbour.c:1490 [inline]
  neigh_resolve_output+0x5c4/0x990 net/core/neighbour.c:1470
  neigh_output include/net/neighbour.h:511 [inline]
  ip6_finish_output2+0x109a/0x25c0 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
  ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:307 [inline]
  NF_HOOK include/linux/netfilter.h:301 [inline]
  mld_sendpack+0x9c2/0xed0 net/ipv6/mcast.c:1682
  mld_send_cr net/ipv6/mcast.c:1978 [inline]
  mld_ifc_timer_expire+0x454/0x950 net/ipv6/mcast.c:2477
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers kernel/time/timer.c:1773 [inline]
  __run_timers kernel/time/timer.c:1740 [inline]
  run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
  </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 58 25 4f fa eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d 24 c9 66  
00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d 14 c9 66 00 fb f4 <c3> cc 55 48 89  
e5 41 57 41 56 41 55 41 54 53 e8 5e 42 00 fa e8 b9
RSP: 0018:ffffffff89007ce8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1226656 RBX: ffffffff8907a1c0 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffffffff8907aa54
RBP: ffffffff89007d18 R08: ffffffff8907a1c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff89e789c0 R14: 0000000000000000 R15: 0000000000000000
  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:690
  default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
  do_idle+0x3c8/0x6e0 kernel/sched/idle.c:269
  cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:361
  rest_init+0x23b/0x371 init/main.c:451
  arch_call_rest_init+0xe/0x1b
  start_kernel+0x904/0x943 init/main.c:784
  x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
  x86_64_start_kernel+0x77/0x7b arch/x86/kernel/head64.c:471
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242
------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel/locking/mutex.c:1419  
mutex_trylock+0x279/0x2f0 kernel/locking/mutex.c:1427
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:mutex_trylock+0x279/0x2f0 kernel/locking/mutex.c:1419
Code: c9 41 b8 01 00 00 00 31 c9 ba 01 00 00 00 31 f6 e8 0c 5e f9 f9 58 48  
8d 65 d8 b8 01 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b e9 0c fe  
ff ff 48 c7 c7 a0 08 d0 8a 48 89 4d d0 e8 70 e7 4f
RSP: 0018:ffff8880ae808ec8 EFLAGS: 00010006
RAX: 0000000000000504 RBX: 1ffff11015d011e1 RCX: 0000000000000004
RDX: 0000000000000100 RSI: ffffffff816b4095 RDI: ffffffff891c9b60
RBP: ffff8880ae808ef8 R08: 0000000000000001 R09: fffffbfff12346bd
R10: fffffbfff12346bc R11: ffffffff891a35e3 R12: ffffffff8ad008a0
R13: 0000000000000000 R14: ffffffff8159d400 R15: ffffffff891c9b60
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200001c0 CR3: 00000000a5da3000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  <IRQ>
  __crash_kexec+0x91/0x200 kernel/kexec_core.c:948
  panic+0x308/0x75c kernel/panic.c:241
  __warn.cold+0x2f/0x3e kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:hlock_class kernel/locking/lockdep.c:167 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:156 [inline]
RIP: 0010:mark_lock+0x22b/0x1220 kernel/locking/lockdep.c:3643
Code: d0 7c 08 84 d2 0f 85 a8 0e 00 00 44 8b 1d ed e6 8d 08 45 85 db 75 b6  
48 c7 c6 00 19 cc 87 48 c7 c7 40 19 cc 87 e8 e4 2d eb ff <0f> 0b 31 db e9  
aa fe ff ff 48 c7 c7 a0 08 d0 8a e8 f0 fb 56 00 e9
RSP: 0018:ffff8880ae809308 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000100 RSI: ffffffff815dc196 RDI: ffffed1015d01253
RBP: ffff8880ae809358 R08: ffffffff8907a1c0 R09: fffffbfff1234161
R10: fffffbfff1234160 R11: ffffffff891a0b03 R12: 0000000000000004
R13: ffffffff8907ab48 R14: 0000000000000001 R15: 00000000000425c6
  mark_usage kernel/locking/lockdep.c:3566 [inline]
  __lock_acquire+0x1e8e/0x4a00 kernel/locking/lockdep.c:3909
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  __netif_tx_lock include/linux/netdevice.h:3925 [inline]
  sch_direct_xmit+0x2e0/0xd30 net/sched/sch_generic.c:311
  __dev_xmit_skb net/core/dev.c:3621 [inline]
  __dev_queue_xmit+0x270a/0x35c0 net/core/dev.c:3982
  dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  neigh_resolve_output net/core/neighbour.c:1490 [inline]
  neigh_resolve_output+0x5c4/0x990 net/core/neighbour.c:1470
  neigh_output include/net/neighbour.h:511 [inline]
  ip6_finish_output2+0x109a/0x25c0 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
  ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:307 [inline]
  NF_HOOK include/linux/netfilter.h:301 [inline]
  mld_sendpack+0x9c2/0xed0 net/ipv6/mcast.c:1682
  mld_send_cr net/ipv6/mcast.c:1978 [inline]
  mld_ifc_timer_expire+0x454/0x950 net/ipv6/mcast.c:2477
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers kernel/time/timer.c:1773 [inline]
  __run_timers kernel/time/timer.c:1740 [inline]
  run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
  </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 58 25 4f fa eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d 24 c9 66  
00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d 14 c9 66 00 fb f4 <c3> cc 55 48 89  
e5 41 57 41 56 41 55 41 54 53 e8 5e 42 00 fa e8 b9
RSP: 0018:ffffffff89007ce8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1226656 RBX: ffffffff8907a1c0 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffffffff8907aa54
RBP: ffffffff89007d18 R08: ffffffff8907a1c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff89e789c0 R14: 0000000000000000 R15: 0000000000000000
  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:690
  default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
  do_idle+0x3c8/0x6e0 kernel/sched/idle.c:269
  cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:361
  rest_init+0x23b/0x371 init/main.c:451
  arch_call_rest_init+0xe/0x1b
  start_kernel+0x904/0x943 init/main.c:784
  x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
  x86_64_start_kernel+0x77/0x7b arch/x86/kernel/head64.c:471
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242
irq event stamp: 169380
hardirqs last  enabled at (169380): [<ffffffff85b80cd8>]  
seqcount_lockdep_reader_access include/linux/seqlock.h:83 [inline]
hardirqs last  enabled at (169380): [<ffffffff85b80cd8>]  
read_seqcount_begin include/linux/seqlock.h:164 [inline]
hardirqs last  enabled at (169380): [<ffffffff85b80cd8>] read_seqbegin  
include/linux/seqlock.h:433 [inline]
hardirqs last  enabled at (169380): [<ffffffff85b80cd8>]  
neigh_resolve_output net/core/neighbour.c:1484 [inline]
hardirqs last  enabled at (169380): [<ffffffff85b80cd8>]  
neigh_resolve_output+0x3e8/0x990 net/core/neighbour.c:1470
hardirqs last disabled at (169379): [<ffffffff85b80c80>]  
seqcount_lockdep_reader_access include/linux/seqlock.h:80 [inline]
hardirqs last disabled at (169379): [<ffffffff85b80c80>]  
read_seqcount_begin include/linux/seqlock.h:164 [inline]
hardirqs last disabled at (169379): [<ffffffff85b80c80>] read_seqbegin  
include/linux/seqlock.h:433 [inline]
hardirqs last disabled at (169379): [<ffffffff85b80c80>]  
neigh_resolve_output net/core/neighbour.c:1484 [inline]
hardirqs last disabled at (169379): [<ffffffff85b80c80>]  
neigh_resolve_output+0x390/0x990 net/core/neighbour.c:1470
softirqs last  enabled at (169342): [<ffffffff81468f2c>]  
_local_bh_enable+0x1c/0x30 kernel/softirq.c:162
softirqs last disabled at (169343): [<ffffffff8146b92b>] invoke_softirq  
kernel/softirq.c:373 [inline]
softirqs last disabled at (169343): [<ffffffff8146b92b>]  
irq_exit+0x19b/0x1e0 kernel/softirq.c:413
---[ end trace 2daec1acd3cd1e7d ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel/locking/mutex.c:737 mutex_unlock+0x1d/0x30  
kernel/locking/mutex.c:744
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         5.4.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:mutex_unlock+0x1d/0x30 kernel/locking/mutex.c:737
Code: 4c 89 ff e8 c5 f2 4f fa e9 8c fb ff ff 55 65 8b 05 00 40 a1 78 a9 00  
ff 1f 00 48 89 e5 75 0b 48 8b 75 08 e8 45 f9 ff ff 5d c3 <0f> 0b 48 8b 75  
08 e8 38 f9 ff ff 5d c3 66 0f 1f 44 00 00 48 b8 00
RSP: 0018:ffff8880ae808ef8 EFLAGS: 00010006
RAX: 0000000000000504 RBX: 1ffff11015d011e1 RCX: ffffffff816b40ad
RDX: 0000000000000100 RSI: ffffffff816b410f RDI: ffffffff891c9b60
RBP: ffff8880ae808ef8 R08: ffffffff8907a1c0 R09: 0000000000000000
R10: fffffbfff123936c R11: ffffffff891c9b67 R12: 0000000000000001
R13: 0000000000000000 R14: ffffffff8159d400 R15: 00000000000000a7
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200001c0 CR3: 00000000a5da3000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  <IRQ>
  __crash_kexec+0x10b/0x200 kernel/kexec_core.c:957
  panic+0x308/0x75c kernel/panic.c:241
  __warn.cold+0x2f/0x3e kernel/panic.c:582
  report_bug+0x289/0x300 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  fixup_bug arch/x86/kernel/traps.c:169 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:hlock_class kernel/locking/lockdep.c:167 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:156 [inline]
RIP: 0010:mark_lock+0x22b/0x1220 kernel/locking/lockdep.c:3643
Code: d0 7c 08 84 d2 0f 85 a8 0e 00 00 44 8b 1d ed e6 8d 08 45 85 db 75 b6  
48 c7 c6 00 19 cc 87 48 c7 c7 40 19 cc 87 e8 e4 2d eb ff <0f> 0b 31 db e9  
aa fe ff ff 48 c7 c7 a0 08 d0 8a e8 f0 fb 56 00 e9
RSP: 0018:ffff8880ae809308 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000100 RSI: ffffffff815dc196 RDI: ffffed1015d01253
RBP: ffff8880ae809358 R08: ffffffff8907a1c0 R09: fffffbfff1234161
R10: fffffbfff1234160 R11: ffffffff891a0b03 R12: 0000000000000004
R13: ffffffff8907ab48 R14: 0000000000000001 R15: 00000000000425c6
  mark_usage kernel/locking/lockdep.c:3566 [inline]
  __lock_acquire+0x1e8e/0x4a00 kernel/locking/lockdep.c:3909
  lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4485
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2f/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  __netif_tx_lock include/linux/netdevice.h:3925 [inline]
  sch_direct_xmit+0x2e0/0xd30 net/sched/sch_generic.c:311
  __dev_xmit_skb net/core/dev.c:3621 [inline]
  __dev_queue_xmit+0x270a/0x35c0 net/core/dev.c:3982
  dev_queue_xmit+0x18/0x20 net/core/dev.c:4046
  neigh_resolve_output net/core/neighbour.c:1490 [inline]
  neigh_resolve_output+0x5c4/0x990 net/core/neighbour.c:1470
  neigh_output include/net/neighbour.h:511 [inline]
  ip6_finish_output2+0x109a/0x25c0 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x444/0xaa0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x38/0x1f0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
  ip6_output+0x25e/0x880 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:307 [inline]
  NF_HOOK include/linux/netfilter.h:301 [inline]
  mld_sendpack+0x9c2/0xed0 net/ipv6/mcast.c:1682
  mld_send_cr net/ipv6/mcast.c:1978 [inline]
  mld_ifc_timer_expire+0x454/0x950 net/ipv6/mcast.c:2477
  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers kernel/time/timer.c:1773 [inline]
  __run_timers kernel/time/timer.c:1740 [inline]
  run_timer_softirq+0x6c3/0x1790 kernel/time/timer.c:1786
  __do_softirq+0x262/0x98c kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x1a3/0x610 arch/x86/kernel/apic/apic.c:1137
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
  </IRQ>
RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
Code: 58 25 4f fa eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d 24 c9 66  
00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d 14 c9 66 00 fb f4 <c3> cc 55 48 89  
e5 41 57 41 56 41 55 41 54 53 e8 5e 42 00 fa e8 b9
RSP: 0018:ffffffff89007ce8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff1226656 RBX: ffffffff8907a1c0 RCX: 0000000000000000
RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffffffff8907aa54
RBP: ffffffff89007d18 R08: ffffffff8907a1c0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff89e789c0 R14: 0000000000000000 R15: 0000000000000000
  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:690
  default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
  do_idle+0x3c8/0x6e0 kernel/sched/idle.c:269
  cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:361
  rest_init+0x23b/0x371 init/main.c:451
  arch_call_rest_init+0xe/0x1b
  start_kernel+0x904/0x943 init/main.c:784
  x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
  x86_64_start_kernel+0x77/0x7b arch/x86/kernel/head64.c:471
  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242
irq event stamp: 169380
hardirqs last  enabled at (169380): [<ffffffff85b80cd8>]  
seqcount_lockdep_reader_access include/linux/seqlock.h:83 [inline]
hardirqs last  enabled at (169380): [<ffffffff85b80cd8>]  
read_seqcount_begin include/linux/seqlock.h:164 [inline]
hardirqs last  enabled at (169380): [<ffffffff85b80cd8>] read_seqbegin  
include/linux/seqlock.h:433 [inline]
hardirqs last  enabled at (169380): [<ffffffff85b80cd8>]  
neigh_resolve_output net/core/neighbour.c:1484 [inline]
hardirqs last  enabled at (169380): [<ffffffff85b80cd8>]  
neigh_resolve_output+0x3e8/0x990 net/core/neighbour.c:1470
hardirqs last disabled at (169379): [<ffffffff85b80c80>]  
seqcount_lockdep_reader_access include/linux/seqlock.h:80 [inline]
hardirqs last disabled at (169379): [<ffffffff85b80c80>]  
read_seqcount_begin include/linux/seqlock.h:164 [inline]
hardirqs last disabled at (169379): [<ffffffff85b80c80>] read_seqbegin  
include/linux/seqlock.h:433 [inline]
hardirqs last disabled at (169379): [<ffffffff85b80c80>]  
neigh_resolve_output net/core/neighbour.c:1484 [inline]
hardirqs last disabled at (169379): [<ffffffff85b80c80>]  
neigh_resolve_output+0x390/0x990 net/core/neighbour.c:1470
softirqs last  enabled at (169342): [<ffffffff81468f2c>]  
_local_bh_enable+0x1c/0x30 kernel/softirq.c:162
softirqs last disabled at (169343): [<ffffffff8146b92b>] invoke_softirq  
kernel/softirq.c:373 [inline]
softirqs last disabled at (169343): [<ffffffff8146b92b>]  
irq_exit+0x19b/0x1e0 kernel/softirq.c:413
---[ end trace 2daec1acd3cd1e7e ]---
Kernel Offset: disabled
Rebooting in 86400 seconds..

