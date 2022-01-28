Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F6949FCB6
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345100AbiA1PUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:20:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50770 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245039AbiA1PUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:20:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB16260DF0;
        Fri, 28 Jan 2022 15:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36417C340EF;
        Fri, 28 Jan 2022 15:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643383211;
        bh=ex6whZix80c3R/+yIzxHpxb+HxTwZBN82khwzKcw/as=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DfdOh8tq6w4FuRI+0yZN0xJHiV+YIHDU5X91yKeSHXDmOeCjcscC8s0T3AW6t6LR4
         EtSsbOcuKQEeWrzf4jCJU0C3Jcc4kFcIsm4seTtewqKyKaqfbW2/9Nw11e8Gy8qvAN
         YnpcXOtO5yNjCUfIAO2RYgUifpuv8Sj2/2qpN0Se5foe1cNSYWaehO1x/apl6iWxq2
         ILNm79vDaqEqr4E4x0kxHOdbDjzodY3YgldYj1ZW7NQpOdIhvmjbsbMe4lyACOn3nk
         pHmblx+BZMybodRVZlQr3gbRJEuQQgRM2ybAkImyTbky5n1NZLTW7cqN7TSTOTsys/
         md+4vAEHo4UqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 23129E5D087;
        Fri, 28 Jan 2022 15:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: dwmac-sun8i: make clk really gated
 during rpm suspended
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338321113.8810.8058423675917516702.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 15:20:11 +0000
References: <20220128145213.2454-1-jszhang@kernel.org>
In-Reply-To: <20220128145213.2454-1-jszhang@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, mripard@kernel.org, wens@csie.org,
        jernej.skrabec@gmail.com, netdev@vger.kernel.org,
        linux-sunxi@lists.linux.dev,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 22:52:13 +0800 you wrote:
> Currently, the dwmac-sun8i's stmmaceth clk isn't disabled even if the
> the device has been runtime suspended. The reason is the driver gets
> the "stmmaceth" clk as tx_clk and enabling it during probe. But
> there's no other usage of tx_clk except preparing and enabling, so
> we can remove tx_clk and its usage then rely on the common routine
> stmmac_probe_config_dt() to prepare and enable the stmmaceth clk
> during driver initialization, and benefit from the runtime pm feature
> after probed.
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: dwmac-sun8i: make clk really gated during rpm suspended
    https://git.kernel.org/netdev/net-next/c/b76bbb34dc80

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


