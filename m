Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A503A34FE
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhFJUmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhFJUmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8CE5E61421;
        Thu, 10 Jun 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623357607;
        bh=M3ajQF+rCDXCoOup/k7P0rlDfj2gAkBjcSGLmxkMpEQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=co/0MHR40weJRytJFdqK6uQuJmlqTEUcCqlp2azcbfhQYqzMf695b/HXcLaC+34tF
         1Anr9IRSGwL95C0DwUcAN19YSJ9qMgHzLdC3wjgJJZu7/+vhYh2/Y3qKt3hOhacb1f
         iMZdonebJRgvqiT72mAuiiS9Xk4MYxZup94C5h8cXGap4TXlnXTrpcyFY7iPuL+tUC
         hqIdzfC76/UjECHbzdK2eXUwYvAL1Zj1zgMel4Sft9oDiIjjfSFsZLHdqvbkZSTgX+
         ivq9bQm5u0RWxhAnRpqrxDKZvWMBKUoY63ongZZ6fbgEiuNa/CxiB5GTGrKCkUrD3u
         XS3KH6bnbpg2A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 81C5D60BE2;
        Thu, 10 Jun 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: davinci_emac: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335760752.27474.5577763610739608837.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:40:07 +0000
References: <20210609141744.3205628-1-yangyingliang@huawei.com>
In-Reply-To: <20210609141744.3205628-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, grygorii.strashko@ti.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 22:17:44 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code and avoid a null-ptr-deref by checking 'res' in it.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/ti/davinci_emac.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: davinci_emac: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/0699073951e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


