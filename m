Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F4433E21E
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhCPXaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhCPXaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:30:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 899BE64EEC;
        Tue, 16 Mar 2021 23:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615937408;
        bh=/Lt2pI2oCtWfhyV5A6PBHgt0N9yy9uALCBCL/g1cWII=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tY3BI4jv74Gb1E95bd8PIEvAiiFf5NDNNE6oxCbK0az178rf0RYLAlq7K55p370p3
         2VAoazSeqhNufEETDb6OMVAoc3mlF+Nk2HwYdqrbZO7l2TyRKuroWq9m7SAvrp6JwA
         SYe5fVGxuDaZxQezCAUARpD++QSyM8Bsw7JnVp6q07bs6JqzdgVX5PTS4+x0KlOzKT
         8WAZwnPjkoUnByQPpLngPljEriyAWvUsKwnqPlPoIhuO2ejyRaCM9YwLeNs4vDsi2c
         a1Adat9PPQM9ORJwaSYwky5H0BfahaKPUnQMriIaKvYjfg9fz1VKKDvH5ohFpzV6AZ
         uzAzA2gPIMwqA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 78F5B60A3D;
        Tue, 16 Mar 2021 23:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] net: ocelot: Extend MRP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593740849.31484.11641461729304594351.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 23:30:08 +0000
References: <20210316201019.3081237-1-horatiu.vultur@microchip.com>
In-Reply-To: <20210316201019.3081237-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Mar 2021 21:10:16 +0100 you wrote:
> This patch series extends the current support of MRP in Ocelot driver.
> Currently the forwarding of the frames happened in SW because all frames
> were trapped to CPU. With this patch the MRP frames will be forward in HW.
> 
> v1 -> v2:
>  - create a patch series instead of single patch
>  - rename ocelot_mrp_find_port to ocelot_mrp_find_partner_port
>  - rename PGID_MRP to PGID_BLACKHOLE
>  - use GFP_KERNEL instead of GFP_ATOMIC
>  - fix other whitespace issues
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: ocelot: Add PGID_BLACKHOLE
    https://git.kernel.org/netdev/net-next/c/ebb1bb401303
  - [net-next,v2,2/3] net: ocelot: Extend MRP
    https://git.kernel.org/netdev/net-next/c/7c588c3e96e9
  - [net-next,v2,3/3] net: ocelot: Remove ocelot_xfh_get_cpuq
    https://git.kernel.org/netdev/net-next/c/2ed2c5f03911

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


