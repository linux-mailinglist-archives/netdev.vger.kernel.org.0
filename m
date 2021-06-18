Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224373AD25A
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 20:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbhFRStg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 14:49:36 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:53944 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFRStd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 14:49:33 -0400
Received: by mail-io1-f72.google.com with SMTP id m20-20020a0566022e94b02904dcec9a796eso4188933iow.20
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 11:47:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yFmUr511A7Swb4Gxe5jCJZh8Muw3dGq5OHPJy+nSss8=;
        b=PC8Ts0/oSpSOH/YP2wdVGblglgd8Z/r3tQooZc+ChNmOUzyXmtS8/mf0ASb6tHIrmd
         mfyfhmnWeMdPOjB4+Kla+UgMKZSE3x6uWmVODFPekw8lKoGU4Ovp2O/qjIidn01hoKIv
         ZkQCtUsbsLq9e6lHpXPjT5WwYoq5p6+7+OSS35cjHvRrK7q2C+JprsEIAKRy4hVHC450
         v0ARMWm0wckXOh35f2olEMNRYMlrGf/3IrD8Er/mfii/L3y0fR+JQerXIJruXFSNyfj8
         WcgK9tpJH3GxhhZXtSYPo5wqG+AmUSq8r+2C1EP2tNCpQdNhjpTxd9qohdaj7WgTBan1
         5M5w==
X-Gm-Message-State: AOAM532jxcnsqXSgp1sZ9HtZQiqjTHQYMsuqMnmpzElVZoY3TUMy2v/O
        cO83wLnWhLXjM+Kuzqfjt4SbxN31RVv0sAm+a3qUNTZSTdNi
X-Google-Smtp-Source: ABdhPJwB4cHi0OxmyC3Qlyj9PLpMmAuCPJttgR0q6uqbZA7gosfeKOpPfW+/NwWtQ0MRa6eRHauWYl5W3nBXZjgPvDGLRcquYt97
MIME-Version: 1.0
X-Received: by 2002:a5e:d616:: with SMTP id w22mr9173574iom.75.1624042041657;
 Fri, 18 Jun 2021 11:47:21 -0700 (PDT)
Date:   Fri, 18 Jun 2021 11:47:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fe4d2805c50ec062@google.com>
Subject: [syzbot] WARNING in send_hsr_supervision_frame (2)
From:   syzbot <syzbot+4d244034ec23341ac562@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net,
        george.mccollister@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        netdev@vger.kernel.org, olteanv@gmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    009c9aa5 Linux 5.13-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14a01a6fd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5c800d14ba1dd912
dashboard link: https://syzkaller.appspot.com/bug?extid=4d244034ec23341ac562

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4d244034ec23341ac562@syzkaller.appspotmail.com

------------[ cut here ]------------
HSR: Could not send supervision frame
WARNING: CPU: 0 PID: 2130 at net/hsr/hsr_device.c:293 send_hsr_supervision_frame+0x66d/0x8d0 net/hsr/hsr_device.c:293
Modules linked in:
CPU: 0 PID: 2130 Comm: kswapd0 Not tainted 5.13.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:send_hsr_supervision_frame+0x66d/0x8d0 net/hsr/hsr_device.c:293
Code: 1d 5d eb eb 04 31 ff 89 de e8 7f 21 ab f8 84 db 75 b6 e8 66 19 ab f8 48 c7 c7 80 df 91 8a c6 05 3d eb eb 04 01 e8 78 22 0c 00 <0f> 0b eb 9a e8 4a 19 ab f8 41 be 3c 00 00 00 ba 01 00 00 00 4c 89
RSP: 0018:ffffc90000007c60 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801cc0c000 RSI: ffffffff815c1755 RDI: fffff52000000f7e
RBP: ffff88807591ac00 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815bb58e R11: 0000000000000000 R12: ffff88802a74a700
R13: 0000000000000000 R14: ffff88802a74a718 R15: 0000000000000017
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2138902303 CR3: 0000000014fd0000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 hsr_announce+0x122/0x320 net/hsr/hsr_device.c:382
 call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1431
 expire_timers kernel/time/timer.c:1476 [inline]
 __run_timers.part.0+0x67c/0xa50 kernel/time/timer.c:1745
 __run_timers kernel/time/timer.c:1726 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1758
 __do_softirq+0x29b/0x9f6 kernel/softirq.c:559
 invoke_softirq kernel/softirq.c:433 [inline]
 __irq_exit_rcu+0x136/0x200 kernel/softirq.c:637
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1100
 </IRQ>
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:647
RIP: 0010:free_unref_page_list+0x4ec/0x7c0 mm/page_alloc.c:3342
Code: ff ff e8 f6 d0 50 ff e9 b4 fe ff ff 48 85 d2 0f 85 95 00 00 00 9c 58 f6 c4 02 0f 85 e6 00 00 00 48 85 d2 74 01 fb 48 83 c4 20 <5b> 5d 41 5c 41 5d 41 5e 41 5f c3 48 89 14 24 e8 70 ac ca ff 48 8b
RSP: 0018:ffffc90007f17500 EFLAGS: 00000286
RAX: 0000000000000002 RBX: ffffc90007f17658 RCX: 1ffffffff2046962
RDX: 0000000000000200 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90007f17660 R08: 0000000000000001 R09: ffffffff9022c8b7
R10: 0000000000000001 R11: 0000000000000000 R12: ffffc90007f17658
R13: ffffc90007f17660 R14: ffffea0001e93448 R15: ffffc90007f17660
 shrink_page_list+0x14ce/0x6060 mm/vmscan.c:1684
 shrink_inactive_list+0x347/0xca0 mm/vmscan.c:2145
 shrink_list mm/vmscan.c:2367 [inline]
 shrink_lruvec+0x7f9/0x14f0 mm/vmscan.c:2662
 shrink_node_memcgs mm/vmscan.c:2850 [inline]
 shrink_node+0x868/0x1de0 mm/vmscan.c:2967
 kswapd_shrink_node mm/vmscan.c:3710 [inline]
 balance_pgdat+0x745/0x1270 mm/vmscan.c:3868
 kswapd+0x5b6/0xdb0 mm/vmscan.c:4125
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
