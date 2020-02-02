Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7AD214FCF4
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 12:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgBBLvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 06:51:15 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:45577 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgBBLvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 06:51:15 -0500
Received: by mail-io1-f69.google.com with SMTP id t12so7440748iog.12
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 03:51:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gDDCrfJjdDDWz7lybOsk1SBJ7NDoCvpPI4Iv7Ym26Q0=;
        b=Ms+7f/YJtROIWNOQ9roTkCWjTmjXvad7pCLMPqpNl16Mf0VfvvyJLjeCS24bBhyNG1
         O3R7aq3eum3PJFaq8DC5fZDf8Scx7ZmczimP5QXF1x0rMcPSkDwD/mCUT1hwI3tskCXD
         ifQPXNAZ/crScJqWFhmyZnW1/v3d/jTzFkrZas4jVyzfjmEqr/K32OzluwQJknzhHHY0
         Pu5ijEpb1eM666EQ873KISA3NV8GYLEYdCIDTQ4tizRp8i2IFyzZJl0D+ETW338i0Dj5
         JeDmVMc99H0jx1lHNFbwH1T7jvtB+KF8OTraxMBQuNgkH/ebW7/43R9N4RiPMhL+7d8k
         ku+g==
X-Gm-Message-State: APjAAAUexvsmXoopcg7S5afRMFdpzs6mJef9BUC8DnBrIN3uHlq51kv0
        wA1Cf2/7rgfDUwhdE6nwScGG/jcJkoebSMj3c9KjiE4lMe0t
X-Google-Smtp-Source: APXvYqzvwDgZBZuuegEnMtws/mdG1zvPsn97DNuVVZnFS/i+Oz9CAIVTKP6SFs7/+cH/DrWu5GQ5v9ZxW5D6Z7hmQEwxjJLF4yom
MIME-Version: 1.0
X-Received: by 2002:a02:a795:: with SMTP id e21mr15049847jaj.1.1580644273174;
 Sun, 02 Feb 2020 03:51:13 -0800 (PST)
Date:   Sun, 02 Feb 2020 03:51:13 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006b3d44059d966ca1@google.com>
Subject: BUG: unable to handle kernel paging request in netlink_unicast
From:   syzbot <syzbot+da7f30a2f1a15a687839@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        penguin-kernel@I-love.SAKURA.ne.jp, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b3a60822 Merge branch 'for-v5.6' of git://git.kernel.org:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1477ae95e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5766bb49c0bc43b9
dashboard link: https://syzkaller.appspot.com/bug?extid=da7f30a2f1a15a687839
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+da7f30a2f1a15a687839@syzkaller.appspotmail.com

kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
BUG: unable to handle page fault for address: ffff88809d910a50
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0011) - permissions violation
PGD b001067 P4D b001067 PUD 21ffff067 PMD 800000009d8001e3 
Oops: 0011 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 12558 Comm: syz-executor.2 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:0xffff88809d910a50
Code: 00 00 00 00 00 00 00 00 00 00 86 7a 03 89 ff ff ff ff 00 60 43 aa 80 88 ff ff 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <50> f8 d1 04 00 c9 ff ff 70 55 a7 86 ff ff ff ff c0 81 e4 8c 80 88
RSP: 0018:ffffc90004d1f860 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff869eea30 RCX: dffffc0000000000
RDX: ffffc900024cb000 RSI: 0000000000005c7e RDI: 0000000000005c7f
RBP: ffffc90004d1fb20 R08: dffffc0000000000 R09: ffffed1014d22849
R10: ffffed1014d22849 R11: 0000000000000000 R12: 1ffff11013dabb07
R13: ffff88809ed5d83a R14: 000000000000006e R15: dffffc0000000000
FS:  00007f828b464700(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88809d910a50 CR3: 000000009c353000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x766/0x920 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0xa2b/0xd40 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2343
 ___sys_sendmsg net/socket.c:2397 [inline]
 __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2437
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45b349
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f828b463c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f828b4646d4 RCX: 000000000045b349
RDX: 0000000000000000 RSI: 0000000020003e00 RDI: 0000000000000004
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000940 R14: 00000000004ca9e5 R15: 000000000075bf2c
Modules linked in:
CR2: ffff88809d910a50
---[ end trace 71a7bd2ec42e29ac ]---
RIP: 0010:0xffff88809d910a50
Code: 00 00 00 00 00 00 00 00 00 00 86 7a 03 89 ff ff ff ff 00 60 43 aa 80 88 ff ff 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <50> f8 d1 04 00 c9 ff ff 70 55 a7 86 ff ff ff ff c0 81 e4 8c 80 88
RSP: 0018:ffffc90004d1f860 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff869eea30 RCX: dffffc0000000000
RDX: ffffc900024cb000 RSI: 0000000000005c7e RDI: 0000000000005c7f
RBP: ffffc90004d1fb20 R08: dffffc0000000000 R09: ffffed1014d22849
R10: ffffed1014d22849 R11: 0000000000000000 R12: 1ffff11013dabb07
R13: ffff88809ed5d83a R14: 000000000000006e R15: dffffc0000000000
FS:  00007f828b464700(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88809d910a50 CR3: 000000009c353000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
