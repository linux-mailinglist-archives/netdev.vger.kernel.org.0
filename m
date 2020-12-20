Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E852DF6A2
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 20:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbgLTTYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 14:24:54 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:54221 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbgLTTYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 14:24:54 -0500
Received: by mail-io1-f70.google.com with SMTP id l20so4445706ioc.20
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 11:24:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GyOG4XA5FlPhLyTLbf58ICy4Vxq4ozvrlX7yh9oblAY=;
        b=Fc2SOS5CvHoF31rQ2iH7fbUG71jjqX0szAYByzIH3LlbfhbTcrvkilxF9uTEMqDLSH
         GI4zYAPMxFxUaJNWGXRntH29uJymGoddsVHqmRlRRDHygYss+FKRoRib8LD73XHDSRn2
         X3DCL8/CHvh38RBTK6HOqkhb6M+KEKp0umDTGKUyTOq1RQXNlmtKEkToLAMyu7WOVM4N
         N1bP4hOUuenGRh0CQtwyMCD3qZbbm6avQLpD8ey5sZowIQYO3jV8hsGrvsjh+/2J8POj
         51k55GYaWtrBdfKwTpM88iDBCwzJ30aWzmS9AMI9UgE5+2II7SEIsYHBqg4M8TvXjsrQ
         8WXQ==
X-Gm-Message-State: AOAM532CfFZgX7HrzlZXgTfITNBVo2HbAOGLDeytH0UddyHlshg6mN75
        zZmxICM+95m+8VTLxHM8VZ93pj2eZDqTXnYZmqNb1UIv8wZe
X-Google-Smtp-Source: ABdhPJwUJ3iWBy970TpS/a/xCqT1Sv0iPqDvMmOTiB8cCrbt7fiGDb+EYJE4FZBl3zG78UnV0O0GBY3G2juTQGxYJ61aoIDXnYJp
MIME-Version: 1.0
X-Received: by 2002:a02:ac18:: with SMTP id a24mr12196966jao.24.1608492253174;
 Sun, 20 Dec 2020 11:24:13 -0800 (PST)
Date:   Sun, 20 Dec 2020 11:24:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005fe14605b6ea4958@google.com>
Subject: WARNING in isotp_tx_timer_handler
From:   syzbot <syzbot+78bab6958a614b0c80b9@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5e60366d Merge tag 'fallthrough-fixes-clang-5.11-rc1' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=179a2287500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=db720fe37a6a41d8
dashboard link: https://syzkaller.appspot.com/bug?extid=78bab6958a614b0c80b9
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10ea3e0f500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78bab6958a614b0c80b9@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 9908 at net/can/isotp.c:835 isotp_tx_timer_handler+0x65f/0xba0 net/can/isotp.c:835
Modules linked in:
CPU: 0 PID: 9908 Comm: systemd-udevd Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:isotp_tx_timer_handler+0x65f/0xba0 net/can/isotp.c:835
Code: c1 e8 03 83 e1 07 0f b6 04 28 38 c8 7f 08 84 c0 0f 85 b8 04 00 00 41 88 54 24 05 e9 07 fb ff ff 40 84 ed 75 21 e8 21 11 80 f9 <0f> 0b 45 31 e4 e8 17 11 80 f9 44 89 e0 48 83 c4 48 5b 5d 41 5c 41
RSP: 0018:ffffc90000007dc8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88803e4e8518 RCX: 0000000000000100
RDX: ffff8880117d5040 RSI: ffffffff87f2102f RDI: 0000000000000003
RBP: 0000000000000000 R08: ffffffff8a7b6540 R09: ffffffff87f20a2e
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880b9c26c80 R14: ffff8880b9c26a00 R15: ffff88803e4e8000
FS:  00007fc247dbb8c0(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcab7e7800 CR3: 000000001c8c6000 CR4: 00000000001506f0
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
RIP: 0010:call_rcu+0x2e7/0x710 kernel/rcu/tree.c:3039
Code: 3c 02 00 0f 85 bb 03 00 00 48 8b 05 63 75 1a 0a 49 03 84 24 f0 00 00 00 49 39 c7 0f 8f 72 01 00 00 e8 5d e4 18 00 ff 34 24 9d <48> 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 80 3c 02 00 0f 84 2f
RSP: 0018:ffffc9000adafb88 EFLAGS: 00000246
RAX: 00000000000010e9 RBX: ffff8880143c1780 RCX: ffffffff815740d7
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8880b9c35b70 R08: 0000000000000001 R09: ffffffff8f4f983f
R10: fffffbfff1e9f307 R11: 0000000000000000 R12: ffff8880b9c35a80
R13: ffff8880b9c35b60 R14: ffff8880b9c35b18 R15: 000000000000002c
 security_inode_free+0x9a/0xc0 security/security.c:1005
 __destroy_inode+0x24d/0x740 fs/inode.c:259
 destroy_inode+0x91/0x1b0 fs/inode.c:282
 iput_final fs/inode.c:1654 [inline]
 iput.part.0+0x41e/0x840 fs/inode.c:1680
 iput+0x58/0x70 fs/inode.c:1670
 dentry_unlink_inode+0x2b1/0x3d0 fs/dcache.c:374
 __dentry_kill+0x3c0/0x640 fs/dcache.c:579
 dentry_kill fs/dcache.c:717 [inline]
 dput+0x696/0xc10 fs/dcache.c:878
 do_renameat2+0xae7/0xbf0 fs/namei.c:4461
 __do_sys_rename fs/namei.c:4503 [inline]
 __se_sys_rename fs/namei.c:4501 [inline]
 __x64_sys_rename+0x5d/0x80 fs/namei.c:4501
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fc246bb7d47
Code: 75 12 48 89 df e8 19 84 07 00 85 c0 0f 95 c0 0f b6 c0 f7 d8 5b c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 b8 52 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 21 41 33 00 f7 d8 64 89 01 48
RSP: 002b:00007ffcab6e3c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 00005556c8f7a380 RCX: 00007fc246bb7d47
RDX: 0000000000000000 RSI: 00007ffcab6e3c70 RDI: 00005556c8f823b0
RBP: 00007ffcab6e3d30 R08: 00005556c8f812c0 R09: 00005556c8f811e0
R10: 00007fc247dbb8c0 R11: 0000000000000246 R12: 00007ffcab6e3c70
R13: 0000000000000001 R14: 00005556c71306cb R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
