Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED4D35A99D
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 02:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbhDJAk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 20:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235314AbhDJAkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 20:40:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EBC686113A;
        Sat, 10 Apr 2021 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618015210;
        bh=zYcsyeWduEvvWon5pC7/yS3mmNg4HmOEdk7BAwGSJC0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YeNpC8BVbZZOCcBSkfvyN2El+0T8DpoIdUFTn0T+FYv9ktAKigy2RQb7OXNRs0WDg
         CyFXuzzsaL5bLrEJZNM9xHeZV6fI3zYXaO2ON+99EqNMGvJOAqnUwM4Mdsad8ZTKRX
         Y3Ek87/6FIcymWcMiPgASzQ246nH5Vi8ZHsqr5loO1p2kr1ygcb+H2nZ5zOtKr8KGd
         nbOnbt7/qmAJhq+GDvjrpqMv+VITkQTK1Lxx62pu50ratIiZjoJVQz2Y1azakgGhLi
         4fTnnPXFKUgLft8bKvXhv1v/DheY9W3xUS0yfWmZXEapcDxzr6a/fnQ5iWVTD5A7xY
         CAHdg6T9s9AGQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E287660BE6;
        Sat, 10 Apr 2021 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: enetc: fix array underflow in error handling
 code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161801520992.30931.3251476857787928738.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Apr 2021 00:40:09 +0000
References: <YHBHfCY/yv3EnM9z@mwanda>
In-Reply-To: <YHBHfCY/yv3EnM9z@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        vladimir.oltean@nxp.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 9 Apr 2021 15:24:28 +0300 you wrote:
> This loop will try to unmap enetc_unmap_tx_buff[-1] and crash.
> 
> Fixes: 9d2b68cc108d ("net: enetc: add support for XDP_REDIRECT")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: enetc: fix array underflow in error handling code
    https://git.kernel.org/netdev/net-next/c/626b598aa8be

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


