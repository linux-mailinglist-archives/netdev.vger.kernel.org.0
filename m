Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C7D456E23
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhKSLXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:23:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235038AbhKSLXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 06:23:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 78C4A61B42;
        Fri, 19 Nov 2021 11:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637320829;
        bh=31gGjr3nOsXqS3vqt1ddLN/8jBc+1ijCedhZw/F9Wu0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A5r4cxdXVCFise9rEhEcQ2lCKZzWfMgglmryT5/LWziZ+o0bcDovZnfPTzGOnqrb9
         647Advk//AVoJTjRsGBxspArouMCHV2A4nuX1X5xMJHAXWcgunnn2ZEhUsdkfIOBP8
         xJc+hn0zWYbH6sDNZEdnetZUK0XiLP/QKictaXXpXjSZgEIxVsgO9ScOUoyP8qzqp7
         sl1G8rdSPbGQf6WV9EDQ7m8VvlDrXxQkGZjoLXNMSIBGfQM3Hg+T8vXsrhqOeQesSt
         95K6yrSk7RjV24uv6iG2jO09TMP6mi1TULvGHE7mIJW26U0dYURt7nWLM+fCB64Hpx
         ri0qiAWYqNAkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 73A05600E8;
        Fri, 19 Nov 2021 11:20:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: add 1000base-KX to
 phylink_caps_to_linkmodes()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732082946.28994.2236847037665000991.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 11:20:29 +0000
References: <E1mnloQ-008LYK-Rp@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mnloQ-008LYK-Rp@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 18:07:06 +0000 you wrote:
> 1000base-KX was missed in phylink_caps_to_linkmodes(), add it. This
> will be necessary to convert stmmac with xpcs to ensure we don't drop
> any supported linkmodes.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net-next] net: phylink: add 1000base-KX to phylink_caps_to_linkmodes()
    https://git.kernel.org/netdev/net-next/c/ec574d9ee5d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


