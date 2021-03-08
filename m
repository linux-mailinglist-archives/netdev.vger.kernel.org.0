Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A5A330970
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 09:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhCHIee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 03:34:34 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54893 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229740AbhCHIeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 03:34:03 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id C3D2A5C0064;
        Mon,  8 Mar 2021 03:34:02 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 08 Mar 2021 03:34:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZRwC6g
        wNTrwFXDmB/P2zI3fjz7zOm2rbHj4LhW9mg1U=; b=Z/TrYt5SgTM+TNqvwmL+r9
        EaCTkji973ipx3M80DCFz7tER53lIPHshXhdbCievH1JNs6IlV+jzKeaHDjGNiPh
        rixGUTTag5jOPfsi8Frlxutb4HbWa9OgzBkpkAFkYQoSyXLpgsOQaAajchviXZhk
        wKvH0AfiQa34lVEBR0uXpMZbGJMMdLKwbuR8byimNP7LKpTgTu3hQBXM5BTGcvWa
        asiH46HOCvDRJNQTKpqORyhiZRbWq4IWHpKQu4+mwbItWPjUQKMwzKOJrDwNtmK4
        W/1zfOieg+e2D8z+NBTEB5KhZSH57YSuCayQ5UZb5UU7G/k/rM0IFfcqcm6y06cA
        ==
X-ME-Sender: <xms:euFFYDc1iSGH8QilOAe-z-9NnGhvL_lQLigmlvCMTiqB1j0i0RZWpw>
    <xme:euFFYJYIOIIhDV_6u5z6i-VPqEUztiTYch3g86fI8VrT34jEI1EvCCq1p6g1ApQA3
    tUydy01zqlqMkU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudduuddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecuogfuuhhsphgvtghtffhomhgrihhnucdlgeelmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepveffheehgeduieeiffdviedvueevieduudeiueehgfehteeggfevudeiteej
    hfelnecuffhomhgrihhnpehshiiikhgrlhhlvghrrdgrphhpshhpohhtrdgtohhmpdhgoh
    hordhglhenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorh
    hg
X-ME-Proxy: <xmx:euFFYOW0tO9bCtsBc-lnp-B9w0H7O9fPCi8b1o8hvd1QxvV7mvK8kQ>
    <xmx:euFFYDhBWa3WpZrMstIYSyDXrS1YYRheBAor73gYYM8P8MoKQjunfQ>
    <xmx:euFFYEUA0UwoBl97zJ-H6Md5Y1ywagAVLR_v5QKmObqXSAB0DzZTIw>
    <xmx:euFFYCWrDpOyAiydK8rmKNS4lSEo0YKmhwkE08uakqPR4BQJGlPAsQ>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id E958B1080063;
        Mon,  8 Mar 2021 03:34:01 -0500 (EST)
Date:   Mon, 8 Mar 2021 10:33:58 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     syzbot <syzbot+779559d6503f3a56213d@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING: ODEBUG bug in net_dm_cmd_trace
Message-ID: <YEXhdq6M0umpKvK8@shredder.lan>
References: <00000000000087674b05bcfd37a0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000087674b05bcfd37a0@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 06:30:27PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d310ec03 Merge tag 'perf-core-2021-02-17' of git://git.ker..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=108adb32d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2b8307379601586a
> dashboard link: https://syzkaller.appspot.com/bug?extid=779559d6503f3a56213d
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12ad095cd00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+779559d6503f3a56213d@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> ODEBUG: init active (active state 0) object type: timer_list hint: sched_send_work+0x0/0x60 include/linux/list.h:135

Will check. I think the problem is in the error path that does not
deactivate the timer

> WARNING: CPU: 1 PID: 8649 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> Modules linked in:
> CPU: 1 PID: 8649 Comm: syz-executor.0 Not tainted 5.11.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 40 4c bf 89 4c 89 ee 48 c7 c7 40 40 bf 89 e8 64 79 fa 04 <0f> 0b 83 05 15 e0 ff 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
> RSP: 0018:ffffc900021df438 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
> RDX: ffff888020cd1bc0 RSI: ffffffff815b4c85 RDI: fffff5200043be79
> RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815ade9e R11: 0000000000000000 R12: ffffffff896d8ea0
> R13: ffffffff89bf4540 R14: ffffffff8161d660 R15: ffffffff900042b0
> FS:  00007f73bb69e700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7a4370f470 CR3: 000000001334a000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  __debug_object_init+0x524/0xd10 lib/debugobjects.c:588
>  debug_timer_init kernel/time/timer.c:722 [inline]
>  debug_init kernel/time/timer.c:770 [inline]
>  init_timer_key+0x2d/0x340 kernel/time/timer.c:814
>  net_dm_trace_on_set net/core/drop_monitor.c:1111 [inline]
>  set_all_monitor_traces net/core/drop_monitor.c:1188 [inline]
>  net_dm_monitor_start net/core/drop_monitor.c:1295 [inline]
>  net_dm_cmd_trace+0x720/0x1220 net/core/drop_monitor.c:1339
>  genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
>  genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
>  genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
>  netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:672
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2348
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2402
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2435
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x465ef9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f73bb69e188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465ef9
> RDX: 0000000000000800 RSI: 0000000020000500 RDI: 0000000000000005
> RBP: 00007f73bb69e1d0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
> R13: 00007ffdb1c8cb0f R14: 00007f73bb69e300 R15: 0000000000022000
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
