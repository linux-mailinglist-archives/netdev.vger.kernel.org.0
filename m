Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C03C3450FC
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhCVUk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229730AbhCVUkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D516961878;
        Mon, 22 Mar 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616445607;
        bh=uOeMl8pGHKXuKl95ml116zP4b3bwod87xUannPmtFbo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IhZarDGyPWKpokrFvuaSTUpEp8CMJ7ny8mTVePUmFj2cylNnz/44P2ZcRrAd3jJ96
         IoD56R6OYTpp7vmp3FUag8PlnS3I2Ilxs0srKEY1RKBO7GcGwrGOmAH+qrlREVclK/
         Izs/7crq0CQ5w9YHi4qo0OnE7wVLouEU/HSeB7g4XsOgLzPt8jJoSSO9G9AgUwp/2+
         RLw6eyzlPK2Ce5mL7GcTqpppqJ3a8bSGR7tFx3t8NTSNMc4lQrQh2I3WK+I10JUGvI
         KciO8GcQhlqNY+VNQGUT6KP6X/CzOp76jWkmpLha1uZhHHMdW2WRq/m12yqypt34uN
         w1EfHLf07BgEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C1E3960A6A;
        Mon, 22 Mar 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: platform: fix build error with
 !CONFIG_PM_SLEEP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644560778.2928.15414100425036462948.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:40:07 +0000
References: <20210322122359.2980197-1-weiyongjun1@huawei.com>
In-Reply-To: <20210322122359.2980197-1-weiyongjun1@huawei.com>
To:     'w00385741 <weiyongjun1@huawei.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, linux@armlinux.org.uk,
        qiangqing.zhang@nxp.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 12:23:59 +0000 you wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> Get rid of the CONFIG_PM_SLEEP ifdefery to fix the build error
> and use __maybe_unused for the suspend()/resume() hooks to avoid
> build warning:
> 
> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:769:21:
>  error: 'stmmac_runtime_suspend' undeclared here (not in a function); did you mean 'stmmac_suspend'?
>   769 |  SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
>       |                     ^~~~~~~~~~~~~~~~~~~~~~
> ./include/linux/pm.h:342:21: note: in definition of macro 'SET_RUNTIME_PM_OPS'
>   342 |  .runtime_suspend = suspend_fn, \
>       |                     ^~~~~~~~~~
> drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c:769:45:
>  error: 'stmmac_runtime_resume' undeclared here (not in a function)
>   769 |  SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
>       |                                             ^~~~~~~~~~~~~~~~~~~~~
> ./include/linux/pm.h:343:20: note: in definition of macro 'SET_RUNTIME_PM_OPS'
>   343 |  .runtime_resume = resume_fn, \
>       |                    ^~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: platform: fix build error with !CONFIG_PM_SLEEP
    https://git.kernel.org/netdev/net-next/c/7ec05a603548

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


