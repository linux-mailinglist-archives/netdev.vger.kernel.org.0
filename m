Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1431922DC87
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 09:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgGZHLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 03:11:17 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:40886 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgGZHLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 03:11:17 -0400
Received: by mail-io1-f71.google.com with SMTP id f25so9223844ioh.7
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 00:11:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xtU03ziR/C9DlJTxyNgvjYJApoaZs/RVr9nkAXL+JKo=;
        b=qEtPWo1cQYqSZA4Ay3bpU//J8IMiF0AQG6GzOOypkhTXqnIZ42Jh2FdO5Y6XhGKWgh
         Ae4XLqjbvBbC00Z5ROEWSb0BvO4Ez1X0dMl4QwlNCAMiUeDE7nhSDqffUqRtvh6Lg+RA
         nYZEuZUXZlS1726mw/soogGRedXnBsRAtZDywDR+jwB0ebsZyHtJeKmoTqD2lUOMFPyj
         rjmPmGwiwVUPB/IqSIwuHMYIc+UUupd1grFwiEqF75cTqR3ZLnOPNyLXYEqEuyqkIdk8
         FbW/dXU2jRo0aoeZWzX6Pub+KdGqY35olRaz4jF8JXwwNvlRkxluRSJSwiZOJ7WrOE5H
         yUNA==
X-Gm-Message-State: AOAM531g86ybQVaI/FTJWGHhxtSuCUnQLGxJEFA7KkkxdYV5vRL/DtgU
        S+CGqP4MVaiugqM53QDna8Tv0Gw0AJCt4yoWXpVrH2HDS/oc
X-Google-Smtp-Source: ABdhPJwz0R3E1qanhG+RXAe2jt6zaQDwLfY3WpxZgmZQD/YOe6n3eXDKwbwFvdEM8Ek1OYBgXMVFj4XTobD/kXQgo0lQWApvFGOm
MIME-Version: 1.0
X-Received: by 2002:a5d:9d11:: with SMTP id j17mr8115835ioj.140.1595747476117;
 Sun, 26 Jul 2020 00:11:16 -0700 (PDT)
Date:   Sun, 26 Jul 2020 00:11:16 -0700
In-Reply-To: <000000000000debe1c05a9c39c93@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000771e6805ab52e911@google.com>
Subject: Re: WARNING in ipvlan_l3s_unregister
From:   syzbot <syzbot+bb3d7a24f705078b1286@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    23ee3e4e Merge tag 'pci-v5.8-fixes-2' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17a1e4c4900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f3bc31881f1ae8a7
dashboard link: https://syzkaller.appspot.com/bug?extid=bb3d7a24f705078b1286
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=151a0317100000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bb3d7a24f705078b1286@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 7576 at drivers/net/ipvlan/ipvlan_l3s.c:148 ipvlan_unregister_nf_hook drivers/net/ipvlan/ipvlan_l3s.c:148 [inline]
WARNING: CPU: 0 PID: 7576 at drivers/net/ipvlan/ipvlan_l3s.c:148 ipvlan_l3s_unregister+0x145/0x1d0 drivers/net/ipvlan/ipvlan_l3s.c:221
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 7576 Comm: syz-executor.0 Not tainted 5.8.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:540
RIP: 0010:ipvlan_unregister_nf_hook drivers/net/ipvlan/ipvlan_l3s.c:148 [inline]
RIP: 0010:ipvlan_l3s_unregister+0x145/0x1d0 drivers/net/ipvlan/ipvlan_l3s.c:221
Code: 48 c1 e8 03 42 80 3c 20 00 74 08 4c 89 f7 e8 12 59 dc fc 49 c7 06 00 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 0b 4a 9d fc <0f> 0b eb c8 e8 02 4a 9d fc c6 05 4b e5 b1 04 01 48 c7 c7 ec f3 09
RSP: 0018:ffffc9000268f308 EFLAGS: 00010293
RAX: ffffffff84d747f5 RBX: 1ffff110137b3c38 RCX: ffff8880a7732400
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff84d7477e R09: fffffbfff131a7ee
R10: fffffbfff131a7ee R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88809bd9e1c0 R14: ffff8880914ae000 R15: ffff888097498040
 ipvlan_set_port_mode+0x33e/0x420 drivers/net/ipvlan/ipvlan_main.c:37
 ipvlan_link_new+0x733/0xab0 drivers/net/ipvlan/ipvlan_main.c:611
 __rtnl_newlink net/core/rtnetlink.c:3339 [inline]
 rtnl_newlink+0x143e/0x1bf0 net/core/rtnetlink.c:3397
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
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45c369
Code: Bad RIP value.
RSP: 002b:00007fff12787788 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002b740 RCX: 000000000045c369
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000005
RBP: 000000000078bf40 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000790730
R13: 0000000000000000 R14: 0000000000000add R15: 000000000078bf0c
Kernel Offset: disabled
Rebooting in 86400 seconds..

