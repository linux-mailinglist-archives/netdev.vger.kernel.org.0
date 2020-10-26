Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7B0298EB2
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780846AbgJZN6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 09:58:32 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:36055 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1775160AbgJZN6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 09:58:30 -0400
Received: by mail-io1-f70.google.com with SMTP id q126so5920330iof.3
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 06:58:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=n/hzCBkM9Wqr2/xJY2TXir8S/juJ9PN0Z6ANs7RVQMg=;
        b=NtkOC7raoMgphsSAG6wTi230lJvOZrYI5MqRBaWAncJ93SptgHVr5R3sy+9wBgSfhL
         XikUgpDT/qjP7fK7f20gJ6BWViqoz77fVB4Ha8S8dczJfqxflY52JkrY8JLIy/hvJ6SM
         8KLOsXgRrSqcMPVT5JLhd3Ucc9B8b57FioFkaj3u96lO14e2mwM0Oafl5/U5/DPjtdGg
         pHFdysautnUnc0Bx0nrp5HPQ9Ts1gjljwbk8Bcq9GXeK59+Zr6jQJeLZBSx0IyqfNQKT
         4wkSEwdo9Fknz51jVSDXgSHZ7pm3DWPmjkvrNou3lexcJ96Wky9qRMdzrIP4O8dU0Coj
         /BoQ==
X-Gm-Message-State: AOAM5339geM7rDGjF0mAV6L3DTc9wa/YETq2b6RHFGdUUpxvCt0FPqHD
        QmXgnC3CuRCLN05IHLLvkZITJjr+9/0JqbzrNCTU4U4AndG7
X-Google-Smtp-Source: ABdhPJwtwmTMOZGTD0LrmF/FfMZMOBZ/DfRR9nadOZ2fNHrvmdFIlfzi0RTNi4mggf8J8sI3U9KvapgTEQc9eE7IqO24cwSjy6qf
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1344:: with SMTP id k4mr2687362ilr.54.1603720708172;
 Mon, 26 Oct 2020 06:58:28 -0700 (PDT)
Date:   Mon, 26 Oct 2020 06:58:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000021315205b29353aa@google.com>
Subject: WARNING in xfrm_alloc_compat
From:   syzbot <syzbot+a7e701c8385bd8543074@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f11901ed Merge tag 'xfs-5.10-merge-7' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17b35564500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fb79b5c2dc1e69e3
dashboard link: https://syzkaller.appspot.com/bug?extid=a7e701c8385bd8543074
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a7e701c8385bd8543074@syzkaller.appspotmail.com

netlink: 404 bytes leftover after parsing attributes in process `syz-executor.4'.
------------[ cut here ]------------
unsupported nla_type 0
WARNING: CPU: 0 PID: 9953 at net/xfrm/xfrm_compat.c:279 xfrm_xlate64_attr net/xfrm/xfrm_compat.c:279 [inline]
WARNING: CPU: 0 PID: 9953 at net/xfrm/xfrm_compat.c:279 xfrm_xlate64 net/xfrm/xfrm_compat.c:300 [inline]
WARNING: CPU: 0 PID: 9953 at net/xfrm/xfrm_compat.c:279 xfrm_alloc_compat+0xf39/0x10d0 net/xfrm/xfrm_compat.c:327
Modules linked in:
CPU: 0 PID: 9953 Comm: syz-executor.4 Not tainted 5.9.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:xfrm_xlate64_attr net/xfrm/xfrm_compat.c:279 [inline]
RIP: 0010:xfrm_xlate64 net/xfrm/xfrm_compat.c:300 [inline]
RIP: 0010:xfrm_alloc_compat+0xf39/0x10d0 net/xfrm/xfrm_compat.c:327
Code: de e8 4b 68 d3 f9 84 db 0f 85 b0 f8 ff ff e8 2e 70 d3 f9 8b 74 24 08 48 c7 c7 40 b9 51 8a c6 05 f7 0d 3c 05 01 e8 b7 db 0e 01 <0f> 0b e9 8d f8 ff ff e8 0b 70 d3 f9 8b 14 24 48 c7 c7 00 b9 51 8a
RSP: 0018:ffffc9000bb4f4b8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff8158cf25 RDI: fffff52001769e89
RBP: 00000000000001a0 R08: 0000000000000001 R09: ffff8880b9e2005b
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffffa1
R13: ffff88802ed1d8f8 R14: ffff888014403c80 R15: ffff88801514fc80
FS:  00007f188bbe6700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000074b698 CR3: 000000001aabe000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 xfrm_alloc_userspi+0x66a/0xa30 net/xfrm/xfrm_user.c:1388
 xfrm_user_rcv_msg+0x42f/0x8b0 net/xfrm/xfrm_user.c:2752
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2764
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
RIP: 0033:0x45de59
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f188bbe5c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 000000000002e640 RCX: 000000000045de59
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 000000000118bf60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000118bf2c
R13: 000000000169fb7f R14: 00007f188bbe69c0 R15: 000000000118bf2c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
