Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED912DA647
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgLOCdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:33:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:47894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbgLOCd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:33:28 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607999565;
        bh=WYSwvgrlDpQVIIDoaLii3hzyMGUXaw29yrS/HV62spw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UZnv4UZ2yINMawrYcI650sixxc7fh+r4xlhZ7p5Xuuz7u8ZXTlKowaes8XCCHAeSp
         0wdof3vABQeaoW42Cb3oaWAUUpmERYYcXzChOfHymbYDL/ho4IdX1wCdgR/SUFP2+5
         YXMfDl+O4q6dhzGzJ0JmHBgAIJG5o1zY41ASWvG2CGolJ65ikDWMf5sIK2bvh6hG97
         I6GTV1ECISIKctHWpnRBtEtCQZjcQJSkUi+zpOqfKa0rF0B4n7ygGSqzFMFY0tLMyh
         xV/J5i5T+X5YVMPIc9rUCCqPSrBdvfLvjON7rjtnlc9dkUIVMQohdHs96BgisGhiGD
         RUpbrSCBtceXQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: bridge: Fix a warning when del bridge sysfs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160799956512.31445.17200550488514446402.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 02:32:45 +0000
References: <20201211122921.40386-1-wanghai38@huawei.com>
In-Reply-To: <20201211122921.40386-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     kuba@kernel.org, nikolay@nvidia.com, davem@davemloft.net,
        roopa@nvidia.com, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Dec 2020 20:29:21 +0800 you wrote:
> I got a warining report:
> 
> br_sysfs_addbr: can't create group bridge4/bridge
> ------------[ cut here ]------------
> sysfs group 'bridge' not found for kobject 'bridge4'
> WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group fs/sysfs/group.c:279 [inline]
> WARNING: CPU: 2 PID: 9004 at fs/sysfs/group.c:279 sysfs_remove_group+0x153/0x1b0 fs/sysfs/group.c:270
> Modules linked in: iptable_nat
> ...
> Call Trace:
>   br_dev_delete+0x112/0x190 net/bridge/br_if.c:384
>   br_dev_newlink net/bridge/br_netlink.c:1381 [inline]
>   br_dev_newlink+0xdb/0x100 net/bridge/br_netlink.c:1362
>   __rtnl_newlink+0xe11/0x13f0 net/core/rtnetlink.c:3441
>   rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3500
>   rtnetlink_rcv_msg+0x385/0x980 net/core/rtnetlink.c:5562
>   netlink_rcv_skb+0x134/0x3d0 net/netlink/af_netlink.c:2494
>   netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
>   netlink_unicast+0x4a0/0x6a0 net/netlink/af_netlink.c:1330
>   netlink_sendmsg+0x793/0xc80 net/netlink/af_netlink.c:1919
>   sock_sendmsg_nosec net/socket.c:651 [inline]
>   sock_sendmsg+0x139/0x170 net/socket.c:671
>   ____sys_sendmsg+0x658/0x7d0 net/socket.c:2353
>   ___sys_sendmsg+0xf8/0x170 net/socket.c:2407
>   __sys_sendmsg+0xd3/0x190 net/socket.c:2440
>   do_syscall_64+0x33/0x40 arch/x86/entry/common.c:46
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> [...]

Here is the summary with links:
  - [v2] net: bridge: Fix a warning when del bridge sysfs
    https://git.kernel.org/netdev/net-next/c/989a1db06eb1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


