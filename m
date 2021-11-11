Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8598144D1FB
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 07:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhKKGqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 01:46:10 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:56054 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhKKGqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 01:46:09 -0500
Received: by mail-io1-f71.google.com with SMTP id y74-20020a6bc84d000000b005e700290338so3394266iof.22
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 22:43:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=mnls3d+B5dNpFY4b4y80Brjr8wlqrHuUE32ifq4dCs8=;
        b=h5R64x+WNKGpQOZdJ1jPIV+mS3YOgcwk6BblQGdgL5MUljKkV2mzxgmktmFiyoxcP1
         4dJi9Ktpw3CJxn17dzi29A9jp3Y3aBLkE3M2Wyfq6N6TO/Fb3vo4kBlZBGGH+YX5Tq60
         2LsYU2mkVVLnGGQuYpNsxuxQsCWEnI0F4BZct80eCcDPv5REX659hR2uM6M0Ug4PAZGf
         btnMOgDVqY4NkPN4zCpkqSJaTH2J+nhVt/wXgdKXel10+RDCQbP8chjr+lda8khVr+C0
         NeZicb6fdOCYToHb2jf9iLimMNuAIZRvCtAF9HL/P74kp3WjXFG2i9RF5FQMaZA8etIY
         I0Xg==
X-Gm-Message-State: AOAM530gW9QoXfidb05/zkeRdkT5RqGNRft80re7kdz2r94ncqKZ7fMc
        3b/2XDL7BhWOxemtx2mZ9Nx2m+5Jiw2qX5c8Ys0zyOMsH1So
X-Google-Smtp-Source: ABdhPJwA57G8Lx4oLqI477r2EWE3KPXCpaPPjX1Ze5ECwkKzAOip1D1Ie0wh3HxAAwqEy/qD2XyMFpdoT6dMY3KnFpfmeynDLMds
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1561:: with SMTP id k1mr2998713ilu.135.1636613000688;
 Wed, 10 Nov 2021 22:43:20 -0800 (PST)
Date:   Wed, 10 Nov 2021 22:43:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008a7c9605d07da846@google.com>
Subject: [syzbot] WARNING in __dev_change_net_namespace
From:   syzbot <syzbot+5434727aa485c3203fed@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, avagin@gmail.com,
        bpf@vger.kernel.org, cong.wang@bytedance.com, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, johannes.berg@intel.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    512b7931ad05 Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b45fb6b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=99780e4a2873b273
dashboard link: https://syzkaller.appspot.com/bug?extid=5434727aa485c3203fed
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5434727aa485c3203fed@syzkaller.appspotmail.com

RAX: ffffffffffffffda RBX: 00007f02bf014f60 RCX: 00007f02bef01ae9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00007f02bc4771d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007ffcc2738d7f R14: 00007f02bc477300 R15: 0000000000022000
 </TASK>
------------[ cut here ]------------
WARNING: CPU: 0 PID: 4974 at net/core/dev.c:11254 __dev_change_net_namespace+0x1079/0x1330 net/core/dev.c:11254
Modules linked in:
CPU: 0 PID: 4974 Comm: syz-executor.2 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__dev_change_net_namespace+0x1079/0x1330 net/core/dev.c:11254
Code: c7 c7 80 9b 8c 8a c6 05 ba 0e 3b 06 01 e8 36 73 d5 01 0f 0b e9 69 f0 ff ff e8 e3 95 57 fa 0f 0b e9 60 fb ff ff e8 d7 95 57 fa <0f> 0b e9 2a fb ff ff 41 bd ea ff ff ff e9 62 f2 ff ff e8 f0 38 9e
RSP: 0018:ffffc900217aed70 EFLAGS: 00010246
RAX: 0000000000040000 RBX: 00000000fffffff4 RCX: ffffc9000b291000
RDX: 0000000000040000 RSI: ffffffff87202d59 RDI: 0000000000000003
RBP: ffff88815cbea000 R08: 0000000000000000 R09: ffff88815cbea64b
R10: ffffffff87202882 R11: 0000000000000000 R12: dffffc0000000000
R13: ffffffff8d0e3dc0 R14: ffff88815cbeac00 R15: ffffffff8d0e3f0c
FS:  00007f02bc477700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32027000 CR3: 0000000162d58000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 do_setlink+0x275/0x3970 net/core/rtnetlink.c:2624
 __rtnl_newlink+0xde6/0x1750 net/core/rtnetlink.c:3391
 rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3506
 rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2491
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f02bef01ae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f02bc477188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f02bf014f60 RCX: 00007f02bef01ae9
RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
RBP: 00007f02bc4771d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 00007ffcc2738d7f R14: 00007f02bc477300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
