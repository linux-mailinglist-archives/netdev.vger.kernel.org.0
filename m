Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 459B64619E9
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378892AbhK2Omo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379002AbhK2OkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:40:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1846FC08EC31;
        Mon, 29 Nov 2021 05:10:12 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 737A1614E0;
        Mon, 29 Nov 2021 13:10:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id DB6FB60E0B;
        Mon, 29 Nov 2021 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638191410;
        bh=yerHb8vdcZxS7nrRsH2RhlSyC1bbWy2Pb/PnUBY2o1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=keUHJE1DedwczHqnOQhmy+If7rEoIwaT48c0b2hPfLdY3fhT9cx0KKJLIADXJqoV1
         8yIJPd2p05Fo2e9oyICP9vp1dh7SenPjtHLEoGus3QHFMdDQh50EfB1UfNQe/4H786
         zBX5NdLLQivAvUs8dBlwUneHag+YQC+o8KhleIzwjfhBHL3RKG3QuMVnTcM4jqOYAW
         Kg0aeBRKDUwzldiRFSmNPsu/s6ZPkYQJh+JEvmGYuKJTq4bCGoMG8HON/6j0Scdixd
         ksiEUciwgCG4XsWMnmDyp3+XJ8LSUOrjxQZOG7RQV8FtuS22Oe6fGSq2LN23r3YOrk
         kMECREFbc3GMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D061C60A5A;
        Mon, 29 Nov 2021 13:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/3] update seville to use shared MDIO driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819141084.10588.639521745351740705.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 13:10:10 +0000
References: <20211129015737.132054-1-colin.foster@in-advantage.com>
In-Reply-To: <20211129015737.132054-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 28 Nov 2021 17:57:34 -0800 you wrote:
> This patch set exposes and utilizes the shared MDIO bus in
> drivers/net/mdio/msio-mscc-miim.c
> 
> v3:
>     * Fix errors using uninitilized "dev" inside the probe function.
>     * Remove phy_regmap from the setup function, since it currently
>     isn't used
>     * Remove GCB_PHY_PHY_CFG definition from ocelot.h - it isn't used
>     yet...
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/3] net: mdio: mscc-miim: convert to a regmap implementation
    https://git.kernel.org/netdev/net-next/c/a27a76282837
  - [v3,net-next,2/3] net: dsa: ocelot: seville: utilize of_mdiobus_register
    https://git.kernel.org/netdev/net-next/c/5186c4a05b97
  - [v3,net-next,3/3] net: dsa: ocelot: felix: utilize shared mscc-miim driver for indirect MDIO access
    https://git.kernel.org/netdev/net-next/c/b99658452355

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


