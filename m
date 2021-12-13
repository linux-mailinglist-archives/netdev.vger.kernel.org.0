Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD138473029
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239996AbhLMPKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:10:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33616 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239992AbhLMPKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:10:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35C4E6112B;
        Mon, 13 Dec 2021 15:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EDA3C34602;
        Mon, 13 Dec 2021 15:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639408208;
        bh=U79dgo2Oi1hCKu3DVMc5M1mfw5cxrCe3bZ1a+rO+hQk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VNnjoNYfr6MoiO1T8vCw3jyARV2pKI2l72rCWglu+plfREHtNnLM9tcHBvn87NO1Z
         huo92jIkSfD61luw9kyyEwwQIIDvEqkgmNg3e0kz7F6+dKUB/w9oJrsvXfDdaT0mTE
         V3P5OaKLhiKBYERACjkoL2qdDDUZGDOfm4boJ56mVYNt4DM/EhdA0mDdcPy/zKu/en
         uGVeOHoPZO5KFiJFqZ8E3UXVdNw5/addDUoYKjvE1Dgf8IOq1mnY9jH9YhCAG6IB1X
         LG4WBynhOcSGGTfVjTYNgIz0DY/6TA2Wj4KovV8m0IJJmLAOhpcDmvXDB5QrCBhXhW
         bA6iWmaCd7h5A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8BA9C609CD;
        Mon, 13 Dec 2021 15:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: Add GFP_DMA32 for rx buffers if no 64 capability
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940820856.31162.13805444072530757704.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 15:10:08 +0000
References: <20211213111515.658351-1-david.wu@rock-chips.com>
In-Reply-To: <20211213111515.658351-1-david.wu@rock-chips.com>
To:     David Wu <david.wu@rock-chips.com>
Cc:     joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 19:15:15 +0800 you wrote:
> Use page_pool_alloc_pages instead of page_pool_dev_alloc_pages, which
> can give the gfp parameter, in the case of not supporting 64-bit width,
> using 32-bit address memory can reduce a copy from swiotlb.
> 
> Signed-off-by: David Wu <david.wu@rock-chips.com>
> ---
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c    | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)

Here is the summary with links:
  - net: stmmac: Add GFP_DMA32 for rx buffers if no 64 capability
    https://git.kernel.org/netdev/net/c/884d2b845477

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


