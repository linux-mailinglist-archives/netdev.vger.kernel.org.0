Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4D7914D86D
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 10:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgA3JyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 04:54:16 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:44890 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgA3JyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 04:54:16 -0500
Received: by mail-il1-f200.google.com with SMTP id h87so2195561ild.11
        for <netdev@vger.kernel.org>; Thu, 30 Jan 2020 01:54:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=9hAzEAIPae/MS5XBWrAm6eWP2RI7+2OSiqzmgbR9qTw=;
        b=df9F9v57n047L2eEf67/6SsWxJCM1MLEORIMpWNFw7SoCV4o+rTCM/g6FoqZ8HXGkQ
         AD2zLBBG6UD1w5uKaPYmXz9FFnM4tk5l6sP6rAn+ahkwGxpwqnCdy4AjIXFRvkW/87RM
         3oh7MyikOfiEY+/pVJcpnzoE2A7jSMzboAMY1eddhrEqE2UG3GIi87RGsO2ZwC38axJ+
         nsDeDtxnKh6R+AF5vxnQIkDFNPjfUh1pQQsNxxzmVUxME1tVzuI29eSdHPbhwmFktAZD
         SjhdjT78yoqpDSwxHvuMtE5Nj5gYRjC8ikgErKTZQk4rLMdq/rZqIAT4PWeqv18MSEr7
         2z7A==
X-Gm-Message-State: APjAAAXezpOsPaoN6bWh4VG3uQJwEvYxIXOF6tpkx1m+OdARoBmlpnff
        55CJ7LJMW3fY2IMKTJI11bRIZLGa6wgemEelioZ9WRHx1Pdt
X-Google-Smtp-Source: APXvYqyR/5l8VfWndFqVVJTxabbsWjeWfENhMAfCpTTMDHa3eKLcpO/4QKWSk3yOAWWOEHMqZFLMuJYy+Shr5HEJrMPxPhf0f36S
MIME-Version: 1.0
X-Received: by 2002:a02:5489:: with SMTP id t131mr3089108jaa.40.1580378055222;
 Thu, 30 Jan 2020 01:54:15 -0800 (PST)
Date:   Thu, 30 Jan 2020 01:54:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000097a900059d58700d@google.com>
Subject: WARNING in nsim_fib6_rt_nh_del
From:   syzbot <syzbot+63abe9d5f32ff88090eb@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b3a60822 Merge branch 'for-v5.6' of git://git.kernel.org:/..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12461f66e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=614e56d86457f3a7
dashboard link: https://syzkaller.appspot.com/bug?extid=63abe9d5f32ff88090eb
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+63abe9d5f32ff88090eb@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 24083 at drivers/net/netdevsim/fib.c:448 nsim_fib6_rt_nh_del+0x287/0x350 drivers/net/netdevsim/fib.c:448
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 24083 Comm: syz-executor.5 Not tainted 5.5.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:176 [inline]
 fixup_bug arch/x86/kernel/traps.c:171 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:269
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:288
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:nsim_fib6_rt_nh_del+0x287/0x350 drivers/net/netdevsim/fib.c:448
Code: 85 db 74 2a e8 ca 00 77 fc 4c 89 e7 e8 52 3a b5 fc e8 bd 00 77 fc 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 a9 00 77 fc <0f> 0b eb e3 e8 a0 00 77 fc be 03 00 00 00 4c 89 f7 e8 33 11 9f fe
RSP: 0018:ffffc90004c462b8 EFLAGS: 00010246
RAX: 0000000000040000 RBX: dffffc0000000000 RCX: ffffc90014a0f000
RDX: 0000000000040000 RSI: ffffffff84fe6cf7 RDI: ffff88809f945480
RBP: ffffc90004c462e8 R08: ffff8880a79660c0 R09: ffff8880a7966950
R10: ffffc90004c462f8 R11: ffffffff8a82e707 R12: ffff88809f9454b8
R13: ffff88809575a600 R14: ffff88809f9454b8 R15: ffff88809ed44710
 nsim_fib6_rt_remove drivers/net/netdevsim/fib.c:688 [inline]
 nsim_fib6_event drivers/net/netdevsim/fib.c:725 [inline]
 nsim_fib_event drivers/net/netdevsim/fib.c:744 [inline]
 nsim_fib_event_nb+0x1582/0x2670 drivers/net/netdevsim/fib.c:772
 notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
 __atomic_notifier_call_chain+0xa6/0x1a0 kernel/notifier.c:173
 atomic_notifier_call_chain+0x2e/0x40 kernel/notifier.c:183
 call_fib_notifiers+0x173/0x2a0 net/core/fib_notifier.c:35
 call_fib6_notifiers+0x4b/0x60 net/ipv6/fib6_notifier.c:22
 call_fib6_entry_notifiers+0xfb/0x150 net/ipv6/ip6_fib.c:399
 fib6_del_route net/ipv6/ip6_fib.c:1980 [inline]
 fib6_del+0xec1/0x1550 net/ipv6/ip6_fib.c:2016
 fib6_clean_node+0x3c4/0x5b0 net/ipv6/ip6_fib.c:2178
 fib6_walk_continue+0x4a9/0x8e0 net/ipv6/ip6_fib.c:2100
 fib6_walk+0x9d/0x100 net/ipv6/ip6_fib.c:2148
 fib6_clean_tree+0xea/0x120 net/ipv6/ip6_fib.c:2228
 __fib6_clean_all+0x118/0x2a0 net/ipv6/ip6_fib.c:2244
 fib6_clean_all+0x2b/0x40 net/ipv6/ip6_fib.c:2255
 rt6_sync_down_dev+0x134/0x150 net/ipv6/route.c:4755
 rt6_disable_ip+0x27/0x460 net/ipv6/route.c:4760
 addrconf_ifdown+0x9b/0x12c0 net/ipv6/addrconf.c:3708
 addrconf_notify+0x5a6/0x2270 net/ipv6/addrconf.c:3633
 notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
 __raw_notifier_call_chain kernel/notifier.c:361 [inline]
 raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
 call_netdevice_notifiers_info net/core/dev.c:1943 [inline]
 call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1928
 call_netdevice_notifiers_extack net/core/dev.c:1955 [inline]
 call_netdevice_notifiers net/core/dev.c:1969 [inline]
 __dev_notify_flags+0x1e9/0x2c0 net/core/dev.c:8193
 dev_change_flags+0x10d/0x170 net/core/dev.c:8229
 do_setlink+0xa47/0x3720 net/core/rtnetlink.c:2596
 rtnl_group_changelink net/core/rtnetlink.c:3103 [inline]
 __rtnl_newlink+0xdd1/0x1790 net/core/rtnetlink.c:3257
 rtnl_newlink+0x69/0xa0 net/core/rtnetlink.c:3377
 rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5438
 netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
 rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5456
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45b349
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fbf97294c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fbf972956d4 RCX: 000000000045b349
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000009c7 R14: 00000000004cb327 R15: 000000000075bf2c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
