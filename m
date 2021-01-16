Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9412F8A89
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbhAPBl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:41:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbhAPBl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 20:41:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 800C42313E;
        Sat, 16 Jan 2021 01:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610761245;
        bh=7nVX75MN46fp0gpta159A4Pi4XNfukyynL5WyMgPNXI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ukEc67RMgvAk2bU/Rvbw3BtwwH/1Q0GWonv/JWaVzkFuDXFaBit2RQLqcr/vvAcRW
         GAU8Ry4XEkGhh+9uv5942A+tTC6gBg4hfQu2ihNLqkk2c0HY9sITBvPuXZlWJR0NL0
         lQNumsiwSqmEjQGpwm9nPnQ66Ti+N4pqFC2qHF2Ld0ktWSpwrlTGFCsGonhntwBpoE
         yPLdEDvI/76rOOMzY8V0yoTKVTR9UZXJ97UYs3/Pk1O6+6PADVJwU/5wx3WT8Gi3jh
         FQ+E7VtvjzQMwLxiAtf1SzujkOrfSHj6h1WKSg0OemPCN6v8Ox4owDu2i3QgYNfW4F
         XKTj/gHsoX0iA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 74A73605AB;
        Sat, 16 Jan 2021 01:40:45 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: dsa: set configure_vlan_while_not_filtering
 to true by default
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161076124547.22751.17188773065231832493.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jan 2021 01:40:45 +0000
References: <20210115231919.43834-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210115231919.43834-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        kurt@linutronix.de, hauke@hauke-m.de, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, matthias.bgg@gmail.com,
        claudiu.manoil@nxp.com, linus.walleij@linaro.org,
        rmk+kernel@armlinux.org.uk, linux@rempel-privat.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 16 Jan 2021 01:19:19 +0200 you wrote:
> As explained in commit 54a0ed0df496 ("net: dsa: provide an option for
> drivers to always receive bridge VLANs"), DSA has historically been
> skipping VLAN switchdev operations when the bridge wasn't in
> vlan_filtering mode, but the reason why it was doing that has never been
> clear. So the configure_vlan_while_not_filtering option is there merely
> to preserve functionality for existing drivers. It isn't some behavior
> that drivers should opt into. Ideally, when all drivers leave this flag
> set, we can delete the dsa_port_skip_vlan_configuration() function.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: dsa: set configure_vlan_while_not_filtering to true by default
    https://git.kernel.org/netdev/net-next/c/0ee2af4ebbe3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


