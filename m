Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A3E4335FB
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbhJSMc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235513AbhJSMcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 08:32:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E2FF86137E;
        Tue, 19 Oct 2021 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634646613;
        bh=XyyFo7VCfQkK4qvOwoiYg2WPBpG6l2mNFmmJjx+2ql0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nwTXKaK7amNOacCPQ9ybufYuxn+NZWOQ4pnyi+Y8TY5YrFg+hg12fRTeckItWWg5J
         Q2zTX3imo0YCyjd4Y0BynEo3tcuBoxSd2C0wrFkGYL4vP+3n0icWPiz/N+NveqSNTN
         IltCs8R5s5ixy/rtRIhT+Ze4fZtcjuCAVLv9sx0KzBxVmrjVnaUDnjW4++ykhse1E8
         m2luSzitIfTcv67gWQRnl8E4wadLbxWy3BB0se1MegoZTXiaXyAJQGfwXo9+1q37rW
         PVqUPuevhQ8BruYzfHhlFIm8SyuypufJwPugNe472IgXdfrhJNZx7sCEmevj0YlMd5
         hUeV+eAN7GHGg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D9C73609D8;
        Tue, 19 Oct 2021 12:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ixp4xx: Make use of dma_pool_zalloc() instead
 of dma_pool_alloc/memset()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464661288.12016.993642519618586973.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 12:30:12 +0000
References: <20211018131630.328-1-caihuoqing@baidu.com>
In-Reply-To: <20211018131630.328-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     khalasa@piap.pl, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 18 Oct 2021 21:16:29 +0800 you wrote:
> Replacing dma_pool_alloc/memset() with dma_pool_zalloc()
> to simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/net/ethernet/xscale/ixp4xx_eth.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Here is the summary with links:
  - net: ethernet: ixp4xx: Make use of dma_pool_zalloc() instead of dma_pool_alloc/memset()
    https://git.kernel.org/netdev/net-next/c/05be94633783

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


