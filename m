Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493282155D2
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 12:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgGFKsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 06:48:20 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:43399 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728264AbgGFKsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 06:48:20 -0400
Received: by mail-io1-f69.google.com with SMTP id f13so20430478iok.10
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 03:48:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ZSkvF6FpHO5ed0FFo5QShyZ2DWco4e/MYymtN3KmtXg=;
        b=sI6mGYsPeDj4CABb5xsmRsj5rZ89EkXdH9DIFaCWM9Tfn5dWmYnDL3rf8iUmr61hho
         MKJyBlMecp07pEeB2vHolK7o4bmMEgvNLyIHkRIJEl185R3mWCvHx15Ql0fexBdBv/v7
         qRfBFzUfy2fx6i4RWYYoDdOs9zs370OxVut9rK0/EfJHEhoIj56I3lWw0rCJb54iTQLp
         Hxz0I9U39dOX/38l4v3fzcoHkfiSRaXItKIaIo8jbXgfGi82iHWW26IHgbNNthu1cjFL
         c5MSOe969hrkkfi7D5uMFmKJ6OlSYbe9mGbtgSkFykFZD4s0g4w5n2zndVFNQNHStAra
         HRZw==
X-Gm-Message-State: AOAM5324FMYlJ0vVxRNFJWR5teoTDQUFOLCeFJ1SLv4+RIT2/wAGO3AB
        jg6EOZyB9q1lz7civI0itQ7m5+4nhE6loi7OXD5O3WHkh+3T
X-Google-Smtp-Source: ABdhPJx2JPkeJrBN4d8dtIgR2239fFzLl4X8Mk2EOjJMfbB9/oYjSs+R2SPYnhjp1Uy66oTAKpPu3fJ8Q3/W+lAXIB7GrGzwAEJO
MIME-Version: 1.0
X-Received: by 2002:a92:2ca:: with SMTP id 193mr30378243ilc.299.1594032499112;
 Mon, 06 Jul 2020 03:48:19 -0700 (PDT)
Date:   Mon, 06 Jul 2020 03:48:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000debe1c05a9c39c93@google.com>
Subject: WARNING in ipvlan_l3s_unregister
From:   syzbot <syzbot+bb3d7a24f705078b1286@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7cc2a8ea Merge tag 'block-5.8-2020-07-01' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1744dc83100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=183dd243398ba7ec
dashboard link: https://syzkaller.appspot.com/bug?extid=bb3d7a24f705078b1286
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bb3d7a24f705078b1286@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 17717 at drivers/net/ipvlan/ipvlan_l3s.c:148 ipvlan_unregister_nf_hook drivers/net/ipvlan/ipvlan_l3s.c:148 [inline]
WARNING: CPU: 0 PID: 17717 at drivers/net/ipvlan/ipvlan_l3s.c:148 ipvlan_l3s_unregister+0x145/0x1d0 drivers/net/ipvlan/ipvlan_l3s.c:221
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 17717 Comm: syz-executor.3 Not tainted 5.8.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:563
RIP: 0010:ipvlan_unregister_nf_hook drivers/net/ipvlan/ipvlan_l3s.c:148 [inline]
RIP: 0010:ipvlan_l3s_unregister+0x145/0x1d0 drivers/net/ipvlan/ipvlan_l3s.c:221
Code: 48 c1 e8 03 42 80 3c 20 00 74 08 4c 89 f7 e8 92 94 dc fc 49 c7 06 00 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 0b 95 9d fc <0f> 0b eb c8 e8 02 95 9d fc c6 05 79 32 92 04 01 48 c7 c7 6c c6 e9
RSP: 0018:ffffc90019d57330 EFLAGS: 00010287
RAX: ffffffff84d6e705 RBX: 1ffff11013b08b98 RCX: 0000000000040000
RDX: ffffc9000f539000 RSI: 00000000000006d7 RDI: 00000000000006d8
RBP: 0000000000000000 R08: ffffffff84d6e68e R09: fffffbfff12da576
R10: fffffbfff12da576 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88809d845cc0 R14: ffff88804bd08000 R15: ffff888055fd6100
 ipvlan_set_port_mode+0x33e/0x420 drivers/net/ipvlan/ipvlan_main.c:37
 ipvlan_nl_changelink+0x18a/0x340 drivers/net/ipvlan/ipvlan_main.c:435
 __rtnl_newlink net/core/rtnetlink.c:3255 [inline]
 rtnl_newlink+0x15e3/0x1bf0 net/core/rtnetlink.c:3397
 rtnetlink_rcv_msg+0x889/0xd40 net/core/rtnetlink.c:5460
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cb29
Code: Bad RIP value.
RSP: 002b:00007f7160e6cc78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000502760 RCX: 000000000045cb29
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000a43 R14: 00000000004cd2a1 R15: 00007f7160e6d6d4
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
