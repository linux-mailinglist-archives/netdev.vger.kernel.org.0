Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0139F31D27E
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhBPWLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:11:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhBPWKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 17:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9755E64E0F;
        Tue, 16 Feb 2021 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613513408;
        bh=ZaNwjEmIhXQgT8LZVncFAK/WEAOdGAp9xIktBYcnoIA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WQDSpa6qBq4AcWY1zwEJE73DsuvzQPuY0DoRGg261OmtnpH42XaYYMNXUZxbzAoE/
         zd+J85NWjvU5hqzd992GM/09/yssP3Eh1UzZVtgPsUrVOeJLUu/T09tIt0KghjTCPZ
         3R/05IWtZb+wbC5PaSA8hgWpXff+8vQyxjegDfq1SofeHhKxYJESC2vaayeljOGV/s
         AZ/wX8EqftuLH4FrTA3rykQyZcqSePBE2rWgoQSj9LSUQ5tDvenxYPhqdSN3mjsGAd
         AoMvWl/qfD52z0Du47BDr6cKWDR5UYHlUbsA9/vIZ9gVqvS/bq3BZx9//JJvNLX/Wl
         5ysNF5ppwFuAQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 88F8160A0D;
        Tue, 16 Feb 2021 22:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: felix: perform teardown on error in
 felix_setup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351340855.15084.15305513018213877507.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 22:10:08 +0000
References: <20210216113213.2854324-1-olteanv@gmail.com>
In-Reply-To: <20210216113213.2854324-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 13:32:13 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> If the driver fails to probe, it would be nice to not leak memory.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> I've decided to target this patch towards net-next because:
> - no user has complained about this being an issue
> - in theory there should be a Fixes: 56051948773e ("net: dsa: ocelot:
>   add driver for Felix switch family") but the fix already conflicts
>   with some patches that are in net-next:
>   * f59fd9cab730 ("net: mscc: ocelot: configure watermarks using devlink-sb")
>   * c54913c1d4ee ("net: dsa: ocelot: request DSA to fix up lack of address learning on CPU port")
>   and it would unnecessarily cause maintainance headaches to resolve the
>   conflicts.
>   Alternatively I could wait until net-next is merged into net and send
>   the bugfix at that point, but the result would be the same: the patch
>   would not be backportable basically anywhere.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: felix: perform teardown on error in felix_setup
    https://git.kernel.org/netdev/net-next/c/6b73b7c96a91

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


