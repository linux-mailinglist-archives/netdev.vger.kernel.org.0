Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D141C159458
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 17:06:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbgBKQGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 11:06:11 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:40208 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729908AbgBKQGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 11:06:11 -0500
Received: by mail-il1-f199.google.com with SMTP id m18so9897345ill.7
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 08:06:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Jdoz05JAAw+9K6HAuWNyOVTPMvhxyYRmEKIP8cTLjUA=;
        b=jtGbqlHCWDFTHQWJ2oGM3i6drq0Kx11Su67yqPcqHo8zoZlRL49LCpjpg/97HqHubt
         tr18a+JpOTmfUOGxnICFE1KutqxDNVyS8xzyc3B0EaMFmIxBjApts5vO7ZEHqWAjwHGD
         IPR768gbg2JGUgITFSYeFR3AQt7aYTKqDN5W2d2T8xqzadNxNCCYM1kQe72uzSUrEMKr
         jWR/iz7gdXZUyVKQ7Boo4t4D7YVw+2X3HQH9Dniqhp4dZ/eBsAWkeIomKS9GOJhq87lZ
         RG5XBIsAoLvmUc0GGk00a3lvRkbZZlnBsbMLiiw2dlZS+u9u6ap4v1474dbFRZbyJOc3
         D9nw==
X-Gm-Message-State: APjAAAVHlNdug5z36D1elWv0JdcoaOuMsWmDgCAUI7ny0Cpbi3p0GZcb
        99Sfb7ofUXA8UoK1GCPXErriKy04TaxAhwZEp6reGrXJdNQe
X-Google-Smtp-Source: APXvYqynHf3OEs4Q7nFiEkAHlhoE3vw/BAvA5frqHvj6nn+PEKRsD7ZEggL5lc2dfMXJ9M0izXdgr3AaxDjhk4SZAOJOBt9p3tCz
MIME-Version: 1.0
X-Received: by 2002:a02:cd0d:: with SMTP id g13mr15627399jaq.110.1581437170301;
 Tue, 11 Feb 2020 08:06:10 -0800 (PST)
Date:   Tue, 11 Feb 2020 08:06:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c54420059e4f08ff@google.com>
Subject: WARNING in dev_change_net_namespace
From:   syzbot <syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@gmail.com,
        hawk@kernel.org, jiri@mellanox.com, johannes.berg@intel.com,
        john.fastabend@gmail.com, kafai@fb.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mkubecek@suse.cz,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0a679e13 Merge branch 'for-5.6-fixes' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15142701e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6780df5a5f208964
dashboard link: https://syzkaller.appspot.com/bug?extid=830c6dbfc71edc4f0b8f
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com

RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000007
R13: 00000000000009cb R14: 00000000004cb3dd R15: 0000000000000016
------------[ cut here ]------------
WARNING: CPU: 0 PID: 24839 at net/core/dev.c:10108 dev_change_net_namespace+0x155f/0x16b0 net/core/dev.c:10108
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 24839 Comm: syz-executor.4 Not tainted 5.6.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 panic+0x264/0x7a9 kernel/panic.c:221
 __warn+0x209/0x210 kernel/panic.c:582
 report_bug+0x1b6/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 do_error_trap+0xcf/0x1c0 arch/x86/kernel/traps.c:267
 do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:dev_change_net_namespace+0x155f/0x16b0 net/core/dev.c:10108
Code: b7 f9 02 01 48 c7 c7 5d 66 e6 88 48 c7 c6 b4 42 04 89 ba 25 27 00 00 31 c0 e8 6d a6 dc fa 0f 0b e9 0d eb ff ff e8 a1 e6 0a fb <0f> 0b e9 2f fe ff ff e8 95 e6 0a fb c6 05 05 b7 f9 02 01 48 c7 c7
RSP: 0018:ffffc90001ae7140 EFLAGS: 00010246
RAX: ffffffff866c18df RBX: 00000000fffffff4 RCX: 0000000000040000
RDX: ffffc90012028000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: ffffc90001ae7240 R08: ffffffff866c1700 R09: fffffbfff1406318
R10: fffffbfff1406318 R11: 0000000000000000 R12: ffff8880918d2b60
R13: ffff8880918d20b8 R14: ffffc90001ae71e8 R15: ffffc90001ae71e0
 do_setlink+0x196/0x3880 net/core/rtnetlink.c:2501
 __rtnl_newlink net/core/rtnetlink.c:3252 [inline]
 rtnl_newlink+0x1509/0x1c00 net/core/rtnetlink.c:3377
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5438
 netlink_rcv_skb+0x19e/0x3e0 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1c/0x20 net/core/rtnetlink.c:5456
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
RIP: 0033:0x45b3b9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f483611ac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f483611b6d4 RCX: 000000000045b3b9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000007
R13: 00000000000009cb R14: 00000000004cb3dd R15: 0000000000000016
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
