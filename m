Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134B3224367
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgGQS4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:56:18 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:50157 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQS4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 14:56:17 -0400
Received: by mail-io1-f69.google.com with SMTP id l7so7088494ioq.16
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 11:56:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/eE1uWfIufW8vQMws/6jTiBN48Hy0hA3uku2kspGanw=;
        b=tO/XOr223LASNZleHhbKcGirllr1YZnpUxLmG/FObWiCKi057ul7U6o5jbAWu/8B6o
         GRm0LoZEiYgA5Waji6s4SNraHBOLrB1nd3JcnLdoHQvQSBtkLkmb9r5kMTjVIZMXy8D0
         NRy/0QjDwHivyp5aOQ9UYOVIAwDPjiSYU7Jk4EJVuMOcu9dlbhU+OelnTQ1Hy1DQ0Zuw
         5e1PDczpBXRWGYIDuZXB1vM1ocyud3+hqa5dgeeBeIzmvhRR+MXIrFUqXimgjhNQ/gF8
         29i3TtND5wFXFYdhIqPBsIoMI6qnSjtlPrPVYv2xFTW1s7xcbBfujldA2Kh8zJ4nHEWe
         XePA==
X-Gm-Message-State: AOAM533YIzfuvHgP4p9ruT1YGqC+CDIlpUeeBZzVsQIUKHyxWLUlZPam
        yabTJbGDJAl6k2htuqRUKyU3BYNmwRB14fKRYmnrUTxRKHRo
X-Google-Smtp-Source: ABdhPJw1KdtA5u31Fl/CNv94wwk5X2Mpayq9H7dYSjQoKDiYimMRrexaFHuYHOiZGYWJ4jbuCnTIrXYo/uhswzv7ZNO6SlvEqSxj
MIME-Version: 1.0
X-Received: by 2002:a92:1bdb:: with SMTP id f88mr11577720ill.233.1595012176420;
 Fri, 17 Jul 2020 11:56:16 -0700 (PDT)
Date:   Fri, 17 Jul 2020 11:56:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000030271005aaa7b603@google.com>
Subject: general protection fault in ath9k_hif_usb_rx_cb (2)
From:   syzbot <syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    313da01a usb: misc: sisusbvga: Move static const tables ou..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=14226dd0900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=999be4eb2478ffa5
dashboard link: https://syzkaller.appspot.com/bug?extid=c6dde1f690b60e0b9fbe
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc00000001f2: 0000 [#1] SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000f90-0x0000000000000f97]
CPU: 1 PID: 356 Comm: syz-executor.1 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:627 [inline]
RIP: 0010:ath9k_hif_usb_rx_cb+0x843/0xf80 drivers/net/wireless/ath/ath9k/hif_usb.c:671
Code: 00 00 00 49 8d 7f 08 48 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 51 05 00 00 4d 8b 7f 08 49 8d bf 90 0f 00 00 48 89 f8 48 c1 e8 03 <0f> b6 04 28 84 c0 74 08 3c 03 0f 8e 25 05 00 00 48 8b 44 24 30 0f
RSP: 0018:ffff8881db309920 EFLAGS: 00010002
RAX: 00000000000001f2 RBX: 0000000000000c05 RCX: ffffc900006a8000
RDX: 0000000000040000 RSI: ffffffff82e1f88b RDI: 0000000000000f90
RBP: dffffc0000000000 R08: 0000000000000001 R09: ffff8881c3e144a3
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000c05 R14: ffff8881d9babb40 R15: 0000000000000000
FS:  0000000002773940(0000) GS:ffff8881db300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f052251e740 CR3: 00000001ad63e000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 __usb_hcd_giveback_urb+0x32d/0x560 drivers/usb/core/hcd.c:1650
 usb_hcd_giveback_urb+0x367/0x410 drivers/usb/core/hcd.c:1716
 dummy_timer+0x11f2/0x3240 drivers/usb/gadget/udc/dummy_hcd.c:1967
 call_timer_fn+0x1ac/0x6e0 kernel/time/timer.c:1404
 expire_timers kernel/time/timer.c:1449 [inline]
 __run_timers.part.0+0x54c/0x9e0 kernel/time/timer.c:1773
 __run_timers kernel/time/timer.c:1745 [inline]
 run_timer_softirq+0x80/0x120 kernel/time/timer.c:1786
 __do_softirq+0x222/0x95b kernel/softirq.c:292
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:711
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0xed/0x140 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:387 [inline]
 __irq_exit_rcu kernel/softirq.c:417 [inline]
 irq_exit_rcu+0x150/0x1f0 kernel/softirq.c:429
 sysvec_apic_timer_interrupt+0x49/0xc0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:596
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/irqflags.h:85 [inline]
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0x3b/0x40 kernel/locking/spinlock.c:191
Code: e8 ca b5 76 fb 48 89 ef e8 62 a2 77 fb f6 c7 02 75 11 53 9d e8 16 46 95 fb 65 ff 0d cf 0d 52 7a 5b 5d c3 e8 f7 4b 95 fb 53 9d <eb> ed 0f 1f 00 55 48 89 fd 65 ff 05 b5 0d 52 7a 45 31 c9 41 b8 01
RSP: 0018:ffff8881ad7b7c30 EFLAGS: 00000292
RAX: 0000000000243e09 RBX: 0000000000000292 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff85afe139
RBP: ffff8881d57fd4a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8881c6e14b00 R14: 0000000000000000 R15: ffff8881c6e14fd8
 do_wait+0x42e/0x9b0 kernel/exit.c:1473
 kernel_wait4+0x14c/0x260 kernel/exit.c:1621
 __do_sys_wait4+0x13f/0x150 kernel/exit.c:1633
 do_syscall_64+0x50/0x90 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x415ffa
Code: Bad RIP value.
RSP: 002b:00007ffd2403c368 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
RAX: ffffffffffffffda RBX: 0000000000023821 RCX: 0000000000415ffa
RDX: 0000000040000001 RSI: 00007ffd2403c3a0 RDI: ffffffffffffffff
RBP: 0000000000000060 R08: 0000000000000001 R09: 0000000002773940
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd2403c3a0 R14: 0000000000023821 R15: 00007ffd2403c3b0
Modules linked in:
---[ end trace 1a7827ecbdcfd2ad ]---
RIP: 0010:ath9k_hif_usb_rx_stream drivers/net/wireless/ath/ath9k/hif_usb.c:627 [inline]
RIP: 0010:ath9k_hif_usb_rx_cb+0x843/0xf80 drivers/net/wireless/ath/ath9k/hif_usb.c:671
Code: 00 00 00 49 8d 7f 08 48 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 51 05 00 00 4d 8b 7f 08 49 8d bf 90 0f 00 00 48 89 f8 48 c1 e8 03 <0f> b6 04 28 84 c0 74 08 3c 03 0f 8e 25 05 00 00 48 8b 44 24 30 0f
RSP: 0018:ffff8881db309920 EFLAGS: 00010002
RAX: 00000000000001f2 RBX: 0000000000000c05 RCX: ffffc900006a8000
RDX: 0000000000040000 RSI: ffffffff82e1f88b RDI: 0000000000000f90
RBP: dffffc0000000000 R08: 0000000000000001 R09: ffff8881c3e144a3
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000c05 R14: ffff8881d9babb40 R15: 0000000000000000
FS:  0000000002773940(0000) GS:ffff8881db300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f052251e740 CR3: 00000001ad63e000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
