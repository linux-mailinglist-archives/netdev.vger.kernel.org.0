Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94733144580
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 20:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgAUT5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 14:57:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:39340 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgAUT5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 14:57:10 -0500
Received: by mail-il1-f200.google.com with SMTP id n6so3019625ile.6
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 11:57:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=KQswfdJ8qWP/W78kO0F+IdNg1RIeejY3FJ22igrRgOw=;
        b=WzhaEvKYYwegmdv6fNL7YpZ4iMRLAbdKMqoKtYn/FTGsz76Wfdd2tW1XGKWxcJqN5V
         krOVcVFQw+yE7IOwH5fCbkRvhT/ZYlmqpzHywHpX2Z4Tzfy3ZGjkNJy3xl5+OUk6dzbl
         rPGtHlWzogtK6ObmNNKVSeXwzn4n11R8F+IjfQcMPa/lBCacchkmFKJn1xDils9aWgio
         DwNGgFGRY7gcEJMVCBnKP86RoibsabGZrQgjfaemVXa5o08h1hzGRvlEJLELMjzCP51V
         mL53o8mCGvvbxuq/tdLARMC1jvhtSWuassWLT5jYXCilh7op4cSWF8BdYw6mieHUHNlK
         1Cww==
X-Gm-Message-State: APjAAAXJ8quidtjgPSGMCEO3RPnKdh4Oq+P9jqgv5FKo499OKFoMxKRc
        pW3Vs1VvuLkkXwagL2iL97aRYFwhn7FSzWgwRiHaC801bkwN
X-Google-Smtp-Source: APXvYqzqjrsg7lfw2H965bFJUSZ4wkaWgkAajRH78XhQZNJEBtDG+UvM6GPHE0gzVEF+CCVjRY0F+Tup+A8xaBhFbY8u/3mO0Oo8
MIME-Version: 1.0
X-Received: by 2002:a92:8991:: with SMTP id w17mr4667636ilk.12.1579636629766;
 Tue, 21 Jan 2020 11:57:09 -0800 (PST)
Date:   Tue, 21 Jan 2020 11:57:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000310afa059cabd024@google.com>
Subject: WARNING in cbq_destroy_class
From:   syzbot <syzbot+0a0596220218fcb603a8@syzkaller.appspotmail.com>
To:     davem@davemloft.net, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    80892772 hsr: Fix a compilation error
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=172efc6ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=0a0596220218fcb603a8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f107d1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12114335e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0a0596220218fcb603a8@syzkaller.appspotmail.com

netlink: 96 bytes leftover after parsing attributes in process `syz-executor414'.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 9624 at net/sched/sch_cbq.c:1437 cbq_destroy_class+0x11a/0x150 net/sched/sch_cbq.c:1437
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9624 Comm: syz-executor414 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
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
RIP: 0010:cbq_destroy_class+0x11a/0x150 net/sched/sch_cbq.c:1437
Code: 00 00 e8 d9 57 da ff 49 39 dc 74 0d e8 9f 98 30 fb 4c 89 e7 e8 67 09 6e fb e8 92 98 30 fb 5b 41 5c 41 5d 5d c3 e8 86 98 30 fb <0f> 0b e9 37 ff ff ff e8 9a 58 6e fb e9 12 ff ff ff e8 b0 58 6e fb
RSP: 0018:ffffc90001ab70e0 EFLAGS: 00010293
RAX: ffff8880a6c1a4c0 RBX: ffff888095886000 RCX: ffffffff86445bcf
RDX: 0000000000000000 RSI: ffffffff86445c9a RDI: 0000000000000005
RBP: ffffc90001ab70f8 R08: ffff8880a6c1a4c0 R09: fffffbfff165e7a0
R10: fffffbfff165e79f R11: ffffffff8b2f3cff R12: ffff888095886320
R13: 0000000000000001 R14: 0000000000000000 R15: ffff888095886320
 cbq_destroy net/sched/sch_cbq.c:1471 [inline]
 cbq_destroy+0x208/0x2c0 net/sched/sch_cbq.c:1447
 qdisc_destroy+0x11f/0x630 net/sched/sch_generic.c:958
 qdisc_put+0xdb/0x100 net/sched/sch_generic.c:985
 notify_and_destroy+0xa2/0xb0 net/sched/sch_api.c:995
 qdisc_graft+0xd42/0x1210 net/sched/sch_api.c:1076
 tc_modify_qdisc+0xcbd/0x1cd0 net/sched/sch_api.c:1663
 rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5424
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5442
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:639 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:659
 kernel_sendmsg+0x44/0x50 net/socket.c:679
 sock_no_sendpage+0x116/0x150 net/core/sock.c:2740
 kernel_sendpage+0x92/0xf0 net/socket.c:3776
 sock_sendpage+0x8b/0xc0 net/socket.c:937
 pipe_to_sendpage+0x2da/0x3c0 fs/splice.c:458
 splice_from_pipe_feed fs/splice.c:512 [inline]
 __splice_from_pipe+0x3ee/0x7c0 fs/splice.c:636
 splice_from_pipe+0x108/0x170 fs/splice.c:671
 generic_splice_sendpage+0x3c/0x50 fs/splice.c:844
 do_splice_from fs/splice.c:863 [inline]
 do_splice+0xba4/0x1680 fs/splice.c:1170
 __do_sys_splice fs/splice.c:1447 [inline]
 __se_sys_splice fs/splice.c:1427 [inline]
 __x64_sys_splice+0x2c6/0x330 fs/splice.c:1427
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x446e79
Code: e8 5c b3 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 0b 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f3ef76eed88 EFLAGS: 00000246 ORIG_RAX: 0000000000000113
RAX: ffffffffffffffda RBX: 00000000006dcc98 RCX: 0000000000446e79
RDX: 0000000000000009 RSI: 0000000000000000 RDI: 0000000000000007
RBP: 00000000006dcc90 R08: 000000000004ffe0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dcc9c
R13: 00000000004aed8e R14: 54c6c2ff093a6d32 R15: 0000000000010000
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
