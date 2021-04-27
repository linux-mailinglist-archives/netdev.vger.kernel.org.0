Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C0136CDBB
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbhD0VLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:38920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239055AbhD0VKy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 17:10:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 18FDA61405;
        Tue, 27 Apr 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619557810;
        bh=V6Wr5y4ARXj6mR8Cem7L0H3zoB8E6ApRobRjZhS+TCc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pHWgOzO6bYgUrXk+YhmP4MjRhGz990G/1zw2dn8MCq95eFJytqcb3ncQmTTYL06P/
         NrICpy/uaDNANLzdun6z3rOwjW5j6xwOZmKMtC9XFX+CLORZkVKI4CrVqQzWMMu3oH
         jBqfaftwy1IkCdCIpHsKtnXYFKtge/dpcUg+4wx3v1QWW5w1iXV4Fr+ErqwL2Gb2t4
         wGLZ1mDzhPYnivRF7ALQQy95NaXp6Q8FudzE+Nw6X8GAwBDA5E6os+TfWYZ3SlQw60
         u4ocIFF/UX5ZaVUWWnjd8K3E/iL6SohYeILti2SEH2WAWh8wlEaxLWrmtLWIitpBJ+
         T2gvhnqayT12A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0F12F60A23;
        Tue, 27 Apr 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: marvell-88x2222: enable autoneg by default
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161955781005.15707.7180768153864807469.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 21:10:10 +0000
References: <20210426160823.4501-1-i.bornyakov@metrotek.ru>
In-Reply-To: <20210426160823.4501-1-i.bornyakov@metrotek.ru>
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     system@metrotek.ru, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Apr 2021 19:08:23 +0300 you wrote:
> There is no real need for disabling autonigotiation in config_init().
> Leave it enabled by default.
> 
> Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> ---
>  drivers/net/phy/marvell-88x2222.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: marvell-88x2222: enable autoneg by default
    https://git.kernel.org/netdev/net-next/c/152fa81109a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


