Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3ED938CFC5
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhEUVVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:21:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229503AbhEUVVd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 17:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 10C13613EE;
        Fri, 21 May 2021 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621632010;
        bh=ELuSNZetOzYEkRYt1fnmAEf3P4Al534S9/JGaix5LWY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MkTmtQKJCU+ly6/YVxZJP/IaxL8clUlZwO9U0QMKotylwcRlt+YzcymtLagYt/Ypt
         4ShSQX27d8HBN2O11oED9O7myseGd8Rhue6Sb/pA8WOPzyrUEPi2luWgJ0k5UYCe2N
         DY6MvMyZVgUeThDsdpBxhkdxFZy4OST1ACq76mz+WBMxSZj+q9jRTBG8qFLoZxaO2S
         sbBqDFgA1kApuAqTLQl7QRRmW71UQpwWHQWmZ8ExjyCtBL6F1ABS13S31Bta91lRH6
         7CSy5ZKlAmMLBnwZXmIXY/zn3jeUxw+uBTixiMmxbsX7V0I/iiXH+iCcjHVBs2Ggo+
         ABBXiYmBIx5fQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0331D60A56;
        Fri, 21 May 2021 21:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Fix bcm_sf2_reg_rgmii_cntrl() call for
 non-RGMII port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163201000.1934.10382533037119124334.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 21:20:10 +0000
References: <20210521174614.2535824-1-f.fainelli@gmail.com>
In-Reply-To: <20210521174614.2535824-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, zajec5@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, rafal@milecki.pl, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 21 May 2021 10:46:14 -0700 you wrote:
> We cannot call bcm_sf2_reg_rgmii_cntrl() for a port that is not RGMII,
> yet we do that in bcm_sf2_sw_mac_link_up() irrespective of the port's
> interface. Move that read until we have properly qualified the PHY
> interface mode. This avoids triggering a warning on 7278 platforms that
> have GMII ports.
> 
> Fixes: 55cfeb396965 ("net: dsa: bcm_sf2: add function finding RGMII register")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: bcm_sf2: Fix bcm_sf2_reg_rgmii_cntrl() call for non-RGMII port
    https://git.kernel.org/netdev/net/c/fc516d3a6aa2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


