Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106753A4AF4
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 00:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhFKW0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 18:26:40 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:33358 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhFKW0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 18:26:39 -0400
Received: by mail-il1-f199.google.com with SMTP id q14-20020a056e02096eb02901dd056f8a57so4376050ilt.0
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 15:24:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=siRIDFznDdx/okEQKHOjv9N0zzIqu96Ladkz4MvhydA=;
        b=tqq4y1ziE8a2yJIJGJhl2VpBc0OAohL7xCEfMuOEEcnE7/icZ4qTwJZVkYZw2e+4MS
         5+/8sFjoB3XcR6w3UVeAAFgHyI4oWNCvlSkcmLu7w6+woHQYdcBwJiF6QP2v725VcPUo
         VrrqjY1BRFyhbqlIuobBvDQ4gyCCyGvf4gR3iUCa/ehlKXUJFN6T29zcDh+ztRDAFThu
         QJ3wRz8Bw4dAj3PuNy752zpavi6TCNTa2vVFSURG9sEHJg2YKVoa80l4SQGwPk68S29E
         E1LF8sDCHQUgQ+HzUBEvYkJzdc+hIi6voNZmUpH8kGwzHI29We6YHPAfASoIG8z9jErM
         46ew==
X-Gm-Message-State: AOAM530ztLOomAAIJ35wUL2Zuo3TSTBaCIQ6C8XHtr/ixHcyMCP3NqDZ
        EjPLjmzASG1PDUBS3hFK9cVed1Te6cq1VDrhUXlID0WBmj9U
X-Google-Smtp-Source: ABdhPJzJjE/KJiazVGLXuASulssro/Yd63xuV12voLQyemCfW5uEVV73yLfMrhmbsoX0SrBN+vYdQ1sMU1aAO4oLJAeEepjM17nm
MIME-Version: 1.0
X-Received: by 2002:a92:d245:: with SMTP id v5mr4827805ilg.245.1623450266946;
 Fri, 11 Jun 2021 15:24:26 -0700 (PDT)
Date:   Fri, 11 Jun 2021 15:24:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000078d3f405c484f89f@google.com>
Subject: [syzbot] WARNING in ethnl_default_doit
From:   syzbot <syzbot+59aa77b92d06cd5a54f2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mkubecek@suse.cz, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1a42624a net: dsa: xrs700x: allow HSR/PRP supervision dupe..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15043cebd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbe37cfd20d4573c
dashboard link: https://syzkaller.appspot.com/bug?extid=59aa77b92d06cd5a54f2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+59aa77b92d06cd5a54f2@syzkaller.appspotmail.com

------------[ cut here ]------------
calculated message payload length (684) not sufficient
WARNING: CPU: 0 PID: 30967 at net/ethtool/netlink.c:369 ethnl_default_doit+0x87a/0xa20 net/ethtool/netlink.c:369
Modules linked in:
CPU: 1 PID: 30967 Comm: syz-executor.0 Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:ethnl_default_doit+0x87a/0xa20 net/ethtool/netlink.c:369
Code: e8 6b b3 2b fa 40 84 ed 0f 85 f9 fd ff ff e8 ad ac 2b fa 8b 74 24 10 48 c7 c7 e0 76 6e 8a c6 05 0b ee 6b 06 01 e8 d9 df 8c 01 <0f> 0b e9 d6 fd ff ff e8 0a c0 70 fa e9 52 f8 ff ff 48 89 de 48 c7
RSP: 0018:ffffc9001731f578 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffffffff8a6e8e60 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815ce355 RDI: fffff52002e63ea1
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815c81be R11: 0000000000000000 R12: 00000000ffffffa6
R13: ffff88801d587380 R14: ffff88802d919800 R15: 1ffff92002e63eb4
FS:  00007fb7d20ef700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2cb23000 CR3: 00000000548f7000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb7d20ef188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000056bf80 RCX: 00000000004665d9
RDX: 0000000020000000 RSI: 0000000020000400 RDI: 0000000000000004
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf80
R13: 00007ffd1ef3866f R14: 00007fb7d20ef300 R15: 0000000000022000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
