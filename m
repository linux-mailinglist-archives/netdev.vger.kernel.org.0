Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74C3442201
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 21:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbhKAUy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 16:54:59 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55791 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229712AbhKAUy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 16:54:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 70E905C01A2;
        Mon,  1 Nov 2021 16:52:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 01 Nov 2021 16:52:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=+/m0Lq
        0oVXlkdOu7GxFGreA1a5dcGZ+cNitA/8F9N/0=; b=mwBfWzi7QIsz3wOxcWmeyq
        FSlVcjOkvnqhCucse9XTH/FscTgEHWewvPOgzA+yVwJjQOyFfNt5mK+xcg2ckhcU
        O+vjsn+gFSv2kiSuV+I9CjbkX88dnjZ1/TF9Ros5wr2vT965abJFUhpbaa8dcGzs
        mLU78cEOUshoGc2lgGsizGYdb8T24/XdauN3K8Xp/GRn1LSswhcmtc67Z6N3XTgd
        GGRkqm+lE3du80z0wZ/FEgQXl/Ax0QGv8sDld53Z8GZ5ygBYHFS0j5KCuHa2CqGv
        Mgu8xrcMfOtcUsdEnSbboTM5DmxtecDANyGOue0mGx+3VlyaesaJ/C5KKmjNtTLg
        ==
X-ME-Sender: <xms:iFOAYbmNHk104qz5r-caFZ5FnC86hkmLC6qrKPkAeoO0meuNaANwFg>
    <xme:iFOAYe2p2KWIwWsODS0ogkYIri0D5Vkl_bo5cEzfkmK6mA3A9HUXihqVGh0j1TnEW
    AK20HZJ7Wa7zJc>
X-ME-Received: <xmr:iFOAYRqgx2lAJKE5izkhuyg5sUunqbYBbxAPdKLEP6uV5LSffCMfoc-kR1JkU-VFAKdwhxxsBBArUdYMZgeAGu86pcM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdehvddgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:iFOAYTnzscyMKrAbhXeYTXt3IbDe1vfP1w5mS9BMQR3bWufwJSxvcA>
    <xmx:iFOAYZ2JGesR5s-AlgpGv7l_wHeKZLUj6OjWJN5lzlXOVxXKuUG4jw>
    <xmx:iFOAYStCJY8FpgS4Bxnnke9S75kguP4wvAYLkZaj4h9n0xmSc8zkKg>
    <xmx:iFOAYTrTHhWav3jRkT6gXeDVhW-Y1YWQlLnPtbmjrJltajuipKwnOA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 1 Nov 2021 16:52:23 -0400 (EDT)
Date:   Mon, 1 Nov 2021 22:52:19 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YYBTg4nW2BIVadYE@shredder>
References: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
 <YYABqfFy//g5Gdis@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYABqfFy//g5Gdis@nanopsycho>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 01, 2021 at 04:03:05PM +0100, Jiri Pirko wrote:
> Sun, Oct 31, 2021 at 06:35:56PM CET, leon@kernel.org wrote:
> >From: Leon Romanovsky <leonro@nvidia.com>
> >
> >Devlink reload was implemented as a special command which does _SET_
> >operation, but doesn't take devlink->lock, while recursive devlink
> >calls that were part of .reload_up()/.reload_down() sequence took it.
> >
> >This fragile flow was possible due to holding a big devlink lock
> >(devlink_mutex), which effectively stopped all devlink activities,
> >even unrelated to reloaded devlink.
> >
> >So let's make sure that devlink reload behaves as other commands and
> >use special nested locking primitives with a depth of 1. Such change
> >opens us to a venue of removing devlink_mutex completely, while keeping
> >devlink locking complexity in devlink.c.
> >
> >Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> Looks fine to me.
> 
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Traces from mlxsw / netdevsim below:

INFO: task syz-executor.0:569 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc7-custom-64786-g16ed1b4acff7 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:24856 pid:  569 ppid:     1 flags:0x00004004
Call Trace:
 context_switch kernel/sched/core.c:4940 [inline]
 __schedule+0x9da/0x22f0 kernel/sched/core.c:6287
 schedule+0xe5/0x280 kernel/sched/core.c:6366
 schedule_preempt_disabled+0x18/0x30 kernel/sched/core.c:6425
 __mutex_lock_common kernel/locking/mutex.c:669 [inline]
 __mutex_lock+0xc06/0x1630 kernel/locking/mutex.c:729
 mutex_lock_nested+0x1b/0x20 kernel/locking/mutex.c:743
 devlink_port_unregister+0x6a/0x260 net/core/devlink.c:9255
 __mlxsw_core_port_fini+0x4c/0x70 drivers/net/ethernet/mellanox/mlxsw/core.c:2787
 mlxsw_core_port_fini+0x3c/0x50 drivers/net/ethernet/mellanox/mlxsw/core.c:2817
 mlxsw_sp_port_remove+0x3a2/0x500 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:1807
 mlxsw_sp_ports_remove drivers/net/ethernet/mellanox/mlxsw/spectrum.c:1870 [inline]
 mlxsw_sp_fini+0xec/0x500 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:3095
 mlxsw_core_bus_device_unregister+0xdf/0x6c0 drivers/net/ethernet/mellanox/mlxsw/core.c:2091
 mlxsw_devlink_core_bus_device_reload_down+0x87/0xb0 drivers/net/ethernet/mellanox/mlxsw/core.c:1473
 devlink_reload+0x184/0x630 net/core/devlink.c:4040
 devlink_nl_cmd_reload+0x612/0x1320 net/core/devlink.c:4161
 genl_family_rcv_msg_doit.isra.0+0x253/0x370 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x389/0x620 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x173/0x480 net/netlink/af_netlink.c:2491
 genl_rcv+0x2e/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x5ae/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x8e1/0xe30 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 __sys_sendto+0x2b6/0x410 net/socket.c:2036
 __do_sys_sendto net/socket.c:2048 [inline]
 __se_sys_sendto net/socket.c:2044 [inline]
 __x64_sys_sendto+0xe6/0x1a0 net/socket.c:2044
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x41f91a
RSP: 002b:00007fffc5b2f5b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00000000014c4320 RCX: 000000000041f91a
RDX: 0000000000000038 RSI: 00000000014c4370 RDI: 0000000000000004
RBP: 0000000000000001 R08: 00007fffc5b2f5d4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000014c4370 R14: 0000000000000004 R15: 0000000000000000

Showing all locks held in the system:
3 locks held by kworker/1:0/20:
 #0: ffff88811aff0558 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x28/0x40 kernel/sched/core.c:474
 #1: ffffffff85ae9c20 (rcu_read_lock){....}-{1:2}, at: trace_sched_stat_runtime include/trace/events/sched.h:517 [inline]
 #1: ffffffff85ae9c20 (rcu_read_lock){....}-{1:2}, at: update_curr+0x1e3/0x7c0 kernel/sched/fair.c:852
 #2: ffff88811afdfcc0 (krc.lock){..-.}-{2:2}, at: kfree_rcu_work+0x549/0x10e0 kernel/rcu/tree.c:3288
1 lock held by khungtaskd/26:
 #0: ffffffff85ae9c20 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x5f/0x27f kernel/locking/lockdep.c:6448
1 lock held by systemd-journal/95:
1 lock held by in:imklog/410:
 #0: ffff88810da2cbc0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0xff/0x120 fs/file.c:990
4 locks held by rs:main Q:Reg/411:
5 locks held by syz-executor.0/569:
 #0: ffffffff862f26b8 (cb_lock){++++}-{3:3}, at: genl_rcv+0x1f/0x40 net/netlink/genetlink.c:802
 #1: ffffffff862f2790 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff862f2790 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x43d/0x620 net/netlink/genetlink.c:790
 #2: ffffffff862cec70 (devlink_mutex){+.+.}-{3:3}, at: devlink_nl_pre_doit+0x34/0xa10 net/core/devlink.c:575
 #3: ffff88810344c278 (&devlink->lock#2){+.+.}-{3:3}, at: devlink_nl_pre_doit+0x4ae/0xa10 net/core/devlink.c:582
 #4: ffff88810344c278 (&devlink->lock/1){+.+.}-{3:3}, at: devlink_port_unregister+0x6a/0x260 net/core/devlink.c:9255


INFO: task devlink:1172 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc7-custom-64786-g16ed1b4acff7 #536
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:devlink         state:D stack:25736 pid: 1172 ppid:   977 flags:0x00004000
Call Trace:
 __schedule+0xa14/0x2660
 schedule+0xd8/0x270
 schedule_preempt_disabled+0x14/0x20
 __mutex_lock+0xa1f/0x1320
 devlink_port_unregister+0xd2/0x2d0
 __nsim_dev_port_del+0x1c8/0x250 [netdevsim]
 nsim_dev_reload_destroy+0x1a3/0x2f0 [netdevsim]
 nsim_dev_reload_down+0x105/0x1a0 [netdevsim]
 devlink_reload+0x52a/0x6a0
 devlink_nl_cmd_reload+0x71d/0x1210
 genl_family_rcv_msg_doit+0x22a/0x320
 genl_rcv_msg+0x341/0x5a0
 netlink_rcv_skb+0x14d/0x430
 genl_rcv+0x29/0x40
 netlink_unicast+0x539/0x7e0
 netlink_sendmsg+0x84d/0xd80
 __sys_sendto+0x23f/0x350
 __x64_sys_sendto+0xe2/0x1b0
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fd4f9d0314a
RSP: 002b:00007fff18371848 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fd4f9d0314a
RDX: 0000000000000034 RSI: 00000000006f0ad0 RDI: 0000000000000003
RBP: 00000000006f0aa0 R08: 00007fd4f9dd9200 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000408d80
R13: 00000000006f0910 R14: 0000000000000000 R15: 0000000000000001
                             
Showing all locks held in the system:
1 lock held by khungtaskd/62: 
 #0: ffffffff83ca4aa0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x53/0x28c
3 locks held by kworker/4:2/144:
 #0: ffff888100101548 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x8ac/0x16f0
 #1: ffffc9000209fdb0 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: process_one_work+0x8e0/0x16f0
 #2: ffff888123f9d440 (&nsim_dev->port_list_lock){+.+.}-{3:3}, at: nsim_dev_trap_report_work+0x62/0xbc0 [netdevsim]
1 lock held by dmesg/1045:
7 locks held by devlink/1172: 
 #0: ffffffff8423dbd8 (cb_lock){++++}-{3:3}, at: genl_rcv+0x1a/0x40
 #1: ffffffff8423dcb0 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x3f9/0x5a0
 #2: ffffffff84222050 (devlink_mutex){+.+.}-{3:3}, at: devlink_nl_pre_doit+0x30/0xa20
 #3: ffff888123f9d278 (&devlink->lock#2){+.+.}-{3:3}, at: devlink_nl_pre_doit+0x376/0xa20
 #4: ffff888176758d10 (&nsim_bus_dev->nsim_bus_reload_lock){+.+.}-{3:3}, at: nsim_dev_reload_down+0x52/0x1a0 [netdevsim]
 #5: ffff888123f9d440 (&nsim_dev->port_list_lock){+.+.}-{3:3}, at: nsim_dev_reload_destroy+0x142/0x2f0 [netdevsim]
 #6: ffff888123f9d278 (&devlink->lock/1){+.+.}-{3:3}, at: devlink_port_unregister+0xd2/0x2d0
