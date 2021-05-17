Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D2E382B74
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 13:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbhEQLtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 07:49:35 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:55976 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhEQLte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 07:49:34 -0400
Received: by mail-io1-f70.google.com with SMTP id p2-20020a5d98420000b029043b3600ac76so249571ios.22
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 04:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yYBFhzqgd/PHAE0tD7Ib82HE2HqWy6JboZUomFESCjA=;
        b=KO7RcWm4natvMxv0H3UQbTFPja06p8S/9qkqFjnUDQ00jop0wEhuT9Zz0oDcd7VSeV
         klK4Ag/Iwt2g4QhXTFLdFm/zKSq7ZhDLnJC0jGhCSJT1025H1D/EE7qotijmeJDg2JjL
         JMC7pAkoKryrzfrfqumDtkli+sP7AnTbaKew0knnAZBQWrSYkwPsBdjSSzRGvNAawDzk
         9Qzdr+ektrYzwdypCYjyE6lzkXM/OM9gbcOhOBELusIp01ckvTpYYHB8GnUuXTsa9sRF
         tfCRyv3ssVCyD9LN6a1TJxQyi++l4xSBJ+5LkqD9UI/UOldzVOKVA+1TuBjezOxA9Eyc
         yRtw==
X-Gm-Message-State: AOAM531AuScaWFdF789O5jaeGXUO2SIWISndcyp1Nx9HFsqSHEdzCa0k
        5q5a5JDa4o1uX2X3Ww6XhHrphv1776rU0vvt68nyRvELOQK9
X-Google-Smtp-Source: ABdhPJyoh3NDfKr2PeoZxpBMtSpga6dgNKx2z3EEleAbpNqhfiRmNOBIIE9vbISVQ/AuXM0sN5Mz5kkDuqz4QY9UqTUIT7KD2Rva
MIME-Version: 1.0
X-Received: by 2002:a92:b106:: with SMTP id t6mr53747751ilh.99.1621252097198;
 Mon, 17 May 2021 04:48:17 -0700 (PDT)
Date:   Mon, 17 May 2021 04:48:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000584fd505c2852b25@google.com>
Subject: [syzbot] WARNING in bond_update_slave_arr (2)
From:   syzbot <syzbot+0d294e1d3ade13a70161@syzkaller.appspotmail.com>
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

HEAD commit:    1678e493 Merge tag 'lto-v5.12-rc6' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=146488fcd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d1a3d65a48dbd1bc
dashboard link: https://syzkaller.appspot.com/bug?extid=0d294e1d3ade13a70161

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0d294e1d3ade13a70161@syzkaller.appspotmail.com

netlink: 'syz-executor.0': attribute type 1 has an invalid length.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 21400 at drivers/net/bonding/bond_main.c:4395 bond_update_slave_arr+0xcb0/0x10c0 drivers/net/bonding/bond_main.c:4395
Modules linked in:
CPU: 0 PID: 21400 Comm: syz-executor.0 Not tainted 5.12.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bond_update_slave_arr+0xcb0/0x10c0 drivers/net/bonding/bond_main.c:4395
Code: cb fc 45 31 e4 e9 76 fe ff ff e8 eb bc cb fc 48 83 3c 24 00 41 bc f4 ff ff ff 0f 85 67 fc ff ff e9 7f fe ff ff e8 d0 bc cb fc <0f> 0b e9 e7 f3 ff ff e8 c4 bc cb fc 48 85 ed 41 bc f4 ff ff ff 0f
RSP: 0018:ffffc90001bbee38 EFLAGS: 00010216
RAX: 000000000002a883 RBX: ffff88807b5d0c00 RCX: ffffc90009192000
RDX: 0000000000040000 RSI: ffffffff84a83480 RDI: 0000000000000003
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff84a82866 R11: 0000000000000001 R12: 0000000000000006
R13: ffff88807b5d0038 R14: 0000000000000000 R15: ffff88807b5d0c00
FS:  00007f3c00d35700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f00387e3000 CR3: 000000007af5a000 CR4: 0000000000350ef0
Call Trace:
 bond_open+0x448/0xc00 drivers/net/bonding/bond_main.c:3710
 __dev_open+0x2bc/0x4d0 net/core/dev.c:1563
 __dev_change_flags+0x583/0x750 net/core/dev.c:8686
 rtnl_configure_link+0xee/0x240 net/core/rtnetlink.c:3125
 __rtnl_newlink+0x1093/0x1710 net/core/rtnetlink.c:3451
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3491
 rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x466459
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3c00d35188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000466459
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 00000000004bf9fb R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007fff04d9e05f R14: 00007f3c00d35300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
