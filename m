Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2496E438C63
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 00:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhJXWhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 18:37:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45647 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231733AbhJXWha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 18:37:30 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id EAEC45C067F;
        Sun, 24 Oct 2021 05:05:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 24 Oct 2021 05:05:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ioU6lK
        lAJErQXd1hx0plMH/SF/kxBti1Ef79yilWQ6Y=; b=jv+c18Tc9MR9rR7L56V+AM
        YOYCL66UMdVa7EgE/xlXNXQi6ZK2+HtVbYJK+Zy/0nXks13yaWyTrQLp2oLBcatJ
        UMsvF85QbQdjFXmDojylrVdouSwNwJ7OH3p6rNH9mnJtP7cYAT/ojms4POV9Igy+
        PJB2MjPV52a1UooQBBwCCdqZ/Tb7BY30afFSZheQUrk7z5r4cbqMfcasZz3Qd5eL
        0WIsbaJLBfP4py9IBIYyDKkTCWOmYwM90YodwMCo6A2Sg864unfTV+vUVDoaDiKR
        IOQ+UE9Cw7x2Adf80RNqybCoDaVJhu+rZc6pJIl6v7A38Fw2PqstF0GQctBLgYqQ
        ==
X-ME-Sender: <xms:zSF1YVUK4TqgoRgF4sDt0UpQYdbgMJ2ZWVESh_Kc1cHiTMZ7XTvaJw>
    <xme:zSF1YVnga8XcJNWP0teH4gG16qSlHUqQfgBv8WiyMrBUA2xDGK3qfUlzKQqDop3Hi
    -sIIfbIGl2Akq4>
X-ME-Received: <xmr:zSF1YRbU6vFFolKb3SIDsEGYSldFpVZkXH2todqOlSMu-pzCpXjg-E6wPeloypxiBlLF1FoanjkaunYN68KxAYCAozw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefvddgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffveegjeeijeeiieeghedtudeftedtvdduvdekieefffekudegleffuefftefh
    hfenucffohhmrghinhepqhgvmhhurdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zSF1YYV9s9in1cPkg6dEssgLOc6nMlnGJSkJ72Nk9Is_UsIpp3EExg>
    <xmx:zSF1YfmzEdBygglD56OcMdeEDml-m19Z4r2RvPxnCRNGMW3PynU1gg>
    <xmx:zSF1YVfzrdfTwZBcpX--FUtSrLE6aqHDF8EkQJS_9zaMKiLE_8uIXQ>
    <xmx:zSF1YdauKe9FdSofK_HXdZew0K_eGIRVIw4oxGhoDwRjqdg6vgRtKA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 24 Oct 2021 05:05:16 -0400 (EDT)
Date:   Sun, 24 Oct 2021 12:05:12 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <YXUhyLXsc2egWNKx@shredder>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 11:42:11AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Align netdevsim to be like all other physical devices that register and
> unregister devlink traps during their probe and removal respectively.

No, this is incorrect. Out of the three drivers that support both reload
and traps, both netdevsim and mlxsw unregister the traps during reload.
Here is another report from syzkaller about mlxsw [1].

Please revert both 22849b5ea595 ("devlink: Remove not-executed trap
policer notifications") and 8bbeed485823 ("devlink: Remove not-executed
trap group notifications").

Thanks

[1]
------------[ cut here ]------------
WARNING: CPU: 1 PID: 556 at net/core/devlink.c:11162 devlink_trap_groups_unregister+0xf6/0x120 net/core/devlink.c:11162
Modules linked in:
CPU: 1 PID: 556 Comm: syz-executor.0 Not tainted 5.15.0-rc6-custom-64140-gb38f6d83c5b7 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:devlink_trap_groups_unregister+0xf6/0x120 net/core/devlink.c:11162
Code: de 31 ff e8 7c 13 12 fe 83 fb ff 75 cc e8 d2 11 12 fe 4c 89 ff e8 ca 50 94 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 ba 11 12 fe <0f> 0b e9 6e ff ff ff 4c 89 ef e8 1b a6 57 fe e9 37 ff ff ff 4c 89
RSP: 0018:ffffc9000116f490 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffffffff8350e302
RDX: 0000000000000000 RSI: ffff8881022655c0 RDI: 0000000000000002
RBP: ffffc9000116f4b8 R08: ffff8881022655c0 R09: fffffbfff0dfa61d
R10: 1ffff110235c42fa R11: fffffbfff0dfa61c R12: ffff88810a0bce28
R13: ffff8881033dc000 R14: 0000000000000001 R15: ffffed102071ebbb
FS:  0000000003152980(0000) GS:ffff88811ae00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055dad1f080f0 CR3: 0000000053fc4000 CR4: 00000000000006e0
Call Trace:
 mlxsw_sp_trap_groups_fini+0x10a/0x1c0 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c:1411
 mlxsw_sp_devlink_traps_fini+0x175/0x1e0 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c:1540
 mlxsw_sp_fini+0x3cb/0x500 drivers/net/ethernet/mellanox/mlxsw/spectrum.c:3114
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
RIP: 0033:0x41f86a
Code: 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 76 c3 0f 1f 44 00 00 55 48 83 ec 30 44 89 4c
RSP: 002b:00007ffdb75a9918 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00000000014c4320 RCX: 000000000041f86a
RDX: 0000000000000038 RSI: 00000000014c4370 RDI: 0000000000000004
RBP: 0000000000000001 R08: 00007ffdb75a9934 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00000000014c4370 R14: 0000000000000004 R15: 0000000000000000
