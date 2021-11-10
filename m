Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143D244C35F
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 15:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhKJOxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 09:53:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:42758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231558AbhKJOw5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 09:52:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DE9E861205;
        Wed, 10 Nov 2021 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636555809;
        bh=eGzlpFg6Nm8CyrQ2z1I+HEKQoa+1alASj5eUJIp2/Es=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GH5m0Y2OnqIb1LYIu8GJ4ihqoCQceBR928d/7JmOzgtkx6JoGoyGVdsxf/1kROyII
         2niufaWmoXU5ddXIOj3+hNj+hzt0vR2pWuR7KA8Uz0qmksHq4nf58HVtOGj9I7Pylv
         P61Ex1Gk2qy1e497l421h25D6uqSvQXi1TxCo4ecoEorFRrvJJWRIa5RX8d7pHA89a
         6MKq5UyEip8WoJ0XNbkaYnqT3/AYR9+xxoJ3FNskLWOLu0FB6pmL9Ir0y/tkWlcsfb
         ijL+JlHCOCIsCmMJZDBJt/wN/imb5mByEsdNi4S2oFYJlY5iVRQniFVm85r+ATHtpQ
         /9byjU4DeOA3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D5D9760AA3;
        Wed, 10 Nov 2021 14:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5: Lag, fix a potential Oops with
 mlx5_lag_create_definer()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163655580887.25401.2747602186847901133.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 14:50:08 +0000
References: <20211110080706.GD5176@kili>
In-Reply-To: <20211110080706.GD5176@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     saeedm@nvidia.com, maorg@nvidia.com, leon@kernel.org,
        davem@davemloft.net, kuba@kernel.org, mbloch@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 Nov 2021 11:07:06 +0300 you wrote:
> There is a minus character missing from ERR_PTR(ENOMEM) so if this
> allocation fails it will lead to an Oops in the caller.
> 
> Fixes: dc48516ec7d3 ("net/mlx5: Lag, add support to create definers for LAG")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net/mlx5: Lag, fix a potential Oops with mlx5_lag_create_definer()
    https://git.kernel.org/netdev/net/c/c7ebe23cee35

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


