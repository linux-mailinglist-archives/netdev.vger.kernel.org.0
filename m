Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D43C454AF5
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 17:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239041AbhKQQdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 11:33:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:57104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232237AbhKQQdH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 11:33:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2669160F90;
        Wed, 17 Nov 2021 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637166609;
        bh=pQXDu9LLYqVGI9NVMBVUnJKg0c2PxYxLHJoQh6fUaM0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BbiXDApr/FO6tbxiZ3CDC1y3D81oZ3E0dcXIL0yjT1eJZ1kEyWAfNmcSNS/cTm8G3
         L1pBlcelOmHws/NEL6enLI8IID5lRGPkYPX0l9cBlgc/GtGw61tl8PWScB0Ocy2j0l
         beXzsE61oqKmS/9OvKnPkgrPrVam5zRBdOazuzHMcRcvFyDEgLCt9sezuymz34SVRU
         5ZfY9v8xGZoqkSOtVcX2d6hIU//SQp7Jfd00YpU1fLZMLQF0oRKim6aOKAKBsXFJr/
         QEFwlJ+/2Zrl5Ukxc6FMpQ55neqzTRbIMCF6Fh4mIDA6fWa2poCOM0SVymu/9xki8g
         xVv0r8SnfOzdA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1489460A3A;
        Wed, 17 Nov 2021 16:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] stmmac: fix build due to brainos in trans_start
 changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163716660907.26682.6507508277145411232.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 16:30:09 +0000
References: <20211117152917.3739-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211117152917.3739-1-alexandr.lobakin@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 Nov 2021 16:29:17 +0100 you wrote:
> txq_trans_cond_update() takes netdev_tx_queue *nq,
> not nq->trans_start.
> 
> Fixes: 5337824f4dc4 ("net: annotate accesses to queue->trans_start")
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] stmmac: fix build due to brainos in trans_start changes
    https://git.kernel.org/netdev/net-next/c/e92af33e472c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


