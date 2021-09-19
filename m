Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E394410B3B
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbhISLVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230392AbhISLVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 07:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 18F7B61268;
        Sun, 19 Sep 2021 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632050409;
        bh=YR2ospmGzJIdN6tfHN8jrcW1D+cYzlSbU2st2GqCN9A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IvXHEU2lNJdNoLWcslPMthZBWBQ3ieUisX41if15k0+nnYREgiysKs1e9WoIdrSdw
         9WErVgZ4+TimbNUrp7oiW2fWdFu5eX3msovbfIFIVtPye4zHNozZ85EzEu1Xccjl6Y
         +7iYPI23SwlDWa6m+fD5bx9gSfwDCvdZUbaB8qMarYDFMQrSw7+OKwtNDvysorigMj
         Nc0xr64TGd4LF7DIwNZ/jD5PtSQEqiygpYDWLQCInTm+5hNHST2b8cA30PEipGwy4S
         PaLJ7SU+vhECvQN9mMt8S228HBhJUoHtvHg1Har3BPFCqStOL89JvfDkpWvWI9zajn
         n2B4VR91lzqpQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 02AA360A53;
        Sun, 19 Sep 2021 11:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/5] Make DSA switch drivers compatible with masters
 which unregister on shutdown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205040900.14261.5733686295786706203.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 11:20:09 +0000
References: <20210917133436.553995-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210917133436.553995-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, kurt@linutronix.de, hauke@hauke-m.de,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com, dqfext@gmail.com,
        matthias.bgg@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, linus.walleij@linaro.org,
        george.mccollister@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux@rempel-privat.de,
        m.grzeschik@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, LinoSanfilippo@gmx.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 17 Sep 2021 16:34:31 +0300 you wrote:
> Changes in v2:
> - fix build for b53_mmap
> - use unregister_netdevice_many
> 
> It was reported by Lino here:
> 
> https://lore.kernel.org/netdev/20210909095324.12978-1-LinoSanfilippo@gmx.de/
> 
> [...]

Here is the summary with links:
  - [v2,net,1/5] net: mdio: introduce a shutdown method to mdio device drivers
    https://git.kernel.org/netdev/net/c/cf9579976f72
  - [v2,net,2/5] net: dsa: be compatible with masters which unregister on shutdown
    https://git.kernel.org/netdev/net/c/0650bf52b31f
  - [v2,net,3/5] net: dsa: hellcreek: be compatible with masters which unregister on shutdown
    https://git.kernel.org/netdev/net/c/46baae56e100
  - [v2,net,4/5] net: dsa: microchip: ksz8863: be compatible with masters which unregister on shutdown
    https://git.kernel.org/netdev/net/c/fe4053078cd0
  - [v2,net,5/5] net: dsa: xrs700x: be compatible with masters which unregister on shutdown
    https://git.kernel.org/netdev/net/c/a68e9da48568

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


