Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E97B34C0CD
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhC2BAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhC2BAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 68E1A61951;
        Mon, 29 Mar 2021 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616979611;
        bh=gpcobxCjcUdS+iH3QsNq2oXcv+K1EvjHXu2erxNHrrQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CaL9yUbHLJa9Wql9vkz8HvKDg7sN7cagoaDqMryo1OEwdcj5VRl38p70qt8L3CIOG
         dMSyamL+yR0g6L87EpfTHUfymd1p1Ln/Cm5Qz2yAa1oJrtAVuFwrdLne7a85xCkhLA
         UjbKSVCI0C7eNgatOPCfxDRdHfhjU3HWexGn2c/bw/F4ZHUJEvoP6NO/b7Lk+lmj2e
         tt+ozUioqxai2fhxYVCUm/gC++63uqgdH5M92s/vkbT0Zz1SvrCFP3ATpXk24R0nKN
         QCWE+RYBwRjwNeNNI8266KW5v6OET6x/VCPK2SXepq+0uf2ffV+TI6c3lJrYxk7zoJ
         fxOc7kS9mPgLw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6095060A56;
        Mon, 29 Mar 2021 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2] net: dsa: mt7530: clean up core and TRGMII clock
 setup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161697961139.31306.12191866785096357875.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:00:11 +0000
References: <20210327060752.474627-1-ilya.lipnitskiy@gmail.com>
In-Reply-To: <20210327060752.474627-1-ilya.lipnitskiy@gmail.com>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        p.zabel@pengutronix.de, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 23:07:52 -0700 you wrote:
> Three minor changes:
> 
> - When disabling PLL, there is no need to call core_write_mmd_indirect
>   directly, use the core_write wrapper instead like the rest of the code
>   in the function does. This change helps with consistency and
>   readability. Move the comment to the definition of
>   core_read_mmd_indirect where it belongs.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dsa: mt7530: clean up core and TRGMII clock setup
    https://git.kernel.org/netdev/net-next/c/4732315ca9fe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


