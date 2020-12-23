Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3987C2E17C1
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgLWDas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgLWDar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 22:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 156F021919;
        Wed, 23 Dec 2020 03:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608694207;
        bh=TisWMARKiZhoKBFWIm1HNUbJPpRWBBiJ4NSi0u9GiW4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fxrQ0a1dNTFvzoFFUWp95j6kNmh6wVGZnvNooqgnSp+ZtxNmNKjXYnOuQNbpg7XLK
         /maO56gCZ0OHzLB+w1sqnjdOb75OkSp6EIwEr7dlYG8bO7rwpTSxU5OeTpTMzeYojC
         I4N9IXmB0o3xzByi3BGKE5l4U5XJfqvngyD2TLe3dtlgdNZpy3FDI+gtSkbr7RDmvf
         thiFKi1KSUSarwqqyoUftdEbwLrSq8d2HxKzIDvf8HgjhUfjWs8/wSqDydWcRDvAsd
         7D5BFgfOGAstm3rnv/w1Ig3rudupc5G7HSUBmSrWVUs7lcUr4v5klZ84S+KlFen+rO
         L3Kmm+2KwUphA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 05D32604E9;
        Wed, 23 Dec 2020 03:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: mvneta: Fix error handling in mvneta_probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160869420701.16175.18389911106403595306.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Dec 2020 03:30:07 +0000
References: <20201220082930.21623-1-dinghao.liu@zju.edu.cn>
In-Reply-To: <20201220082930.21623-1-dinghao.liu@zju.edu.cn>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     kjlu@umn.edu, thomas.petazzoni@bootlin.com, davem@davemloft.net,
        kuba@kernel.org, rmk+kernel@armlinux.org.uk,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 20 Dec 2020 16:29:30 +0800 you wrote:
> When mvneta_port_power_up() fails, we should execute
> cleanup functions after label err_netdev to avoid memleak.
> 
> Fixes: 41c2b6b4f0f80 ("net: ethernet: mvneta: Add back interface mode validation")
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: ethernet: mvneta: Fix error handling in mvneta_probe
    https://git.kernel.org/netdev/net/c/58f60329a6be

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


