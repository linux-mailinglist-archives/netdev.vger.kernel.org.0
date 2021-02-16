Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8D031CE86
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 17:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhBPQ6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 11:58:06 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:45914 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbhBPQ6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 11:58:03 -0500
Received: by mail-il1-f198.google.com with SMTP id h17so8288609ila.12
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 08:57:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/cY0qWscmzESNuhdF1KDTC8gVtW3bzbaKQCi1T8YxiE=;
        b=kLYyDT6HMOyixah8rBgYQpSL14u2BYstSVRi117+egysNttnr2Kuv73Z9F68d8LIXL
         30MIPIm8OI2lVBfGb5eKy6DSWihFTSHePvhXeUbvbfdDNdInaOKBK87RaU8AVwNxahH8
         3B7S48vigq8Rj8V+wvdQFWTFlYAAsMhEys3eC2ZQvs70r6c9HoZ+yV6YB6PEnFGytc0E
         yaeqSKpV1X+W4taMmSHGsm4jJZxPoKQYeJepR0FZ/UPWOfTe9NLIQbBllb0y/uejnYSu
         tvblXiaJTnP78Yl1nVnPqcoar7EHEX2j67n++HsSkLt5OsPyu+Vo8YZfG5GlpLKVm6bT
         /N6g==
X-Gm-Message-State: AOAM530qh0ebO0TMleJepCv6OPcJLEdu8SaDDmtNzzWPWR9MTWv/brvZ
        jWTn52LcvyL62zdhbbZKh8DBRd5zHPg2wfkgUxjk7uMmBn4V
X-Google-Smtp-Source: ABdhPJzVTRmtZPUVzWLUItwE7NUJUjtZvh/9j8Cg4DCcncGFgQjhzznRK6YhG23Vh0Bde7xjufuC7Qj9f7PlxYKBbCF0Xk35rhc7
MIME-Version: 1.0
X-Received: by 2002:a05:6602:26c6:: with SMTP id g6mr17487095ioo.150.1613494642690;
 Tue, 16 Feb 2021 08:57:22 -0800 (PST)
Date:   Tue, 16 Feb 2021 08:57:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000064f0f05bb76ff3b@google.com>
Subject: WARNING in slave_kobj_release
From:   syzbot <syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, j.vosburgh@gmail.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f40ddce8 Linux 5.11
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15e8b204d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b919ebed7b4902
dashboard link: https://syzkaller.appspot.com/bug?extid=bfda097c12a00c8cae67
compiler:       Debian clang version 11.0.1-2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=111279f4d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15861a4cd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com

R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd2f280090
R13: 00007ffd2f2800b0 R14: 00007ffd2f280088 R15: 0000000000000000
kobject_add_internal failed for bonding_slave (error: -12 parent: ipvlan1)
------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 0 PID: 8425 at lib/debugobjects.c:508 debug_print_object lib/debugobjects.c:505 [inline]
WARNING: CPU: 0 PID: 8425 at lib/debugobjects.c:508 debug_object_assert_init+0x1fa/0x250 lib/debugobjects.c:890
Modules linked in:
CPU: 0 PID: 8425 Comm: syz-executor866 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object lib/debugobjects.c:505 [inline]
RIP: 0010:debug_object_assert_init+0x1fa/0x250 lib/debugobjects.c:890
Code: e8 3b 17 ee fd 4c 8b 45 00 48 c7 c7 40 dc 0d 8a 48 c7 c6 a0 d8 0d 8a 48 c7 c2 80 de 0d 8a 31 c9 49 89 d9 31 c0 e8 66 17 7a fd <0f> 0b ff 05 5a 89 e6 09 48 83 c5 38 48 89 e8 48 c1 e8 03 42 80 3c
RSP: 0018:ffffc90001afeda8 EFLAGS: 00010046
RAX: 2bba7eb7734aa500 RBX: 0000000000000000 RCX: ffff888020a30000
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffffff89b0ac20 R08: ffffffff815fb522 R09: ffffed1017384004
R10: ffffed1017384004 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888024ccb940 R14: 0000000000000000 R15: ffffffff9020efa8
FS:  00000000019db300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb44efdf000 CR3: 00000000120f2000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 debug_timer_assert_init kernel/time/timer.c:737 [inline]
 debug_assert_init kernel/time/timer.c:782 [inline]
 del_timer+0x3d/0x310 kernel/time/timer.c:1202
 try_to_grab_pending+0xbd/0x9e0 kernel/workqueue.c:1252
 __cancel_work_timer+0x84/0x540 kernel/workqueue.c:3098
 slave_kobj_release+0x50/0xd0 drivers/net/bonding/bond_main.c:1467
 kobject_cleanup+0x1c9/0x280 lib/kobject.c:705
 bond_kobj_init drivers/net/bonding/bond_main.c:1488 [inline]
 bond_alloc_slave drivers/net/bonding/bond_main.c:1505 [inline]
 bond_enslave+0x630/0x57e0 drivers/net/bonding/bond_main.c:1707
 do_set_master net/core/rtnetlink.c:2519 [inline]
 do_setlink+0xcf6/0x3d00 net/core/rtnetlink.c:2715
 __rtnl_newlink net/core/rtnetlink.c:3376 [inline]
 rtnl_newlink+0x146b/0x1b00 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x887/0xd60 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2494
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x9ae/0xd50 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2345
 ___sys_sendmsg net/socket.c:2399 [inline]
 __sys_sendmsg+0x2bf/0x370 net/socket.c:2432
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4498e9
Code: 4f 01 00 85 c0 b8 00 00 00 00 48 0f 44 c3 5b c3 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd2f280058 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00000000004498e9
RDX: 0000000000000000 RSI: 00000000200001c0 RDI: 0000000000000004
RBP: 0000000000000004 R08: 0000000000000001 R09: 000000000000000a
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd2f280090
R13: 00007ffd2f2800b0 R14: 00007ffd2f280088 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
