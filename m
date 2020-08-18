Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2054249162
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 01:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgHRXPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 19:15:19 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:40020 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726944AbgHRXPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 19:15:15 -0400
Received: by mail-il1-f197.google.com with SMTP id o9so14620531ilk.7
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 16:15:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=E4BHJHLXtNc8TZauQeJum4JuNvEC50LzEspiC76MB7w=;
        b=r8ArLyd721X+VYADvcnNXuq9jTRVyhDmXTROpVci8M4KHJfw1k5CtdIVeli7il+d/6
         KoII2Q7GUISqK9DQ4ewcT/fWgsQxQcWSzbbUDGpJYsCCCG9e+y7+donPC2yiFfsZgy+z
         +rmKmXzPa2fbzrl7ccDVYpADzg2I488JoH3iIXns+ID7vmiz+1BX3cgWnYqHAgAzTDN4
         FE2XypnwqB/Uc7Y/wq3DsrLCDNMO3/3lfwXpfkme+fzx1BJdruXM+MZOBIFDwZbVMltk
         GbNGpKFkOHk2ALQ76wfXYJ+/wnaDTIZPyBNXY+usLfgDr6uAmu/osX+Ych8ijdznoRX9
         Cpeg==
X-Gm-Message-State: AOAM533iEuxgdXWBfEPOW43Abn37dR1jliSgXPj6b49JiKWyEH2Cb4hF
        +14AilluohsUq0LkYoqWkWi1kfPgP80C9bwexMMWoRgJVWuQ
X-Google-Smtp-Source: ABdhPJxgDvUT3inYOsUCzmNuPTrFGeU1nm10VjumbI4RN9urZdUY06Y80I/TgyDKodUyAbxPXwJINaeJ32YoH1OrvKk4XPFGCxDv
MIME-Version: 1.0
X-Received: by 2002:a02:93c5:: with SMTP id z63mr21565598jah.70.1597792514447;
 Tue, 18 Aug 2020 16:15:14 -0700 (PDT)
Date:   Tue, 18 Aug 2020 16:15:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003fa34d05ad2f0f7d@google.com>
Subject: WARNING in nsim_destroy
From:   syzbot <syzbot+8f4ae52bf05388da0a8e@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9123e3a7 Linux 5.9-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=166038ea900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3d400a47d1416652
dashboard link: https://syzkaller.appspot.com/bug?extid=8f4ae52bf05388da0a8e
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8f4ae52bf05388da0a8e@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 31885 at net/core/dev.c:8856 dev_xdp_uninstall net/core/dev.c:8856 [inline]
WARNING: CPU: 0 PID: 31885 at net/core/dev.c:8856 rollback_registered_many+0xe71/0x1210 net/core/dev.c:9276
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 31885 Comm: syz-executor.4 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x4a kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:dev_xdp_uninstall net/core/dev.c:8856 [inline]
RIP: 0010:rollback_registered_many+0xe71/0x1210 net/core/dev.c:9276
Code: 8d 22 00 00 48 c7 c6 80 ee fe 88 48 c7 c7 c0 ee fe 88 c6 05 fc 0c 71 04 01 e8 7d 29 09 fb 0f 0b e9 db f7 ff ff e8 df 1a 38 fb <0f> 0b e9 48 fe ff ff 48 89 ef e9 a2 fb ff ff e8 cb 1a 38 fb 0f b6
RSP: 0018:ffffc90008397428 EFLAGS: 00010246
RAX: 0000000000040000 RBX: ffff888048710bb8 RCX: ffffc90011ae4000
RDX: 0000000000040000 RSI: ffffffff863c26a1 RDI: 0000000000000005
RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffff8a7e5be7
R10: 0000000000000000 R11: 0000000000000001 R12: 00000000fffffff0
R13: ffff888048710000 R14: dffffc0000000000 R15: ffffc9000102e000
 rollback_registered net/core/dev.c:9326 [inline]
 unregister_netdevice_queue+0x2dd/0x570 net/core/dev.c:10407
 unregister_netdevice include/linux/netdevice.h:2774 [inline]
 nsim_destroy+0x35/0x70 drivers/net/netdevsim/netdev.c:339
 __nsim_dev_port_del+0x144/0x1e0 drivers/net/netdevsim/dev.c:946
 nsim_dev_port_del_all drivers/net/netdevsim/dev.c:959 [inline]
 nsim_dev_reload_destroy+0xff/0x1e0 drivers/net/netdevsim/dev.c:1135
 nsim_dev_reload_down+0x6e/0xd0 drivers/net/netdevsim/dev.c:712
 devlink_reload+0xc1/0x3a0 net/core/devlink.c:2974
 devlink_nl_cmd_reload+0x346/0x820 net/core/devlink.c:3009
 genl_family_rcv_msg_doit net/netlink/genetlink.c:669 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:714 [inline]
 genl_rcv_msg+0x61d/0x980 net/netlink/genetlink.c:731
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2470
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:742
 netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1330
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2353
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2407
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2440
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45d239
Code: 5d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f58abc86c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000027800 RCX: 000000000045d239
RDX: 0000000000000000 RSI: 0000000020000800 RDI: 0000000000000003
RBP: 000000000118cf80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118cf4c
R13: 00007ffc33e71c6f R14: 00007f58abc879c0 R15: 000000000118cf4c
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
