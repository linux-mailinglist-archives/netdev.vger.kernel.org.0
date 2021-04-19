Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0240364DD0
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 00:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhDSWuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 18:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhDSWuj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 18:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 280FF61354;
        Mon, 19 Apr 2021 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618872609;
        bh=PYr4jLYb3kBhSj5ciSjKErhHywg5ePiN+/Z2SiQjYTo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tznZV4Gg3Yqg2GN/LnSA4vN+OxXU+hP7wYzk2bEacFqHppxtwnmuTXhDBpZueEAh3
         aXuR1iGdUODsLMlR+i4qV3ss6FKWeSsvBGdD8ZN/Jj1NKAyzAPni2rzeUmMTjtRu8z
         A7KJcEHTToQVU4SqPbokIWsGk/zZnpGhu42N35NTYlXO14UhULWpgAgFtrLAfbf1gT
         SAfcq0MvxOw+tzK2BsYhkj4PHXPeH8iOvn9WDRJUAqBXbMVcLvkvbfoB7rU0gzth07
         FpyQ4S3oPXkHdkZ5Sww2Yj1uv9ZWSqgxQWmF+XZhGLSyRz3L2iHClwJAxa6cOuyyws
         3BCNJBh4h1aQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1BDA560970;
        Mon, 19 Apr 2021 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ixp4xx: Set the DMA masks explicitly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887260910.25363.7213881537036335763.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 22:50:09 +0000
References: <20210418182853.1759584-1-linus.walleij@linaro.org>
In-Reply-To: <20210418182853.1759584-1-linus.walleij@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 18 Apr 2021 20:28:53 +0200 you wrote:
> The former fix only papered over the actual problem: the
> ethernet core expects the netdev .dev member to have the
> proper DMA masks set, or there will be BUG_ON() triggered
> in kernel/dma/mapping.c.
> 
> Fix this by simply copying dma_mask and dma_mask_coherent
> from the parent device.
> 
> [...]

Here is the summary with links:
  - net: ethernet: ixp4xx: Set the DMA masks explicitly
    https://git.kernel.org/netdev/net/c/8d892d60941b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


