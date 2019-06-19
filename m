Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E9E4BE57
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbfFSQfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 12:35:12 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51273 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725899AbfFSQfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 12:35:12 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1E3F3223AD;
        Wed, 19 Jun 2019 12:35:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 19 Jun 2019 12:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QWszy1
        QIZnq1jTGoaVFxRLAtJXpnXGB4FyzDJyOceJ0=; b=ITt4xmstYiV1EbvbS00vri
        3GD/I46andthTRF0WUtHJblgiDmB857RUr7BD7mvEmsLEl1Qvr6GbFrZMPvG0qWi
        o3N3G/Thig+ItN7LBJ0MiPomXApVTdUccKE4FxIgn/syoLQGhDLMz4Q8GV4HmJOZ
        trXuebsm22ZzLwNVGeIYWR/ISO41IUW75nDZv+w6EyYwe6+PxkjxhRNORQcDFKy+
        Fi+8gIyN80F9XdgMoSlfyTNW4VIqmdDNNQw8ptggFh/JCOBm+SPMMR6KiVN8z9xn
        eYAfu6oxdithER5xHhdf8NhkXIQfxiD+LNSavT+Sv4xbLmueDZMRD/HEKe7x6y5A
        ==
X-ME-Sender: <xms:PWQKXYVnTu53V7EkhYPmUZmYT0JAHOPcpWO1gogp4icu8hteJmvKTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddvgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecuogfuuhhsphgvtghtffhomhgrihhnucdlgeelmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinh
    epthgvshhtshdrnhgvthdpghhoohdrghhlpdgrphhpshhpohhtrdgtohhmnecukfhppedu
    leefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:PWQKXTd4LMijvR3frMovsmHVL-5JeNGcrq8i5eQMOxHeRC75ergFZg>
    <xmx:PWQKXUsst1a2aP06I4Mptvl9Y3PJWqiWTE8xf2EftiUqjHPjdAgnxg>
    <xmx:PWQKXS9ojuIe2HPaawGzFYB0QyxRnpj_Ug5et8jei_hKgBelqttgGA>
    <xmx:P2QKXXv_1UsVIDG3nDd46QsweVjP8bdxHEUTTqt5yeVs34p5wRf7xw>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F3E938008D;
        Wed, 19 Jun 2019 12:35:09 -0400 (EDT)
Date:   Wed, 19 Jun 2019 19:35:07 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     syzbot <syzbot+382566d339d52cd1a204@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, dsahern@gmail.com, idosch@mellanox.com,
        jiri@mellanox.com, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Subject: Re: general protection fault in call_fib6_multipath_entry_notifiers
Message-ID: <20190619163507.GA2080@splinter>
References: <0000000000004237d7058baf24e3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000004237d7058baf24e3@google.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 08:47:07AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    39f58860 net/mlx5: add missing void argument to function m..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=115eb99ea00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=4937094fc643655f
> dashboard link: https://syzkaller.appspot.com/bug?extid=382566d339d52cd1a204
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=120c9e11a00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120c3d21a00000
> 
> The bug was bisected to:
> 
> commit ebee3cad835f7fe7250213225cf6d62c7cf3b2ca
> Author: Ido Schimmel <idosch@mellanox.com>
> Date:   Tue Jun 18 15:12:48 2019 +0000
> 
>     ipv6: Add IPv6 multipath notifications for add / replace
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1529970aa00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=1729970aa00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1329970aa00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+382566d339d52cd1a204@syzkaller.appspotmail.com
> Fixes: ebee3cad835f ("ipv6: Add IPv6 multipath notifications for add /
> replace")
> 
> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 9190 Comm: syz-executor149 Not tainted 5.2.0-rc5+ #38
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:call_fib6_multipath_entry_notifiers+0xd1/0x1a0

Did not consider the case where RTA_MULTIPATH does not encode valid
nexthop information in which case 'rt_notif' can be NULL. Will send a
fix after I run some tests.

> net/ipv6/ip6_fib.c:396
> Code: 8b b5 30 ff ff ff 48 c7 85 68 ff ff ff 00 00 00 00 48 c7 85 70 ff ff
> ff 00 00 00 00 89 45 88 4c 89 e0 48 c1 e8 03 4c 89 65 80 <42> 80 3c 28 00 0f
> 85 9a 00 00 00 48 b8 00 00 00 00 00 fc ff df 4d
> RSP: 0018:ffff88809788f2c0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 1ffff11012f11e59 RCX: 00000000ffffffff
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff88809788f390 R08: ffff88809788f8c0 R09: 000000000000000c
> R10: ffff88809788f5d8 R11: ffff88809788f527 R12: 0000000000000000
> R13: dffffc0000000000 R14: ffff88809788f8c0 R15: ffffffff89541d80
> FS:  000055555632c880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000080 CR3: 000000009ba7c000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  ip6_route_multipath_add+0xc55/0x1490 net/ipv6/route.c:5094
>  inet6_rtm_newroute+0xed/0x180 net/ipv6/route.c:5208
>  rtnetlink_rcv_msg+0x463/0xb00 net/core/rtnetlink.c:5219
>  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
>  rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5237
>  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
>  netlink_unicast+0x531/0x710 net/netlink/af_netlink.c:1328
>  netlink_sendmsg+0x8ae/0xd70 net/netlink/af_netlink.c:1917
>  sock_sendmsg_nosec net/socket.c:646 [inline]
>  sock_sendmsg+0xd7/0x130 net/socket.c:665
>  ___sys_sendmsg+0x803/0x920 net/socket.c:2286
>  __sys_sendmsg+0x105/0x1d0 net/socket.c:2324
>  __do_sys_sendmsg net/socket.c:2333 [inline]
>  __se_sys_sendmsg net/socket.c:2331 [inline]
>  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2331
>  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x4401f9
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff
> 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffc09fd0028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004401f9
> RDX: 0000000000000000 RSI: 0000000020000080 RDI: 0000000000000003
> RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401a80
> R13: 0000000000401b10 R14: 0000000000000000 R15: 0000000000000000
> Modules linked in:
> ---[ end trace 77949df4cfac115c ]---
> RIP: 0010:call_fib6_multipath_entry_notifiers+0xd1/0x1a0
> net/ipv6/ip6_fib.c:396
> Code: 8b b5 30 ff ff ff 48 c7 85 68 ff ff ff 00 00 00 00 48 c7 85 70 ff ff
> ff 00 00 00 00 89 45 88 4c 89 e0 48 c1 e8 03 4c 89 65 80 <42> 80 3c 28 00 0f
> 85 9a 00 00 00 48 b8 00 00 00 00 00 fc ff df 4d
> RSP: 0018:ffff88809788f2c0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 1ffff11012f11e59 RCX: 00000000ffffffff
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffff88809788f390 R08: ffff88809788f8c0 R09: 000000000000000c
> R10: ffff88809788f5d8 R11: ffff88809788f527 R12: 0000000000000000
> R13: dffffc0000000000 R14: ffff88809788f8c0 R15: ffffffff89541d80
> FS:  000055555632c880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020000080 CR3: 000000009ba7c000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
