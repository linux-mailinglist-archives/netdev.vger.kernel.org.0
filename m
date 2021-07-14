Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392613C8B52
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 20:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhGNTAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 15:00:18 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:39804 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhGNTAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 15:00:16 -0400
Received: by mail-io1-f72.google.com with SMTP id v2-20020a5d94020000b02905058dc6c376so1853875ion.6
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 11:57:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=FXh2bXqx9XOXDqPo/4Em2QPdfuhaE8nPMfQxb+O+VqE=;
        b=FpqxXvB4gmlvG+7aM/XF/i0cPut658kEnXI2nAAT0UFV35olBW1QGFaZSkN7RJF9Wf
         rPCsHuQ+IRZchnB/LYLnHgYtBI6UxggYqX3NGxoF1k4a/HsjZTdjMVISo9s5uKoAuby3
         u1l9PQLWtvQh0iSvqikjGj3rIcvpIn2dYDlrQhAknLLzetWU/osQbB4s7uAipBrax+Qu
         UK1BBvU4pW5x5HLdypy3aaGSrT2TQIk2P+hgNvYw7i19ged/p5g8Nw3Eh9Q/Zucg3Kn5
         B4P8Dm0k+L6iD7pzXhW9BD2Up4W8c7VT0cIJNNIqfa0QMrTeuBN4WSgy00ZmouwlZ0Uv
         v1PA==
X-Gm-Message-State: AOAM533VkuS57eVnen6r/s87vdREH2sMBIBwa8YWtAisNcptTofRvZW7
        AwYoGFwIzhVTqauzeMcdKQxscztOM3fdM4B5COrSNQ1o4XEw
X-Google-Smtp-Source: ABdhPJxXBwnFfSM1fvlJm/v8iT+oOe2IOUF0qHWKcZN8vlxN2QTV9dSCMR6JOHBVSozuJwcJ1huXu8BttxRsaHarL1Mw8iRbS5yF
MIME-Version: 1.0
X-Received: by 2002:a5d:9f11:: with SMTP id q17mr7746713iot.62.1626289043502;
 Wed, 14 Jul 2021 11:57:23 -0700 (PDT)
Date:   Wed, 14 Jul 2021 11:57:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd7c8a05c719ecf2@google.com>
Subject: [syzbot] WARNING in internal_create_group
From:   syzbot <syzbot+9937dc42271cd87d4b98@syzkaller.appspotmail.com>
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    5d52c906f059 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16acf1e2300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=51ea6c9df4ed04c4
dashboard link: https://syzkaller.appspot.com/bug?extid=9937dc42271cd87d4b98

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9937dc42271cd87d4b98@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 9350 at fs/sysfs/group.c:116 internal_create_group+0x911/0xb20 fs/sysfs/group.c:116
Modules linked in:
CPU: 1 PID: 9350 Comm: syz-executor.4 Not tainted 5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:internal_create_group+0x911/0xb20 fs/sysfs/group.c:116
Code: 0f 85 e8 f7 ff ff 41 bd ea ff ff ff e9 34 fd ff ff e8 33 bc 82 ff 48 8b 7c 24 08 e8 89 11 ff ff e9 20 fd ff ff e8 1f bc 82 ff <0f> 0b 41 bd ea ff ff ff e9 0e fd ff ff e8 0d bc 82 ff 48 8b 14 24
RSP: 0018:ffffc9000181f2b0 EFLAGS: 00010246
RAX: 0000000000040000 RBX: 0000000000000000 RCX: ffffc90012931000
RDX: 0000000000040000 RSI: ffffffff81f2c5f1 RDI: 0000000000000003
RBP: ffff8880706b9d08 R08: 0000000000000000 R09: ffff8880706b9d0f
R10: ffffffff81f2bd9e R11: 0000000000000000 R12: 0000000000000000
R13: ffff88809a948070 R14: 0000000000000000 R15: ffff88809a94807c
FS:  00007feaac597700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000006f6c CR3: 000000009d5fa000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 blk_register_queue+0xda/0x570 block/blk-sysfs.c:871
 __device_add_disk+0x7b5/0xd10 block/genhd.c:529
 add_disk include/linux/genhd.h:217 [inline]
 nbd_dev_add+0x712/0x900 drivers/block/nbd.c:1709
 nbd_genl_connect+0x551/0x1660 drivers/block/nbd.c:1817
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x85b/0xda0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2392
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2446
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2475
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007feaac597188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000000000000 RSI: 0000000020000540 RDI: 0000000000000008
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffe11ff566f R14: 00007feaac597300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
