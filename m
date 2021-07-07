Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03ADD3BF10C
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 22:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhGGUxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 16:53:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhGGUxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Jul 2021 16:53:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C77EF61CD1;
        Wed,  7 Jul 2021 20:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625691064;
        bh=Ct4dOmBsNruy03UbUBokuSSXzn56Dr/qDtxqmnRYTJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kRzqLVniqFPoXY0XbDpGnjZBziO5SJD12Ft+qVYK0IZnv/04VSlCpa/4akvaAem7m
         x9OW2b1GH4JWrnuw4y1sHMxWpe4rq5fDbA5Z3VhwbtekA0HfBTHVgUWtsikYmUckTo
         GMzBe7L/ovBIyam2asgsuETwFD8sG05uEgcTT/JbIzfkIlWsfuI6kKzdpZSiWjJxkI
         kLKponL+L1/D8RsjhHmEw6CtGdjmJhcvVNZFXw+ILtKhZpIKQ4vngQrBH14bm2Aqse
         K/Pk/PgTGTosD+fG0opGt9b+3mTmG8IEqYBW5awEqximn/rfYyfK+fFPbwoRPE5rJ/
         4HxkkOOxfpYWA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B9D2F609BA;
        Wed,  7 Jul 2021 20:51:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] stmmac: dwmac-loongson: Fix unsigned comparison to zero
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162569106475.4918.15116058947596602803.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Jul 2021 20:51:04 +0000
References: <20210707075057.34348-1-yuehaibing@huawei.com>
In-Reply-To: <20210707075057.34348-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, zhangqing@loongson.cn,
        jiaxun.yang@flygoat.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 7 Jul 2021 15:50:57 +0800 you wrote:
> plat->phy_interface is unsigned integer, so the condition
> can't be less than zero and the warning will never printed.
> 
> Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net] stmmac: dwmac-loongson: Fix unsigned comparison to zero
    https://git.kernel.org/netdev/net/c/0d472c69c6a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


