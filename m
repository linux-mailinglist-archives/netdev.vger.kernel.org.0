Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D550D401B20
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 14:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237454AbhIFMZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 08:25:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237245AbhIFMZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 08:25:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D23AA60F45;
        Mon,  6 Sep 2021 12:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630931045;
        bh=Zy6R3EZkqy/7oKKjFPZvaCgdsk/p/dmxINF1eormd2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mobPM3FuHmPvktTp1XetDVVecmIwCeUfsHDs8j5oSSKxvo2JqTryi/bn+1d6a1vIj
         uSMHzRYAvL+y36YcYNSjJYH8Z5IK3MEH8QVqtGIgmHpHPTe//3D70lYo/KnnGkKL/3
         AbdKVXL/TOc/aH9Y2B/Ua55wXVcH1g2pE+KuqUyGU2aVqpkqZ81ytcGEzcWX8NyBBy
         8lfvP41sJxZdxfFTOY3Q58B4TofqImwr8yLj+oH6cULSwzrLbNlqgx2Mp8A89/scDT
         ZA50tobH/qFBtF4eWP1e0JP3spgFNBMTNiPedyOF2yJHk1+ooNQlYSbL0JqbnL/Cie
         8uRYYsacyFA+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C544F60A37;
        Mon,  6 Sep 2021 12:24:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] stmmac: dwmac-loongson:Fix missing return value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163093104580.13830.7607505980479153914.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Sep 2021 12:24:05 +0000
References: <20210906072107.10906-1-long870912@gmail.com>
In-Reply-To: <20210906072107.10906-1-long870912@gmail.com>
To:     zhaoxiao <long870912@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  6 Sep 2021 15:21:07 +0800 you wrote:
> Add the return value when phy_mode < 0.
> 
> Signed-off-by: zhaoxiao <long870912@gmail.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - stmmac: dwmac-loongson:Fix missing return value
    https://git.kernel.org/netdev/net/c/5289de5929d1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


