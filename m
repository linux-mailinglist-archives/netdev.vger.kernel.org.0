Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FCE2FC10A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391761AbhASUbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:31:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:57788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392007AbhASUaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:30:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CFD2B2310C;
        Tue, 19 Jan 2021 20:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611088208;
        bh=xG+S8MDMuq0xv/+0m2nQZ2WBgtvVs1jiDabl7J+xEMA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lT1A9WHydcMwmUZGt4H0eeKxQ0ug48I75BdiWCKd5FnJCRfFdQLOEE/QqsIUuDJfj
         tbAcVp/vnTJQ5pVB+PssEQWOfGXhnY+IFKDrudzbFd7ZD+GWvnbm3KVbnuoImsEqH/
         LkizVdyGn6h7dkif8YSqjxFxiFC8JRss+s70/yvmsqKUbQyNSLKg3317JKgDccsLjU
         Lk5+SDILl0FBo8czqJSJQLmxnmTqmyogvh/Jd88NjReEqhpr+vjo+AdRj/WayiOJjO
         buTKKbsY5vM563ls4Q0GVWE9G3/mKYrYwCniFn8HHFoHVPEE4CcJCOEFd2lDJFCRya
         WlgCUULil7Ohg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id D8B6460591;
        Tue, 19 Jan 2021 20:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] sh_eth: Fix reboot crash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161108820888.22632.1269769286087994374.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 20:30:08 +0000
References: <20210118150656.796584-1-geert+renesas@glider.be>
In-Reply-To: <20210118150656.796584-1-geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, f.fainelli@gmail.com,
        linux@armlinux.org.uk, ioana.ciornei@nxp.com,
        wsa+renesas@sang-engineering.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 18 Jan 2021 16:06:54 +0100 you wrote:
> Hi,
> 
> This patch fixes a regression v5.11-rc1, where rebooting while a sh_eth
> device is not opened will cause a crash.
> 
> Changes compared to v1:
>   - Export mdiobb_{read,write}(),
>   - Call mdiobb_{read,write}() now they are exported,
>   - Use mii_bus.parent to avoid bb_info.dev copy,
>   - Drop RFC state.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] mdio-bitbang: Export mdiobb_{read,write}()
    https://git.kernel.org/netdev/net/c/8eed01b5ca9c
  - [net,v2,2/2] sh_eth: Make PHY access aware of Runtime PM to fix reboot crash
    https://git.kernel.org/netdev/net/c/02cae02a7de1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


