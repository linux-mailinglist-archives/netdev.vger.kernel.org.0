Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925AB3B962A
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbhGAScg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230123AbhGASce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:32:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 27FF461420;
        Thu,  1 Jul 2021 18:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625164204;
        bh=YEk/VCfFrK/bCUGYddsh8UDCp1qgUcPzkqxF4bd/JlY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V2vCRxHWaeD1qCw4ie3aRW9qXtlwOeQcpns7YqERNaGOI9wF9KSlhha7mk83zf7k3
         1hGghAULknkTZqdoFiiDiZmj0aY+gWrC6gWPq2g5TePOjYxc31dMgFmIvuVVGA3yt3
         7T72QaTpA+aiGwyLAp0e55p8ectUSMWlu2Byj1zoI/P4dKJ+hRZ56aeprJQL2nDDri
         mmFls/j6jj6jSZedXmwhiO2016F8FYgpH3j5n16OLMJHD+jkH3CvuGxrWEDrGaBLG9
         FRJy25B5izf25wrr7Zjeb1PYmtFZXiwCqOMU9iwOxvL4LWQDvWkYTLbZsyTPwsde5r
         zloTb34OC+qGg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 18FA760A56;
        Thu,  1 Jul 2021 18:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/802/garp: fix memleak in garp_request_join()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162516420409.17332.599996156094431434.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 18:30:04 +0000
References: <20210629115328.1328947-1-yangyingliang@huawei.com>
In-Reply-To: <20210629115328.1328947-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 29 Jun 2021 19:53:28 +0800 you wrote:
> I got kmemleak report when doing fuzz test:
> 
> BUG: memory leak
> unreferenced object 0xffff88810c909b80 (size 64):
>   comm "syz", pid 957, jiffies 4295220394 (age 399.090s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 08 00 00 00 01 02 00 04  ................
>   backtrace:
>     [<00000000ca1f2e2e>] garp_request_join+0x285/0x3d0
>     [<00000000bf153351>] vlan_gvrp_request_join+0x15b/0x190
>     [<0000000024005e72>] vlan_dev_open+0x706/0x980
>     [<00000000dc20c4d4>] __dev_open+0x2bb/0x460
>     [<0000000066573004>] __dev_change_flags+0x501/0x650
>     [<0000000035b42f83>] rtnl_configure_link+0xee/0x280
>     [<00000000a5e69de0>] __rtnl_newlink+0xed5/0x1550
>     [<00000000a5258f4a>] rtnl_newlink+0x66/0x90
>     [<00000000506568ee>] rtnetlink_rcv_msg+0x439/0xbd0
>     [<00000000b7eaeae1>] netlink_rcv_skb+0x14d/0x420
>     [<00000000c373ce66>] netlink_unicast+0x550/0x750
>     [<00000000ec74ce74>] netlink_sendmsg+0x88b/0xda0
>     [<00000000381ff246>] sock_sendmsg+0xc9/0x120
>     [<000000008f6a2db3>] ____sys_sendmsg+0x6e8/0x820
>     [<000000008d9c1735>] ___sys_sendmsg+0x145/0x1c0
>     [<00000000aa39dd8b>] __sys_sendmsg+0xfe/0x1d0
> 
> [...]

Here is the summary with links:
  - [net] net/802/garp: fix memleak in garp_request_join()
    https://git.kernel.org/netdev/net/c/42ca63f98084

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


