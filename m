Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D18A2A1499
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 10:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgJaJQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 05:16:17 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:46296 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgJaJQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 05:16:15 -0400
Received: by mail-io1-f69.google.com with SMTP id a2so5900063iod.13
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 02:16:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xLjHG+oo1mvJiFjz/+5HaW1lg2ZdzALrAQFDD7i6P+4=;
        b=mgr6DIeyjYstkzL3TiRrb8sj0hTL2QsAvisXY85OSmHHgLTD7YiPRBmKoRtlVsMUOZ
         mb64zoapNhhJrXkIhayDlskx7hcqwQxbP+Us5wUs7DHVUBuheKp/nOYIczW3dNI39tmR
         uI7gY81qdIShP4ROXNJ+D0K6Q6nmHj7tjwrFCdmN1Iogz+cYMU1bG6S8ZpQH9FuHgKr9
         SJqbpzFEEaJPnEpP5r5pwOYyzyLI4ZBaKhsm8xGhRpVhPzDBI2jxFjbxuXN8c457Xqx5
         UtpGpxyJvELMsi/j4H9IDen6cOrGeUSUjQhG90DoZag6hX5uNR7F5aHxOXuTt+wxjNEi
         IctQ==
X-Gm-Message-State: AOAM530PEd+5/MvoYcsW2vfmBb1dybqMITYSY9KxTDJbs0h24FVEiTkv
        Km3TSRoKGWEns/uA3C7MaUqU0+u+hqsRSbAx1LWe2gJyJpsa
X-Google-Smtp-Source: ABdhPJyymRLz3SDl7zRbs5Pum0MM1Cng3fL3a2ckPs1cZq+o+VK4NOIZYyiwKy+2K4VJoFKW7mxuyYvpKn/abCHB3q695NImdMwY
MIME-Version: 1.0
X-Received: by 2002:a92:3f02:: with SMTP id m2mr4953938ila.231.1604135774393;
 Sat, 31 Oct 2020 02:16:14 -0700 (PDT)
Date:   Sat, 31 Oct 2020 02:16:14 -0700
In-Reply-To: <00000000000021315205b29353aa@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000011c9b05b2f3f7ce@google.com>
Subject: Re: WARNING in xfrm_alloc_compat
From:   syzbot <syzbot+a7e701c8385bd8543074@syzkaller.appspotmail.com>
To:     0x7f454c46@gmail.com, davem@davemloft.net, dima@arista.com,
        hdanton@sina.com, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    4e78c578 Add linux-next specific files for 20201030
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13284492500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=83318758268dc331
dashboard link: https://syzkaller.appspot.com/bug?extid=a7e701c8385bd8543074
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10191ea2500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1172adf4500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a7e701c8385bd8543074@syzkaller.appspotmail.com

------------[ cut here ]------------
unsupported nla_type 0
WARNING: CPU: 0 PID: 8479 at net/xfrm/xfrm_compat.c:279 xfrm_xlate64_attr net/xfrm/xfrm_compat.c:279 [inline]
WARNING: CPU: 0 PID: 8479 at net/xfrm/xfrm_compat.c:279 xfrm_xlate64 net/xfrm/xfrm_compat.c:300 [inline]
WARNING: CPU: 0 PID: 8479 at net/xfrm/xfrm_compat.c:279 xfrm_alloc_compat+0xf39/0x10d0 net/xfrm/xfrm_compat.c:327
Modules linked in:
CPU: 1 PID: 8479 Comm: syz-executor174 Not tainted 5.10.0-rc1-next-20201030-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:xfrm_xlate64_attr net/xfrm/xfrm_compat.c:279 [inline]
RIP: 0010:xfrm_xlate64 net/xfrm/xfrm_compat.c:300 [inline]
RIP: 0010:xfrm_alloc_compat+0xf39/0x10d0 net/xfrm/xfrm_compat.c:327
Code: de e8 3b 4a d2 f9 84 db 0f 85 b0 f8 ff ff e8 1e 52 d2 f9 8b 74 24 08 48 c7 c7 20 e5 51 8a c6 05 3b eb 3a 05 01 e8 e3 f2 0e 01 <0f> 0b e9 8d f8 ff ff e8 fb 51 d2 f9 8b 14 24 48 c7 c7 e0 e4 51 8a
RSP: 0018:ffffc900015cf378 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888021221a80 RSI: ffffffff8158ed95 RDI: fffff520002b9e61
RBP: 000000000000000c R08: 0000000000000001 R09: ffff8880b9e2005b
R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffffa1
R13: ffff888143d890f8 R14: ffff88801b8b4780 R15: ffff88802148c000
FS:  00000000017d3880(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd917a6b6c0 CR3: 000000001f6a2000 CR4: 00000000001506e0
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
 ____sys_sendmsg+0x331/0x810 net/socket.c:2362
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
 __sys_sendmmsg+0x195/0x470 net/socket.c:2506
 __do_sys_sendmmsg net/socket.c:2535 [inline]
 __se_sys_sendmmsg net/socket.c:2532 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2532
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440339
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffcd04d1fc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440339
RDX: 00000000000000f1 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401b40
R13: 0000000000401bd0 R14: 0000000000000000 R15: 0000000000000000

