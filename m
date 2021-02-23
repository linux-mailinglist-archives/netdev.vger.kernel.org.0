Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EA2322CB7
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 15:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhBWOsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 09:48:09 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:44201 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbhBWOsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 09:48:01 -0500
Received: by mail-il1-f200.google.com with SMTP id a9so10443474ilm.11
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 06:47:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=P+zFeH+d72qPP3Q6ls0umAtZ7gXIoT+uMcJ3RoGOWxA=;
        b=Q5SctxHVkEZtJPlLiJGA9fyd8ix7te5OkyW0QzUg3VTDJ5rGgTCz9oqwPrBfLLLbcN
         0PSvgS9IHj6PRoK7+SEEbAbKyE9N/dz9/mi3ASFR+IbtZ2yLG/kvnjm5dbhhmWj7SoVT
         AlVrA+vNiq7mZudEM0uSmW0PJBd97ZtvtQmdoswVSUaP0TedNVA4EAFxSL9OnVn1FWxb
         LKYjP8m+nVBVgCZouUG9ag+otPEENJLHEEXhsoWUWOMFF+WUSKBONl7sXRkaYJZplwFh
         XL/sm24ztKAuY6agGCVud5OK7SteiHPQkMMCCA4zyVJN41ZPpoq4UnmEolKl4N3cVeJb
         Iicg==
X-Gm-Message-State: AOAM531iRSG3AB9tEpF9opjcohAPPO2BL+loWLhyqslls4/69S3t+hJz
        NW9J0TDv2E8GRvwjwPqOYTHN91Aw3GB2xXTGDoGuJwPBieCY
X-Google-Smtp-Source: ABdhPJxYu+T1N9kSUPvH/8XW1KO+HxHjJ6RaJOROleftkMaW4UhFJnxRbIR/3rE9JDE4MrpcMpHT7NpAuGvGLA6ZI9hT0yrVuHh3
MIME-Version: 1.0
X-Received: by 2002:a6b:7619:: with SMTP id g25mr20689499iom.177.1614091640122;
 Tue, 23 Feb 2021 06:47:20 -0800 (PST)
Date:   Tue, 23 Feb 2021 06:47:20 -0800
In-Reply-To: <00000000000056c3e005b82689d1@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d8369805bc01fe68@google.com>
Subject: Re: general protection fault in xfrm_user_rcv_msg_compat
From:   syzbot <syzbot+5078fc2d7cf37d71de1c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    a99163e9 Merge tag 'devicetree-for-5.12' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a6fccad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a875029a795d230
dashboard link: https://syzkaller.appspot.com/bug?extid=5078fc2d7cf37d71de1c
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167c1832d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10214f12d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5078fc2d7cf37d71de1c@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xe51af2c1f2c7bd20: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0x28d7b60f963de900-0x28d7b60f963de907]
CPU: 1 PID: 8357 Comm: syz-executor113 Not tainted 5.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_type include/net/netlink.h:1130 [inline]
RIP: 0010:xfrm_xlate32_attr net/xfrm/xfrm_compat.c:404 [inline]
RIP: 0010:xfrm_xlate32 net/xfrm/xfrm_compat.c:526 [inline]
RIP: 0010:xfrm_user_rcv_msg_compat+0x5e5/0x1070 net/xfrm/xfrm_compat.c:571
Code: 3c 38 00 0f 85 50 08 00 00 48 8b 04 24 4c 8b 20 4d 85 e4 0f 84 0b 02 00 00 e8 b7 7f c9 f9 49 8d 7c 24 02 48 89 f8 48 c1 e8 03 <42> 0f b6 14 38 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85
RSP: 0018:ffffc900017ff3d8 EFLAGS: 00010202
RAX: 051af6c1f2c7bd20 RBX: 0000000000000006 RCX: 0000000000000000
RDX: ffff88801ac60000 RSI: ffffffff87a9f019 RDI: 28d7b60f963de902
RBP: ffff888020c9af50 R08: 000000000000001b R09: ffff888020c9af53
R10: ffffffff87a9f259 R11: 0000000000000024 R12: 28d7b60f963de900
R13: 0000000000000007 R14: ffff888020c9af40 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0063) knlGS:0000000009c092c0
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000020002752 CR3: 000000002d87a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 xfrm_user_rcv_msg+0x556/0x8b0 net/xfrm/xfrm_user.c:2774
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2824
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
 do_syscall_32_irqs_on arch/x86/entry/common.c:77 [inline]
 __do_fast_syscall_32+0x56/0x80 arch/x86/entry/common.c:139
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:164
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f48549
Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000ffca8dbc EFLAGS: 00000282 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000020003c80
RDX: 0000000000000000 RSI: 00000000ffca8e10 RDI: 00000000080e3000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 1494ca3373de8f76 ]---
RIP: 0010:nla_type include/net/netlink.h:1130 [inline]
RIP: 0010:xfrm_xlate32_attr net/xfrm/xfrm_compat.c:404 [inline]
RIP: 0010:xfrm_xlate32 net/xfrm/xfrm_compat.c:526 [inline]
RIP: 0010:xfrm_user_rcv_msg_compat+0x5e5/0x1070 net/xfrm/xfrm_compat.c:571
Code: 3c 38 00 0f 85 50 08 00 00 48 8b 04 24 4c 8b 20 4d 85 e4 0f 84 0b 02 00 00 e8 b7 7f c9 f9 49 8d 7c 24 02 48 89 f8 48 c1 e8 03 <42> 0f b6 14 38 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85
RSP: 0018:ffffc900017ff3d8 EFLAGS: 00010202
RAX: 051af6c1f2c7bd20 RBX: 0000000000000006 RCX: 0000000000000000
RDX: ffff88801ac60000 RSI: ffffffff87a9f019 RDI: 28d7b60f963de902
RBP: ffff888020c9af50 R08: 000000000000001b R09: ffff888020c9af53
R10: ffffffff87a9f259 R11: 0000000000000024 R12: 28d7b60f963de900
R13: 0000000000000007 R14: ffff888020c9af40 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0063) knlGS:0000000009c092c0
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00007efcea642000 CR3: 000000002d87a000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

