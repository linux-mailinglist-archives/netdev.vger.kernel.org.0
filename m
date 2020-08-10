Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666C32407CE
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 16:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgHJOrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 10:47:21 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:47932 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgHJOrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 10:47:17 -0400
Received: by mail-io1-f71.google.com with SMTP id 18so7155524ioo.14
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 07:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=MoaBoYYMsIB/NvMH2oTkEpq0vOb0W8e7nW7Ah/O0ZEY=;
        b=LGbDU+ofYn0nfhXjZmikdCUIasPbajqu40U6t0EOpTyp0+2/5LtXO83NpsyL5YWdDc
         NaVHoGYWSRXGV5tDHfIkfjSPq2MiZLM21q7TBZfoQQ9wKEnCLBKMpPvQEkN/GsQwXkrg
         PAuM2Tu6Tc+/wQhZ6dHQ2dsHwMUX9hlgHD4L/quhs2Kqxn2Oe0uRwvIBKpQ4h7PARBjP
         gSaK8psmZGsYJYbpEM3B8uPutgl7aazJ3/gVg3Z0JTr0FfHSdMD177af6v12WAAWmTPR
         7Z5nbLNScJ01Hy0tLvolnqA7+oIDDgRmp8EYuafYO3ONXH7a/700oDRnqxe/bCQl54QL
         x9aw==
X-Gm-Message-State: AOAM531YNURZqQOh4WvAlfWTUpVSG0UpuqeRDKw1Dzd/52yjXNplg0fP
        fE+GclVfG6WK/CKZNW5TrKausptvxjAP/uUy6Lpj8j3OApXo
X-Google-Smtp-Source: ABdhPJz0QlAh/MjSxz4qBc/xVxOVuQog3nOkrLdmY62Wny3JrPjSL/ETqGEkH03+kqY8ZxcVu4Zd9uf0epZWOC2pmeDLagIZOIYw
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:bf1:: with SMTP id d17mr18219489ilu.261.1597070836515;
 Mon, 10 Aug 2020 07:47:16 -0700 (PDT)
Date:   Mon, 10 Aug 2020 07:47:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e44a6605ac8707f8@google.com>
Subject: WARNING in send_hsr_supervision_frame
From:   syzbot <syzbot+306c47d7ca825a3a6589@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    449dc8c9 Merge tag 'for-v5.9' of git://git.kernel.org/pub/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11b7d71a900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf68a13f867fd1b4
dashboard link: https://syzkaller.appspot.com/bug?extid=306c47d7ca825a3a6589
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+306c47d7ca825a3a6589@syzkaller.appspotmail.com

------------[ cut here ]------------
HSR: Could not send supervision frame
WARNING: CPU: 1 PID: 32657 at net/hsr/hsr_device.c:299 send_hsr_supervision_frame+0x889/0xb40 net/hsr/hsr_device.c:299
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 32657 Comm: kworker/u4:1 Not tainted 5.8.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue:  0x0 (wg-kex-wg2)
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x45 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:send_hsr_supervision_frame+0x889/0xb40 net/hsr/hsr_device.c:299
Code: 02 31 ff 89 de e8 07 db 8c f9 84 db 0f 85 8b fd ff ff e8 ba de 8c f9 48 c7 c7 00 de 20 89 c6 05 e5 61 c5 02 01 e8 59 ea 5d f9 <0f> 0b e9 6c fd ff ff e8 9b de 8c f9 41 be 42 00 00 00 ba 01 00 00
RSP: 0000:ffffc90000da8c48 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888095cc8280 RSI: ffffffff815db887 RDI: fffff520001b517b
RBP: 00000000000088fb R08: 0000000000000001 R09: ffff8880ae731927
R10: 0000000000000000 R11: 0000000000003143 R12: ffff8880a62c1400
R13: 0000000000000000 R14: ffff8880510aece8 R15: ffff8880ae725600
 hsr_announce+0x122/0x320 net/hsr/hsr_device.c:404
 call_timer_fn+0x1ac/0x760 kernel/time/timer.c:1413
 expire_timers kernel/time/timer.c:1458 [inline]
 __run_timers.part.0+0x67c/0xaa0 kernel/time/timer.c:1755
 __run_timers kernel/time/timer.c:1736 [inline]
 run_timer_softirq+0xae/0x1a0 kernel/time/timer.c:1768
 __do_softirq+0x2de/0xa24 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x1f3/0x230 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1090
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:__raw_spin_unlock_irq include/linux/spinlock_api_smp.h:169 [inline]
RIP: 0010:_raw_spin_unlock_irq+0x4b/0x80 kernel/locking/spinlock.c:199
Code: c0 58 34 b6 89 48 ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 75 31 48 83 3d 06 70 c3 01 00 74 25 fb 66 0f 1f 44 00 00 <bf> 01 00 00 00 e8 bb fc 5c f9 65 8b 05 54 3a 0f 78 85 c0 74 02 5d
RSP: 0000:ffffc90005787e40 EFLAGS: 00000286
RAX: 1ffffffff136c68b RBX: ffff888095cc8280 RCX: 1ffffffff1562d79
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffffffff87f2c42f
RBP: ffff8880aa071800 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88803930bf00
R13: ffff8880a0a49d00 R14: 0000000000000000 R15: ffff8880aa071800
 worker_thread+0x147/0x1120 kernel/workqueue.c:2435
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
