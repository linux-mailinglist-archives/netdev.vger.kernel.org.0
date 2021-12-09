Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C0E46F478
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 21:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbhLIUDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 15:03:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42160 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhLIUDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 15:03:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE6E2B82567
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 20:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82D2AC341C7;
        Thu,  9 Dec 2021 20:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639080011;
        bh=CC42lOz3dSjTXthF3XhDSnDdabQHMrBqGRB87P6fUIc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GcqepBvWSYgQRwwc01jCgG1YpR8Ii02T8OjNpznu1O35UlIaqKeSvdOTkZnZsgwdA
         ao9/Qj1DXD641dIUnkS7jzp2oOqy/CMbjF9vcm/xciTJ0vANbM6UNnRNyhGiICpRKb
         mS304U9aFMhmvFyP5JQeRb4hTy2iFC2kLMgSBJH2CZr2RDxdCoKNaBX8M9m9gm8mMA
         rmVeZ8GWhUZlxpr4wsrjSDsNA1l8FiiTU4O4SDxbCbWWooQFhzAo9NL12OlW2KIM/i
         SP2RxtmoC+mytLsGZB1/drXKklBGYmuD6T12O+MyyCGAfk1U18UXO7O1O47wv+jr8D
         4ru5w0pNFCujg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 510AB60A54;
        Thu,  9 Dec 2021 20:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: phylink: introduce legacy mode flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163908001132.24516.13773473862700421452.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 20:00:11 +0000
References: <Ya+DGaGmGgWrlVkW@shell.armlinux.org.uk>
In-Reply-To: <Ya+DGaGmGgWrlVkW@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     chris.snook@gmail.com, nbd@nbd.name, f.fainelli@gmail.com,
        john@phrozen.org, Mark-MC.Lee@mediatek.com, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        hkallweit1@gmail.com, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 7 Dec 2021 15:51:53 +0000 you wrote:
> Hi all,
> 
> In March 2020, phylink gained support to split the PCS support out of
> the MAC callbacks. By doing so, a slight behavioural difference was
> introduced when a PCS is present, specifically:
> 
> 1) the call to mac_config() when the link comes up or advertisement
>    changes were eliminated
> 2) mac_an_restart() will never be called
> 3) mac_pcs_get_state() will never be called
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: phylink: add legacy_pre_march2020 indicator
    https://git.kernel.org/netdev/net-next/c/3e5b1feccea7
  - [net-next,2/5] net: dsa: mark DSA phylink as legacy_pre_march2020
    https://git.kernel.org/netdev/net-next/c/0a9f0794d9bd
  - [net-next,3/5] net: mtk_eth_soc: mark as a legacy_pre_march2020 driver
    https://git.kernel.org/netdev/net-next/c/b06515367fac
  - [net-next,4/5] net: phylink: use legacy_pre_march2020
    https://git.kernel.org/netdev/net-next/c/001f4261fe4d
  - [net-next,5/5] net: ag71xx: remove unnecessary legacy methods
    https://git.kernel.org/netdev/net-next/c/11053047a4af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


