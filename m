Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88292F0414
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 23:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbhAIWUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 17:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbhAIWUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 17:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C87032225E;
        Sat,  9 Jan 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610230807;
        bh=ecOZQspyVoHvbfdrVQ/Ay0EtULpvFj/rOmQiUzIBwn4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hvAReR5IV+jRf5dAhf3KFVa3o4dmZBW5NX8gYBwhd8esvHRsPiE2+QGxBsw9HvhIP
         N2q0TRIxO8hhZBgHDZ9ZRkM3c0DLHBMKhFhKaVJaTRZ5/Fz+tBVLCA1rddq9PHG3rq
         OcJ+syCsH4fqwX7cw2+asEzzvrihrUnImnuu37F3UfYCmNtPoqN68/LWLSOvnX6kZN
         b4ZHyal5VnDiry8kmNb7kCyAqSeBTXPmFm30ytmXuGg0Dzd1v+wj8135pLrqPqdgsO
         NduUFuL5DzPWiIoqr+ZdBjD2E3Cf03D6WS+29zXytO6DwAzItnM/dfVeIf+f8rCOiE
         ILaXSczmhavbw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id BB65A605AE;
        Sat,  9 Jan 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V3] net: ipv6: Validate GSO SKB before finish IPv6
 processing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161023080776.1972.10480180895140805173.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jan 2021 22:20:07 +0000
References: <1610027418-30438-1-git-send-email-ayal@nvidia.com>
In-Reply-To: <1610027418-30438-1-git-send-email-ayal@nvidia.com>
To:     Aya Levin <ayal@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dja@axtens.net,
        netdev@vger.kernel.org, moshe@mellanox.com, tariqt@nvidia.com,
        dan.carpenter@oracle.com, jengelh@medozas.de, kaber@trash.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  7 Jan 2021 15:50:18 +0200 you wrote:
> There are cases where GSO segment's length exceeds the egress MTU:
>  - Forwarding of a TCP GRO skb, when DF flag is not set.
>  - Forwarding of an skb that arrived on a virtualisation interface
>    (virtio-net/vhost/tap) with TSO/GSO size set by other network
>    stack.
>  - Local GSO skb transmitted on an NETIF_F_TSO tunnel stacked over an
>    interface with a smaller MTU.
>  - Arriving GRO skb (or GSO skb in a virtualised environment) that is
>    bridged to a NETIF_F_TSO tunnel stacked over an interface with an
>    insufficient MTU.
> 
> [...]

Here is the summary with links:
  - [net,V3] net: ipv6: Validate GSO SKB before finish IPv6 processing
    https://git.kernel.org/netdev/net/c/b210de4f8c97

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


