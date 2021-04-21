Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7C23671EA
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244996AbhDURu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244889AbhDURus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:50:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B00A961422;
        Wed, 21 Apr 2021 17:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619027414;
        bh=TTyu7wmjMrDzl+3OrRJqrNUYHSJoREbsfVWUZJoCK1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PICAVAJHIy54CT+KWDVRO0y/2HN5rlslOsiNuh27tk7W/OIO/penGRBC59nAZsPQV
         FADtkuCNgSG7ZODmEOx1SDOtn7XNNEtc2T7d2mLJcgevjhZH3EQ9OP/gK8d497UeOk
         tlfn5hZTeAohJusbGenaSxsD3xLu9qn0v0sVNGXk2U3rT2Mv5ugjSAp8VubxoAdkEv
         hbvA5zoNsgBh/lzzuubfZdClTd0OpQh4nS5sE2Jvv5N5gRZl+1+XkGV26F8ccQouMi
         R80XSLa9Ef0nLWgLmE3ZZfT+gxkmG4ksGxMQydxMQys22q7Qy/r/c2CpHtQzr+Rkev
         BZgNFheCv1uEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A748F60A3C;
        Wed, 21 Apr 2021 17:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] net: dsa: fix bridge support for drivers without
 port_bridge_flags callback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161902741468.20144.2290526822940755644.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 17:50:14 +0000
References: <20210421130540.12522-1-o.rempel@pengutronix.de>
In-Reply-To: <20210421130540.12522-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Apr 2021 15:05:40 +0200 you wrote:
> Starting with patch:
> a8b659e7ff75 ("net: dsa: act as passthrough for bridge port flags")
> 
> drivers without "port_bridge_flags" callback will fail to join the bridge.
> Looking at the code, -EOPNOTSUPP seems to be the proper return value,
> which makes at least microchip and atheros switches work again.
> 
> [...]

Here is the summary with links:
  - [net-next,v1] net: dsa: fix bridge support for drivers without port_bridge_flags callback
    https://git.kernel.org/netdev/net-next/c/70a7c484c7c3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


