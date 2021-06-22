Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706283B0BD9
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232441AbhFVRw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:51612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232348AbhFVRwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1EFBD61353;
        Tue, 22 Jun 2021 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624384206;
        bh=ESgFv0vtJ21tRzqywt1ll8Kx5wBSrdb3mdom7uZBV+4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WGmbPdZKWEIGOuZqUyeEYKlD8yyAVzaSEGw7QIDtMrfy4nWDiuFV/wtYkczckA1f9
         N3Dpy+/mDvhpsgfzSFkdo8Kg398LSI2a7yfDasev4x7VTNn7ATlvQtnLHTIMQHvMZK
         MNXRUGUxzKpsFCldIjm5qwq7Ox7C7tk3W0eUsFMgq36EsSTH4GF/SdydIQdIDyoF1e
         y8P0WlV0l5119sWWQ1x6D4cd03bfy1R9SbTZBT+en5/y0724KL9rd0D4HDCOTIaQAe
         jhVi4HMQ9sqCEyEh7af/qrlLcT+MHUwZnxWfbeFMvAK6oyAov278A/jr3zIESMB7eH
         NAdIGpOWsGlzw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0F88B60A6C;
        Tue, 22 Jun 2021 17:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] stmmac: dwmac-loongson: fix uninitialized variable
 in loongson_dwmac_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438420605.559.7709125546546487044.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:50:06 +0000
References: <YNHOz8Aqo7Y1ZwO+@mwanda>
In-Reply-To: <YNHOz8Aqo7Y1ZwO+@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, zhangqing@loongson.cn,
        jiaxun.yang@flygoat.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 22 Jun 2021 14:51:43 +0300 you wrote:
> The "mdio" variable is never set to false.  Also it should be a bool
> type instead of int.
> 
> Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] stmmac: dwmac-loongson: fix uninitialized variable in loongson_dwmac_probe()
    https://git.kernel.org/netdev/net-next/c/b0e03950dd71

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


