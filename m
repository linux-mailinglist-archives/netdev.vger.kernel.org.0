Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6787540CF46
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 00:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhIOWV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 18:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232481AbhIOWV1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 18:21:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CAE7861178;
        Wed, 15 Sep 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631744407;
        bh=2DRRaZ344nkiwsic8m5KiFZIPgDPU+XFGbRWTStB9GY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P3mB+0V++LVl9ngIdjJdVDC/u5yf6iPSUfqobp301qVpkWrTZJ6vX7M5gCrH7kdRX
         a/GCC30O8Mwx9RYTDuXNJqsOQAJUbzaRV756BuSL82QWuEBOx1ccgrr2ID+JZv67aQ
         +qkWQOKzEg9nz5ZWbyBdDPYFMzip3oZE+T0Ud5f/z6HOntAa3BCbYPA25bH1qTg++n
         c7Hlqk9wgwsoQHE7CYCCmtgYh3otH5L2o2pg0CvhFmuVfUuENbl+5SzTrpONmKhnAn
         vLSKJMK0Qs6CTnp339reRa2n83roRe3FMRD6pU6iPxOsKtbwhYLkKNT0hwxegjgFif
         brFx7JxyNiOZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B6CAF60A9E;
        Wed, 15 Sep 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: dsa: destroy the phylink instance on any error in
 dsa_slave_phy_setup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163174440774.30266.2894405249922469653.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 22:20:07 +0000
References: <20210914134331.2303380-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210914134331.2303380-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux@armlinux.org.uk, rmk+kernel@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 14 Sep 2021 16:43:31 +0300 you wrote:
> DSA supports connecting to a phy-handle, and has a fallback to a non-OF
> based method of connecting to an internal PHY on the switch's own MDIO
> bus, if no phy-handle and no fixed-link nodes were present.
> 
> The -ENODEV error code from the first attempt (phylink_of_phy_connect)
> is what triggers the second attempt (phylink_connect_phy).
> 
> [...]

Here is the summary with links:
  - [v2,net] net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup
    https://git.kernel.org/netdev/net/c/6a52e7336803

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


