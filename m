Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9C5436E2D
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 01:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhJUXVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 19:21:41 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:34727 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbhJUXVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 19:21:40 -0400
Received: by mail-io1-f72.google.com with SMTP id k20-20020a5d97d4000000b005da6f3b7dc7so1566278ios.1
        for <netdev@vger.kernel.org>; Thu, 21 Oct 2021 16:19:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=7xis1CFt9o3RmZy4dt49zTPd9KTpfXh+qnwELqDjLco=;
        b=7go4drIqsD0JjXmOXzDdVZzK0DCIJwCNws/Rte2cL7kVzkJnI0NfcQYpsifKDtC8Yd
         VdHnF678zLqUEq89MPWMJnNbfx3lwk8dBJXXxqttqMKMKVyILrzLS6DqAvUpCjTdmV+c
         ApLJN2L1xrcc9NuRP4qWn8bjAzv1xCxDHVFMlKkc4caFoor5r7T7K81ikTZgIyLLpqPe
         7BMAFFM8AoCGMWsdiQ6v32rg1wO6J3v6njCITyEhOlmU49E2cTFTJMr7NR/uvOALhqKX
         7hD5Z0HWqQPq0ES40FFWq5P8pPyh+5i8NkbeystfCMl4YAzpeGouwQF3GO1/u2KKga47
         zLsA==
X-Gm-Message-State: AOAM532wMMCqdPfYWaiUplV3C2WYrxq19ZmbkV6rX8UeQROVKY/3s3+i
        Fp7Hcf1VyXYJOrgqvXuDzQTzXJ102kYYG/B9mVNtqX5imX1S
X-Google-Smtp-Source: ABdhPJwnaBUwWj2OU1cPAblMDguTes/Mm8n6qwclplq/HNd/pOKxSRxZGyvk25OVD+R8Hu/flRfArCwGawOp9zMVlIMRdWsQMVew
MIME-Version: 1.0
X-Received: by 2002:a6b:f614:: with SMTP id n20mr6198592ioh.134.1634858364062;
 Thu, 21 Oct 2021 16:19:24 -0700 (PDT)
Date:   Thu, 21 Oct 2021 16:19:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000c522305cee520e6@google.com>
Subject: [syzbot] WARNING in batadv_nc_mesh_free
From:   syzbot <syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com>
To:     a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mareklindner@neomailbox.ch, netdev@vger.kernel.org,
        sven@narfation.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2f111a6fd5b5 Merge tag 'ceph-for-5.15-rc7' of git://github..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=115750acb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d95853dad8472c91
dashboard link: https://syzkaller.appspot.com/bug?extid=28b0702ada0bf7381f58
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1026ef2cb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c9c162b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com

RBP: 00007ffef262e230 R08: 0000000000000002 R09: 00007fddc8003531
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 0 PID: 6517 at lib/debugobjects.c:508 debug_print_object lib/debugobjects.c:505 [inline]
WARNING: CPU: 0 PID: 6517 at lib/debugobjects.c:508 debug_object_assert_init+0x1fa/0x250 lib/debugobjects.c:895
Modules linked in:
CPU: 0 PID: 6517 Comm: syz-executor011 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object lib/debugobjects.c:505 [inline]
RIP: 0010:debug_object_assert_init+0x1fa/0x250 lib/debugobjects.c:895
Code: e8 4b 15 b8 fd 4c 8b 45 00 48 c7 c7 a0 31 b4 8a 48 c7 c6 00 2e b4 8a 48 c7 c2 e0 33 b4 8a 31 c9 49 89 d9 31 c0 e8 b6 c6 36 fd <0f> 0b ff 05 3a 5c c5 09 48 83 c5 38 48 89 e8 48 c1 e8 03 42 80 3c
RSP: 0018:ffffc90002c7e698 EFLAGS: 00010046
RAX: cffa606352c78700 RBX: 0000000000000000 RCX: ffff888076ce9c80
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffffff8a512d00 R08: ffffffff81693402 R09: ffffed1017383f2c
R10: ffffed1017383f2c R11: 0000000000000000 R12: dffffc0000000000
R13: ffff88801bcd1720 R14: 0000000000000002 R15: ffffffff90ba5a20
FS:  0000555557087300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5473f3c000 CR3: 0000000070ca6000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 debug_timer_assert_init kernel/time/timer.c:739 [inline]
 debug_assert_init kernel/time/timer.c:784 [inline]
 del_timer+0xa5/0x3d0 kernel/time/timer.c:1204
 try_to_grab_pending+0x151/0xbb0 kernel/workqueue.c:1270
 __cancel_work_timer+0x14c/0x710 kernel/workqueue.c:3129
 batadv_nc_mesh_free+0x4a/0xf0 net/batman-adv/network-coding.c:1869
 batadv_mesh_free+0x6f/0x140 net/batman-adv/main.c:245
 batadv_mesh_init+0x4e5/0x550 net/batman-adv/main.c:226
 batadv_softif_init_late+0x8fe/0xd70 net/batman-adv/soft-interface.c:804
 register_netdevice+0x826/0x1c30 net/core/dev.c:10229
 __rtnl_newlink net/core/rtnetlink.c:3458 [inline]
 rtnl_newlink+0x14b3/0x1d10 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x934/0xe60 net/core/rtnetlink.c:5572
 netlink_rcv_skb+0x200/0x470 net/netlink/af_netlink.c:2510
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x814/0x9f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0xa29/0xe50 net/netlink/af_netlink.c:1935
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0x5b9/0x910 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x36f/0x450 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fddc82bc7e9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffef262e228 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fddc82bc7e9
RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 00007ffef262e230 R08: 0000000000000002 R09: 00007fddc8003531
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
