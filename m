Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0ABC426C7E
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242407AbhJHOME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:12:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240974AbhJHOMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:12:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BACE561056;
        Fri,  8 Oct 2021 14:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633702207;
        bh=GXJB3Kmmg0vzn8PCBDaLkdkw4ub7doSn3WPoxJna7Io=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=on3XrsRWZzhaND3TksGAEO/4T4hnuS1z75uMubKuFdF4Gt5ZRUtKqM2xn/g6hpt9j
         pcNm23+Jro2Mx6HTFgrE/Wmh6Kp++ownLkQ/l3jffJWGa1/WyvASqWB6mfzpwKiOxk
         djKRZcpFp1lcUXlRMfXxewsEgWlzjn1M5EjEEQwNGhdq2VlVXPJjRZaF03f0/yr03r
         u65nwD8elbb52DY3wlhWDuuTsyypHwvrtfBNcg7/Dv5u2/6KumKNtvGAeR5huoA4L3
         l3okrhh74mPGXnEv4ZPvMpSo8qsiIS3XtXNJ4FM1CxNi1Jpfd0r6aQ8Ws4u17FXFYx
         pi3alWHxOzEfg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC19460A44;
        Fri,  8 Oct 2021 14:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] net: add a helpers for loading
 netdev->dev_addr from platform
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163370220770.32461.3932582106955719897.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 14:10:07 +0000
References: <20211007181847.3529859-1-kuba@kernel.org>
In-Reply-To: <20211007181847.3529859-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, michael@walle.cc, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Oct 2021 11:18:44 -0700 you wrote:
> Similarly to recently added device_get_ethdev_address()
> and of_get_ethdev_address() create a helper for drivers
> loading mac addr from platform data.
> 
> nvmem_get_mac_address() does not have driver callers
> so instead of adding a helper there unexport it.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] ethernet: un-export nvmem_get_mac_address()
    https://git.kernel.org/netdev/net-next/c/da8f606e15c7
  - [net-next,v2,2/3] eth: platform: add a helper for loading netdev->dev_addr
    https://git.kernel.org/netdev/net-next/c/ba882580f211
  - [net-next,v2,3/3] ethernet: use platform_get_ethdev_address()
    https://git.kernel.org/netdev/net-next/c/4d04cdc5ee49

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


