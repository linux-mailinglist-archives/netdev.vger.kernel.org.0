Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4324BA635
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 17:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242553AbiBQQls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 11:41:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243394AbiBQQlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 11:41:44 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341B7F67
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 08:41:23 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id d194-20020a6bcdcb000000b0063a4e3b9da6so2538077iog.6
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 08:41:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=nqAPwEEhwPR0Pv3AXtCJI0o79dEiYFLyRlAR6waSNts=;
        b=uHk1Il8gHrDBvvhrQ2UKYOnfoNm13MtfvU91gUt6a61EwSWfEDOhkcFCT07M6hmYSi
         OmDZPGtpw5+6LbkJu+IXaqKB9Raqf4cvD07PCk7qP9enk9JbXZ9M2zyjw6UChVC18gQq
         /1YFNKCtqnxJyvQ9p97TjyQxbNYlrcf5u/tk8HF3HDiq9+4JV2DJGTSZ7JfvuJcYSeCq
         vFXcAWlpY1OwNmwuBzAO7BzVa0xd0yOYRLnnpcRbMeWndLrYmcyr6woC7hia+41MQ4Qt
         BHPBPqGVlwJG6XwggaCaY+TMgmVOdCxhiML9EJr5cpdwQcxECYcbhZEPulYguBfozras
         Vz6Q==
X-Gm-Message-State: AOAM533x9bR9o2oFu01PQnQqIg2+pKPmxNzWlqzqYslV7OXso121HyzT
        5+3BspbTAYm5kwWUZI9he6EiHvZ1sKWRNqgCGkXOnL9bVKo1
X-Google-Smtp-Source: ABdhPJzi2uSOJET/qIt8gik3yCeeRZab/iPkcQghp1KpFihPA8CNzTSywhz9uvEfe3jJVjNXMHcYmjLOy0cNzv1xnB6cRloCtYG+
MIME-Version: 1.0
X-Received: by 2002:a02:3c01:0:b0:314:37ed:233 with SMTP id
 m1-20020a023c01000000b0031437ed0233mr2380641jaa.118.1645116082579; Thu, 17
 Feb 2022 08:41:22 -0800 (PST)
Date:   Thu, 17 Feb 2022 08:41:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b772b805d8396f14@google.com>
Subject: [syzbot] BUG: sleeping function called from invalid context in smc_pnet_apply_ib
From:   syzbot <syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com>
To:     jgg@ziepe.ca, liangwenpeng@huawei.com,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        liweihang@huawei.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c832962ac972 net: bridge: multicast: notify switchdev driv..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16b157bc700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=266de9da75c71a45
dashboard link: https://syzkaller.appspot.com/bug?extid=4f322a6d84e991c38775
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4f322a6d84e991c38775@syzkaller.appspotmail.com

infiniband syz1: set down
infiniband syz1: added lo
RDS/IB: syz1: added
smc: adding ib device syz1 with port count 1
BUG: sleeping function called from invalid context at kernel/locking/mutex.c:577
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 17974, name: syz-executor.3
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
6 locks held by syz-executor.3/17974:
 #0: ffffffff90865838 (&rdma_nl_types[idx].sem){.+.+}-{3:3}, at: rdma_nl_rcv_msg+0x161/0x690 drivers/infiniband/core/netlink.c:164
 #1: ffffffff8d04edf0 (link_ops_rwsem){++++}-{3:3}, at: nldev_newlink+0x25d/0x560 drivers/infiniband/core/nldev.c:1707
 #2: ffffffff8d03e650 (devices_rwsem){++++}-{3:3}, at: enable_device_and_get+0xfc/0x3b0 drivers/infiniband/core/device.c:1321
 #3: ffffffff8d03e510 (clients_rwsem){++++}-{3:3}, at: enable_device_and_get+0x15b/0x3b0 drivers/infiniband/core/device.c:1329
 #4: ffff8880482c85c0 (&device->client_data_rwsem){++++}-{3:3}, at: add_client_context+0x3d0/0x5e0 drivers/infiniband/core/device.c:718
 #5: ffff8880230a4118 (&pnettable->lock){++++}-{2:2}, at: smc_pnetid_by_table_ib+0x18c/0x470 net/smc/smc_pnet.c:1159
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 PID: 17974 Comm: syz-executor.3 Not tainted 5.17.0-rc3-syzkaller-00170-gc832962ac972 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9576
 __mutex_lock_common kernel/locking/mutex.c:577 [inline]
 __mutex_lock+0x9f/0x12f0 kernel/locking/mutex.c:733
 smc_pnet_apply_ib+0x28/0x160 net/smc/smc_pnet.c:251
 smc_pnetid_by_table_ib+0x2ae/0x470 net/smc/smc_pnet.c:1164
 smc_ib_add_dev+0x4d7/0x900 net/smc/smc_ib.c:940
 add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:720
 enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1331
 ib_register_device drivers/infiniband/core/device.c:1419 [inline]
 ib_register_device+0x814/0xaf0 drivers/infiniband/core/device.c:1365
 rxe_register_device+0x2fe/0x3b0 drivers/infiniband/sw/rxe/rxe_verbs.c:1146
 rxe_add+0x1331/0x1710 drivers/infiniband/sw/rxe/rxe.c:246
 rxe_net_add+0x8c/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:538
 rxe_newlink drivers/infiniband/sw/rxe/rxe.c:268 [inline]
 rxe_newlink+0xa9/0xd0 drivers/infiniband/sw/rxe/rxe.c:249
 nldev_newlink+0x30a/0x560 drivers/infiniband/core/nldev.c:1717
 rdma_nl_rcv_msg+0x36d/0x690 drivers/infiniband/core/netlink.c:195
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x2ee/0x430 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2413
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f909305f059
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f90919d4168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f9093171f60 RCX: 00007f909305f059
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 00007f90930b908d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff171c256f R14: 00007f90919d4300 R15: 0000000000022000
 </TASK>

=============================
[ BUG: Invalid wait context ]
5.17.0-rc3-syzkaller-00170-gc832962ac972 #0 Tainted: G        W        
-----------------------------
syz-executor.3/17974 is trying to lock:
ffffffff8d710098 (smc_ib_devices.mutex){+.+.}-{3:3}, at: smc_pnet_apply_ib+0x28/0x160 net/smc/smc_pnet.c:251
other info that might help us debug this:
context-{4:4}
6 locks held by syz-executor.3/17974:
 #0: ffffffff90865838 (&rdma_nl_types[idx].sem){.+.+}-{3:3}, at: rdma_nl_rcv_msg+0x161/0x690 drivers/infiniband/core/netlink.c:164
 #1: ffffffff8d04edf0 (link_ops_rwsem){++++}-{3:3}, at: nldev_newlink+0x25d/0x560 drivers/infiniband/core/nldev.c:1707
 #2: ffffffff8d03e650 (devices_rwsem){++++}-{3:3}, at: enable_device_and_get+0xfc/0x3b0 drivers/infiniband/core/device.c:1321
 #3: ffffffff8d03e510 (clients_rwsem){++++}-{3:3}, at: enable_device_and_get+0x15b/0x3b0 drivers/infiniband/core/device.c:1329
 #4: ffff8880482c85c0 (&device->client_data_rwsem){++++}-{3:3}, at: add_client_context+0x3d0/0x5e0 drivers/infiniband/core/device.c:718
 #5: ffff8880230a4118 (&pnettable->lock){++++}-{2:2}, at: smc_pnetid_by_table_ib+0x18c/0x470 net/smc/smc_pnet.c:1159
stack backtrace:
CPU: 1 PID: 17974 Comm: syz-executor.3 Tainted: G        W         5.17.0-rc3-syzkaller-00170-gc832962ac972 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4678 [inline]
 check_wait_context kernel/locking/lockdep.c:4739 [inline]
 __lock_acquire.cold+0x213/0x3ab kernel/locking/lockdep.c:4977
 lock_acquire kernel/locking/lockdep.c:5639 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5604
 __mutex_lock_common kernel/locking/mutex.c:600 [inline]
 __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:733
 smc_pnet_apply_ib+0x28/0x160 net/smc/smc_pnet.c:251
 smc_pnetid_by_table_ib+0x2ae/0x470 net/smc/smc_pnet.c:1164
 smc_ib_add_dev+0x4d7/0x900 net/smc/smc_ib.c:940
 add_client_context+0x405/0x5e0 drivers/infiniband/core/device.c:720
 enable_device_and_get+0x1cd/0x3b0 drivers/infiniband/core/device.c:1331
 ib_register_device drivers/infiniband/core/device.c:1419 [inline]
 ib_register_device+0x814/0xaf0 drivers/infiniband/core/device.c:1365
 rxe_register_device+0x2fe/0x3b0 drivers/infiniband/sw/rxe/rxe_verbs.c:1146
 rxe_add+0x1331/0x1710 drivers/infiniband/sw/rxe/rxe.c:246
 rxe_net_add+0x8c/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:538
 rxe_newlink drivers/infiniband/sw/rxe/rxe.c:268 [inline]
 rxe_newlink+0xa9/0xd0 drivers/infiniband/sw/rxe/rxe.c:249
 nldev_newlink+0x30a/0x560 drivers/infiniband/core/nldev.c:1717
 rdma_nl_rcv_msg+0x36d/0x690 drivers/infiniband/core/netlink.c:195
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x2ee/0x430 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2413
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f909305f059
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f90919d4168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f9093171f60 RCX: 00007f909305f059
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 00007f90930b908d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fff171c256f R14: 00007f90919d4300 R15: 0000000000022000
 </TASK>
smc:    ib device syz1 port 1 has pnetid SYZ2 (user defined)
lo speed is unknown, defaulting to 1000
lo speed is unknown, defaulting to 1000
lo speed is unknown, defaulting to 1000
lo speed is unknown, defaulting to 1000
lo speed is unknown, defaulting to 1000
lo speed is unknown, defaulting to 1000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
