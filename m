Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD441B90B1
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 15:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgDZNnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 09:43:15 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:35653 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgDZNnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 09:43:14 -0400
Received: by mail-il1-f198.google.com with SMTP id r5so16646996ilq.2
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 06:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rlJAfwbPqtPWQJVZIPkomN7KJEtdzrl3Ui0y/x3Z8hs=;
        b=R/i+UUzgkeIrMF048zf0v6IepV+9u5p7D/dR5ZkDvSZbvqQjj8FzKtnK5xTrC0/z8G
         yXQTaj3Sst4wPmk3Sv8pHByww5SXFqMsDz7ZazoMVSWYlU6GQDA8kKMma4Rb3zT/Cllq
         7uulK2I+LiZyAHKStWH/t745AC49zPdtF7on5CQOdBFARGoYqZyWNUNtRroYjSPo8MMb
         bI7ZTff/XrWGPqvDLmF7yojiuZgdkrhwuK6OpOan48oNVhUmeA9NQS6oQlbRmpshnmuj
         GxXgVxmSMvCbRA1gDfnm22TcZW7fCnDbChaXcWMoC5aLmif4apQng9MzLJ2OviOYB1t7
         /bAA==
X-Gm-Message-State: AGi0PuaKgOfhwRACGpPEKQxitpFK3EfpHgKxpr2HKJEptCzlaJVH4KXq
        QEFIe6eOL7V9Gsx4UO/24rXQ6fJ09qTnrgHDcIURMRQYu+4I
X-Google-Smtp-Source: APiQypKxs5VGnvM1qXq+lYJKi9Um6WY+7O0zommb3ly8Y5J38otFgmbS3FSL4vxdihxPch6+sK5nNtt+xHbSN3izMbjCgJLBOJWR
MIME-Version: 1.0
X-Received: by 2002:a02:9642:: with SMTP id c60mr16053970jai.87.1587908593710;
 Sun, 26 Apr 2020 06:43:13 -0700 (PDT)
Date:   Sun, 26 Apr 2020 06:43:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aa012505a431c7d9@google.com>
Subject: WARNING in ib_unregister_device_queued
From:   syzbot <syzbot+4088ed905e4ae2b0e13b@syzkaller.appspotmail.com>
To:     dledford@redhat.com, jgg@ziepe.ca, kamalheib1@gmail.com,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        parav@mellanox.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    b9663b7c net: stmmac: Enable SERDES power up/down sequence
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=166bf717e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d351a1019ed81a2
dashboard link: https://syzkaller.appspot.com/bug?extid=4088ed905e4ae2b0e13b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4088ed905e4ae2b0e13b@syzkaller.appspotmail.com

rdma_rxe: ignoring netdev event = 10 for netdevsim0
infiniband  yz2: set down
------------[ cut here ]------------
WARNING: CPU: 0 PID: 22753 at drivers/infiniband/core/device.c:1565 ib_unregister_device_queued+0x122/0x160 drivers/infiniband/core/device.c:1565
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 22753 Comm: syz-executor.5 Not tainted 5.7.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x35 kernel/panic.c:582
 report_bug+0x27b/0x2f0 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:175 [inline]
 fixup_bug arch/x86/kernel/traps.c:170 [inline]
 do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
 do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:ib_unregister_device_queued+0x122/0x160 drivers/infiniband/core/device.c:1565
Code: fb e8 72 e2 d4 fb 48 89 ef e8 2a c3 c1 fe 48 83 c4 08 5b 5d e9 5f e2 d4 fb e8 5a e2 d4 fb 0f 0b e9 46 ff ff ff e8 4e e2 d4 fb <0f> 0b e9 6f ff ff ff 48 89 ef e8 2f a9 12 fc e9 16 ff ff ff 48 c7
RSP: 0018:ffffc900072ef290 EFLAGS: 00010246
RAX: 0000000000040000 RBX: ffff8880a6a24000 RCX: ffffc90013201000
RDX: 0000000000040000 RSI: ffffffff859e51b2 RDI: ffff8880a6a24310
RBP: 0000000000000019 R08: ffff88808d21c280 R09: ffffed1014d449bb
R10: ffff8880a6a24dd3 R11: ffffed1014d449ba R12: 0000000000000006
R13: ffff88805988c000 R14: 0000000000000000 R15: ffffffff8a44f8c0
 rxe_notify+0x77/0xd0 drivers/infiniband/sw/rxe/rxe_net.c:605
 notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
 call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
 call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
 call_netdevice_notifiers net/core/dev.c:1974 [inline]
 rollback_registered_many+0x75c/0xe70 net/core/dev.c:8828
 rollback_registered+0xf2/0x1c0 net/core/dev.c:8873
 unregister_netdevice_queue net/core/dev.c:9969 [inline]
 unregister_netdevice_queue+0x1d7/0x2b0 net/core/dev.c:9962
 unregister_netdevice include/linux/netdevice.h:2725 [inline]
 nsim_destroy+0x35/0x60 drivers/net/netdevsim/netdev.c:330
 __nsim_dev_port_del+0x144/0x1e0 drivers/net/netdevsim/dev.c:934
 nsim_dev_port_del_all+0x86/0xe0 drivers/net/netdevsim/dev.c:947
 nsim_dev_reload_destroy+0x77/0x110 drivers/net/netdevsim/dev.c:1123
 nsim_dev_reload_down+0x6e/0xd0 drivers/net/netdevsim/dev.c:703
 devlink_reload+0xbd/0x3b0 net/core/devlink.c:2797
 devlink_nl_cmd_reload+0x2f7/0x7c0 net/core/devlink.c:2832
 genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
 genl_rcv_msg+0x627/0xdf0 net/netlink/genetlink.c:735
 netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c829
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6fae1cac78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004fcc00 RCX: 000000000045c829
RDX: 0000000000000000 RSI: 0000000020000800 RDI: 0000000000000006
RBP: 000000000078c040 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 0000000000000905 R14: 00000000004cbaab R15: 00007f6fae1cb6d4
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
