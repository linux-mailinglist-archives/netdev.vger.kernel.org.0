Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EE2380F24
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 19:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235223AbhENRlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 13:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235203AbhENRlW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 13:41:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ACFB6613EC;
        Fri, 14 May 2021 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621014010;
        bh=CHAnB1pfuBs2+dJhQpiQfNIilrMPD/OFF3k1pVrjHjo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZaVrdJTkD9/gljSUysvvloVzeGDTG2bwmKVWUWKmA/Dl2OXHjf6imQsW6K/gA1rVG
         TwsA9WnI3a8E1ypvK7jEucHb78uspAC8YNF5mafxzDk24yE5U0JygYS5H4re/7t5FT
         zLWs0FsucUr3ZgyGFFQp9qPTKeeT8LVgjMY+xZHV/1qSuEGPdHf3WGuW4dPGxqo6Fu
         pBbhAun51M9XG7WLd+piGoNQGYh3b11MLy1chJG82Mh2iSrj2G1is0lnLOFsEG12et
         KCP/UQ8MrZUCw1PWgrnswvyeFmlPg5qmb54dTcpgRvklEACk4Z/t1MoHPju8ZkIgvi
         KLMDWJ66noNUQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A15E360A2C;
        Fri, 14 May 2021 17:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: fix build when IPv6 is disabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162101401065.20897.4000953716606078069.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 17:40:10 +0000
References: <20210514015348.15448-1-mcroce@linux.microsoft.com>
In-Reply-To: <20210514015348.15448-1-mcroce@linux.microsoft.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        linus.luessing@c0d3.blue, roopa@nvidia.com, nikolay@nvidia.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 14 May 2021 03:53:48 +0200 you wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> The br_ip6_multicast_add_router() prototype is defined only when
> CONFIG_IPV6 is enabled, but the function is always referenced, so there
> is this build error with CONFIG_IPV6 not defined:
> 
> net/bridge/br_multicast.c: In function ‘__br_multicast_enable_port’:
> net/bridge/br_multicast.c:1743:3: error: implicit declaration of function ‘br_ip6_multicast_add_router’; did you mean ‘br_ip4_multicast_add_router’? [-Werror=implicit-function-declaration]
>  1743 |   br_ip6_multicast_add_router(br, port);
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |   br_ip4_multicast_add_router
> net/bridge/br_multicast.c: At top level:
> net/bridge/br_multicast.c:2804:13: warning: conflicting types for ‘br_ip6_multicast_add_router’
>  2804 | static void br_ip6_multicast_add_router(struct net_bridge *br,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> net/bridge/br_multicast.c:2804:13: error: static declaration of ‘br_ip6_multicast_add_router’ follows non-static declaration
> net/bridge/br_multicast.c:1743:3: note: previous implicit declaration of ‘br_ip6_multicast_add_router’ was here
>  1743 |   br_ip6_multicast_add_router(br, port);
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: fix build when IPv6 is disabled
    https://git.kernel.org/netdev/net-next/c/30515832e987

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


