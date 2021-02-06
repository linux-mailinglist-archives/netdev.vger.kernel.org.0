Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74291312059
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 23:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhBFWvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 17:51:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:47928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhBFWvG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 17:51:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 11B5C64E2B;
        Sat,  6 Feb 2021 22:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612651826;
        bh=B13pNJat6nMoB7KGYyp1bvL/8DHdU101SrhsLI0JuAs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t6NJJdsmeZNNRIF/ycAmxyOQEIl4NsuzJzKCYbKElv7nBPXxYXNpq6ZhFHGh03IPw
         1mJYEM63FHIgK4M5vCkr4hdAQO39NzHh01+fPie+k+CWS4MZQNzyjN8N/GtPXxt+l5
         aP6NITZBesQRWFtgkQFOXqMnsgzhxRBE9roZ24ZVxvAa8ClJAkZw7XwKf+YLPq5QVB
         vauFgqeh1HhC2/mzLDnZzHky/3cm03xLmQ6UiEfkIYP4+C9C9fXNT19295ct5OTwk/
         2azwOI+pbW/EEbI7o0ZqdyDZWdTL1rW1u4xsd8exCoVWtelrrLU2rS+ukzJxdfI2er
         6uKEYZC1Sm+Yw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0319A609F7;
        Sat,  6 Feb 2021 22:50:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/4] Automatically manage DSA master interface
 state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161265182600.12519.6709577722296881593.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Feb 2021 22:50:26 +0000
References: <20210205133713.4172846-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210205133713.4172846-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        yoshfuji@linux-ipv6.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  5 Feb 2021 15:37:09 +0200 you wrote:
> This patch series adds code that makes DSA open the master interface
> automatically whenever one user interface gets opened, either by the
> user, or by various networking subsystems: netconsole, nfsroot.
> With that in place, we can remove some of the places in the network
> stack where DSA-specific code was sprinkled.
> 
> Vladimir Oltean (4):
>   net: dsa: automatically bring up DSA master when opening user port
>   net: dsa: automatically bring user ports down when master goes down
>   Revert "net: Have netpoll bring-up DSA management interface"
>   Revert "net: ipv4: handle DSA enabled master network devices"
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/4] net: dsa: automatically bring up DSA master when opening user port
    https://git.kernel.org/netdev/net-next/c/9d5ef190e561
  - [v3,net-next,2/4] net: dsa: automatically bring user ports down when master goes down
    https://git.kernel.org/netdev/net-next/c/c0a8a9c27493
  - [v3,net-next,3/4] Revert "net: Have netpoll bring-up DSA management interface"
    https://git.kernel.org/netdev/net-next/c/ea92000d5430
  - [v3,net-next,4/4] Revert "net: ipv4: handle DSA enabled master network devices"
    https://git.kernel.org/netdev/net-next/c/46acf7bdbc72

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


