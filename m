Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D830B20B6BD
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgFZRTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:19:18 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:50113 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725882AbgFZRTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:19:18 -0400
Received: by mail-il1-f200.google.com with SMTP id i7so6894920ilq.16
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:19:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=J+1+atZsYhwgiTNwIKhLHMj1tqXsKVQRhorRw7ExzUA=;
        b=SlK/Zw0g09e0ViwjvMtgESiFvXhMFu9zowScDro+YE8ixpm5CpRYiSOoMtS1hrJOCU
         RpkYw5FyGoRtjaOsPm6IDZ1EsVb0rhFqELZXHW85hnOu8aQSOLuwEdVvnnSwPtcp8WUr
         /OJA3jXkd9yQPo+XXe2J7zqzyru0afTlYE4Fo1Why0I3EmUOnWW0KsH+tMxQctBJpTHw
         dDVKibP7FzhHqfO9C8NABDZj8UfqiUsgsRqic18iKXJycIhJ3KT2PgIIFOj88Mpq/OV1
         OuJNZw9tAatTVAORo7P+e82mrAkjSDQziBnaTGJHvXLHTdaLSCVgpGV9O9xfQSMdh19m
         6eeg==
X-Gm-Message-State: AOAM532Vt3Cor9xg0tvszJ1dHnrHjLfhrLet+G6o9shOJJ0SAt7o4bpF
        IRuD9L4qvTwhI6Ih1PfTWIFZ16GjFSh6wcQppoJjEbyMsGMS
X-Google-Smtp-Source: ABdhPJwgZJtRtXtF4JFXA/HJJSPyGJWxOLeed4GwIef8ZkC+0CQwo/N2QYBZKB4DRF8e4L3tyREOwljYGf3FF7grzkhjCvGQ4P0q
MIME-Version: 1.0
X-Received: by 2002:a5e:9b0e:: with SMTP id j14mr2938730iok.169.1593191956863;
 Fri, 26 Jun 2020 10:19:16 -0700 (PDT)
Date:   Fri, 26 Jun 2020 10:19:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a5de6405a8ffe8f2@google.com>
Subject: WARNING in hsr_dev_finalize
From:   syzbot <syzbot+7f1c020f68dab95aab59@syzkaller.appspotmail.com>
To:     ap420073@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    4a21185c Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14458775100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf3aec367b9ab569
dashboard link: https://syzkaller.appspot.com/bug?extid=7f1c020f68dab95aab59
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17bbeb75100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1587d955100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7f1c020f68dab95aab59@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 7036 at net/core/dev.c:8992 rollback_registered_many+0xbdb/0xf60 net/core/dev.c:8992
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 7036 Comm: syz-executor966 Not tainted 5.8.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x45 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 exc_invalid_op+0x24d/0x400 arch/x86/kernel/traps.c:235
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:563
RIP: 0010:rollback_registered_many+0xbdb/0xf60 net/core/dev.c:8992
Code: 00 00 31 f6 4c 89 f7 e8 f3 d9 fc ff e9 4f fe ff ff 4c 89 e7 e9 48 fd ff ff e8 31 65 3e fb 0f 0b e9 da fd ff ff e8 25 65 3e fb <0f> 0b e9 18 fe ff ff e8 19 65 3e fb 0f b6 2d de 64 74 04 31 ff 89
RSP: 0018:ffffc90001f5ef60 EFLAGS: 00010293
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffffffff8634e915
RDX: ffff8880949f0000 RSI: ffffffff8634eb2b RDI: 0000000000000005
RBP: ffff888094a6e0b8 R08: 0000000000000000 R09: ffffffff8a7b01c7
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8880a693ea00
R13: 0000000000034960 R14: ffff888094a6e000 R15: 0000000000000000
 rollback_registered net/core/dev.c:9013 [inline]
 unregister_netdevice_queue+0x2dd/0x570 net/core/dev.c:10094
 unregister_netdevice include/linux/netdevice.h:2754 [inline]
 hsr_dev_finalize+0x5ce/0x746 net/hsr/hsr_device.c:483
 hsr_newlink+0x27c/0x520 net/hsr/hsr_netlink.c:83
 __rtnl_newlink+0x1090/0x1730 net/core/rtnetlink.c:3339
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3397
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5460
 netlink_rcv_skb+0x15a/0x430 net/netlink/af_netlink.c:2469
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2352
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2406
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2439
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:359
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443ee9
Code: Bad RIP value.
RSP: 002b:00007ffe34db5118 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000443ee9
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 00007ffe34db5120 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000fdfc
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
