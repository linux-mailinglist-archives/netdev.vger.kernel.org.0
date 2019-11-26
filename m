Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B46AA109AB0
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 10:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfKZJFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 04:05:08 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:51317 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbfKZJFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 04:05:08 -0500
Received: by mail-io1-f71.google.com with SMTP id t18so7359077iob.18
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 01:05:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OFHVSlfS2yDF527fhuEXlXOXPa5EQL6IyHToLAgPneA=;
        b=HZJc8WKu1UWcaZErp2TrSX9J/Rv6yMt8vdQoe82Pt7fU6cwMfJvx1EsH8uMgkgNDzK
         oaSFwatJtNX6vkfduk87ZdmN1sTeRZ6RKnIlvCVHu8IDgB9W3B8M/ASjT3Fdgy2WhjDM
         6hAAQQZ5EaDtQe1wB6mVXddgIbTk3oMCZ3ECSKHT89Pcqay/GOVxYsk3T8VTro5BjcxW
         hsWfLRfRw/ErGOdkgvx4aCHn3n2MDR+BtjQvKCY1D/o1zmZMhxNT//HR6Ya71Yxz0wHC
         WigkBSkWTIoFkyey1QIqv/VhPd09yCro8k0nFqpWqRsb0OC81O+RSaH/ZYZRzhE1qmVx
         3X0w==
X-Gm-Message-State: APjAAAVCw0cjPNPyrv48oMLbPl5vP4KKC3tazfaQ2k0yMcduD5ZpV+El
        UwmIyvKlZV7iFYxvtT9cOgw1cbGPApJfgGq9pDVzBh8ERObN
X-Google-Smtp-Source: APXvYqzleiyVjiPoRdaLBXB+zjhmA6LiBl49k5vct0dNHB/1NvyCK+e1PzihY8x9fRjMVPYynqu/mdouOAIPlgXcuEQRx4qKddyd
MIME-Version: 1.0
X-Received: by 2002:a92:1d52:: with SMTP id d79mr36776177ild.185.1574759107701;
 Tue, 26 Nov 2019 01:05:07 -0800 (PST)
Date:   Tue, 26 Nov 2019 01:05:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000038b5c205983c2df4@google.com>
Subject: WARNING in mark_lock (3)
From:   syzbot <syzbot+a229d8d995b74f8c4b6c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    81429eb8 Merge tag 'arm64-fixes' of git://git.kernel.org/p..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=171edaf2e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56f109a734a2de32
dashboard link: https://syzkaller.appspot.com/bug?extid=a229d8d995b74f8c4b6c
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ee1f3ce00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a229d8d995b74f8c4b6c@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 8024 at kernel/locking/lockdep.c:167 hlock_class  
kernel/locking/lockdep.c:167 [inline]
WARNING: CPU: 0 PID: 8024 at kernel/locking/lockdep.c:167  
mark_lock+0x8d2/0x1650 kernel/locking/lockdep.c:3643
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8024 Comm: udevd Not tainted 5.4.0-rc8-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1fb/0x318 lib/dump_stack.c:118
  panic+0x264/0x7a9 kernel/panic.c:221
  __warn+0x20e/0x210 kernel/panic.c:582
  report_bug+0x1b6/0x2f0 lib/bug.c:195
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  do_error_trap+0xd7/0x440 arch/x86/kernel/traps.c:272
  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:hlock_class kernel/locking/lockdep.c:167 [inline]
RIP: 0010:mark_lock+0x8d2/0x1650 kernel/locking/lockdep.c:3643
Code: 0f 85 af 02 00 00 83 3d 8f 7a 65 07 00 0f 85 7a f8 ff ff 31 db 48 c7  
c7 24 71 36 88 48 c7 c6 3c 2f 3b 88 31 c0 e8 be f4 ec ff <0f> 0b e9 6e f8  
ff ff 4c 69 f3 b0 00 00 00 48 c7 c0 d0 f4 1c 89 4c
RSP: 0018:ffff8880aea09520 EFLAGS: 00010046
RAX: 7cc85c2266612300 RBX: 0000000000000000 RCX: ffff88809907a480
RDX: 0000000080000502 RSI: 0000000000000001 RDI: ffffffff815cbf54
RBP: ffff8880aea09620 R08: ffffffff8178fcea R09: fffffbfff111a493
R10: fffffbfff111a493 R11: 0000000000000000 R12: 1ffff1101320f5c5
R13: dffffc0000000000 R14: 0000000000000004 R15: 0000000000000010
  mark_usage kernel/locking/lockdep.c:3566 [inline]
  __lock_acquire+0x5a0/0x1be0 kernel/locking/lockdep.c:3909
  lock_acquire+0x158/0x250 kernel/locking/lockdep.c:4487
  __raw_spin_lock include/linux/spinlock_api_smp.h:142 [inline]
  _raw_spin_lock+0x2d/0x40 kernel/locking/spinlock.c:151
  spin_lock include/linux/spinlock.h:338 [inline]
  __netif_tx_lock include/linux/netdevice.h:3897 [inline]
  sch_direct_xmit+0x154/0xd50 net/sched/sch_generic.c:311
  __dev_xmit_skb net/core/dev.c:3400 [inline]
  __dev_queue_xmit+0x1bf7/0x3010 net/core/dev.c:3761
  dev_queue_xmit+0x17/0x20 net/core/dev.c:3825
  neigh_hh_output include/net/neighbour.h:500 [inline]
  neigh_output include/net/neighbour.h:509 [inline]
  ip6_finish_output2+0xff2/0x13b0 net/ipv6/ip6_output.c:116
  __ip6_finish_output+0x693/0x8c0 net/ipv6/ip6_output.c:142
  ip6_finish_output+0x52/0x1e0 net/ipv6/ip6_output.c:152
  NF_HOOK_COND include/linux/netfilter.h:294 [inline]
  ip6_output+0x26f/0x370 net/ipv6/ip6_output.c:175
  dst_output include/net/dst.h:436 [inline]
  NF_HOOK include/linux/netfilter.h:305 [inline]
  mld_sendpack+0x770/0xb80 net/ipv6/mcast.c:1682
  mld_send_initial_cr+0x24c/0x2c0 net/ipv6/mcast.c:2099
  mld_dad_timer_expire+0x2e/0x350 net/ipv6/mcast.c:2118
  call_timer_fn+0x95/0x170 kernel/time/timer.c:1404
  expire_timers kernel/time/timer.c:1449 [inline]
  __run_timers+0x7b6/0x990 kernel/time/timer.c:1773
  run_timer_softirq+0x4a/0x90 kernel/time/timer.c:1786
  __do_softirq+0x333/0x7c4 arch/x86/include/asm/paravirt.h:766
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x227/0x230 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x113/0x280 arch/x86/kernel/apic/apic.c:1137
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
  </IRQ>
RIP: 0010:update_stack_state+0x3c/0x530 arch/x86/kernel/unwind_frame.c:196
Code: 00 00 49 89 f5 49 89 ff 65 48 8b 04 25 28 00 00 00 48 89 45 d0 48 bb  
00 00 00 00 00 fc ff df 48 89 f8 48 c1 e8 03 48 89 45 a8 <8a> 04 18 84 c0  
0f 85 71 03 00 00 41 8b 07 89 45 a4 4d 8d 67 58 4c
RSP: 0018:ffff888097ae7520 EFLAGS: 00000a02 ORIG_RAX: ffffffffffffff13
RAX: 1ffff11012f5ced0 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000009 RSI: ffff888097ae7f48 RDI: ffff888097ae7680
RBP: ffff888097ae75c8 R08: ffffffff81629dbd R09: ffff888097ae7680
R10: ffffed1012f5cedc R11: 0000000000000000 R12: ffff888097ae7f48
R13: ffff888097ae7f48 R14: ffff888097ae76d0 R15: ffff888097ae7680
  unwind_next_frame+0x3f1/0x7a0 arch/x86/kernel/unwind_frame.c:311
  arch_stack_walk+0xb4/0xe0 arch/x86/kernel/stacktrace.c:25
  stack_trace_save+0xb6/0x150 kernel/stacktrace.c:123
  save_stack mm/kasan/common.c:69 [inline]
  set_track mm/kasan/common.c:77 [inline]
  __kasan_kmalloc+0x11c/0x1b0 mm/kasan/common.c:510
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:524
  __do_kmalloc_node mm/slab.c:3615 [inline]
  __kmalloc_node_track_caller+0x4d/0x60 mm/slab.c:3629
  __kmalloc_reserve net/core/skbuff.c:141 [inline]
  __alloc_skb+0xe8/0x500 net/core/skbuff.c:209
  alloc_skb include/linux/skbuff.h:1049 [inline]
  alloc_skb_with_frags+0xb6/0x600 net/core/skbuff.c:5662
  sock_alloc_send_pskb+0x7cc/0xbc0 net/core/sock.c:2244
  unix_dgram_sendmsg+0x612/0x2460 net/unix/af_unix.c:1625
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  __sys_sendto+0x442/0x5e0 net/socket.c:1952
  __do_sys_sendto net/socket.c:1964 [inline]
  __se_sys_sendto net/socket.c:1960 [inline]
  __x64_sys_sendto+0xe5/0x100 net/socket.c:1960
  do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7f31c173d282
Code: 48 83 c8 ff eb ea 90 90 53 48 83 ec 20 8b 05 81 d3 2a 00 85 c0 75 21  
45 31 c9 45 31 c0 4c 63 d1 48 63 ff b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff  
ff 77 61 48 83 c4 20 5b c3 48 89 54 24 08 89 0c 24
RSP: 002b:00007ffdbd60f5e0 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000000000063a3c0 RCX: 00007f31c173d282
RDX: 0000000000000008 RSI: 00007ffdbd60f630 RDI: 0000000000000009
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 000000000063d8f0 R14: 000000000063a250 R15: 000000000000000b
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
