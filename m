Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A0A31D289
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhBPWUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhBPWUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 17:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C6CE864E7C;
        Tue, 16 Feb 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613514007;
        bh=KNTIPA8usX6dR1CxCwRFKCbt7JaolkFya/tsKYG7C3g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rgtI5PfHADrVfxa0kebtMwLxArN1SaFxV+xtj4YnOZZcyaWaPm3b8tDxW6MC1BzgZ
         IDSV5i0J/2L9rJAojdhpT+z18+W3cSrDcdZqoKjGF/G388Te+HxUo3vMnM1L9Vx9Af
         cl/ENjVk9yZ6RuM+HQxbgYRbmQF3gDADd01us1yF5h6eCGp1SBoxNZB814BK07D93o
         zzBksNW3BM3MT2slBILmILqOUP7k5ufGw/vyc337jlh4xMw9j3okeTuxSiQ9K96e7v
         i7/KioB3R4ysaDyP7pFdRoRU4ERHr9uLqpJk6Fgfo3cij+yspxec5++gpjtVKzcG24
         FEHewBb2DVcfg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B3E6560971;
        Tue, 16 Feb 2021 22:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] Add 5gbase-r PHY interface mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351400773.20875.3644702482424924435.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 22:20:07 +0000
References: <20210216192055.7078-1-kabel@kernel.org>
In-Reply-To: <20210216192055.7078-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, lkp@intel.com, ashkan.boldaji@digi.com,
        andrew@lunn.ch, chris.packham@alliedtelesis.co.nz,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 20:20:51 +0100 you wrote:
> Hello,
> 
> there is still some testing needed for Amethyst patches, so I have
> split the part adding support for 5gbase-r interface mode and am sending
> it alone.
> 
> The first two patches are already reviewed.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] dt-bindings: net: Add 5GBASER phy interface
    https://git.kernel.org/netdev/net-next/c/4b08de909061
  - [net-next,2/4] net: phy: Add 5GBASER interface mode
    https://git.kernel.org/netdev/net-next/c/7331d1d4622b
  - [net-next,3/4] net: phylink: Add 5gbase-r support
    https://git.kernel.org/netdev/net-next/c/f6813bdafdb3
  - [net-next,4/4] sfp: add support for 5gbase-t SFPs
    https://git.kernel.org/netdev/net-next/c/cfb971dec56b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


